%{
#include <stdio.h>
#include "y.tab.h"
int yylval;
%}
ws [ \t\n]+
digit [0-9]
number {digit}+
%%
{ws} {}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MUL;}
"/" {return DIV;}
";" {return SEMICOLON;}
{number} {yylval = atoi(yytext); return NUMBER;}
. {printf("yylex : error %s\n", yytext);}
%%
