#include <stdio.h>

void print_Matrix(int M[10][10], int m, int n)
{
  printf("\n Matrix :\n");
  int i, j;
  for (i = 0; i < m; i++)
  {
    for (j = 0; j < n; j++)
      printf("[%02d] ", M[i][j]);
    printf("\n");
  }
}

void swap(int *a, int *b)
{
  int temp;
  temp = *a;
  *a = *b;
  *b = temp;
}

void insertion_sort(int M[10][10], int m, int n)
{
  int i, j, k;
  for (i = 0; i < n; i++)
  {
    for (j = 1; j < m; j++)
      for (k = j; k > 0; k--)
      {
        if (M[k][i] < M[k - 1][i])
          swap(&M[k][i], &M[k - 1][i]);
        else
          break;
      }
  }

  printf("\nSorted Matrix : \n");
  print_Matrix(M, m, n);
}

void selection_sort(int M[10][10], int m, int n)
{
  int i, j, k, c, min;
  for (i = 0; i < n; i++)
    for (j = 0; j < m - 1; j++)
    {
      for (k = j, c = j, min = M[j][i]; k < m; k++)
        if (min > M[k][i])
        {
          min = M[k][i];
          c = k;
        }
      swap(&M[j][i], &M[c][i]);
    }

  printf("\nSorted Matrix :\n");
  print_Matrix(M, m, n);
}

int main()
{
  int matrix[10][10], m, n;
  int i, j, opt;
  printf("Enter the no. of rows of the matrix : ");
  scanf("%d", &m);
  printf("Enter the no. of columns of the matrix : ");
  scanf("%d", &n);

  printf("Enter the elements of the matrix : \n");
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
    {
      printf(" (%d,%d) : ", i, j);
      scanf("%d", &matrix[i][j]);
    }

  printf("Matrix before sorting :\n");
  print_Matrix(matrix, m, n);

  printf("Choose from the following : \n");
  printf("[1] Insertion Sort\n");
  printf("[2] Selection Sort\n");

  printf("Your current option : ");
  scanf("%d", &opt);

  switch (opt)
  {
  case 1:
    insertion_sort(matrix, m, n);
    break;
  case 2:
    selection_sort(matrix, m, n);
    break;
  }
  return 0;
}
