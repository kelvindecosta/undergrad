import java.lang.Math;
import java.util.Scanner;

class Program {
	public static void main(String args[]) {
		System.out.print("Enter a number to find its square root : ");

		Scanner input = new Scanner(System.in);
		double x, y;
		x = input.nextInt();
		y = Math.sqrt(x);
		System.out.println("Square root of " + x + " is " + y);
	}
}
