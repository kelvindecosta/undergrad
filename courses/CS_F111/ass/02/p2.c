#include <stdio.h>

int main()
{
	int age;
	printf("Enter your age : ");
	scanf("%d", &age);
	if (age > 18)
		printf("MAJOR");
	else
		printf("MINOR");
	return 0;
}
