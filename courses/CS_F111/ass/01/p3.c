int main()
{
  int num;
  printf("Enter a digit to get its word :");
  scanf("%d", &num);
  printf("\n Word = ");

  switch (num)
  {
  case 0:
    printf("Zero");
    break;
  case 1:
    printf("One");
    break;
  case 2:
    printf("Two");
    break;
  case 3:
    printf("Three");
    break;
  case 4:
    printf("Four");
    break;
  case 5:
    printf("Five");
    break;
  case 6:
    printf("Six");
    break;
  case 7:
    printf("Seven");
    break;
  case 8:
    printf("Eight");
    break;
  case 9:
    printf("Nine");
    break;
  default:
    printf("Invalid Input");
  }

  return 0;
}
