/* BISON TOKEN NAMES */

%token T_AND T_BEGIN T_FORWARD T_DIV T_DO T_ELSE T_END T_FOR T_FUNCTION T_IF T_ARRAY T_MOD T_NOT T_OF T_OR T_PROCEDURE T_PROGRAM T_RECORD T_THEN T_TO T_TYPE T_VAR T_WHILE T_ID T_INT T_STR T_ASSIGNMENT T_RANGE T_RELOP T_MULOP T_ADDOP

%{

#include <fstream>
#include <iostream>
#include <iomanip>
#include <map>   //data structure for symbol table
#include <string>
#include "lex.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE 1
#define FW 40

struct id_attr{
	std::string type;
	size_t addr;
};

std::string current_id, current_type;

std::map< std::string, id_attr > symt;

int yyerror(const char *);

%}



/* THE GRAMMAR */

%%

Program
:
T_PROGRAM T_ID ';' OptTypeDefinitions OptVariableDeclarations OptSubprogramDeclarations CompoundStatement '.'
;

TypeDefinitions
:
T_TYPE TypeDefinition ';' _OptTypeDefinitions 
;

OptTypeDefinitions
:
/* empty */
|
TypeDefinitions
;

_OptTypeDefinitions
:
/* empty */
|
TypeDefinition ';' _OptTypeDefinitions
;

TypeDefinition
:
T_ID {/* std::cout<<"current id: "<<std::string(yytext_ptr)<<",    "; */ current_id = std::string(yytext_ptr);} '=' Type
{/* std::cout<<"current id: "<<current_id<<",    "<<"current type: "<<current_type<<std::endl; */ symt[current_id] = {current_type, symt.size()}; current_type = "";}
;

VariableDeclarations
:
T_VAR VariableDeclaration ';' _OptVariableDeclarations
;

VariableDeclaration
:
IdentifierList ':' Type
;

_OptVariableDeclarations
:
/* empty */
|
VariableDeclaration ';' _OptVariableDeclarations
;

OptVariableDeclarations
:
/* empty */
|
VariableDeclaration ';' OptVariableDeclarations
;

OptSubprogramDeclarations
:
/* empty */
|
SubprogramDeclarations
;

SubprogramDeclarations
:
/* empty */
|
SubprogramDeclaration ';' SubprogramDeclarations
;

SubprogramDeclaration
:
ProcedureDeclaration
|
FunctionDeclaration
;

ProcedureDeclaration
:
T_PROCEDURE T_ID '(' FormalParameterList ')' ';' DeclarationBody
;

FunctionDeclaration
:
T_FUNCTION T_ID '(' FormalParameterList ')' ':' ResultType ';' DeclarationBody
;

DeclarationBody
:
Block
|
T_FORWARD
;

FormalParameterList
:
/* empty */
|
IdentifierList ':' Type OptIdentifiers
;

OptIdentifiers
:
/* empty */
|
';' IdentifierList ':' Type {current_type.append(",");} OptIdentifiers
;

Block
:
CompoundStatement
|
VariableDeclarations CompoundStatement
;

CompoundStatement
:
T_BEGIN StatementSequence T_END
;

StatementSequence
:
Statement Statements
;

Statement
:
SimpleStatement
|
StructuredStatement
;

SimpleStatement
:
/* empty */
|
AssignmentStatement
|
ProcedureStatement
;

AssignmentStatement
:
Variable T_ASSIGNMENT Expression
;

ProcedureStatement
:
T_ID '(' ActualParameterList ')'
;

StructuredStatement
:
CompoundStatement
|
T_IF Expression T_THEN Statement CloseIf
|
T_WHILE Expression T_DO Statement
|
T_FOR T_ID T_ASSIGNMENT Expression T_TO Expression T_DO Statement
;

CloseIf
:
/* empty */
|
T_ELSE Statement
;

Statements
:
/* empty */
|
';' Statement Statements
;

Type   /* todo: replace literal typename with special (reserved) symbols */
:
T_ID {current_type.append(std::string(yytext_ptr));}
|
T_ARRAY '[' Constant T_RANGE Constant ']' T_OF {current_type.append("array_of_");} Type
|
T_RECORD {current_type.append("record {");} FieldList T_END {current_type.append("}");}
;

ResultType
:
T_ID
;

FieldList
:
/* empty */
|
IdentifierList ':' Type {current_type.append(",");} OptIdentifiers
;

Constant
:
T_INT
|
Sign T_INT
;

Expression
:
SimpleExpression
|
SimpleExpression RelationalOp SimpleExpression
;

RelationalOp
:
T_RELOP
|
'='
;

SimpleExpression
:
Term Summand
|
Sign Term Summand
;

AddOp
:
T_ADDOP
|
T_OR
;

Term
:
Factor Multiplicand
;

Summand
:
/* empty */
|
AddOp Term Summand
;

MulOp
:
T_MULOP
|
T_DIV
|
T_MOD
|
T_AND
;

Factor
:
T_INT
|
T_STR
|
Variable
|
FunctionReference
|
T_NOT Factor
|
'(' Expression ')'
;

Multiplicand
:
/* empty */
|
MulOp Factor Multiplicand
;

FunctionReference
:
T_ID '(' ActualParameterList ')'
;

Variable
:
T_ID ComponentSelection
;

ComponentSelection
:
/* empty */
|
'.' T_ID ComponentSelection
|
'[' Expression ']' ComponentSelection
;

ActualParameterList
:
/* empty */
|
Expression OptExpressions
;

OptExpressions
:
/* empty */
|
',' Expression OptExpressions
;

IdentifierList
:
T_ID Identifiers
;

Identifiers
:
/* empty */
|
',' T_ID Identifiers
;

Sign
:
'+'
|
'-'
;

%%

int yyerror(const char *s){
	std::cerr<<s<<std::endl;
	return 0;
}

int main(void){
	int ret = yyparse();
	if (ret == 1){
		std::cout<<"\nsyntax error found\n";
	}else if (ret == 2){
		std::cout<<"\nmemory exhausted\n";
	}else{
		std::cout<<"\nno syntax error found\n";
	}
	std::cout<<"\n";
	for (std::map<std::string, id_attr>::iterator itr = symt.begin(); itr != symt.end(); ++itr){
		std::cout<<std::setw(FW)<<std::left<<itr->first<<std::setw(FW)<<std::left<<itr->second.type<<std::setw(FW)<<std::left<<itr->second.addr<<"\n";
	}        
	return 0;
}
