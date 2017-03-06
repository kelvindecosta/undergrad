#include <stdio.h>
int main()
{
  int array[10][10], m, n, key, i, j, index_i, index_j;
  printf("Enter the row size of the array :");
  scanf("%d", &m);

  printf("Enter the column size of the array :");
  scanf("%d", &n);

  printf("Enter the elements of the array :\n");
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
      scanf("%d", &array[i][j]);

  printf("\nEnter the key :");
  scanf("%d", &key);

  index_i = index_j = -1;
  for (i = 0; i < m; i++)
    for (j = 0; j < n; j++)
      if (key == array[i][j])
      {
        index_i = i;
        index_j = j;
        printf("\nKey found at (%d,%d) ", index_i, index_j);
      }
  if (index_i != -1 && index_j != -1)
    printf("\nLast instance of key found at (%d,%d)", index_i, index_j);
  else
    printf("\nKey is not in the array!");
  return 0;
}
