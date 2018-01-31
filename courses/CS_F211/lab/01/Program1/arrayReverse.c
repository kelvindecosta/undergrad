#include <time.h>
#include <stdio.h>

clock_t timer;
void start()
{
	timer = clock();
}

void end()
{
	timer = difftime(timer, clock());
	printf("Executed in %d", timer);
}

void printArray(int A[10], int n)
{
	printf("Array : [");
	for (int i = 0; i < n; i++)
		printf("%d, ", A[i]);
	printf("]\n");
}

int main()
{
	int n;
	printf("Enter array size : ");
	scanf("%d", &n);
	int A[n], B[n];
	printf("Enter array elements : \n");
	for (int i = 0; i < n; i++)
	{
		printf("[%d] : ", i);
		scanf("%d", &A[i]);
		getchar();
	}

	start();

	for (int i = 0; i < n; i++)
		B[i] = A[n - 1 - i];

	printArray(A, n);
	printArray(B, n);
	end();
	return 0;
}
