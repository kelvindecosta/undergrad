import java.util.Scanner;

class Program {
	public static void main(String[] args) {
		Scanner input = new Scanner(System.in);
		System.out.println("Enter a number to check if it is odd , even or a multiple of 5 or 10 : ");
		int num = input.nextInt();

		if (num % 2 == 0)
			System.out.println(num + " is even.");
		else
			System.out.println(num + " is odd.");

		if (num % 10 == 0)
			System.out.println(num + " is a multile of 5 and 10.");
		else if (num % 5 == 0)
			System.out.println(num + " is a multiple of 5 only.");
		else
			System.out.println(num + " is not a multiple of 5 nor of 10.");
	}
}
