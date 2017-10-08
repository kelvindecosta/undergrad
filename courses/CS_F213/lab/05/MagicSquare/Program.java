import java.util.*;

class Program {
	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		print("Enter a number to print it's 4x4 Magic Square : ");
		int sum = input.nextInt();

		MagicSquare magicSquare = new MagicSquare(sum);
		magicSquare.printSquare();
	}

	public static void print(String string) {
		System.out.print(string);
	}
}

class MagicSquare {
	double square[][];
	int sum;

	MagicSquare(int sum) {
		square = new double[4][4];
		this.sum = sum;
		this.set();
	}

	public void set() {

		int count = 0;

		for (int i = 0; i < 4; i++)
			for (int j = 0; j < 4; j++) {
				square[i][j] = (sum / (double) 4) - 8.5;
				count++;
				if (i == j || (i + j) == 3)
					square[i][j] += count;
				else
					square[i][j] += (17 - count);

			}
	}

	public void printSquare() {
		Program.print("MAGIC SQUARE (" + this.sum + ") :\n");
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++)
				Program.print("[" + square[i][j] + "] ");
			Program.print("\n");
		}
	}
}
