%{
    #include<stdio.h>
    int sum = 0;
    int count = 0;
%}
nums \+?[0-9]+
%%
{nums} {
    sum += atoi(yytext);
    count++;
}
\n {}
.* {}
%%
int main(int argc, char **argv){
    yylex();
    printf("Average : %.2f\n", sum / (float)count);
}