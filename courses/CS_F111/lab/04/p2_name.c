#include <stdio.h>
#include <stdlib.h>

int main()
{
    char name[200];
    printf("Enter your name : ");
    scanf("%[^\n]s", &name);
    printf("Hello %s! Goodbye!", name);
    return 0;
}
