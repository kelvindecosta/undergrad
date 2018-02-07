package stack;

import java.util.*;

class StackImplementation {
	public static Scanner input;

	public static void clearScreen() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
	}

	public static void pak() {
		System.out.println("Press any key to continue!");
		input.nextLine();
	}

	public static void main(String args[]) {
		input = new Scanner(System.in);
		MyStack stack = new MyStack(10);
		int opt;
		do {
			clearScreen();
			System.out.println("Stack Operations");
			System.out.println("[1] : Push ");
			System.out.println("[2] : Pop");
			System.out.println("[3] : Print");
			System.out.println("[0] : Exit");
			System.out.print("\nOption : ");
			char ch;
			opt = input.nextInt();
			input.nextLine();
			System.out.println("");

			switch (opt) {
				case 1:
					System.out.print("Push Operation\nElement : ");
					ch = input.next().charAt(0);
					stack.push(ch);
					stack.print();
					break;
				case 2:
					System.out.println("Pop Operation");
					ch = stack.pop();
					if (ch != 0)
						System.out.println("Popped " + ch);
					break;
				case 3:
					System.out.println("Print Operation");
					stack.print();
					break;
				case 0:
					System.out.println("Exit Operation");
					break;
				default:
					System.out.println("Invalid Option!");
			}
			pak();
		} while (opt != 0);
		System.out.println("Bye!");
	}
}
