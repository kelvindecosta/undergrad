#include <stdio.h>

int quadrant(int x, int y)
{
   if (y >= 0)
      if (x >= 0)
         return 1;
      else
         return 2;
   else if (x >= 0)
      return 4;
   else
      return 3;
}

int main()
{
   int x, y;
   printf("Enter the coordiantes of a point on the Cartesian plane :\n");
   printf("x : ");
   scanf("%d", &x);

   printf("y : ");
   scanf("%d", &y);

   printf("The point (%d,%d) lies on quadrant %d\n", x, y, quadrant(x, y));
}
