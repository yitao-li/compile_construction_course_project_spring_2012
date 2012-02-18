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


ID	{LETTER}(LETTER|DIGIT|_)*


/* WARNING: STRING MUST CONSIST OF PRINTING CHARACTER(S) */

STR	\"[^\"]*\"




/* semantic actions */

%%

{COMMENT}	{printf("COMMENT\n");}


{WS}	{printf("WHITE SPACE\n");}


{ID}	{printf("IDENTIFIER\n");}


{STR}	{printf("STRING\n");}


%%




/* functions */

int yywrap(void){
	//printf("Done!\n");
	return 1;
}
