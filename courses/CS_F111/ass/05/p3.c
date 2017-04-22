#include <stdio.h>

int string_token(char *str, char words[][10])
{
    int i = 0, j = 0;
    char *ptr;
    ptr = str;

    while (*ptr != '\0')
    {
        j = 0;
        while (*(ptr + j) == ' ')
            j++;
        while (*(ptr + j) != ' ')
        {
            words[i][j] = *(ptr + j);
            j++;
        }
        words[i][j] = '\0';
        i++;
        j++;
        ptr += j;
    }

    return i;
}

int main()
{
    char string[100];
    char words[10][10];
    printf("Enter a string to find the number of words : \n");
    scanf("%[^\n]s", string);

    printf("Number of words = %d\n", string_token(string, words));
}
