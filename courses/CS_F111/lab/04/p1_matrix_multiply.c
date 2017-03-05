#include <stdio.h>
void input_array_size(int *m, int *n, char A_name)
{
  printf("Enter the row size of %c : ", A_name);
  scanf("%d", m);

  printf("Enter the column size of %c : ", A_name);
  scanf("%d", n);
}

void input_array(int A[10][10], int m, int n, char A_name)
{
  printf("Enter the elements of %c : \n", A_name);
  int i, j;
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
    {
      printf("(%d,%d) : ", i, j);
      scanf("%d", &A[i][j]);
    }
}

void output_array(int A[10][10], int m, int n, char A_name)
{
  printf("Matrix %c : \n", A_name);
  int i, j;
  for (i = 0; i < m; i++)
  {
    for (j = 0; j < n; j++)
      printf(" [%02d]", A[i][j]);
    printf("\n");
  }
  printf("\n");
}

void multiply_array(int A[10][10], int m, int n, int B[10][10], int p, int q, int C[10][10])
{
  int i, j, k;
  for (i = 0; i < m; i++)
    for (j = 0; j < q; j++)
      for (k = 0, C[i][j] = 0; k < n; k++)
        C[i][j] += (A[i][k]) * (B[k][j]);
}

int main()
{
  int A[10][10], B[10][10], C[10][10], m, n, p, q;
  input_array_size(&m, &n, 'A');
  input_array_size(&p, &q, 'B');

  if (n != p)
  {
    printf("The two matrices cannot be multiplied!\n");
    return 0;
  }

  input_array(A, m, n, 'A');
  input_array(B, p, q, 'B');

  printf("\n ");
  output_array(A, m, n, 'A');

  printf("\n");
  output_array(B, p, q, 'B');

  printf("\nMultiplying matrices A and B as : ");
  multiply_array(A, m, n, B, p, q, C);
  output_array(C, m, q, 'C');
  return 0;
}
