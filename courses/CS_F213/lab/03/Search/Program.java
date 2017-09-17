import java.util.*;

class Program {
	public static void main(String args[]) {
		ArrayList<Integer> array = new ArrayList<Integer>();
		Random random = new Random();
		random.setSeed(System.currentTimeMillis());
		for (int i = 1; i <= 10; i++)
			array.add(random.nextInt() % 11);

		System.out.print("Enter a number to check if it is in the array : ");
		Scanner input = new Scanner(System.in);
		int check = input.nextInt();

		if (array.contains(check))
			System.out.println("The array contains " + check);
		else
			System.out.println("The array does not contain " + check);

		Collections.sort(array);
		Iterator arrayLoop = array.iterator();
		while (arrayLoop.hasNext())
			System.out.print("[" + arrayLoop.next() + "] ");
		System.out.println("\n");
	}
}
