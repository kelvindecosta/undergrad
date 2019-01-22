#include <stdio.h>
int main()
{
	int a = 100, b = 5, c = 2;
	float x, y = 1.0;

	x = y += (a >> 4) + b % c;
	printf("x=%f\n", x);
	return 0;
}
