import java.util.*;

class Book implements Comparable<Book> {
	private String name;
	private double cost;

	public Book(String name, double cost) {
		this.name = name;
		this.cost = cost;
	}

	public String getName() {
		return name;
	}

	public double getCost() {
		return cost;
	}

	public int compareTo(Book b) {
		if (this.name.equals(b.getName()))
			return 0;
		else
			return this.name.compareTo(b.getName());
	}
}

abstract class GeneralisedSearch {
	public static boolean search(Object[] arr, Object item) {
		for (int i = 0; i < arr.length; i++)
			if (((Comparable) item).compareTo((Comparable) arr[i]) == 0)
				return true;

		return false;
	}
}

class Program {
	public static void main(String[] args) {
		Scanner input = new Scanner(System.in);
		Book[] books = new Book[] { new Book("Chem", 2.5), new Book("Phy", 3.5), new Book("Math", 5) };
		Book book = new Book("Chem", 2.5);
		System.out.print(GeneralisedSearch.search(books, book));
	}
}
