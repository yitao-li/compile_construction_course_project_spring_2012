%{

/* necessary definitions */

#define YY_MAIN 1
#define YY_SKIP_YYWRAP 1

%}

/* regex definitions */

WS	[ \t\n]+


/* semantic actions */

%%

{WS}	{printf("white space\n");}

%%

/* functions */

int yywrap(void){
	printf("Done!\n");
	return 1;
}
