#include <stdio.h>
int main()
{
    int N, i, j;
    printf("Enter a number to print a pattern : ");
    scanf("%d", &N);

    for (i = 1; i <= N; i++)
    {
        for (j = i; j >= 1; j--)
            printf("%d", j);
        printf("\n");
    }

    return 0;
}
