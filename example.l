
	/* definitions of manifest constants*/
	#define LT 0
	#define LE 1
	#define EQ 2
	#define NE 3
	#define GT 4
	#define GE 5
	#define IF 6
	#define THEN 6
	#define ELSE 7
	#define ID 8
	#define NUMBER 9
	#define RELOP 10

/* regular definitions */
delim	 [ \t\n]
ws	 {delim}+
letter	 [A-Za-z]
digit	 [0-9]
id	 {letter}({letter}|{digit})*
number	 {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%

{ws}	 {/* no action and no return */}
if	 {return(1F);}
then	 {return(THEN);}
else	 {return(ELSE);}
{id}	 {yylval = (int)installID(); return(1D);}
{number}	 {yylval = (int)installNum(); return(NUMBER);}
"<"	 {yylval = LT; return(REL0P);}
"<="	 {yylval = LE; return(REL0P);}
"="	 {yylval = EQ; return(REL0P);}
"<>"	 {yylval = NE; return(REL0P);}
">"	 {yylval = GT; return(REL0P);}
">="	 {yylval = GE; return(REL0P);}

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
