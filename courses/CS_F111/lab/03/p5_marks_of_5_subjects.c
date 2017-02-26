#include <stdio.h>
int main()
{
	float marks[5], avg;
	int i;
	printf("Enter subject marks :\n");
	for (i = 0; i < 5; i++)
	{
		printf("Subject %d : ", i + 1);
		scanf("%f", &marks[i]);
	}

	for (i = 0, avg = 0; i < 5; i++)
	{
		avg += marks[i];
	}

	printf("\nTotal    : %f", avg);
	avg /= i;
	printf("\nAverage  : %f", avg);
	printf("\nDivision : ");
	if (avg > 80)
		printf("DISTINCTION");
	else if (avg > 69)
		printf("CLASS I");
	else if (avg > 59)
		printf("CLASS II");
	else if (avg > 49)
		printf("CLASS III");
	else if (avg > 38)
		printf("AVERAGE");
	else
		printf("FAIL");

	return 0;
}
