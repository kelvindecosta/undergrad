%{
#include<stdio.h>
%}
%%
"+" { printf("PLUS\n"); }
"-" { printf("MINUS\n"); }
"*" { printf("TIMES\n"); }
"/" { printf("DIVIDE\n"); }
"|" { printf("ABS\N"); }
[a-zA-Z|_][a-zA-Z0-9]+ { printf("SYMBOL %s\n", yytext); }
[0-9]+ { printf("NUMBER %s\n", yytext); }
\n { printf("NEWLINE\n"); }
[ \t] { }
. { printf("MYSTERY_CHAR %s\n", yytext); }
%%
main(int argc, char **argv){
	yylex();
}
