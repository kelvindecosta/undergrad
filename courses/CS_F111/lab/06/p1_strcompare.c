#include <stdio.h>
#include <string.h>

int main()
{
  char string1[100], string2[100];
  printf("Enter two strings : \n");

  printf("String 1 : ");
  scanf("%[^\n]s", &string1);
  getchar();

  printf("Strign 2 : ");
  scanf("%[^\n]s", &string2);
  getchar();

  if (!strcmp(string1, string2))
    printf("The two strings ' %s ' and ' %s ' are equal.", string1, string2);
  else
    printf("The two strings ' %s ' and ' %s ' are not equal.", string1, string2);
  return 0;
}
