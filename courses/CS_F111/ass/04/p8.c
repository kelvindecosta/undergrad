#include <stdio.h>

int power(int);
float series(int);

int main()
{
    int N;
    printf("Enter the number of terms to print series : ");
    scanf("%d", &N);

    printf("\nSeries = %f", series(N));
    return 0;
}

int power(int a)
{
    int i, pow = 1;
    for (i = 1; i <= a; i++)
        pow *= 2;
    return (pow);
}

float series(int N)
{
    float s = 0;
    int i;
    for (i = 0; i <= N; i++)
        s += (float)(3 + 2 * i) / power(i);

    return (s);
}
