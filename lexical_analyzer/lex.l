%{
/* necessary definitions */

#include <fstream>
#include <iostream>
#include <iomanip>
#include <map>   //data structure for symbol table
#include <string>
#define YY_DECL int yylex(std::map<std::string, int> &symt, std::ofstream &r_fn)
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


/* ASSUMING AN INTEGER MUST BE FOLLOWED BY A WHITE SPACE (SUBJECT TO CHANGE) <!-- ({DIGIT}+)?({WS}) */

INT	{DIGIT}+


ERROR	.

/* semantic actions */

%%


{COMMENT}	{/* std::cout<<"COMMENT\n"; */ r_fn<<"COMMENT\n";}


{WS}	{/* std::cout<<"WHITE SPACE\n"; */ r_fn<<"WS\n";}


and	{std::cout<<"and"<<std::setw(FW)<<"< KEYWORD, AND >\n";r_fn<<"AND\n";}


begin	{std::cout<<"begin"<<std::setw(FW)<<"< KEYWORD, BEGIN >\n";r_fn<<"BEGIN\n";}


forward	{std::cout<<"forward"<<std::setw(FW)<<"< KEYWORD, FORWARD >\n";r_fn<<"FORWARD\n";}


div	{std::cout<<"div"<<std::setw(FW)<<"< KEYWORD, DIV >\n";r_fn<<"DIV\n";}


do	{std::cout<<"do"<<std::setw(FW)<<"< KEYWORD, DO >\n";r_fn<<"DO\n";}


else	{std::cout<<"else"<<std::setw(FW)<<"< KEYWORD, ELSE >\n";r_fn<<"ELSE\n";}


end	{std::cout<<"end"<<std::setw(FW)<<"< KEYWORD, END >\n";r_fn<<"END\n";}


for	{std::cout<<"for"<<std::setw(FW)<<"< KEYWORD, FOR >\n";r_fn<<"FOR\n";}


function	{std::cout<<"function"<<std::setw(FW)<<"< KEYWORD, FUNCTION >\n";r_fn<<"FUNCTION\n";}


if	{std::cout<<"if"<<std::setw(FW)<<"< KEYWORD, IF >\n";r_fn<<"IF\n";}


array	{std::cout<<"array"<<std::setw(FW)<<"< KEYWORD, ARRAY >\n";r_fn<<"ARRAy\n";}


mod	{std::cout<<"mod"<<std::setw(FW)<<"< KEYWORD, MOD >\n";r_fn<<"MOD\n";}


not	{std::cout<<"not"<<std::setw(FW)<<"< KEYWORD, NOT >\n";r_fn<<"NOT\n";}


of	{std::cout<<"of"<<std::setw(FW)<<"< KEYWORD, OF >\n";r_fn<<"OF\n";}


or	{std::cout<<"or"<<std::setw(FW)<<"< KEYWORD, OR >\n";r_fn<<"OR\n";}


procedure	{std::cout<<"procedure"<<std::setw(FW)<<"< KEYWORD, PROCEDURE >\n";r_fn<<"PROCEDURE\n";}


program	{std::cout<<"program"<<std::setw(FW)<<"< KEYWORD, PROGRAM >\n";r_fn<<"PROGRAM\n";}


record	{std::cout<<"record"<<std::setw(FW)<<"< KEYWORD, RECORD >\n";r_fn<<"RECORD\n";}


then	{std::cout<<"then"<<std::setw(FW)<<"< KEYWORD, THEN >\n";r_fn<<"THEN\n";}


to	{std::cout<<"to"<<std::setw(FW)<<"< KEYWORD, TO >\n";r_fn<<"TO\n";}


type	{std::cout<<"type"<<std::setw(FW)<<"< KEYWORD, TYPE >\n";r_fn<<"TYPE\n";}


var	{std::cout<<"var"<<std::setw(FW)<<"< KEYWORD, VAR >\n";r_fn<<"VAR\n";}


while	{std::cout<<"while"<<std::setw(FW)<<"< KEYWORD, WHILE >\n";r_fn<<"WHILE\n";}


{ID}	{std::string str(yytext_ptr); std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< IDENTIFIER, \""<<yytext_ptr<<"\" >\n"; if (symt.find(str) == symt.end()) { symt[str] = symt.size(); }r_fn<<"IDENTIFIER\n";}


{INT}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< INTEGER, \""<<yytext_ptr<<"\" >\n";r_fn<<"INT\n";}


{STR}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< STRING, \""<<yytext_ptr<<"\" >\n";r_fn<<"STR\n";}


{RELOP}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< RELATIONAL_OPERATOR, \""<<yytext_ptr<<"\" >\n";r_fn<<"RELOP\n";}


{ARITHMOP}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< ARITHEMATIC_OPERATOR, \""<<yytext_ptr<<"\" >\n";r_fn<<"ARITHMOP\n";}


{SYM}	{std::cout<<"\""<<yytext_ptr<<"\""<<std::setw(FW)<<"< SYMBOL, \""<<yytext_ptr<<"\" >\n";r_fn<<"SYM\n";}


{ERROR}	{std::cout<<"PARSER ERROR\n";r_fn<<"ERROR\n";return -1;}


%%




/* functions */

int yywrap(void){
	return 1;
}

int main(void){
	std::map<std::string, int> symt;
	std::ofstream f("symtable.out", std::ios::out | std::ios::trunc), rf("rules.out", std::ios::out | std::ios::trunc);
	yylex(symt, rf);
	//f<<"\n\nContent of the symbol table: \n\n";
	//f<<"Value"<<std::setw(FW)<<"Key\n";
	for (std::map<std::string, int>::iterator itr = symt.begin(); itr != symt.end(); ++itr){
		f<<"\""<<itr->first<<"\""<<std::setw(FW)<<itr->second<<"\n";
	}
	f.close();
	return 0;
}
