%{
/* necessary definitions */

#include <iostream>
#include <iomanip>
#include <map>   //data structure for symbol table
#include <string>
#define YY_DECL int yylex(std::map<std::string, int> & symt)
#define YY_MAIN 0
#define YY_SKIP_YYWRAP 1

int yywrap(void);
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

{COMMENT}	{/* std::cout<<"COMMENT\n"; */}


{WS}	{/* std::cout<<"WHITE SPACE\n"; */}


and	{std::cout<<"and\t\t< KEYWORD, AND >\n";}


begin	{std::cout<<"begin\t\t< KEYWORD, BEGIN >\n";}


forward	{std::cout<<"forward\t\t< KEYWORD, FORWARD >\n";}


div	{std::cout<<"div\t\t< KEYWORD, DIV >\n";}


do	{std::cout<<"do\t\t< KEYWORD, DO >\n";}


else	{std::cout<<"else\t\t< KEYWORD, ELSE >\n";}


end	{std::cout<<"end\t\t< KEYWORD, ELSE >\n";}


for	{std::cout<<"for\t\t< KEYWORD, FOR >\n";}


function	{std::cout<<"function\t\t< KEYWORD, FUNCTION >\n";}


if	{std::cout<<"if\t\t< KEYWORD, IF >\n";}


array	{std::cout<<"array\t\t< KEYWORD, ARRAY >\n";}


mod	{std::cout<<"mod\t\t< KEYWORD, MOD >\n";}


not	{std::cout<<"not\t\t< KEYWORD, NOT >\n";}


of	{std::cout<<"of\t\t< KEYWORD, OF >\n";}


or	{std::cout<<"or\t\t< KEYWORD, OR >\n";}


procedure	{std::cout<<"procedure\t\t< KEYWORD, PROCEDURE >\n";}


program	{std::cout<<"program\t\t< KEYWORD, PROGRAM >\n";}


record	{std::cout<<"record\t\t< KEYWORD, RECORD >\n";}


then	{std::cout<<"then\t\t< KEYWORD, THEN >\n";}


to	{std::cout<<"to\t\t< KEYWORD, TO >\n";}


type	{std::cout<<"type\t\t< KEYWORD, TYPE >\n";}


var	{std::cout<<"var\t\t< KEYWORD, VAR >\n";}


while	{std::cout<<"while\t\t< KEYWORD, WHILE >\n";}


{ID}	{std::string str(yytext_ptr); std::cout<<yytext_ptr<<"\t\t< IDENTIFIER, \""<<yytext_ptr<<"\" >\n"; if (symt.find(str) == symt.end()) { symt[str] = symt.size(); }}


{INT}	{std::cout<<yytext_ptr<<"\t\t< INTEGER, \""<<yytext_ptr<<"\" >\n";}


{STR}	{std::cout<<yytext_ptr<<"\t\t< STRING, \""<<yytext_ptr<<"\" >\n";}


{RELOP}	{std::cout<<yytext_ptr<<"\t\t< RELATIONAL_OPERATOR, \""<<yytext_ptr<<"\" >\n";}


{ARITHMOP}	{std::cout<<yytext_ptr<<"\t\t< ARITHEMATIC_OPERATOR, \""<<yytext_ptr<<"\" >\n";}


{SYM}	{std::cout<<yytext_ptr<<"\t\t< SYMBOL, \""<<yytext_ptr<<"\" >\n";}


%%




/* functions */

int yywrap(void){
	return 1;
}

int main(void){
	std::map<std::string, int> symt;
	yylex(symt);
	std::cout<<"Content of the symbol table: \n\n";
	std::cout<<"Name"<<std::setw(16)<<"Location\n";
	for (std::map<std::string, int>::iterator itr = symt.begin(); itr != symt.end(); ++itr){
		std::cout<<itr->first<<std::setw(16)<<itr->second<<"\n";
	}
	return 0;
}
