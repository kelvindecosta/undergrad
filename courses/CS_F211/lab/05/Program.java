import java.util.*;
import java.io.*;

class Student implements Serializable {
	String name;
	String id;
	String year;
	Double gpa;

	public Student(String name, String id, String year, Double gpa) {
		this.name = name;
		this.id = id;
		this.year = year;
		this.gpa = gpa;
	}

	public void print() {
		System.out.println(name + " | " + id + " | " + year + " | " + gpa);
	}

	public void swap(Student other) {
		String temp;
		temp = this.name;
		this.name = other.name;
		other.name = temp;

		temp = this.id;
		this.id = other.id;
		other.id = temp;

		temp = this.year;
		this.year = other.year;
		other.year = temp;

		Double fake;
		fake = this.gpa;
		this.gpa = other.gpa;
		other.gpa = fake;
	}
}

class Program {

	static ArrayList<Student> students;
	static Scanner input;

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
		students = new ArrayList<Student>();
		int opt;
		do {
			readStudents();
			clearScreen();
			System.out.println("Student System");
			System.out.println("[1] : Add New Student");
			System.out.println("[2] : Sort via Name (merge sort)");
			System.out.println("[3] : Sort via Year (insertion sort)");
			System.out.println("[4] : Sort via Name (quick sort)");
			System.out.println("[0] : Exit");
			System.out.print("Option : ");
			opt = input.nextInt();
			input.nextLine();

			switch (opt) {
				case 1:
					System.out.println("New Student : ");
					addStudent();
					break;
				case 2:
					System.out.println("Students merge sorted by name : ");
					students = mergeSort(students);
					printStudents();
					break;
				case 3:
					System.out.println("Students insertion sorted by year : ");
					students = insertionSort(students);
					printStudents();
					break;
				case 4:
					System.out.println("Student quick sorted by name : ");
					quickSort(students, 0, students.size() - 1);
					printStudents();
					break;
				case 0:
					break;
			}
			pak();
		} while (opt != 0);
	}

	public static void addStudent() {
		System.out.print("Name        : ");
		String name = input.nextLine();

		System.out.print("ID          : ");
		String id = input.nextLine();

		System.out.print("Enroll Year : ");
		String year = input.nextLine();

		System.out.print("GPA         : ");
		Double gpa = input.nextDouble();
		input.nextLine();

		Student temp = new Student(name, id, year, gpa);
		students.add(temp);
		updateStudents();
	}

	public static void readStudents() {
		try {
			students.clear();
			File studentFile = new File("students.db");
			if (!studentFile.exists())
				studentFile.createNewFile();

			ObjectInputStream studentStream = new ObjectInputStream(new FileInputStream(studentFile));
			Student student = null;
			while ((student = (Student) studentStream.readObject()) != null)
				students.add(student);

			studentStream.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

	public static void updateStudents() {
		File studentFile = new File("students.db");
		File temp = new File("temp.db");
		try {
			if (!studentFile.exists())
				studentFile.createNewFile();

			if (!temp.exists())
				temp.createNewFile();

			ObjectOutputStream studentStream = new ObjectOutputStream(new FileOutputStream(temp));

			for (int i = 0; i < students.size(); i++)
				studentStream.writeObject(students.get(i));
			studentStream.close();

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		studentFile.delete();
		temp.renameTo(studentFile);
	}

	public static ArrayList<Student> mergeSort(ArrayList<Student> slist) {
		if (slist.isEmpty())
			return slist;

		if (slist.size() == 1)
			return slist;

		int half = slist.size() / 2;
		ArrayList<Student> answer = new ArrayList<Student>();
		ArrayList<Student> sub1 = new ArrayList<Student>();
		ArrayList<Student> sub2 = new ArrayList<Student>();

		for (int i = 0; i < half; i++)
			sub1.add(slist.get(i));

		for (int i = half; i < slist.size(); i++)
			sub2.add(slist.get(i));

		sub1 = mergeSort(sub1);
		sub2 = mergeSort(sub2);

		int i = 0;
		int j = 0;

		while (i < sub1.size() && j < sub2.size()) {
			if (sub1.get(i).name.compareTo(sub2.get(j).name) < 0)
				answer.add(sub1.get(i++));
			else
				answer.add(sub2.get(j++));
		}
		while (i < sub1.size())
			answer.add(sub1.get(i++));
		while (j < sub2.size())
			answer.add(sub2.get(j++));

		return answer;
	}

	public static ArrayList<Student> insertionSort(ArrayList<Student> slist) {
		if (slist.isEmpty())
			return slist;

		for (int i = 0; i < slist.size() - 1; i++) {
			int x = i + 1;
			for (int j = i; j >= 0; j--)
				if (slist.get(x).year.compareTo(slist.get(j).year) < 0) {
					slist.get(x).swap(slist.get(j));
					x = j;
				}
		}
		return slist;
	}

	public static void quickSort(ArrayList<Student> slist, int start, int end) {
		if (start < end) {
			int i = partition(slist, start, end);
			quickSort(slist, start, i - 1);
			quickSort(slist, i + 1, end);
		}
	}

	public static int partition(ArrayList<Student> slist, int start, int end) {
		int r = end;
		int j = start;
		int i = j - 1;

		while (j < end) {
			if (slist.get(j).name.compareTo(slist.get(r).name) < 0) {
				i++;
				slist.get(j).swap(slist.get(i));
			}
			j++;
		}
		i++;
		slist.get(i).swap(slist.get(r));
		return i;
	}

	public static void printStudents() {
		for (int i = 0; i < students.size(); i++)
			students.get(i).print();
		System.out.println();
	}
}
