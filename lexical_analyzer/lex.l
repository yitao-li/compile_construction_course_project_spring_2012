%{
/* necessary definitions */

#define YY_MAIN 1
#define YY_SKIP_YYWRAP 1

%}




/* regex definitions */

/* WARNING: ASCII WHITESPACE CHARS ONLY (UNICODE ONES NOT INCLUDED) */

WS	[\x09\x0A\x0B\x0C\x0D\x20]+


/* WARNING: GREEDY MATCHING REQUIRED*/

COMMENT	\{(.|{WS})*\}


LETTER	[A-Za-z]


DIGIT	[0-9]


ID	{LETTER}(_|{LETTER}|{DIGIT})*


INT	{DIGIT}+


/* WARNING: STRING MUST CONSIST OF PRINTING CHARACTER(S) */

STR	\"[^\"]*\"


RELOP	"<="|">="|"<>"|":="|".."|[<>]


ARITHMOP	[\+\-\*]


SYM	[\.,:;\(\)\[\]]




/* semantic actions */

%%

{COMMENT}	{printf("COMMENT\n");}


{WS}	{printf("WHITE SPACE\n");}

and	{printf("AND\n");}


begin	{}


forward	{}


div	{}


do	{}


else	{}


end	{}


for	{}


function	{}


if	{}


array


mod	{}


not	{}


of	{}


or	{}


procedure	{}


program	{}


record	{}


then	{}


to	{}


type	{}


var	{}


while	{}


{ID}	{printf("IDENTIFIER\n");}


{INT}	{printf("INTEGER\n");}


{STR}	{printf("STRING\n");}


{RELOP}	{printf("RELATIONAL OPERATOR\n");}


{ARITHMOP}	{printf("ARITHMETIC OPERATOR\n");}


{SYM}	{printf("SYMBOL\n");}


%%




/* functions */

int yywrap(void){
	printf("Done!\n");
	exit(0);
}
