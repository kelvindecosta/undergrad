#include <stdio.h>

void upcase_str(char *str)
{
  char *ptr;
  ptr = str;
  while (*ptr != '\0')
  {
    if (*ptr >= 97 && *ptr <= 122)
      *ptr -= 32;
    ptr++;
  }
}

int main()
{
  char string[100];
  printf("Enter a string to convert it to uppercase : ");
  scanf("%[^\n]s", &string);
  upcase_str(string);
  printf("Uppercase string : %s ", string);

  return 0;
}
