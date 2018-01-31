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


int main()
{
	int n;
	printf("Enter array size : ");
	scanf("%d", &n);
	getchar();
	char A[n];
	printf("Enter array elements : \n");
	for(int i =0; i < n; i++)
	{
		printf("[%d] : ",i);
		scanf("%c", &A[i]);
		getchar();
	}

	start();
	int balance = 0;

	for(int i = 0; i< n; i++)
		if(A[i]== '(')
			balance++;
		else if(A[i] == ')')
			balance--;
	if(balance ==0)
		printf("\n\nEquation is balanced");
	else
		printf("\n\nEquation is not balanced");

	end();
	return 0;
}
