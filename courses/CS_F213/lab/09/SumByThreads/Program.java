import java.util.*;

class Summation implements Runnable {
	int start;
	int end;
	int sum;

	public Summation(int s, int e) {
		start = s;
		end = e;
		sum = 0;
	}

	public void run() {
		for (int i = start; i <= end; i++)
			sum += i;

		System.out.println("Sum from " + start + " to " + end + " is " + sum);
	}

	public int getSum() {
		return sum;
	}
}

class Program {
	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		System.out.print("Enter a number to print the sum of all natural numbers to it : ");
		int N = input.nextInt();

		System.out.print("Enter the number of threads : ");
		int t = input.nextInt();

		ArrayList<Summation> sumList = new ArrayList<Summation>();
		ArrayList<Thread> threadList = new ArrayList<Thread>();

		int sumCount = N / t;
		int buffer = sumCount;
		while (buffer <= N) {
			sumList.add(new Summation(buffer - sumCount + 1, buffer));
			buffer += sumCount;
		}

		for (int i = 0; i < sumList.size(); i++) {
			try {
				threadList.add(new Thread(sumList.get(i)));
				threadList.get(i).start();
			} catch (Exception E) {
				System.out.println(E.getMessage());
			}
		}
		boolean check = true;

		while (check) {
			int i;
			for (i = 0; i < threadList.size(); i++)
				if (threadList.get(i).isAlive())
					break;
			if (i == threadList.size())
				check = false;
		}

		long sum = 0;
		for (int i = 0; i < sumList.size(); i++)
			sum += sumList.get(i).getSum();

		System.out.print("Sum of first " + N + " natural numbers is : " + sum);
	}
}
