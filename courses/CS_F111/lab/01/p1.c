#include <stdio.h>

int main()
{
    int a, b, r;
    float x, y, z;

    printf("Enter two integers to get their sum :\n");
    scanf("%d,%d", &a, &b);
    r = a + b;
    printf("\n Sum = %d", r);

    printf("\n Enter two decimals to get their difference:\n");
    scanf("%f,%f", &x, &y);
    if (x > y)
        z = x - y;
    else
        z = y - x;
    printf("\n Difference = %f", z);
    return (0);
}
