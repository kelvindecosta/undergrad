#include <stdio.h>

int main()
{
	float m1, m2, m3, m4, m5, average;
	printf("Enter the following marks to calculate percentage and division : ");

	printf("\n Subject 1 : ");
	scanf("%f", &m1);
	printf("\n Subject 2 : ");
	scanf("%f", &m2);
	printf("\n Subject 3 : ");
	scanf("%f", &m3);
	printf("\n Subject 4 : ");
	scanf("%f", &m4);
	printf("\n Subject 5 : ");
	scanf("%f", &m5);

	average = (m1 + m2 + m3 + m4 + m5) / 5;
	printf("\n Average  : %f", average);
	printf("\n Division : ");

	if (average > 80)
		printf("Distinction");
	else if (average >= 60)
		printf("First");
	else if (average >= 45)
		printf("Second");
	else
		printf("Fail");

	printf("\n");
	return 0;
}
