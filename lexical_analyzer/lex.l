%{

/* necessary definitions */

#define YY_MAIN 1
#define YY_SKIP_YYWRAP 1

%}

/* regex definitions */

COMMENT \{.*\}

/*can \r by itself be an EOL character?? (i.e. overprint the current line...)*/

WS	[ \t\n\r\f\v\x03\x04\x0A\x0B\x0C\x1C\x1D\x1E\x1F]+


/* semantic actions */

%%

{COMMENT}	{printf("COMMENT\n");}

{WS}	{/* printf("WHITE SPACE\n"); */}


%%

/* functions */

int yywrap(void){
	printf("Done!\n");
	return 1;
}
