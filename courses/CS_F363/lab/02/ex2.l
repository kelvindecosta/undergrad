%{
#include<stdio.h>
int chars = 0;
int words = 0;
int lines = 0;
%}
word [a-zA-Z]+
newline \n
%%
{word} { words++; chars += strlen(yytext); }
{newline} { chars++; lines++; }
. { chars++; }
%%
main(int argc, char **argv){
	yylex();
	printf("%8d%8d%8d\n", lines, words, chars);
}
