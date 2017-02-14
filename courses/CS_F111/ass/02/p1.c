#include <stdio.h>

int main()
{
	char color;
	printf("Enter a character to print a color : ");
	scanf("%c", &color);

	switch (color)
	{
	case 'R':
	case 'r':
		printf("\nRED");
		break;
	case 'G':
	case 'g':
		printf("\nGREEN");
		break;
	case 'B':
	case 'b':
		printf("\nBLUE");
		break;
	default:
		printf("\nBLACK");
	}
	return 0;
}
