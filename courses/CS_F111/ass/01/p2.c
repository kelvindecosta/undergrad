#include "stdio.h"

int main()
{
    int num, n, rev = 0;
    printf("Enter a number to find its reverse :");
    scanf("%d", &num);
    n = num;
    while (n != 0)
    {
        rev = 10 * rev + n % 10;
        n = n / 10;
    }
    printf("Reverse of %d is %d \n", num, rev);
    return 0;
}
