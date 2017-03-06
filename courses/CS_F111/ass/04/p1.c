#include <stdio.h>
int main()
{
  int array[10], size, key, i, index;
  printf("Enter the size of the array :");
  scanf("%d", &size);

  printf("Enter the elements of the array :\n");
  for (i = 0; i < size; i++)
    scanf("%d", &array[i]);

  printf("\nEnter the key :");
  scanf("%d", &key);

  index = -1;
  for (i = 0; i < size; i++)
    if (key == array[i])
    {
      index = i;
      printf("\nKey found at %d ", index);
    }
  if (index != -1)
    printf("\nLast instance of key found at %d", index);

  else
    printf("\nKey not in array!");
  return 0;
}
