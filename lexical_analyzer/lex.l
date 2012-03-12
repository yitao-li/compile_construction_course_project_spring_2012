%{
/* necessary definitions */

#include "parser.tab.h"

//#define YY_DECL int yylex(void)
//#define YY_MAIN 0
#define YY_SKIP_YYWRAP 1
#define FW 32

int yywrap(void);

%}


/* regex definitions */

/* WARNING: ASCII WHITESPACE CHARS ONLY (UNICODE ONES NOT INCLUDED) */

WS	[\x09\x0A\x0B\x0C\x0D\x20]+


/* WARNING: GREEDY MATCHING SHOULD BE DISABLED (OTHERWISE 2 COMMENTS WILL BECOME 1 COMMENT)*/

COMMENT	\{[^\}]*\}


LETTER	[A-Za-z]


DIGIT	[0-9]


/* WARNING: STRING MUST CONSIST OF PRINTING CHARACTER(S) */

STR	\"[^\"]*\"


ASSIGNMENT	":="


RANGE	".."


RELOP	"<"|"<="|">"|">="|"<>"|"="


MULOP	[\*]


ADDOP	[\+\-]


SYM     [\.,:;\(\)\[\]]


ID	{LETTER}(_|{LETTER}|{DIGIT})*


/* ASSUMING AN INTEGER MUST BE FOLLOWED BY A WHITE SPACE (SUBJECT TO CHANGE) <!-- ({DIGIT}+)?({WS}) */

INT	{DIGIT}+


ERROR	.

/* semantic actions */

%%


{COMMENT}	{}


{WS}	{}


and	{return T_AND;}


begin	{return T_BEGIN;}


forward	{return T_FORWARD;}


div	{return T_DIV;}


do	{return T_DO;}


else	{return T_ELSE;}


end	{return T_END;}


for	{return T_FOR;}


function	{return T_FUNCTION;}


if	{return T_IF;}


array	{return T_ARRAY;}


mod	{return T_MOD;}


not	{return T_NOT;}


of	{return T_OF;}


or	{return T_OR;}


procedure	{return T_PROCEDURE;}


program	{return T_PROGRAM;}


record	{return T_RECORD;}


then	{return T_THEN;}


to	{return T_TO;}


type	{return T_TYPE;}


var	{return T_VAR;}


while	{return T_WHILE;}


{ID}	{std::cout<<std::string(yytext_ptr)<<std::endl; return T_ID;}


{INT}	{return T_INT;}


{STR}	{return T_STR;}


{ASSIGNMENT} {return T_ASSIGNMENT;}


{RANGE} {return T_RANGE;}


{RELOP}	{return T_RELOP;}


{MULOP}	{return T_MULOP;}


{ADDOP}	{return T_ADDOP;}


{SYM} {return *yytext_ptr;}


%%




/* functions */

int yywrap(void){
	return 1;
}
