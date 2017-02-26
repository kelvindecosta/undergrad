#include <stdio.h>
int main()
{
	float marks[10], avg, high, low;
	int i;
	printf("Enter the marks of 10 students : \n");
	for (i = 0; i < 10; i++)
	{
		printf("Student %d : ", i + 1);
		scanf("%f", &marks[i]);
	}
	high = low = marks[0];
	for (i = 0, avg = 0; i < 10; i++)
	{
		avg += marks[i];
		if (marks[i] > high)
			high = marks[i];
		if (marks[i] < low)
			low = marks[i];
	}
	avg = avg / i;
	printf("\nAverage       : %f", avg);
	printf("\nHighest Marks : %f", high);
	printf("\nLowest Marks  : %f", low);

	return 0;
}
