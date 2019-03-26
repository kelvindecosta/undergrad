class Generator {
	public static String id_regex = "[a-zA-z]+[0-9]*";
	public static String term_regex = "\\d+|" + id_regex;
	public static String expr_regex = "(" + term_regex + ")(\\+(" + term_regex + "))*";
	public static String Stmt_regex = id_regex + "=" + expr_regex;

	public static void printRow(String i, String o, String a1, String a2, String r) {
		System.out.println(String.format("%9s|%5s|%5s|%5s|%5s|", i, o, a1, a2, r));
	}

	public static void main(String[] args) {
		String input = args[0];

		if (input.matches(Stmt_regex)) {
			System.out.println(input + " is a valid Statement");
		} else {
			System.out.println(input + " is an invalid Statement\nTry again");
			return;
		}

		printRow("INPUT  ", "OPC ", "AR1 ", "AR2 ", "RES ");
		String[] token = input.split("=");
		String[] expr_token = token[1].split("\\+");

		int count = 0;

		if (expr_token.length == 1) {
			printRow(input, "=", token[1], "nil", token[0]);
			return;
		} else {
			String pretemp = "";
			String temp = "";
			for (int i = 0; i < expr_token.length - 1; i++) {
				pretemp = "temp" + count++;
				temp = "temp" + count;
				if (i == 0) {
					printRow(input, "+", expr_token[i], expr_token[i + 1], temp);
				} else {
					printRow("", "+", pretemp, expr_token[i + 1], temp);
				}
			}
			printRow("", "=", temp, "nil", token[0]);
		}

	}
}