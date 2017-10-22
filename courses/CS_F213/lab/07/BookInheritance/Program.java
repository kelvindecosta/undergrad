import java.util.*;

class Info {
  String name;
  String author;
  int year;

  public Info(String name, String author, int year) {
    this.name = name;
    this.author = author;
    this.year = year;
  }

  public void display() {
    System.out.println("Name     : " + this.name);
    System.out.println("Author   : " + this.author);
    System.out.println("Year     : " + this.year);
  }
}

class Book extends Info {
  int categorycode;

  public Book(String name, String author, int year, int categorycode) {
    super(name, author, year);
    this.categorycode = (categorycode - 1) % 3 + 1;
  }

  public void display() {
    super.display();
    String category;
    String[] categories = { "Philosophy", "Novel-Fiction", "Autobiography" };
    category = categories[categorycode - 1];

    System.out.println("Category : " + category);
  }
}

class Program {
  public static void main(String[] args) {
    ArrayList<Book> books = new ArrayList<Book>();
    books.add(new Book("The Firm", "John Grisham", 1991, 2));
    books.add(new Book("My Experiments with Truth", "M. K. Gandhi", 1925, 3));
    books.add(new Book("By Parallel Reasoning", "Paul Bartha", 2010, 1));

    for (int i = 0; i < books.size(); i++) {
      System.out.println("Book [" + (i + 1) + "] : ");
      books.get(i).display();
      System.out.println("");
    }
  }
}
