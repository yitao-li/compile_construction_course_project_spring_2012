/* BISON TOKEN NAMES */

%token T_AND T_BEGIN T_FORWARD T_DIV T_DO T_ELSE T_END T_FOR T_FUNCTION T_IF T_ARRAY T_MOD T_NOT T_OF T_OR T_PROCEDURE T_PROGRAM T_RECORD T_THEN T_TO T_TYPE T_VAR T_WHILE T_ID T_INT T_STR T_ASSIGNMENT T_RANGE T_RELOP T_MULOP T_ADDOP

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
	size_t addr;
} id_attr;

typedef struct scope{
	std::map< std::string, id_attr > symt;
	scope *p;
	scope(void):p(NULL){
		symt["integer"] = {"integer", 0};    //predefined types
		symt["string"] = {"string", 1};
		symt["boolean"] = {"boolean", 2};
		symt["true"] = {"true", 3};
		symt["false"] = {"false", 3};
	}
	scope(scope *_p):p(_p){}
} scope;

scope prog_scope, *current_scope = &prog_scope, *next_scope;

int argc = 0, current_argc = 0, s_err = 0, ind = 0, current_sgn, current_const, current_l, current_u;
std::string current_id, current_type, type, current_typename, exp_type, lhs_type, ret_type;
std::vector<std::string> current_argv;
std::fstream rules(RULES_OUTPUT, std::ios::out | std::ios::trunc), tac(TAC_OUTPUT, std::ios::out | std::ios::trunc);

template <class T>
inline std::string to_string (const T & t){
	std::stringstream ss;
	ss << t;
	return ss.str();
}

int yyerror(const char *), UpdateVar(void), UpdateType(scope *), LookupId(scope *, const std::string, std::string &);
std::string LookupTypeDef(const std::string);
void print_label(const std::string s), print_tac(const std::string s);

%}



/* THE GRAMMAR */

%%

Program
:
T_PROGRAM T_ID
{
	current_scope -> symt[std::string("program ").append(std::string(yytext_ptr))] = {"program", current_scope -> symt.size()};
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
	current_scope -> symt[current_id] = {current_type, current_scope -> symt.size()};
	prog_scope.symt[current_typename] = {LookupTypeDef(current_type), current_scope -> symt.size()};
	current_type = "";
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
}
'(' FormalParameterList {
	current_scope -> symt[std::string("procedure ").append(current_id)] = {"void", current_scope -> symt.size()};  //procedure returns type 'void'
	print_label(current_id);
	current_type = "";
	argc = 0;
}')' ';' DeclarationBody {rules<<"ProcedureDeclaration\n";}
;

FunctionDeclaration
:
T_FUNCTION T_ID
{
	current_id = std::string(yytext_ptr);
	next_scope = new scope(current_scope);
} '(' FormalParameterList ')' ':' ResultType
{
	current_scope -> symt[std::string("function ").append(current_id)] = {exp_type, current_scope -> symt.size()};
	current_type = "";
	argc = 0;
}';' DeclarationBody {rules<<"FunctionDeclaration\n";}
;

DeclarationBody
:
Block
{
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
}
T_ASSIGNMENT Expression
{
	if (lhs_type != "" && exp_type != "" && lhs_type != exp_type){  //if both lhs and rhs are syntatically valid (hence have types)
		yyerror(std::string("incompatible types in assignment of ").append(exp_type).append(" to ").append(lhs_type).c_str());
		++s_err;
	}
	lhs_type = "";
	exp_type = "";
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
	if (current_type == ""){
		current_type = type;
	}
} {rules<<"Type\n";}
|
T_ARRAY '[' Constant{current_l = current_const;} T_RANGE Constant{current_u = current_const;} ']' T_OF
{
	current_type.append("array[").append(to_string<int>(current_l)).append("..").append(to_string<int>(current_u)).append("]_of_");
} Type {rules<<"Type\n";}
{
	current_type.append(LookupTypeDef(type));
}
|
T_RECORD {
	current_type.append("record{");
} FieldList T_END {
	current_type.append("}");
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

FieldList
:
/* empty */ {rules<<"FieldList\n";}
|
IdentifierList ':' Type {
	for (int i = 0; i < current_argc; ++i){
		current_type.append(LookupTypeDef(type)).append(",");
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
T_RELOP {rules<<"RelationalOp\n";}
|
'=' {rules<<"RelationalOp\n";}
;

SimpleExpression
:
Term Summand {rules<<"SimpleExpression\n";}
|
Sign Term Summand {rules<<"SimpleExpression\n";}
;

AddOp
:
T_ADDOP {rules<<"AddOp\n";}
|
T_OR {rules<<"AddOp\n";}
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
	exp_type = "integer";
	rules<<"Factor\n";
}
|
T_STR
{
	exp_type = "string";
	rules<<"Factor\n";
}
|
Variable {rules<<"Factor\n";}
|
FunctionReference {rules<<"Factor\n";}
|
T_NOT Factor
{
	//exp_type = "boolean";  /* not sure if this is necessary */
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
	if (!LookupId(current_scope, std::string("var ").append(prev_id), exp_type) && !LookupId(current_scope, std::string("function ").append(prev_id), exp_type)){  // <-- must be a variable
		yyerror(std::string("variable '").append(prev_id).append("' is not declared").c_str());
		++s_err;
	}
}
ComponentSelection {rules<<"Variable\n";}
;

ComponentSelection
:
/* empty */ {rules<<"ComponentSelection\n";}
|
'.' T_ID ComponentSelection {rules<<"ComponentSelection\n"; /* TODO: check whether the specified component exists in object */}
|
'[' Expression ']' ComponentSelection {rules<<"ComponentSelection\n";}
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

Sign
:
'+'
{
	current_sgn = 1;
	rules<<"Sign\n";
}
|
'-'
{
	current_sgn = -1;
	rules<<"Sign\n";
}
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
			current_scope -> symt[s] = {LookupTypeDef(type), current_scope -> symt.size()};
		}
	}
	current_argv.clear();
	current_argc = 0;
	return 0;
}

int UpdateType(scope *next_scope){
	if (next_scope){     /* <-- this is for FormalParameterList only */
		for (int i = 0; i < current_argc; ++i){
			current_type.append(LookupTypeDef(type)).append(",");    //assumption: formal parameter overwrites variable declaration with the same name that is outside the current scope
			next_scope -> symt[std::string("var ").append(current_argv[i])] = {LookupTypeDef(type), current_scope -> symt.size()};
		}
	}else{
		for (int i = 0; i < current_argc; ++i){
			current_type.append(LookupTypeDef(type)).append(",");
		}
	}
	current_argv.clear();
	argc += current_argc;
	current_argc = 0;
	return 0;
}

int LookupId(scope *current_scope, const std::string name, std::string & type){
	std::map< std::string, id_attr >::iterator it;
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
	std::map< std::string, id_attr >::iterator it;
	while ( (it = prog_scope.symt.find(eq_type)) != prog_scope.symt.end() ){
		if (it -> second.type == eq_type){
			return eq_type;
		}
		eq_type = it -> second.type;
	}
	return eq_type;   //type is not pre-defined
}

void print_label(const std::string s){
	tac<<std::string('\t', ind)<<s<<":\n";
	++ind;
}

void print_tac(const std::string s){
	tac<<std::string('\t', ind)<<s<<"\n";
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
