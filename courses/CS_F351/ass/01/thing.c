#include <stdio.h>

int main()
{
    float salary, basic, allowance, HRA;
    printf("Enter the following figures to calculate salary : ");
    printf("\n Basic : ");
    scanf("%f", &basic);
    printf("\n Allowance : ");
    scanf("%f", &allowance);

    HRA = 0.4 * basic;
    salary = basic + HRA + allowance;

    printf("\n HRA = %f", HRA);
    printf("\n Salary = %f", salary);

    return 0;
}
