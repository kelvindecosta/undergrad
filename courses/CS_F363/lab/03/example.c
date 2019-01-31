#include <stdio.h>

int main(int argc, char **argv)
{
    int a = 1, b = 2;
    float c = 0.3, d = 0.5;
    char e = 'A', f = 'B';
    a = a + b;
    b = a - b;
    a = a - b;

    if (a > b)
    {
        printf("yes");
    }
    else
    {
        printf("no");
    }
}