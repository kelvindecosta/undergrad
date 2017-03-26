#include <stdio.h>

int main()
{
  int length = 0;
  char string[100];
  printf("Enter a string to find its length : \n");
  scanf("%[^\n]s", &string);
  while (string[length] != '\0')
  {
    length++;
    if (length == 100)
      break;
  }

  printf("The length of the string is %d characters.", length);
  return 0;
}
