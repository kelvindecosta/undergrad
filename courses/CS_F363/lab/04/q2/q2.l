%{
    #include<stdio.h>
    int osum = 0, esum = 0;
%}
odd [\+\-]?[0-9]*[13579]
even [\+\-]?[0-9]*[02468]
%%
{odd} {
    osum += atoi(yytext);
}
{even} {
    esum += atoi(yytext);
}
\n {}
.* {}
%%
int main(int argc, char **argv){
    yylex();
    printf("ODD SUM  : %d\nEVEN SUM : %d\n", osum, esum);
}