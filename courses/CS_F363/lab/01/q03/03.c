#include <stdio.h>
#define SQR(x) ((x) * (x))

main()
{
    int a = 5, b = 3, c;
    c = SQR(a);
    printf("c=%d\n", c);

    c = SQR(a + b);
    printf("c=%d\n", c);
}