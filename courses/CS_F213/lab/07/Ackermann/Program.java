import java.util.*;

class Program {
  public static void main(String[] args) {
    long x, y;
    Scanner input = new Scanner(System.in);

    System.out.println("Enter the inputs for Ackerman's fucntion : ");

    System.out.print("x : ");
    x = input.nextInt();

    System.out.print("y : ");
    y = input.nextInt();

    System.out.println("A(" + x + ", " + y + ") = " + Ackerman(x, y));
  }

  public static long Ackerman(long x, long y) {
    if (x == 0)
      return y + 1;
    else if (y == 0)
      return Ackerman(x - 1, 1);
    else
      return Ackerman(x - 1, Ackerman(x, y - 1));
  }
}
