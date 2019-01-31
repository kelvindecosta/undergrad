%{
    #include<stdio.h>
    void display(char *text, char *token, int line) {
        printf("%-30s %-30s %4d\n", text, token, line);
    }
%}
%option yylineno
KEYWORD (if|else|class|do|while|for|return|void|default|static|int|float|char|struct|switch|case|break|continue)
IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*
CHAR \'.\'
dig [0-9]+
STRING \".*\"
fraction (\.{dig})?
exponent ([Ee][+-]?{dig})?
INT [+-]?{dig}
FLOAT {INT}{fraction}{exponent}
OPERATOR [\+\-\*\/\%\^]
WHITES \s
header #include<{IDENTIFIER}\.h>
%%
{KEYWORD}       {display(yytext, "keyword", yylineno);}
{INT}           {display(yytext, "integer", yylineno);}
{FLOAT}         {display(yytext, "float", yylineno);}
{CHAR}          {display(yytext, "character", yylineno);}
{OPERATOR}      {display(yytext, "operator", yylineno);}
{STRING}        {display(yytext, "string", yylineno);}
{IDENTIFIER}    {display(yytext, "identifier", yylineno);}
{header}        {display(yytext, "header", yylineno);}
\n {}
. {}
%%
int main(int argc, char **argv){
    printf("%-30s%-30s%s\n", "LEXEME", "TYPE", "LINE");
    yylex();
}
