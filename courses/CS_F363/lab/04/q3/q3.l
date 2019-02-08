%{
    #include<stdio.h>
    #include<string.h>


    char* strlwr(char* s)
    {
        char* tmp = s;

        for (;*tmp;++tmp) {
            *tmp = tolower((unsigned char) *tmp);
        }

        return s;
    }

    char* strupr(char* s)
    {
        char* tmp = s;

        for (;*tmp;++tmp) {
            *tmp = toupper((unsigned char) *tmp);
        }
        return s;
    }
%}
lower [a-z]+
upper [A-Z]+
%%
{lower} {
    printf("%s", strupr(yytext));
}
{upper} {
    printf("%s", strlwr(yytext));
}
\n {printf("%s", yytext);}
%%
int main(int argc, char **argv){
    yylex();
}
