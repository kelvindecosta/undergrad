import java.util.*;

interface Moveable {
	public void move(String newPos);
}

abstract class ChessPiece implements Moveable {
	String name;
	String color;
	String curPos;

	public ChessPiece(String name, String color, String curPos) {
		this.name = name;
		this.color = color;
		this.curPos = curPos;
	}

	public void move(String newPos) {
		System.out.println(this.color + " " + this.name + " from " + this.curPos + " to " + newPos);
		curPos = newPos;
	}

	public String getName() {
		return this.color + " " + this.name;
	}
}

class King extends ChessPiece {
	public King(String color, String pos) {
		super("King", color, pos);
	}
}

class Queen extends ChessPiece {
	public Queen(String color, String pos) {
		super("Queen", color, pos);
	}
}

class Pawn extends ChessPiece {
	public Pawn(String color, String pos) {
		super("Pawn", color, pos);
	}
}

class Program {
	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		ArrayList<ChessPiece> pieces = new ArrayList<ChessPiece>();
		pieces.add(new King("White", "e1"));
		pieces.add(new Queen("Black", "d8"));
		pieces.add(new Pawn("White", "a2"));

		int opt;
		do {
			clearScreen();
			System.out.println("List of Board Pieces : ");
			for (int i = 0; i < pieces.size(); i++) {
				System.out.println("[" + (i + 1) + "] : " + (pieces.get(i)).getName());
			}

			System.out.print("\nEnter a piece (O to exit) and its new Position : ");
			String[] inp = input.nextLine().split("\\s+");

			opt = Integer.parseInt(inp[0]);

			if (opt - 1 < pieces.size()) {
				pieces.get(opt - 1).move(inp[1]);
				System.out.println("Press ENTER to continue!");
				input.nextLine();
			}
		} while (opt != 0);

		System.out.print("BYE!");
	}

	public static void clearScreen() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
	}
}
