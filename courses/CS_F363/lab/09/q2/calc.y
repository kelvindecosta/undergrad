%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<ctype.h>
%}
%token NUMBER PLUS MINUS MUL DIV SEMICOLON
%%
lines : lines expr SEMICOLON {printf("Result = %d\n", $2);}
     | lines SEMICOLON
     |
     ;
expr : PLUS expr expr {$$ = $2 + $3;}
     | MINUS expr expr {$$ = $2 - $3;}
     | MUL expr expr {$$ = $2 * $3;}
     | DIV expr expr {$$ = $2 / $3;}
     | NUMBER {$$ = $1;}
     ;
%%
int main(){
	yyparse();
}
int yyerror(char *msg){
	printf("error : %s\n", msg);
	exit(1);
}
