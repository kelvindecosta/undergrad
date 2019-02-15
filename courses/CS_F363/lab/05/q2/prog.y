%{
#include<stdio.h>
int count[2] = {0, 0};
%}
%token ZERO ONE SEMICOLON
%%

lines : lines S SEMICOLON
        {
		printf("accepted\n");
		printf("0=%d,1=%d\n", count[0], count[1]);
		count[0] = count[1] = 0;
	}
	| lines error SEMICOLON
	|
	;
S : ONE A
    {count[1]++;};
A : ZERO S {count[0]++;}
  | ZERO {count[0]++;}
  | ONE S {count[1]++;}
  ;
%%
int yyerror(char *msg) {
 printf("error in input %s\n", msg);
 exit(1);
}

int main(){
yyparse();
}
