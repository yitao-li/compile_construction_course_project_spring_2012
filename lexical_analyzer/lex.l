%{

/* necessary definitions */

#define YY_MAIN 1
#define YY_SKIP_YYWRAP 1

%}


/* regex definitions */

/* WARNING: ASCII WHITESPACE CHARS ONLY (UNICODE ONES ARE NOT SUPPORTED) */

WS	[\x09\x0A\x0B\x0C\x0D\x20]+


/* WARNING: GREEDY MATCHING REQUIRED*/

COMMENT \{(.|{WS})*\}



/* semantic actions */

%%

{COMMENT}	{/*printf("COMMENT\n");*/}

{WS}	{/*printf("WHITE SPACE\n");*/}


%%

/* functions */

int yywrap(void){
	//printf("Done!\n");
	return 1;
}
