import java.util.Scanner;

class Program {
	public static void main(String[] args) {
		Scanner input = new Scanner(System.in);
		System.out.println("Enter a number to print its multiplication table : ");
		int num = input.nextInt();

		for (int i = 1; i <= 12; i++)
			System.out.println(num + " times " + i + " is " + num * i + ".");

	}
}
