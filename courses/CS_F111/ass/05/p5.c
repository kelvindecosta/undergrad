#include <stdio.h>

int *dynamic_alloc(int array[10])
{
  int i, counter = 0;
  for (i = 0; i < 10; i++)
    if (array[i])
      counter++;

  int *ptr, j;
  ptr = (int *)malloc(counter * sizeof(int));

  for (i = 0, j = 0; i < 10; i++)
    if (array[i])
      *(ptr + j++) = array[i];

  printf("\nArray with only Non-zero elements :\n");
  for (i = 0; i < counter; i++)
    printf("[%d] : %d\n", i, *(ptr + i));

  return ptr;
}

int main()
{
  int array[10], *a, i;
  printf("Enter the 10 elements of the array : \n");

  for (i = 0; i < 10; i++)
  {
    printf("[%d]", i);
    scanf("%d", array + i);
  }

  a = dynamic_alloc(array);
  printf("\n\nAdress of the dynamic array : %d", a);
}
