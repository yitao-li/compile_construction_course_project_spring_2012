/* BISON TOKEN NAMES */

%token T_AND T_BEGIN T_FORWARD T_DIV T_DO T_ELSE T_END T_FOR T_FUNCTION T_IF T_ARRAY T_MOD T_NOT T_OF T_OR T_PROCEDURE T_PROGRAM T_RECORD T_THEN T_TO T_TYPE T_VAR T_WHILE T_ID T_INT T_STR T_ASSIGNMENT T_RANGE T_RELOP T_MULOP T_ADDOP

%{

#include <fstream>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <map>   //data structure for symbol table
#include <list>
#include <string>
#include "lex.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE 1
#define FW 50
#define SYM_OUTPUT "symtable.out"
#define RULES_OUTPUT "rules.out"

typedef struct id_attr{
	std::string type;
	size_t addr;
} id_attr;

typedef struct scope{
	std::map< std::string, id_attr > symt;
	scope *p;
	scope(void):p(NULL){}
	scope(scope *_p):p(_p){}
} scope;

scope global_scope, *current_scope = &global_scope;

int argc = 0, current_argc = 0;
std::string current_id, current_type, type;
std::list<std::string> current_argv;
std::fstream rules_out(RULES_OUTPUT, std::ios::out | std::ios::trunc);

int yyerror(const char *);
int UpdateVar(void), UpdateType(void);

%}



/* THE GRAMMAR */

%%

Program
:
T_PROGRAM T_ID
{
	current_scope -> symt[std::string("program ").append(std::string(yytext_ptr))] = {"program", current_scope -> symt.size()};
	std::cout<<"ENTERING "<<(current_scope)<<std::endl;
	current_scope = new scope(current_scope);
}
';' OptTypeDefinitions OptVariableDeclarations OptSubprogramDeclarations CompoundStatement '.'
{
	rules_out<<"Program\n";
	current_scope = current_scope -> p;
	std::cout<<"ENTERING "<<(current_scope)<<std::endl;
}
;

TypeDefinitions
:
T_TYPE TypeDefinition ';' _OptTypeDefinitions {rules_out<<"TypeDefinitions\n";}
;

OptTypeDefinitions
:
/* empty */ {rules_out<<"OptTypeDefinitions\n";}
|
TypeDefinitions {rules_out<<"OptTypeDefinitions\n";}
;

_OptTypeDefinitions
:
/* empty */ {rules_out<<"_OptTypeDefinitions\n";}
|
TypeDefinition ';' _OptTypeDefinitions {rules_out<<"_OptTypeDefinitions\n";}
;

TypeDefinition
:
T_ID {
	current_id = std::string("typedef ").append(std::string(yytext_ptr));
} '=' Type
{
	current_scope -> symt[current_id] = {current_type, current_scope -> symt.size()};
	current_type = "";
}
{rules_out<<"TypeDefinition\n";}
;

VariableDeclarations
:
T_VAR VariableDeclaration ';' _OptVariableDeclarations {rules_out<<"VariableDeclarations\n";}
;

VariableDeclaration
:
IdentifierList ':' Type {UpdateVar();} {rules_out<<"VariableDeclaration\n";}
;

OptVariableDeclarations
:
/* empty */ {rules_out<<"OptVariableDeclarations\n";}
|
VariableDeclarations {rules_out<<"OptVariableDeclarations\n";}
;

_OptVariableDeclarations
:
/* empty */ {rules_out<<"_OptVariableDeclarations\n";}
|
VariableDeclaration ';' _OptVariableDeclarations {rules_out<<"_OptVariableDeclarations\n";}
;

OptSubprogramDeclarations
:
/* empty */ {rules_out<<"OptSubprogramDeclarations\n";}
|
SubprogramDeclarations {rules_out<<"OptSubprogramDeclarations\n";}
;

SubprogramDeclarations
:
/* empty */ {rules_out<<"SubprogramDeclarations\n";}
|
SubprogramDeclaration ';' SubprogramDeclarations {rules_out<<"SubprogramDeclarations\n";}
;

SubprogramDeclaration
:
ProcedureDeclaration {rules_out<<"SubprogramDeclaration\n";}
|
FunctionDeclaration {rules_out<<"SubprogramDeclaration\n";}
;

ProcedureDeclaration
:
T_PROCEDURE T_ID {
	current_id = std::string(yytext_ptr);
	}
'(' FormalParameterList {
	std::stringstream ss;
	ss << argc;
	argc = 0;
	current_type = "";
	current_scope -> symt[std::string("procedure ").append(current_id)] = {ss.str(), current_scope -> symt.size()};
}')' ';' DeclarationBody {rules_out<<"ProcedureDeclaration\n";}
;

FunctionDeclaration
:
T_FUNCTION T_ID {
	current_id = std::string(yytext_ptr);
} '(' FormalParameterList {
	std::stringstream ss;
	ss << argc;
	argc = 0;
	current_type = "";
	current_scope -> symt[std::string("function ").append(current_id)] = {ss.str(), current_scope -> symt.size()};
} ')' ':' ResultType ';' DeclarationBody {rules_out<<"FunctionDeclaration\n";}
;

DeclarationBody
:
Block
{
	rules_out<<"DeclarationBody\n";
}
|
T_FORWARD
{
	rules_out<<"DeclarationBody\n";
}
;

FormalParameterList
:
{
	argc = 0;
}
/* empty */ {rules_out<<"FormalParameterList\n";}
|
{
	argc = 0;
}
IdentifierList ':' Type {
/*
	for (int i = 0; i < current_argc; ++i){
		current_type.append(type).append(",");
	}
	current_argv.clear();
	argc += current_argc;
	current_argc = 0;
*/
	UpdateType();
}OptIdentifiers {rules_out<<"FormalParameterList\n";}
;

OptIdentifiers
:
/* empty */ {rules_out<<"OptIdentifiers\n";}
|
';' IdentifierList ':' Type {
/*
	for (int i = 0; i < current_argc; ++i){
		current_type.append(type).append(",");
	}
	current_argv.clear();
	argc += current_argc;
	current_argc = 0;
*/
	UpdateType();
}
OptIdentifiers {rules_out<<"OptIdentifiers\n";}
;

Block
:
{
	current_scope = new scope(current_scope);
}
CompoundStatement
{
	rules_out<<"Block\n";
	current_scope = current_scope -> p;
}
|
VariableDeclarations CompoundStatement
{
	rules_out<<"Block\n";
	current_scope = current_scope -> p;
}
;

CompoundStatement
:
T_BEGIN StatementSequence T_END {rules_out<<"CompoundStatement\n";}
;

StatementSequence
:
Statement Statements {rules_out<<"StatementSequence\n";}
;

Statement
:
SimpleStatement {rules_out<<"Statement\n";}
|
StructuredStatement {rules_out<<"Statement\n";}
;

SimpleStatement
:
/* empty */ {rules_out<<"SimpleStatement\n";}
|
AssignmentStatement {rules_out<<"SimpleStatement\n";}
|
ProcedureStatement {rules_out<<"SimpleStatement\n";}
;

AssignmentStatement
:
Variable T_ASSIGNMENT Expression {rules_out<<"AssignmentStatement\n";}
;

ProcedureStatement
:
T_ID '(' ActualParameterList ')' {rules_out<<"ProcedureStatement\n";}
;

StructuredStatement
:
CompoundStatement {rules_out<<"StructuredStatement\n";}
|
T_IF Expression T_THEN Statement CloseIf {rules_out<<"StructuredStatement\n";}
|
T_WHILE Expression T_DO Statement {rules_out<<"StructuredStatement\n";}
|
T_FOR T_ID T_ASSIGNMENT Expression T_TO Expression T_DO Statement {rules_out<<"StructuredStatement\n";}
;

CloseIf
:
/* empty */ {rules_out<<"CloseIf\n";}
|
T_ELSE Statement {rules_out<<"CloseIf\n";}
;

Statements
:
/* empty */ {rules_out<<"Statements\n";}
|
';' Statement Statements {rules_out<<"Statements\n";}
;

Type   /* todo: replace literal typename with special (reserved) symbols */
:
T_ID {
	type = std::string(yytext_ptr);
	if (current_type == ""){
		current_type = type;
	}
} {rules_out<<"Type\n";}
|
T_ARRAY '[' Constant T_RANGE Constant ']' T_OF {
	current_type.append("array_of_");
} Type {
	current_type.append(type);
} {rules_out<<"Type\n";}
|
T_RECORD {
	current_type.append("record_{");
} FieldList T_END {
	current_type.append("}");
} {rules_out<<"Type\n";}
;

ResultType
:
T_ID {rules_out<<"ResultType\n";}
;

FieldList
:
/* empty */ {rules_out<<"FieldList\n";}
|
IdentifierList ':' Type {
	for (int i = 0; i < current_argc; ++i){
		current_type.append(type).append(",");
	}
	current_argv.clear();
	current_argc = 0;
}
OptIdentifiers {rules_out<<"FieldList\n";}
;

Constant
:
T_INT {rules_out<<"Constant\n";}
|
Sign T_INT {rules_out<<"Constant\n";}
;

Expression
:
SimpleExpression {rules_out<<"Expression\n";}
|
SimpleExpression RelationalOp SimpleExpression {rules_out<<"Expression\n";}
;

RelationalOp
:
T_RELOP {rules_out<<"RelationalOp\n";}
|
'=' {rules_out<<"RelationalOp\n";}
;

SimpleExpression
:
Term Summand {rules_out<<"SimpleExpression\n";}
|
Sign Term Summand {rules_out<<"SimpleExpression\n";}
;

AddOp
:
T_ADDOP {rules_out<<"AddOp\n";}
|
T_OR {rules_out<<"AddOp\n";}
;

Term
:
Factor Multiplicand {rules_out<<"Term\n";}
;

Summand
:
/* empty */ {rules_out<<"Summand\n";}
|
AddOp Term Summand {rules_out<<"Summand\n";}
;

MulOp
:
T_MULOP {rules_out<<"MulOp\n";}
|
T_DIV {rules_out<<"MulOp\n";}
|
T_MOD {rules_out<<"MulOp\n";}
|
T_AND {rules_out<<"MulOp\n";}
;

Factor
:
T_INT {rules_out<<"Factor\n";}
|
T_STR {rules_out<<"Factor\n";}
|
Variable {rules_out<<"Factor\n";}
|
FunctionReference {rules_out<<"Factor\n";}
|
T_NOT Factor {rules_out<<"Factor\n";}
|
'(' Expression ')' {rules_out<<"Factor\n";}
;

Multiplicand
:
/* empty */ {rules_out<<"Multiplicand\n";}
|
MulOp Factor Multiplicand {rules_out<<"Multiplicand\n";}
;

FunctionReference
:
T_ID '(' ActualParameterList ')' {rules_out<<"FunctionReference\n";}
;

Variable
:
T_ID ComponentSelection {rules_out<<"Variable\n";}
;

ComponentSelection
:
/* empty */ {rules_out<<"ComponentSelection\n";}
|
'.' T_ID ComponentSelection {rules_out<<"ComponentSelection\n";}
|
'[' Expression ']' ComponentSelection {rules_out<<"ComponentSelection\n";}
;

ActualParameterList
:
/* empty */ {rules_out<<"ActualParameterList\n";}
|
Expression OptExpressions {rules_out<<"ActualParameterList\n";}
;

OptExpressions
:
/* empty */ {rules_out<<"OptExpressions\n";}
|
',' Expression OptExpressions {rules_out<<"OptExpressions\n";}
;

IdentifierList
:
T_ID {
	current_argv.push_back(std::string(yytext_ptr));
	++current_argc;
} Identifiers {rules_out<<"IdentifierList\n";}
;

Identifiers
:
/* empty */ {rules_out<<"Identifiers\n";}
|
',' T_ID {
	current_argv.push_back(std::string(yytext_ptr));
	++current_argc;
} Identifiers {rules_out<<"Identifiers\n";}
;

Sign
:
'+' {rules_out<<"Sign\n";}
|
'-' {rules_out<<"Sign\n";}
;

%%

int yyerror(const char *s){
	std::cerr<<s<<std::endl;
	return 0;
}

int UpdateVar(void){
	for (std::list<std::string>::iterator itr = current_argv.begin(); itr != current_argv.end(); ++itr){
		current_scope -> symt[std::string("var ").append(*itr)] = {type, current_scope -> symt.size()};
	}
	current_argv.clear();
	current_argc = 0;
	return 0;
}

int UpdateType(void){
	for (int i = 0; i < current_argc; ++i){
		current_type.append(type).append(",");
	}
	current_argv.clear();
	argc += current_argc;
	current_argc = 0;
	return 0;
}

int main(void){
	int ret = yyparse();
	std::fstream sym_out(SYM_OUTPUT, std::ios::out | std::ios::trunc);
	if (ret == 1){
		std::cout<<"\nsyntax error found\n";
	}else if (ret == 2){
		std::cout<<"\nmemory exhausted\n";
	}else{
		std::cout<<"\nno syntax error found\n";
	}
	std::cout<<"\n";
	sym_out<<std::setw(FW)<<std::left<<"Symbol"<<std::setw(FW)<<std::left<<"Type"<<std::setw(FW)<<"Address"<<"\n\n";
	for (std::map<std::string, id_attr>::iterator itr = current_scope -> symt.begin(); itr != current_scope -> symt.end(); ++itr){
		sym_out<<std::setw(FW)<<std::left<<itr->first<<std::setw(FW)<<std::left<<itr->second.type<<std::setw(FW)<<std::left<<itr->second.addr<<"\n";
	}
	sym_out.close();
	rules_out.close();
	return 0;
}
