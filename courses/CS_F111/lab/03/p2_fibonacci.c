#include <stdio.h>

int main()
{
    int fib1, fib2, N;
    printf("Enter a number N to print the fibonacci sequence till N :");
    scanf("%d", &N);

    printf("Fibonacci sequence till %d is \n ", N);
    for (fib1 = 0, fib2 = 1; fib1 + fib2 <= N; fib1 = fib2 - fib1)
    {
        fib2 = fib2 + fib1;
        printf("%d, ", fib1);
    }
    printf("%d, %d \n", fib1, fib2);

    return 0;
}
