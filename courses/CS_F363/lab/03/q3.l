%{
    #include<stdio.h>
%}
digits [0-9]+
fraction (\.{digits})?
exponent (E[+-]?{digits})?
number {digits}{fraction}{exponent}
%%
{number} {
    printf("Recognized : %s\n", yytext);
}
%%
int main(int argc, char **argv){
    yylex();
}

