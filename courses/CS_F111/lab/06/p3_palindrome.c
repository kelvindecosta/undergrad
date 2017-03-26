#include <stdio.h>
#include <string.h>

int isPalindrome(char str[100])
{
  int i, length;
  length = strlen(str);

  for (i = 0; i < length / 2; i++)
    if (str[i] != str[length - 1 - i])
      return 0;
  return 1;
}

int main()
{
  char string[100];
  printf("Enter a string to check if it is a palindrome : \n");
  scanf("%[^\n]s", string);

  if (isPalindrome(string))
    printf("The string '%s' is a palindrome.", string);
  else
    printf("The string '%s' is not a palindrome.", string);

  return 0;
}
