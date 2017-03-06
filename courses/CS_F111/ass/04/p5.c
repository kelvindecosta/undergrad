#include <stdio.h>
#include <math.h>

int prime_test(int num)
{
  int prime = 1, i;
  if (num % 2 != 0)
  {
    for (i = 2; i <= sqrt(num); i++)
      if (num % i == 0)
        prime = 0;
  }
  else if (num != 2)
    prime = 0;
  return (prime);
}

int main()
{
  int num;
  printf("Enter a number to check if it is a prime : ");
  scanf("%d", &num);

  if (prime_test(num))
    printf("%d is a prime number.", num);
  else
    printf("%d is not a prime number.", num);
  return 0;
}
