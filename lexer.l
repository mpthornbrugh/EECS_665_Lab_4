%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//Define the tokens that you want to return from your lex as follows
#define ID 256
#define INTVAL 257

int list_type;
%}

%option noyywrap nounput yylineno
ID [a-zA-Z][a-zA-Z0-9_]*
%x COMMENT

%%
/****************************************
* Matching with Single line comments in our 
* C code
******************************************/
"//" {
BEGIN COMMENT;
}

/****************************************
* A new line indicates end of a single 
* line comment in C
****************************************/
<COMMENT>[\n](\r)? {
BEGIN 0;
}

/****************************************
* Lexer ignores the comments section
* by Ignoring anything inside a comment
****************************************/
<COMMENT>[ \t] {
}

<COMMENT>. {
}

/**************************************
* If an identifier is matched, then 
* print ID and return a token ID
**************************************/

{ID} {
printf("ID\n");
return ID;
}

%%
int main(int argc, const char* argv[])
{
  /*Make a call to yylex() recursively. Each call to yylex() parses one token.
    yylex() returns 1 whenever an expression you have specified is found in the input text,
    0 when end of file is encountered.*/

return 0;
}