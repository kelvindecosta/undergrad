#include <stdio.h>
#include <string.h>

char *string_search(char *str1, char *str2)
{
  char *ptr;
  int length = strlen(str2);
  if (strlen(str1) < length || strlen(str1) == length && *str1 != *str2)
    return NULL;

  ptr = str1;

  while (*ptr != '\0')
  {
    int i;
    for (i = 0; i < length; i++)
      if (*(ptr + i) != *(str2 + i))
        break;

    if (i == length)
      return ptr;
    else
      ptr++;
  }

  return NULL;
}

int main()
{
  char Str1[100], Str2[100], *first;
  printf("Enter the two strings : \n");
  printf("String 1 : ");
  scanf("%[^\n]s", &Str1);
  getchar();
  printf("String 2 : ");
  scanf("%[^\n]s", &Str2);

  first = string_search(Str1, Str2);
  if (first != NULL)
    printf("%s", first);
  else
    printf("No occurence\n");
}
