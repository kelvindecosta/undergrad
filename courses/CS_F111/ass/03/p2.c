#include <stdio.h>
int main()
{
    float i, x, y;

    printf("\n\n                         INTELLIGENCE \n\n");
    for (i = 0; i < 59; i++)
        printf("-");
    printf("\n");

    printf("|         |");
    for (y = 1; y <= 6; y++)
    {
        printf(" y = %g |", y);
    }
    printf("\n");

    for (i = 0; i < 59; i++)
        printf("-");
    printf("\n");

    for (x = 5.5; x <= 12.5; x += 0.5)
    {
        printf("| x= %04.1f |", x);
        for (y = 1; y <= 6; y++)
        {
            i = 2 + (y + 0.5 * x);
            printf(" %05.2f |", i);
        }
        printf("\n");
    }

    for (i = 0; i < 59; i++)
        printf("-");
    printf("\n\n");

    return 0;
}
