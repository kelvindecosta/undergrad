%{
    #include<stdio.h>
    int c = 0, v = 0;
%}
vowels [AaEeIiOoUu]
consonants [b-dB-Df-hF-Hj-nJ-Np-tP-Tv-zV-Z]
%%
{vowels} {
    v++;
}

{consonants} {
    c++;
}
\n {}
. {}
%%
int main(int argc, char **argv){
    yylex();
    printf("Consonants : %d\nVowels     : %d\n", c, v);
}

