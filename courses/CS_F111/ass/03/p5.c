#include <stdio.h>
int main()
{
  int Array[10][10], size, i, j, opt;
  int s;
  int row_max, col_max;

  printf("Enter the size of the square matrix : ");
  scanf("%d", &size);
  printf("Enter the elements of the matrix :\n");
  for (i = 0; i < size; i++)
    for (j = 0; j < size; j++)
      scanf("%d", &Array[i][j]);

start:

  printf("Enter the option : \n");
  printf("[1] Leading Diagonal Sum\n");
  printf("[2] Upper Triangle Sum\n");
  printf("[3] Row and Column Max\n");
  printf("[4] Transpose\n");
  printf("[0] Exit program\n");
  printf("Your option : ");
  scanf("%d", &opt);

  switch (opt)
  {
  case 1:
    goto unit1;
    break;
  case 2:
    goto unit2;
    break;
  case 3:
    goto unit3;
    break;
  case 4:
    goto unit4;
    break;
  case 0:
    goto dead;
    break;
  default:
    goto start;
  }

unit1:
  //Leading Diagonal Sum
  for (i = 0, s = 0; i < size; i++)
    for (j = 0; j < size; j++)
      if (i == j)
        s += Array[i][j];
  printf("\nLeading Diagonal Sum = %d\n", s);
  return 0;

unit2:
  for (i = 0, s = 0; i < size; i++)
    for (j = i; j < size; j++)
      s += Array[i][j];
  printf("\nUpper Triangle Sum = %d\n", s);
  return 0;

unit3:
  printf("Row maxima :\n");
  for (i = 0; i < size; i++)
  {
    for (j = 0, row_max = Array[i][j]; j < size; j++)
      if (Array[i][j] > row_max)
        row_max = Array[i][j];
    printf("Row %d : %d\n", i + 1, row_max);
  }

  printf("\nColumn maxima :\n");
  for (i = 0; i < size; i++)
  {
    for (j = 0, col_max = Array[j][i]; j < size; j++)
      if (Array[j][i] > col_max)
        col_max = Array[j][i];
    printf("Column %d : %d\n", i + 1, col_max);
  }
  return 0;

unit4:
  for (i = 0; i < size; i++)
    for (j = i; j < size; j++)
    {
      s = Array[i][j];
      Array[i][j] = Array[j][i];
      Array[j][i] = s;
    }
  printf("\nTranspose :\n");
  for (i = 0; i < size; i++)
  {
    for (j = 0; j < size; j++)
      printf("%d ", Array[i][j]);
    printf("\n");
  }

  return 0;

dead:
  return 0;
}
