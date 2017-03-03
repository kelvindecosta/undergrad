#include <stdio.h>

int main()
{
  int A[10][10], B[10][10], C[10][10], m, n, i, j;
  printf("Enter the no. of rows of the arrays : ");
  scanf("%d", &m);
  printf("Enter the no. of columns of the arrays : ");
  scanf("%d", &n);

  printf("Array A : \n");
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
      scanf("%d", &A[i][j]);

  printf("\nArray B : \n");
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
      scanf("%d", &B[i][j]);

  printf("Array A+B = C :\n");

  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
      C[i][j] = A[i][j] + B[i][j];

  for (i = 0; i < m; i++)
  {
    for (j = 0; j < n; j++)
    {
      printf("%02d ", C[i][j]);
    }
    printf("\n");
  }
  return 0;
}
