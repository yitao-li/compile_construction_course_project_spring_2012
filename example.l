%{
	/* definitions of manifest constants
	LT, LE, EQ, NE, GT, GE,
	IF, THEN, ELSE, ID, NUMBER, RELOP */
	
	#define YY_MAIN 1

	#define LT 0
	#define LE 1
	#define EQ 2
	#define NE 3
	#define GT 4
	#define GE 5
	#define IF 6
	#define THEN 7
	#define ELSE 8
	#define ID 9
	#define NUMBER 10
	#define RELOP 11

	
	int yylval;
%}

/* regular definitions */
delim	 [ \t\n]
ws	 {delim}+
letter	 [A-Za-z]
digit	 [0-9]
id	 {letter}({letter}|{digit})*
number	 {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%

{ws}	 {/* no action and no return */}
if	 {return(IF);}
then	 {return(THEN);}
else	 {return(ELSE);}
{id}	 {yylval = (int)installID(); return(ID);}
{number}	 {yylval = (int)installNum(); return(NUMBER);}
"<"	 {yylval = LT; return(RELOP);}
"<="	 {yylval = LE; return(RELOP);}
"="	 {yylval = EQ; return(RELOP);}
"<>"	 {yylval = NE; return(RELOP);}
">"	 {yylval = GT; return(RELOP);}
">="	 {yylval = GE; return(RELOP);}

%%

int installID(void){
	/* function to install the lexeme, whose first character is pointed to by yytext, and whose length is yyleng, into the symbol table and return a
	pointer thereto*/
	printf("\ninstallID\n");
	return 0;
}

int installNum(void){
	/* similar to installID, but puts numerical constants into a separate table */
	printf("\ninstallNum\n");
	return 0;
}

int yywrap(void){
	printf("\nDone!\n");
	return 0;
}
