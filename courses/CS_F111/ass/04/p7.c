#include <stdio.h>

int mini(int a, int b, int c)
{
    int min;
    if (a < b)
        if (a < c)
        {
            a--;
            b++;
            c++;
            min = a;
        }
        else
        {
            a++;
            b++;
            c--;
            min = c;
        }
    else if (b < c)
    {
        a++;
        b--;
        c++;
        min = b;
    }
    else
    {
        a++;
        b++;
        c--;
        min = c;
    }
    printf("a=  %d , b= %d , c= %d\n", a, b, c);
    return (min);
}

int main()
{
    int a, b, c;
    printf("Enter 3 numbers : \n");

    printf("a = ");
    scanf("%d", &a);

    printf("b = ");
    scanf("%d", &b);

    printf("c = ");
    scanf("%d", &c);

    printf("a=  %d , b= %d , c= %d \n", a, b, c);
    mini(a, b, c);
    printf("a=  %d , b= %d , c= %d \n", a, b, c);
}
