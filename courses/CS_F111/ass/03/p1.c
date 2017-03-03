#include <stdio.h>
int main()
{
    int num, sum = 0;
    printf("Enter a series of numbers : \n");
    do
    {
        scanf("%d", &num);
        sum += num;

        if (num == 17)
        {
            printf("Sum = %d", sum);
            return 0;
        }

    } while (sum < 100);

    printf("Sum = %d", sum);
    return 0;
}
