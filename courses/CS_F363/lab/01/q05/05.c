#include <stdio.h>

int A[10000][10000];

int main()
{
  for (int i = 0; i < 10000; i++)
    for (int j = 0; j < 10000; j++)
      A[j][i] = 0;
}
