#include <stdio.h>

int main()
{
    int i = 0;
    printf("ASCII CODE\n");
    while (i < 128)
    {
        printf("Character : %c , ASCII : %d \n", i, i);
        i++;
    }
    return 0;
}
