/* BISON TOKEN NAMES */

%token T_AND T_BEGIN T_FORWARD T_DIV T_DO T_ELSE T_END T_FOR T_FUNCTION T_IF T_ARRAY T_MOD T_NOT T_OF T_OR T_PROCEDURE T_PROGRAM T_RECORD T_THEN T_TO T_TYPE T_VAR T_WHILE T_ID T_INT T_STR T_ASSIGNMENT T_RANGE T_RELOP T_MULOP

%{

#include <fstream>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <map>   //data structure for symbol table
#include <vector>
#include <string>
#include "lex.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE 1
#define FW 50
#define SYM_OUTPUT "symtable.out"
#define RULES_OUTPUT "rules.out"
#define TAC_OUTPUT "a.txt"

typedef struct id_attr{
	std::string type;
	std::map< std::string, std::string > field_list;
	size_t addr;
	id_attr(const std::string _type, const size_t _addr):type(_type), addr(_addr){}
	id_attr(void):type(""), addr(0){}
} id_attr;

typedef struct scope{
	std::map<std::string, id_attr> symt;
	scope *p;
	scope(void):p(NULL){
		symt["integer"] = id_attr("integer", 0);    //predefined types
		//symt["typedef integer"] = id_attr("integer", 1);
		symt["string"] = id_attr("string", 2);
		symt["typedef string"] = id_attr("string", 3);
		symt["boolean"] = id_attr("boolean", 4);
		symt["typedef boolean"] = id_attr("boolean", 5);
		symt["true"] = id_attr("true", 6);
		symt["false"] = id_attr("false", 7);
	}
	scope(scope *_p):p(_p){}
} scope;

scope prog_scope, *current_scope = &prog_scope, *next_scope;
bool temp_var;  //whether temp variables are used in tac
int argc = 0, current_argc = 0, s_err = 0, ind = 0, tmpc = 0, current_sgn, current_const, current_l, current_u;  //l/u:  array lower/upper bounds
std::string current_id, current_ret, type, current_typename, exp_type, lhs_type, ret_type, vt, et, current_var, current_exp;  //tac output for current variable/expression
id_attr current_id_attr;
std::vector<std::string> current_argv;
std::fstream rules(RULES_OUTPUT, std::ios::out | std::ios::trunc), tac(TAC_OUTPUT, std::ios::out | std::ios::trunc);

template <class T>
inline std::string to_string (const T & t){
	std::stringstream ss;
	ss << t;
	return ss.str();
}

int yyerror(const char *), UpdateVar(void), UpdateType(scope *), LookupId(scope *, const std::string, std::string &);
std::string LookupTypeDef(const std::string), Temp(void), Temp(int), Temp_Eq(void), Temp_Eq(int);
void print_label(const std::string s), print_tac(const std::string s), print_var(const std::string s);

%}



/* THE GRAMMAR */

%%

Program
:
T_PROGRAM T_ID
{
	current_scope -> symt[std::string("program ").append(std::string(yytext_ptr))] = id_attr("program", current_scope -> symt.size());
}
';' OptTypeDefinitions OptVariableDeclarations OptSubprogramDeclarations CompoundStatement '.'
{
	rules<<"Program\n";
}
;

TypeDefinitions
:
T_TYPE TypeDefinition ';' _OptTypeDefinitions {rules<<"TypeDefinitions\n";}
;

OptTypeDefinitions
:
/* empty */ {rules<<"OptTypeDefinitions\n";}
|
TypeDefinitions {rules<<"OptTypeDefinitions\n";}
;

_OptTypeDefinitions
:
/* empty */ {rules<<"_OptTypeDefinitions\n";}
|
TypeDefinition ';' _OptTypeDefinitions {rules<<"_OptTypeDefinitions\n";}
;

TypeDefinition
:
T_ID {
	current_id = std::string("typedef ").append(current_typename = std::string(yytext_ptr));
} '=' Type
{
	current_id_attr.addr = current_scope -> symt.size();
	current_scope -> symt[current_id] = current_id_attr;    //this stores the FieldList of the type
	prog_scope.symt[current_typename] = id_attr(LookupTypeDef(current_id_attr.type), current_scope -> symt.size());    //this stores type equivalence
	current_id_attr.type = "";
	current_id_attr.field_list.clear();
}
{rules<<"TypeDefinition\n";}
;

VariableDeclarations
:
T_VAR VariableDeclaration ';' _OptVariableDeclarations {rules<<"VariableDeclarations\n";}
;

VariableDeclaration
:
IdentifierList ':' Type {UpdateVar();} {rules<<"VariableDeclaration\n";}
;

OptVariableDeclarations
:
/* empty */ {rules<<"OptVariableDeclarations\n";}
|
VariableDeclarations {rules<<"OptVariableDeclarations\n";}
;

_OptVariableDeclarations
:
/* empty */ {rules<<"_OptVariableDeclarations\n";}
|
VariableDeclaration ';' _OptVariableDeclarations {rules<<"_OptVariableDeclarations\n";}
;

OptSubprogramDeclarations
:
/* empty */ {rules<<"OptSubprogramDeclarations\n";}
|
SubprogramDeclarations {rules<<"OptSubprogramDeclarations\n";}
;

SubprogramDeclarations
:
/* empty */ {rules<<"SubprogramDeclarations\n";}
|
SubprogramDeclaration ';' SubprogramDeclarations {rules<<"SubprogramDeclarations\n";}
;

SubprogramDeclaration
:
ProcedureDeclaration {rules<<"SubprogramDeclaration\n";}
|
FunctionDeclaration {rules<<"SubprogramDeclaration\n";}
;

ProcedureDeclaration
:
T_PROCEDURE T_ID
{
	current_id = std::string(yytext_ptr);
	next_scope = new scope(current_scope);
	print_label(std::string("procedure_").append(current_id));
	++ind;
}
'(' FormalParameterList {
	current_scope -> symt[std::string("procedure ").append(current_id)] = id_attr("void", current_scope -> symt.size());  //procedure returns type 'void'
	current_id_attr.type = "";
	current_id_attr.field_list.clear();
	argc = 0;
}')' ';' DeclarationBody
{
	--ind;
	rules<<"ProcedureDeclaration\n"; print_tac("return"); --ind; tac<<"\n";
}
;

FunctionDeclaration
:
T_FUNCTION T_ID
{
	current_ret = current_id = std::string(yytext_ptr);
	next_scope = new scope(current_scope);
	print_label(std::string("function_").append(current_id));
	++ind
} '(' FormalParameterList ')' ':' ResultType
{
	current_scope -> symt[std::string("function ").append(current_id)] = id_attr(exp_type, current_scope -> symt.size());
	current_id_attr.type = "";
	current_id_attr.field_list.clear();
	argc = 0;
}';' DeclarationBody
{
	--ind;
	rules<<"FunctionDeclaration\n";
}
;

DeclarationBody
:
Block
{
	print_tac(std::string("funreturn ").append(current_ret).append("\t\t; should be \"mov eax, <result>\" in x86 assembly")); --ind; tac<<"\n";
	rules<<"DeclarationBody\n";
}
|
T_FORWARD
{
	rules<<"DeclarationBody\n";
}
;

FormalParameterList
:
{
	argc = 0;
}
/* empty */ {rules<<"FormalParameterList\n";}
|
{
	argc = 0;
}
IdentifierList ':' Type {
	UpdateType(next_scope);
}OptIdentifiers {rules<<"FormalParameterList\n";}
;

OptIdentifiers
:
/* empty */ {rules<<"OptIdentifiers\n";}
|
';' IdentifierList ':' Type {
	UpdateType(next_scope);
}
OptIdentifiers {rules<<"OptIdentifiers\n";}
;

Block
:
{
	current_scope = next_scope;
	next_scope = NULL;
}
CompoundStatement
{
	rules<<"Block\n";
	current_scope = current_scope -> p;
}
|
VariableDeclarations CompoundStatement
{
	rules<<"Block\n";
	current_scope = current_scope -> p;
}
;

CompoundStatement
:
T_BEGIN StatementSequence T_END {rules<<"CompoundStatement\n";}
;

StatementSequence
:
Statement Statements {rules<<"StatementSequence\n";}
;

Statement
:
SimpleStatement {rules<<"Statement\n";}
|
StructuredStatement {rules<<"Statement\n";}
;

SimpleStatement
:
/* empty */ {rules<<"SimpleStatement\n";}
|
AssignmentStatement {rules<<"SimpleStatement\n";}
|
ProcedureStatement {rules<<"SimpleStatement\n";}
;

AssignmentStatement
:
Variable
{
	lhs_type = exp_type;
	//HEREHERE
/*
	if (!temp_var){
		tac<<" := ";
	}else{
		tac<<Temp_Eq();
	}
	TODO: DO THIS AFTER EXPRESSION HAS BEEN EVALUATED
*/
}
T_ASSIGNMENT Expression
{
	std::string l_type, r_type;
	if (lhs_type != "" && exp_type != "" && (l_type = LookupTypeDef(lhs_type)) != (r_type = LookupTypeDef(exp_type))){  //if both lhs and rhs are syntatically valid (hence have types)
		yyerror(std::string("incompatible types in assignment of ").append(r_type).append(" to ").append(l_type).c_str());
		++s_err;
	}else if (lhs_type == ""){
		yyerror("unable to determine the type of the left-hand side due to previous error(s)");
	}else if (exp_type == ""){
		yyerror("unable to determine the type of the right-hand side due to previous error(s)");
	}
	tac<<et<<"\n";  //et = "";
	lhs_type = "";
	exp_type = "";
	tac<<current_exp<<current_var;    //evaluate the right-hand side, get the left-hand side, and then perform the ':=' operator
	print_tac(vt.append(" := ").append(et).append("\n"));
	rules<<"AssignmentStatement\n";
}
;

ProcedureStatement
:
T_ID {
	if (!LookupId(current_scope, std::string("procedure ").append(prev_id), exp_type) && !LookupId(current_scope, std::string("function ").append(prev_id), exp_type)){
		yyerror(std::string("procedure or function '").append(prev_id).append("' is not defined").c_str());
		++s_err;
	}
}
 '(' ActualParameterList ')' {rules<<"ProcedureStatement\n";}
;

StructuredStatement
:
CompoundStatement {rules<<"StructuredStatement\n";}
|
T_IF Expression T_THEN Statement CloseIf {rules<<"StructuredStatement\n";}
|
T_WHILE Expression T_DO Statement {rules<<"StructuredStatement\n";}
|
T_FOR T_ID
{
	std::string var_name(yytext_ptr);
	if (!LookupId(current_scope, std::string("var ").append(var_name), exp_type)){
		yyerror(std::string("variable ").append(var_name).append(" is not declared").c_str());
		++s_err;
	}
}
T_ASSIGNMENT Expression T_TO Expression T_DO Statement {rules<<"StructuredStatement\n";}
;

CloseIf
:
/* empty */ {rules<<"CloseIf\n";}
|
T_ELSE Statement {rules<<"CloseIf\n";}
;

Statements
:
/* empty */ {rules<<"Statements\n";}
|
';' Statement Statements {rules<<"Statements\n";}
;

Type   /* todo: replace literal typename with special (reserved) symbols */
:
T_ID {
	type = std::string(yytext_ptr);
	if (current_id_attr.type == ""){
		current_id_attr.type = type;
	}
} {rules<<"Type\n";}
|
T_ARRAY '[' Constant{current_l = current_const;} T_RANGE Constant{current_u = current_const;} ']' T_OF
{
	current_id_attr.type.append("array[").append(to_string<int>(current_l)).append("..").append(to_string<int>(current_u)).append("]_of_");
} Type {rules<<"Type\n";}
{
	std::string t = LookupTypeDef(type);
	current_id_attr.type.append(t);
	current_id_attr.field_list["."] = t;
}
|
T_RECORD {
	current_id_attr.type.append("record{");
} FieldList T_END {
	current_id_attr.type.append("}");
} {rules<<"Type\n";}
;

ResultType
:
T_ID {
	std::string type_name(yytext_ptr);
	exp_type = LookupTypeDef(type_name);
	if (!LookupId(current_scope, type_name, exp_type)){
		yyerror(std::string("invalid return type: type '").append(type_name).append("' is not declared").c_str());
		++s_err;
	}
	rules<<"ResultType\n";
}
;

FieldList /* assuming FieldList is only used in record declarations */
:
/* empty */ {rules<<"FieldList\n";}
|
IdentifierList ':' Type {
	for (int i = 0; i < current_argc; ++i){
		current_id_attr.field_list[current_argv[i]] = type;  //entry for type of field in symbol table, note: use typename here
		current_id_attr.type.append(LookupTypeDef(type)).append(",");
	}
	current_argv.clear();
	current_argc = 0;
}
OptIdentifiers {rules<<"FieldList\n";}
;

Constant
:
T_INT
{
	current_const = atoi(yytext_ptr);
	rules<<"Constant\n";
}
|
Sign T_INT
{
	current_const = current_sgn * atoi(yytext_ptr);
	rules<<"Constant\n";
}
;

Expression
:
SimpleExpression
{
	rules<<"Expression\n";
}
|
SimpleExpression RelationalOp SimpleExpression
{
	exp_type = "boolean";
	rules<<"Expression\n";
}
;

RelationalOp
:
T_RELOP
{
	et.append(" ").append(std::string(yytext_ptr)).append(" ");
	rules<<"RelationalOp\n";
}
|
'='
{
	et.append(" = ");
	rules<<"RelationalOp\n";
}
;

SimpleExpression
:
{
	et = "";
	temp_var = false;
}
Term Summand {rules<<"SimpleExpression\n";}
|
Sign
{
	et.append(current_sgn == -1 ? "-" : "+");
}
Term Summand {rules<<"SimpleExpression\n";}
;

Sign
:
'+'
{
	current_sgn = 1;   /* note: different semantic actions needed, depending on whether sign appears in array index or in some expression */
	rules<<"Sign\n";
}
|
'-'
{
	current_sgn = -1;
	rules<<"Sign\n";
}
;

AddOp
:
Sign
{
	if (!temp_var){
		et.append(current_sgn == -1 ? " - " : " + ");
	}else{
//		print_tac(et.append("\n"));  //HEREHERE
		et = Temp_Eq().append(Temp()).append(current_sgn == -1 ? " - " : " + ");
	}
	rules<<"AddOp\n";
}
|
T_OR
{
	if (!temp_var){
		et.append(" or ");
	}else{
//		print_tac(et.append("\n"));  //HEREHERE
		et = Temp_Eq().append(Temp()).append(" or ");
	}
	rules<<"AddOp\n";
}
;

Term
:
Factor Multiplicand {rules<<"Term\n";}
;

Summand
:
/* empty */ {rules<<"Summand\n";}
|
AddOp Term Summand {rules<<"Summand\n";}
;

MulOp
:
T_MULOP {rules<<"MulOp\n";}
|
T_DIV {rules<<"MulOp\n";}
|
T_MOD {rules<<"MulOp\n";}
|
T_AND {rules<<"MulOp\n";}
;

Factor
:
T_INT
{
	et.append(std::string(yytext_ptr));
	exp_type = "integer";
	rules<<"Factor\n";
}
|
T_STR
{
	et.append(std::string(yytext_ptr));
	exp_type = "string";
	rules<<"Factor\n";
}
|
Variable{
	if (!temp_var){
		//std::cout<<"Variable == "<<vt<<std::endl;
	}else{
		//HEREHERE
	}
	rules<<"Factor\n";
}
|
FunctionReference {rules<<"Factor\n";}
|
T_NOT Factor
{
	//exp_type = "boolean";  /* this should be unnecessary */
	rules<<"Factor\n";
}
|
'(' Expression ')' {rules<<"Factor\n";}
;

Multiplicand
:
/* empty */ {rules<<"Multiplicand\n";}
|
MulOp Factor Multiplicand {rules<<"Multiplicand\n";}
;

FunctionReference
:
T_ID 
{
	if (!LookupId(current_scope, std::string("function ").append(prev_id), exp_type)){  // <-- must be a function
		yyerror(std::string("invalid function reference: function '").append(prev_id).append("' is not defined").c_str());
		++s_err;
	}
	ret_type = exp_type;
}
'(' ActualParameterList ')' {exp_type = ret_type; rules<<"FunctionReference\n";}
;

Variable
:
T_ID
{       /* note: the 'variable' in this context could also be a function's return value */
	temp_var = false;
	if (!LookupId(current_scope, std::string("var ").append(prev_id), exp_type) && !LookupId(current_scope, std::string("function ").append(prev_id), exp_type)){  // <-- must be a variable
		yyerror(std::string("variable '").append(prev_id).append("' is not declared").c_str());
		++s_err;
	}
	current_var = "";
	vt = prev_id;
}
ComponentSelection {
	rules<<"Variable\n";
}
;

ComponentSelection
:
/* empty */
{
	rules<<"ComponentSelection\n";
}
|
'.'
{
	if (!temp_var){
		print_var(Temp_Eq(tmpc + 1).append(vt).append("."));  //HEREHERE
		temp_var = true;
	}else{
		print_var(Temp_Eq(tmpc + 1).append(Temp()).append("."));
	}
	vt = Temp(++tmpc);
//	print_tac(Temp_Eq().append(Temp()).append("."));
	//current_id = prev_id;
}
T_ID
{
	std::map<std::string, id_attr>::iterator t;
	std::map<std::string, std::string>::iterator ft;
	if (exp_type != ""){   //if no error occurred in previous type lookup
		if ( (t = current_scope -> symt.find(std::string("typedef ").append(exp_type))) == current_scope -> symt.end() ){
			yyerror(std::string("type '").append(exp_type).append("' is not defined").c_str());
			exp_type = "";
			++s_err;
		}else if ( (ft = t -> second.field_list.find(prev_id)) == t -> second.field_list.end() ){
			yyerror(std::string("field '").append(prev_id).append("' of type '").append(exp_type).append("' is not defined").c_str());
			exp_type = "";
			++s_err;
		}else{
			exp_type = ft -> second;
		}
	}
	current_var.append(prev_id).append("\n");
	//++tmpc;
}
ComponentSelection {rules<<"ComponentSelection\n"; /* TODO: check whether the specified component exists in object */}
|
'['
{
	print_tac("[");
}
Expression ']'
{
	print_tac("]");
}
ComponentSelection {rules<<"ComponentSelection\n";}
;

ActualParameterList
:
/* empty */ {rules<<"ActualParameterList\n";}
|
Expression OptExpressions {rules<<"ActualParameterList\n";}
;

OptExpressions
:
/* empty */ {rules<<"OptExpressions\n";}
|
',' Expression OptExpressions {rules<<"OptExpressions\n";}
;

IdentifierList
:
T_ID {
	current_argv.push_back(std::string(yytext_ptr));
	++current_argc;
} Identifiers {rules<<"IdentifierList\n";}
;

Identifiers
:
/* empty */ {rules<<"Identifiers\n";}
|
',' T_ID {
	current_argv.push_back(std::string(yytext_ptr));
	++current_argc;
} Identifiers {rules<<"Identifiers\n";}
;


%%

int yyerror(const char *s){
	std::cerr<<"\nline "<<yylineno<<":\nerror: "<<s<<"\n";
	return 0;
}

int UpdateVar(void){
	std::string s;
	for (std::vector<std::string>::iterator itr = current_argv.begin(); itr != current_argv.end(); ++itr){
		if (LookupId(current_scope, s = std::string("var ").append(*itr), exp_type)){
			yyerror(std::string("redeclaration of variable '").append(*itr).append("'").c_str());
			++s_err;
		}else{
			//current_scope -> symt[s] = id_attr(LookupTypeDef(type), current_scope -> symt.size());
			/* note: at this level use typename instead */
			current_scope -> symt[s] = id_attr(type, current_scope -> symt.size());
		}
	}
	current_argv.clear();
	current_argc = 0;
	return 0;
}

int UpdateType(scope *next_scope){
	if (next_scope){     /* <-- this is for FormalParameterList only */
		for (int i = 0; i < current_argc; ++i){
			current_id_attr.type.append(LookupTypeDef(type)).append(",");    //assumption: formal parameter overwrites variable declaration with the same name that is outside the current scope
			next_scope -> symt[std::string("var ").append(current_argv[i])] = id_attr(LookupTypeDef(type), current_scope -> symt.size());
		}
	}else{
		for (int i = 0; i < current_argc; ++i){
			current_id_attr.type.append(LookupTypeDef(type)).append(",");
		}
	}
	current_argv.clear();
	argc += current_argc;
	current_argc = 0;
	return 0;
}

int LookupId(scope *current_scope, const std::string name, std::string & type){
	std::map<std::string, id_attr>::iterator it;
	while (current_scope){
		if ( (it = current_scope -> symt.find(name)) != current_scope -> symt.end()){
			type = it -> second.type;
			return 1;    //found
		}
		current_scope = current_scope -> p;
	}
	return 0;  //not found
}

std::string LookupTypeDef(const std::string type){
	std::string eq_type = type;
	std::map<std::string, id_attr>::iterator it;
	while ( (it = prog_scope.symt.find(eq_type)) != prog_scope.symt.end() ){
		if (it -> second.type == eq_type){
			return eq_type;
		}
		eq_type = it -> second.type;
	}
	return eq_type;   //type is not pre-defined
}

std::string Temp(void){
	return std::string("temp").append(to_string<int>(tmpc));
}

std::string Temp(int c){
	return std::string("temp").append(to_string<int>(c));
}

std::string Temp_Eq(void){
	return std::string("temp").append(to_string<int>(tmpc)).append(" := ");
}

std::string Temp_Eq(int c){
	return std::string("temp").append(to_string<int>(c)).append(" := ");
}

void print_label(const std::string s){
	tac<<std::string("\t", ind)<<s<<":\n";
	++ind;
}

void print_tac(const std::string s){
	tac<<std::string("\t", ind)<<s;
}

void print_var(const std::string s){
	current_var.append(std::string("\t", ind)).append(s);
}

int main(void){
	int ret = yyparse();
	//std::fstream sym(SYM_OUTPUT, std::ios::out | std::ios::trunc);
	if (ret == 1){
		std::cerr<<"\nsyntax error found\n";
	}else if (ret == 2){
		std::cerr<<"\nmemory exhausted\n";
	}else{
		std::cout<<"\nno syntax error found\n";
	}
	if (s_err){
		std::cerr<<"\n"<<s_err<<" semantic error(s) found\n";
	}else{
		std::cout<<"\nno semantic error found\n";
	}
	std::cout<<"\n";
	/*
	sym<<std::setw(FW)<<std::left<<"Symbol"<<std::setw(FW)<<std::left<<"Type"<<std::setw(FW)<<"Address"<<"\n\n";
	for (std::map<std::string, id_attr>::iterator itr = current_scope -> sym.begin(); itr != current_scope -> sym.end(); ++itr){
		sym<<std::setw(FW)<<std::left<<itr->first<<std::setw(FW)<<std::left<<itr->second.type<<std::setw(FW)<<std::left<<itr->second.addr<<"\n";
	}
	sym.close();
	*/
	rules.close();
	tac.close();
	return 0;
}
