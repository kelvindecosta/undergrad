#include<time.h>
#include<stdio.h>

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

void checkDuplicates(int A[], int n)
{
	for(int i =0; i< n-1; i++)
		for(int j = i+1 ; j < n; j++)
			if(A[i] == A[j])
			{
				printf("Duplicate %d found at %d and %d", A[i], i ,j);
				return;
			}
	printf("Array has no duplicates");
}

int main()
{
	int n;
	printf("Enter array size : ");
	scanf("%d", &n);
	int A[n];
	printf("Enter array elements : \n");
	for(int i =0; i < n; i++)
	{
		printf("[%d] : ",i);
		scanf("%d", &A[i]);
	}

	start();

	checkDuplicates(A, n);
	end();
	return 0;
}
