#include <stdio.h>

void swap(int *a, int *b)
{
  int temp;
  temp = *a;
  *a = *b;
  *b = temp;
}

void print_2D_array(int A[10][10], int m, int n)
{
  int i, j;
  for (i = 0; i < m; i++)
  {
    for (j = 0; j < n; j++)
      printf("[%02d] ", A[i][j]);
    printf("\n");
  }
}

void sort_array(int A[10][10], int m, int n)
{
  int i, j, x, y, index_i = 0, index_j = 0, min;
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
    {
      min = A[i][j];
      index_i = i;
      index_j = j;
      for (x = i; x < m; x++)
      {
        if (x == i)
          y = j;
        else
          y = 0;

        for (; y < n; y++)
          if (min > A[x][y])
          {
            min = A[x][y];
            index_i = x;
            index_j = y;
          }
      }
      swap(&A[i][j], &A[index_i][index_j]);
    }
}

int main()
{
  int array[10][10], m, n, beg, end, mid, i, j, key, mark_i, mark_j;

  printf("Enter the row size of the array : ");
  scanf("%d", &m);

  printf("Enter the cloumn size of the array : ");
  scanf("%d", &n);

  printf("Enter the elements : \n");
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
    {
      printf("(%d ,%d) : ", i, j);
      scanf("%d", &array[i][j]);
    }

  sort_array(array, m, n);
  printf("\nSorted Matrix : \n");
  print_2D_array(array, m, n);

  printf("\nEnter the key value : ");
  scanf("%d", &key);

  for (i = 0, mark_i = -1, mark_j = -1; i < m; i++)
  {
    if (key >= array[i][0] && key <= array[i][n - 1])
    {
      mark_i = i;
      break;
    }
  }

  if (mark_i != -1)
  {
    beg = 0;
    end = n - 1;
    do
    {
      mid = (beg + end) / 2;

      if (array[mark_i][mid] == key)
      {
        mark_j = mid;
        printf("Key %d  found at (%d,%d) \n", key, mark_i, mark_j);
        return 0;
      }

      else if (array[mark_i][mid] > key)
        end = mid - 1;
      else
        beg = mid + 1;
    } while (beg <= end);

    printf("Key not in array!");
  }

  else
    printf("\nKey not in array !");

  return 0;
}
