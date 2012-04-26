/* BISON TOKEN NAMES */

%token T_AND T_BEGIN T_FORWARD T_DIV T_DO T_ELSE T_END T_FOR T_FUNCTION T_IF T_ARRAY T_MOD T_NOT T_OF T_OR T_PROCEDURE T_PROGRAM T_RECORD T_THEN T_TO T_TYPE T_VAR T_WHILE T_ID T_INT T_STR T_ASSIGNMENT T_RANGE T_RELOP T_MUL

%{

#include <fstream>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <map>   //data structure for symbol table
#include <vector>
#include <stack>
#include <string>
#include "lex.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE 1
#define FW 50
#define FUNC_REF "funcall "
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
		symt["typedef integer"] = id_attr("integer", 1);
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
bool temp_var, unop, lhs_unop;  //n_op: number of operators found in current expression <-- note: n_op is computed recursively
int argc = 0, current_argc = 0, s_err = 0, ind = 0, tmpc = 0, current_sgn, term_sgn, current_const, current_l, current_u, temp_exp, temp_m_exp, n_op;  //l/u:  array lower/upper bounds  //reg: indicating which register to use
std::string prog_name, current_id, current_ret, type, current_typename, exp_type, lhs_type, ret_type, vt, index_t, current_var, lhs_vt, lhs_var, current_factor, et, _et, m_et, current_exp, _current_exp, current_m_exp, current_m_exps, tmp_exp, current_relop;  //tac output for current variable/expression
std::stack<bool> temp_var_save;
std::stack<std::string> func_ref, current_id_save, current_ret_save, type_save, current_typename_save, exp_type_save, lhs_type_save, ret_type_save, vt_save, current_var_save, lhs_vt_save, lhs_var_save, current_factor_save, et_save, _et_save, m_et_save, current_exp_save, _current_exp_save, current_m_exp_save, current_m_exps_save, current_relop_save, array_t;  //stacks are required for nested '(' Expression ')' s and '[' Expression ']' s
std::stack<int> current_sgn_save, temp_exp_save, temp_m_exp_save, n_op_save, term_sgn_save;
std::vector<std::string> current_argv, current_param;
std::stack< std::vector<std::string> > func_param;
id_attr current_id_attr;
std::fstream rules(RULES_OUTPUT, std::ios::out | std::ios::trunc), tac(TAC_OUTPUT, std::ios::out | std::ios::trunc);

template <class T>
inline std::string to_string (const T & t){
	std::stringstream ss;
	ss << t;
	return ss.str();
}

int yyerror(const char *), UpdateVar(void), UpdateType(scope *), LookupId(scope *, const std::string, std::string &);
std::string LookupTypeDef(const std::string), Temp(void), Temp(int), Temp_Eq(void), Temp_Eq(int);
void print_label(const std::string), print_tac(const std::string), print_var(const std::string), print_exp(const std::string), print_m_exp(const std::string), print_m_exps(const std::string), print_exp_text(const std::string), print_addop(const std::string), print_mulop(const std::string), save_state(bool), restore_state(bool), print_multiplicand(void), add_param(void);

/*, print_m_exp_text(const std::string), print_exp_text(void), print_m_exp_text(void)*/

%}



/* THE GRAMMAR */

%%

Program
:
T_PROGRAM T_ID
{
	prog_name = std::string(yytext_ptr);
	current_scope -> symt[std::string("program ").append(prog_name)] = id_attr("program", current_scope -> symt.size());
	print_tac(std::string("goto program_").append(prog_name).append("\n\n"));
}
';' OptTypeDefinitions OptVariableDeclarations OptSubprogramDeclarations
{
	print_label(std::string("program_").append(prog_name));
}
CompoundStatement '.'
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
	print_label(std::string("procedure_").append(current_id)); //++ind;
}
'(' FormalParameterList {
	current_scope -> symt[std::string("procedure ").append(current_id)] = id_attr("void", current_scope -> symt.size());  //procedure returns type 'void'
	current_id_attr.type = "";
	current_id_attr.field_list.clear();
	argc = 0;
}')' ';' DeclarationBody
{
	print_tac("return\n\n");
	--ind;
	rules<<"ProcedureDeclaration\n";
}
;

FunctionDeclaration
:
T_FUNCTION T_ID
{
	current_ret = current_id = std::string(yytext_ptr);
	next_scope = new scope(current_scope);
	print_label(std::string("function_").append(current_id)); //++ind;
} '(' FormalParameterList ')' ':' ResultType
{
	current_scope -> symt[std::string("function ").append(current_id)] = id_attr(exp_type, current_scope -> symt.size());
	current_id_attr.type = "";
	current_id_attr.field_list.clear();
	argc = 0;
}';' DeclarationBody
{
	print_tac(std::string("funreturn ").append(current_ret).append("\n\n"));
	--ind;
	rules<<"FunctionDeclaration\n";
}
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
	lhs_var = current_var;
	current_var = "";
	lhs_vt = vt;
	lhs_unop = unop;
	unop = false;
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
	lhs_type = "";
	exp_type = "";   //note: CORNER CASE "a[i] := b[j]" contains 4 addresses, hence require a temporary when represented in tac form
	tac<<current_exp<<lhs_var;    //evaluate the right-hand side, get the left-hand side, and then perform the ':=' operator
//std::cout<<"LINE 322 PRINTING LHS_VAR:\n"<<lhs_var<<std::endl;
	current_exp = "";
	lhs_var = "";
	if (lhs_unop && (unop || (temp_exp == 2) || (temp_exp == 1 && temp_m_exp == 2))){
		print_tac(Temp_Eq(++tmpc).append(et).append("\n"));
		print_tac(lhs_vt.append(" := ").append(Temp()).append("\n"));
	}else{
		print_tac(lhs_vt.append(" := ").append(et).append("\n"));
	}
	et = "";
	current_m_exp = "";
	current_var = "";
	lhs_unop = false;
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
'('
{
	save_state(true);
}
ActualParameterList
')'
{
	restore_state(true);
	rules<<"ProcedureStatement\n";
}
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
	current_id_attr.type.append(LookupTypeDef(type));
	current_id_attr.field_list["."] = type;
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
/*
	for (int i = 0; i < current_argc; ++i){
		current_id_attr.field_list[current_argv[i]] = type;  //entry for type of field in symbol table, note: use typename here
		current_id_attr.type.append(LookupTypeDef(type)).append(",");
	}
	current_argv.clear();
	current_argc = 0;
*/
	UpdateType(NULL);
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
SimpleExpression
{
	_et = et;
	_current_exp = current_exp; //et = "";
}
RelationalOp
SimpleExpression
{
	current_exp = _current_exp.append(current_exp);
	et = _et.append(" ").append(current_relop).append(" ").append(et);
	temp_exp = 2;
	exp_type = "boolean";
	rules<<"Expression\n";
}
;

RelationalOp
:
T_RELOP
{
	current_relop = std::string(yytext_ptr);
	rules<<"RelationalOp\n";
}
|
'='
{
	current_relop = "=";
	rules<<"RelationalOp\n";
}
;

SimpleExpression
:
{
	temp_exp = 1;  //at least 1 term exists on the right-hand side
	n_op = 0;
	current_exp = "";
	current_m_exps = "";
	et = "";
}
Term
{
	term_sgn = 1;
	print_multiplicand();
}
Summand
{
	current_exp = current_m_exps.append(current_exp);
	rules<<"SimpleExpression\n";
}
|
Sign
{
	temp_exp = 1;  //at least 1 term exists on the right-hand side
	n_op = 0;
	term_sgn = current_sgn;
	current_exp = "";
	current_m_exps = "";
	et = "";
}
Term
{
	print_multiplicand();
}
Summand
{
	current_exp = current_m_exps.append(current_exp);
	rules<<"SimpleExpression\n";
}
;

MulOp
:
T_MUL
{
	print_mulop(" * ");
	rules<<"MulOp\n";
}
|
T_DIV
{
	print_mulop(" / ");
	rules<<"MulOp\n";
}
|
T_MOD
{
	print_mulop(" mod ");
	rules<<"MulOp\n";
}
|
T_AND
{
	print_mulop(" and ");
	rules<<"MulOp\n";
}
;

Multiplicand
:
/* empty */
|
MulOp Factor
{
	if (temp_m_exp <= 2){
		m_et.append(current_factor);
	}else{
		current_m_exp.append(current_factor).append("\n");
	}
	current_factor = "";
}
Multiplicand
{
	rules<<"Multiplicand\n";
}
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
	print_addop(current_sgn == -1 ? " - " : " + ");
	rules<<"AddOp\n";
}
|
T_OR
{
	print_addop(" or ");
	rules<<"AddOp\n";
}
;

Term
:
Factor
{
	temp_m_exp = 1;
	m_et = current_factor;
	current_m_exp = "";
}
Multiplicand
{
	rules<<"Term\n";
}
;

Summand
:
/* empty */
{
	rules<<"Summand\n";
}
|
AddOp Term
{
	term_sgn = 1;
	print_multiplicand();
	if (temp_exp > 2){
		current_exp.append("\n");
	}
}
Summand {
	rules<<"Summand\n";
}
;

Factor
:
{
	unop = false;
}
T_INT
{
	current_factor = std::string(yytext_ptr);
	exp_type = "integer";
	rules<<"Factor\n";
}
|
T_STR
{
	current_factor = std::string(yytext_ptr);
	exp_type = "string";
	rules<<"Factor\n";
}
|
Variable
{
	current_m_exps.append(current_var);
	current_var = "";
	current_factor = vt;
	rules<<"Factor\n";
}
|
FunctionReference
{ //unop = true;  //note: with the current grammar using unop for function calls and params would be too complicated and error-prone
	for (int i = 0; i < func_param.top().size(); ++i){ //print_tac(std::string("param ").append(func_param.top()[i]).append("\n"));
		print_m_exps(std::string("param ").append(func_param.top()[i]).append("\n"));
	}
	func_param.pop();
	print_m_exps(Temp_Eq(++tmpc).append(FUNC_REF).append(func_ref.top()).append("\n"));
	current_factor = Temp();
	func_ref.pop();
	rules<<"Factor\n";
}
|
T_NOT Factor
{	//exp_type = "boolean";  /* this should be unnecessary */
	rules<<"Factor\n";
}
|
'('
{
	save_state(false);
}
Expression
{
	exp_type = "";
	if (n_op == 0){  //constant or single variable
		current_factor = et;
	}else if (temp_exp == 2){  //only 1 operator in current expression
		print_exp(Temp_Eq(++tmpc).append(et).append("\n"));
		current_factor = Temp();
	}else{     //temporary variable required
		current_factor = et;
	}
	tmp_exp = current_exp;
}
')'
{
	restore_state(false);
	current_m_exps.append(tmp_exp);
	rules<<"Factor\n";
}
;

FunctionReference
:
T_ID
{
//HEREHERE
	if (!LookupId(current_scope, std::string("function ").append(prev_id), exp_type)){  // <-- must be a function
		yyerror(std::string("invalid function reference: function '").append(prev_id).append("' is not defined").c_str());
		++s_err;
	}
	func_ref.push(prev_id);   //reason for using stack: function reference can also occur in ActualParameterList
	ret_type = exp_type;
}
'('
{
	save_state(true);
}
ActualParameterList  //similar reasoning as above
{
	func_param.push(current_param);
	current_param.clear();
}
')'
{
	restore_state(true);
	exp_type = ret_type;
	rules<<"FunctionReference\n";
//	std::cout<<"FunctionReference\n"<<"func_ref.size() == "<<func_ref.size()<<std::endl;
}
;

Variable
:
T_ID
{       /* note: the 'variable' in this context could also be a function's return value */
	temp_var = false;
	unop = false;
	if (!LookupId(current_scope, std::string("var ").append(prev_id), exp_type) && !LookupId(current_scope, std::string("function ").append(prev_id), exp_type)){  // <-- must be a variable
		yyerror(std::string("variable '").append(prev_id).append("' is not declared").c_str());
		++s_err;
	}
	current_var = "";
	vt = prev_id;
}
ComponentSelection {
	if (temp_var){
		vt = Temp();
	}
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
	if (unop){
		print_var(Temp_Eq(++tmpc).append(vt).append("\n"));
		print_var(Temp_Eq(tmpc + 1).append(Temp()).append("."));
		unop = false;
	}else if (!temp_var){
		print_var(Temp_Eq(tmpc + 1).append(vt).append("."));
		temp_var = true;
	}else{
		print_var(Temp_Eq(tmpc + 1).append(Temp()).append("."));
	}
	vt = Temp(++tmpc);
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
}
ComponentSelection
{
	rules<<"ComponentSelection\n";
}
|
'['
{
	array_t.push(vt);
	save_state(true);
}
Expression
{
	vt = array_t.top();
	array_t.pop();
	if (unop){
		print_exp(Temp_Eq(++tmpc).append(et).append("\n"));
		et = Temp();
		unop = false;
	}else if ((temp_exp == 2) || (temp_exp == 1 && temp_m_exp == 2)){  //note: in tac form [] operator can only have constant or 1 single variable as argument
		print_exp(Temp_Eq(++tmpc).append(et).append("\n"));
		et = Temp();
	}
	if (!temp_var){
		index_t = vt.append("[").append(et).append("]");
	}else{
		index_t = Temp().append("[").append(et).append("]");
	}
	tac<<current_exp<<current_var;    //evaluate the right-hand side, get the left-hand side, and then perform the ':=' operator
}
']'
{
	restore_state(true);
	current_var = "";
	vt = index_t;
	unop = true;
	std::map<std::string, id_attr>::iterator t;
	std::map<std::string, std::string>::iterator ft;
	if (exp_type != ""){    //if no error occurred in previous type lookup
		if ( (t = current_scope -> symt.find(std::string("typedef ").append(exp_type))) == current_scope -> symt.end() ){
			yyerror(std::string("type '").append(exp_type).append("' is not defined").c_str());
			exp_type = "";
			++s_err;
		}else if ( (ft = t -> second.field_list.find(".")) == t -> second.field_list.end() ){
			yyerror(std::string("type '").append(exp_type).append("' is not defined as an array").c_str());
			exp_type = "";
			++s_err;
		}else{
			exp_type = ft -> second;
		}
	}
}
ComponentSelection{
	rules<<"ComponentSelection\n";
}
;

ActualParameterList
:
/* empty */ {rules<<"ActualParameterList\n";}
|
Expression
{
	add_param();
}
OptExpressions {rules<<"ActualParameterList\n";}
;

OptExpressions
:
/* empty */ {rules<<"OptExpressions\n";}
|
',' Expression
{
	add_param();
}
OptExpressions {rules<<"OptExpressions\n";}
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
		}else{  /* note: at this level use typename instead */
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
			current_id_attr.field_list[current_argv[i]] = type;
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
	tac<<std::string(ind++, '\t')<<s<<":\n";
}

void print_tac(const std::string s){
	tac<<std::string(ind, '\t')<<s;
}

void print_var(const std::string s){
	current_var.append(std::string(ind, '\t')).append(s);
}

void print_exp(const std::string s){
	current_exp.append(std::string(ind, '\t')).append(s);
}

void print_m_exp(const std::string s){
	current_m_exp.append(std::string(ind, '\t')).append(s);
}

void print_m_exps(const std::string s){
	current_m_exps.append(std::string(ind, '\t')).append(s);
}

void print_addop(const std::string op){
//print_tac(std::string("temp_exp == ").append(to_string<int>(temp_exp)).append(", temp_m_exp == ").append(to_string<int>(temp_m_exp)).append("\n"));
	if (temp_exp < 2){
		if (unop || (temp_m_exp == 2)){   //note: temp_m_exp may only need to be boolean?
			print_exp(Temp_Eq(++tmpc).append(et).append("\n"));
			et = Temp();
		}
		et.append(op);
	}else{
		if (unop || (temp_exp == 2 && temp_m_exp == 1)){
			print_exp(Temp_Eq(++tmpc).append(et).append("\n"));
		}
		print_exp(Temp_Eq(tmpc + 1).append(Temp()).append(op));
		et = Temp(++tmpc);
	}
	unop = false;
	++n_op;
	++temp_exp;
}

void print_mulop(const std::string op){
	if (temp_m_exp < 2){
		if (unop){
			print_exp(Temp_Eq(++tmpc).append(m_et).append("\n"));
			m_et = Temp();
		}
		m_et.append(op);
	}else{
		if (unop || (temp_m_exp == 2)){
			print_m_exp(Temp_Eq(++tmpc).append(m_et).append("\n"));
		}
		print_m_exp(Temp_Eq(tmpc + 1).append(Temp()).append(op));
		m_et = Temp(++tmpc);
	}
	unop = false;
	++n_op;
	++temp_m_exp;
}

void print_exp_text(const std::string s){
	if (temp_exp <= 2){
		et.append(s);
	}else{
		current_exp.append(s);
	}
}

void save_state(bool save_current_factor){
	temp_var_save.push(temp_var);
	current_id_save.push(current_id);
	current_ret_save.push(current_ret);
	type_save.push(type);
	current_typename_save.push(current_typename);
	exp_type_save.push(exp_type);
	lhs_type_save.push(lhs_type);
	ret_type_save.push(ret_type);
	vt_save.push(vt);
	current_var_save.push(current_var);
	lhs_vt_save.push(lhs_vt);
	lhs_var_save.push(lhs_var);
	if (save_current_factor){
		current_factor_save.push(current_factor);
	}
	et_save.push(et);
	_et_save.push(_et);
	m_et_save.push(m_et);
	current_exp_save.push(current_exp);
	_current_exp_save.push(_current_exp);
	current_m_exp_save.push(current_m_exp);
	current_m_exps_save.push(current_m_exps);
	current_relop_save.push(current_relop);
	current_sgn_save.push(current_sgn);
	temp_exp_save.push(temp_exp);
	temp_m_exp_save.push(temp_m_exp);
	n_op_save.push(n_op);
	term_sgn_save.push(term_sgn);
}

void restore_state(bool recover_current_factor){
	temp_var = temp_var_save.top();
	temp_var_save.pop();
	current_id = current_id_save.top();
	current_id_save.pop();
	current_ret = current_ret_save.top();
	current_ret_save.pop();
	type = type_save.top();
	type_save.pop();
	current_typename = current_typename_save.top();
	current_typename_save.pop();
	exp_type = exp_type_save.top();
	exp_type_save.pop();
	lhs_type = lhs_type_save.top();
	lhs_type_save.pop();
	ret_type = ret_type_save.top();
	ret_type_save.pop();
	vt = vt_save.top();
	vt_save.pop();
	current_var = current_var_save.top();
	current_var_save.pop();
	lhs_vt = lhs_vt_save.top();
	lhs_vt_save.pop();
	lhs_var = lhs_var_save.top();
	lhs_var_save.pop();
	if (recover_current_factor){
		current_factor = current_factor_save.top();
		current_factor_save.pop();
	}
	et = et_save.top();
	et_save.pop();
	_et = _et_save.top();
	_et_save.pop();
	m_et = m_et_save.top();
	m_et_save.pop();
	current_exp = current_exp_save.top();
	current_exp_save.pop();
	_current_exp = _current_exp_save.top();
	_current_exp_save.pop();
	current_m_exp = current_m_exp_save.top();
	current_m_exp_save.pop();
	current_m_exps = current_m_exps_save.top();
	current_m_exps_save.pop();
	current_relop = current_relop_save.top();
	current_relop_save.pop();
	current_sgn = current_sgn_save.top();
	current_sgn_save.pop();
	temp_exp = temp_exp_save.top();
	temp_exp_save.pop();
	temp_m_exp = temp_m_exp_save.top();
	temp_m_exp_save.pop();
	n_op = n_op_save.top() + n_op;   //note: n_op is the total number of operations found in the entire expression
	n_op_save.pop();
	term_sgn = term_sgn_save.top();
	term_sgn_save.pop();
}

void print_multiplicand(void){
	if (temp_m_exp == 1){
		print_exp_text(term_sgn == 1 ? current_factor : std::string("-").append(current_factor));    //no multiplication required, print directly as part of the summand
	}else if (temp_m_exp == 2){
		if (temp_exp == 1){
			print_exp_text(term_sgn == 1 ? m_et : std::string("-").append(m_et));   //e.g. c := a * b; no temporary required
		}else{
			print_m_exp(Temp_Eq(++tmpc).append(term_sgn == 1 ? m_et : std::string("-").append(m_et)).append("\n"));
			current_m_exps.append(current_m_exp);  //e.g. c := a * b; requiring 1 temporary
			print_exp_text(Temp());
		}
	}else{     //temporary required, reverse sign of temporary if necessary
		current_m_exps.append(current_m_exp);
		if (term_sgn == -1){
			print_m_exps(std::string(m_et).append(" := -").append(m_et).append("\n"));
		}
		print_exp_text(m_et);
	}
	current_factor = "";
}

void add_param(void){
	tac<<current_exp;
	current_exp = "";
	current_m_exp = "";
	exp_type = "";
	if (unop || (temp_exp == 2) || (temp_exp == 1 && temp_m_exp == 2)){
		print_tac(Temp_Eq(++tmpc).append(et).append("\n"));  //print_tac(std::string("param ").append(Temp()).append("\n"));
		current_param.push_back(Temp());
	}else{
		current_param.push_back(et);   //print_tac(std::string("param ").append(et).append("\n"));
	}
	et = "";
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
