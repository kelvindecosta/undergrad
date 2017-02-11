#include <stdio.h>
#include <math.h>

int main()
{
    float principal, interestRate, simpleInterest, compoundInterest, Term;

    printf("Enter the following details : \n");
    printf("\n Principal : ");
    scanf("%f", &principal);
    printf("\n Interest Rate : ");
    scanf("%f", &interestRate);
    printf("\n Term : ");
    scanf("%f", &Term);

    simpleInterest = principal * interestRate * Term;
    compoundInterest = principal * (pow(1 + interestRate, Term) - 1);

    printf("\n Simple Interest : %f", simpleInterest);
    printf("\n Compound Interest : %f", compoundInterest);

    return 0;
}
