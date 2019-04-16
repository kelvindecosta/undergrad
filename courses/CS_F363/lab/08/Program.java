import java.util.*;
import java.io.*;

public class Program {
	public static void main(String[] args) throws Exception {
		Scanner sc = new Scanner(System.in);
		PrintWriter writer = new PrintWriter(args[1], "UTF-8");

		String input = "";
		writer.println(".global main");
		writer.println("msg:");
		writer.println(".string \"Final result of LHS var = %d\\n\"");
		writer.println(".comm a,4");
		writer.println(".comm b,4");
		writer.println(".comm c,4");
		writer.println(".comm d,4");
		writer.println(".comm e,4");
		writer.println(".comm f,4");
		writer.println(".comm z,4");
		writer.println("\nmain:");
		writer.println("pushl %ebp");
		writer.println("movl %esp, %ebp");
		writer.println();

		File input_File = new File(args[0]);
		BufferedReader reader = new BufferedReader(new FileReader(input_File));

		while (true) {
			input = reader.readLine();
			if (input == null) {
				break;
			}
			String[] tokens = input.split(" ");

			String op = tokens[0];
			String arg1 = tokens[1];
			String arg2 = tokens[2];
			String res = tokens[3];

			switch (op) {
				case "=":
					writer.print("movl ");
					break;
				case "-":
					writer.print("subl ");
					break;
				default:
					;
			}

			if (Character.isDigit(arg1.charAt(0))) {
				writer.print("$" + arg1);
			} else if (arg1.equals("eax")) {
				writer.print("%" + arg1);
			} else {
				writer.print(arg1);
			}

			if (res.equals("eax")) {
				writer.println(", %" + res);
			} else {
				writer.println("," + res);
			}
		}

		writer.println("\n\npushl z");
		writer.println("pushl $msg");
		writer.println("call printf");
		writer.println("leave");
		writer.println("ret");
		writer.close();
	}
}
