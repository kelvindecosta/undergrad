#include <stdio.h>
int main()
{
  int marks_1[10], marks_2[10], i;
  printf("Enter the marks lists :\n");

  printf("List 1: \n");
  for (i = 0; i < 10; i++)
  {
    printf("Mark %d : ", i + 1);
    scanf("%d", &marks_1[i]);
  }

  printf("\nList 2: \n");
  for (i = 0; i < 10; i++)
  {
    printf("Mark %d : ", i + 1);
    scanf("%d", &marks_2[i]);
  }

  for (i = 0; i < 10; i++)
  {
    if (marks_1[i] != marks_2[i])
    {
      printf("\nNOT IDENTICAL!");
      return 0;
    }
  }
  printf("\nIDENTICAL!");

  return 0;
}
