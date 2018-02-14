package queue;

import java.util.*;

class QueueImplementation {
	static Scanner input;

	public static void clearScreen() {
		System.out.println("\033[H\033[2J");
		System.out.flush();
	}

	public static void pak() {
		System.out.println("Press any key to continue!");
		input.nextLine();
	}

	public static void main(String args[]) {
		input = new Scanner(System.in);
		ArrayBasedQueue queue = new ArrayBasedQueue(20);

		int opt;
		do {
			clearScreen();
			System.out.println("Queue Operations");
			System.out.println("[1] : Enqueue");
			System.out.println("[2] : Dequeue");
			System.out.println("[3] : Print");
			System.out.println("[0] : Exit");
			System.out.print("Option : ");

			opt = input.nextInt();
			Integer e;
			input.nextLine();

			switch (opt) {
				case 1:
					System.out.println("Enqueue Operation");
					System.out.print("Element : ");
					e = input.nextInt();
					input.nextLine();
					queue.enq(e);
					break;
				case 2:
					System.out.println("Dequeue Operation");
					e = queue.deq();
					if (e != null)
						System.out.println("Dequeued element : " + e);
					break;
				case 3:
					System.out.println("Print Operation");
					queue.print();
					break;
				case 0:
					break;
				default:
					System.out.println("Invalid Option!");
			}
			pak();
		} while (opt != 0);
		System.out.println("Bye");

	}
}
