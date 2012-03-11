/* BISON TOKEN NAMES */

%token T_COMMENT T_AND T_BEGIN T_FORWARD T_DIV T_DO T_ELSE T_END T_FOR T_FUNCTION T_IF T_ARRAY T_MOD T_NOT T_OF T_OR T_PROCEDURE T_PROGRAM T_RECORD T_THEN T_TO T_TYPE T_VAR T_WHILE T_ID T_INT T_STR T_ASSIGNMENT T_RANGE T_RELOP T_MULOP T_ADDOP ERROR

%{
#include "lex.h"

#define YYERROR_VERBOSE 1

int yyerror(const char *);
%}



/* THE GRAMMAR */

%%

Program
:
T_PROGRAM T_ID ';' OptTypeDefinitions OptVariableDeclarations OptSubprogramDeclarations CompoundStatement '.'
;

OptTypeDefinitions
:
/* empty */
|
TypeDefinitions
;

TypeDefinitions
:
T_TYPE TypeDefinition ';'
|
TypeDefinitions TypeDefinition ';' 
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

TypeDefinition
:
T_ID '=' Type
;

VariableDeclarations
:
T_VAR VariableDeclaration ';' OptVariableDeclarations
;

OptVariableDeclarations
:
/* empty */
|
VariableDeclaration ';' OptVariableDeclarations
;

VariableDeclaration
:
IdentifierList ':' Type
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
';' IdentifierList ':' Type OptIdentifiers
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

Type
:
T_ID
|
T_ARRAY '[' Constant T_RANGE Constant ']' T_OF Type
|
T_RECORD FieldList T_END
;

ResultType
:
T_ID
;

FieldList
:
/* empty */
|
IdentifierList ':' Type OptIdentifiers
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
SimpleExpression T_RELOP SimpleExpression
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
Expression ComponentSelection
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
	std::cout<<s<<std::endl;
	return(0);
}

int main(void){
	yyparse();
	return 0;
}
