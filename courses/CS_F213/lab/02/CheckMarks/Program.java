import java.util.Scanner;

class Program {
	public static void main(String[] args) {
		double marks[] = { 0, 0, 0 };
		Scanner input = new Scanner(System.in);
		System.out.println("Enter the marks for each subject : ");
		double avg = 0;
		for (int i = 0; i < 3; i++) {
			System.out.print("Subject " + (i + 1) + " : ");
			marks[i] = input.nextDouble();
			avg += marks[i];
		}
		avg /= 3;
		String div;
		if (avg >= 75)
			div = "distinction";
		else if (avg >= 60)
			div = "first class";
		else if (avg >= 50)
			div = "second class";
		else if (avg >= 40)
			div = "pass";
		else
			div = "fail";

		System.out.println("You have been placed in " + div + " division.");
	}
}
