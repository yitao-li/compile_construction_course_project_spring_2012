%{
/* necessary definitions */

#include <iostream>
#include <iomanip>
#include <map>   //data structure for symbol table
#include <string>
#define YY_DECL int yylex(std::map<std::string, int> & symt)
#define YY_MAIN 0
#define YY_SKIP_YYWRAP 1
#define FW 32

int yywrap(void);
%}


/* regex definitions */

/* WARNING: ASCII WHITESPACE CHARS ONLY (UNICODE ONES NOT INCLUDED) */

WS	[\x09\x0A\x0B\x0C\x0D\x20]+


/* WARNING: GREEDY MATCHING REQUIRED*/

COMMENT	\{(.|{WS})*\}


LETTER	[A-Za-z]


DIGIT	[0-9]


/* WARNING: STRING MUST CONSIST OF PRINTING CHARACTER(S) */

STR	\"[^\"]*\"


RELOP	"<="|">="|"<>"|":="|".."|[<>=]


ARITHMOP	[\+\-\*]


SYM	[\.,:;\(\)\[\]]


ID	{LETTER}(_|{LETTER}|{DIGIT})*


INT	({DIGIT}+)?=[\x09\x0A\x0B\x0C\x0D\x20]


ERROR	.

/* semantic actions */

%%

{COMMENT}	{/* std::cout<<"COMMENT\n"; */}


{WS}	{/* std::cout<<"WHITE SPACE\n"; */}


and	{std::cout<<"and"<<std::setw(FW)<<"< KEYWORD, AND >\n";}


begin	{std::cout<<"begin"<<std::setw(FW)<<"< KEYWORD, BEGIN >\n";}


forward	{std::cout<<"forward"<<std::setw(FW)<<"< KEYWORD, FORWARD >\n";}


div	{std::cout<<"div"<<std::setw(FW)<<"< KEYWORD, DIV >\n";}


do	{std::cout<<"do"<<std::setw(FW)<<"< KEYWORD, DO >\n";}


else	{std::cout<<"else"<<std::setw(FW)<<"< KEYWORD, ELSE >\n";}


end	{std::cout<<"end"<<std::setw(FW)<<"< KEYWORD, END >\n";}


for	{std::cout<<"for"<<std::setw(FW)<<"< KEYWORD, FOR >\n";}


function	{std::cout<<"function"<<std::setw(FW)<<"< KEYWORD, FUNCTION >\n";}


if	{std::cout<<"if"<<std::setw(FW)<<"< KEYWORD, IF >\n";}


array	{std::cout<<"array"<<std::setw(FW)<<"< KEYWORD, ARRAY >\n";}


mod	{std::cout<<"mod"<<std::setw(FW)<<"< KEYWORD, MOD >\n";}


not	{std::cout<<"not"<<std::setw(FW)<<"< KEYWORD, NOT >\n";}


of	{std::cout<<"of"<<std::setw(FW)<<"< KEYWORD, OF >\n";}


or	{std::cout<<"or"<<std::setw(FW)<<"< KEYWORD, OR >\n";}


procedure	{std::cout<<"procedure"<<std::setw(FW)<<"< KEYWORD, PROCEDURE >\n";}


program	{std::cout<<"program"<<std::setw(FW)<<"< KEYWORD, PROGRAM >\n";}


record	{std::cout<<"record"<<std::setw(FW)<<"< KEYWORD, RECORD >\n";}


then	{std::cout<<"then"<<std::setw(FW)<<"< KEYWORD, THEN >\n";}


to	{std::cout<<"to"<<std::setw(FW)<<"< KEYWORD, TO >\n";}


type	{std::cout<<"type"<<std::setw(FW)<<"< KEYWORD, TYPE >\n";}


var	{std::cout<<"var"<<std::setw(FW)<<"< KEYWORD, VAR >\n";}


while	{std::cout<<"while"<<std::setw(FW)<<"< KEYWORD, WHILE >\n";}


{ID}	{std::string str(yytext_ptr); std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< IDENTIFIER, \""<<yytext_ptr<<"\" >\n"; if (symt.find(str) == symt.end()) { symt[str] = symt.size(); }}


{INT}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< INTEGER, \""<<yytext_ptr<<"\" >\n";}


{STR}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< STRING, \""<<yytext_ptr<<"\" >\n";}


{RELOP}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< RELATIONAL_OPERATOR, \""<<yytext_ptr<<"\" >\n";}


{ARITHMOP}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< ARITHEMATIC_OPERATOR, \""<<yytext_ptr<<"\" >\n";}


{SYM}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< SYMBOL, \""<<yytext_ptr<<"\" >\n";}


{ERROR}	{std::cout<<"PARSER ERROR\n";return -1;}


%%




/* functions */

int yywrap(void){
	return 1;
}

int main(void){
	std::map<std::string, int> symt;
	yylex(symt);
	std::cout<<"\n\nContent of the symbol table: \n\n";
	std::cout<<"Value"<<std::setw(FW)<<"Key\n";
	for (std::map<std::string, int>::iterator itr = symt.begin(); itr != symt.end(); ++itr){
		std::cout<<"\""<<itr->first<<"\""<<std::setw(FW)<<itr->second<<"\n";
	}
	return 0;
}
