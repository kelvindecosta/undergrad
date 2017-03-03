#include <stdio.h>
int main()
{
  int A[10], size, i;
  printf("Enter Size of array : \n");
  scanf("%d", &size);

  for (i = 0; i < size; i++)
  {
    printf("Element %d : ", i + 1);
    scanf("%d", &A[i]);
  }

  for (i = 0; i < size / 2; i++)
  {
    int temp;
    temp = A[i];
    A[i] = A[size - 1 - i];
    A[size - 1 - i] = temp;
  }

  printf("Reversed array : ");
  for (i = 0; i < size; i++)
    printf(" %d ", A[i]);
}
