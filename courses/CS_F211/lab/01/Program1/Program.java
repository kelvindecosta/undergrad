import java.util.*;

class Program {
	static long time;

	public static void start() {
		time = System.currentTimeMillis();
	}

	public static void end() {
		time = System.currentTimeMillis() - time;
		System.out.println("Executed in " + time + " ms");
	}

	public static void main(String args[]) {
		char[] A, B;
		Scanner input = new Scanner(System.in);
		System.out.print("Enter the character array : ");
		A = (input.nextLine()).toCharArray();
		start();
		int n = A.length;
		B = new char[n];
		for (int i = 0; i < n; i++)
			B[i] = A[n - 1 - i];

		System.out.println("A : " + new String(A));
		System.out.println("B : " + new String(B));

		end();
	}
}
