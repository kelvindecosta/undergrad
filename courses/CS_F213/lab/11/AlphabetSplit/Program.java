import java.io.*;

class Program {
	public static File inputData;
	public static File cData;
	public static File vData;

	public static void main(String args[]) {
		try {
			inputData = new File("InputData.txt");
			cData = new File("cData.txt");
			vData = new File("vData.txt");
			cData.createNewFile();
			vData.createNewFile();

			if (inputData.exists() && !inputData.isDirectory()) {
				FileInputStream input = new FileInputStream(inputData);
				FileOutputStream c = new FileOutputStream(cData);
				FileOutputStream v = new FileOutputStream(vData);

				System.out.println("File Contents :");
				System.out.println("InputData.txt :");

				int content;
				while ((content = input.read()) != -1) {
					System.out.print((char) content);
					if (content >= 65 && content <= 90 || content >= 97 && content <= 122) {
						switch (content) {
							case 65:
							case 97:
							case 69:
							case 101:
							case 73:
							case 105:
							case 79:
							case 111:
							case 85:
							case 117:
								v.write(content);
								break;
							default:
								c.write(content);
						}
					}
					if ((char) content == '\n') {
						v.write(content);
						c.write(content);
					}
				}

				c.close();
				v.close();

				FileInputStream cin = new FileInputStream(cData);
				FileInputStream vin = new FileInputStream(vData);

				System.out.println("\n\nConsonants.txt :");
				while ((content = cin.read()) != -1)
					System.out.print((char) content);

				System.out.println("\n\nVowels.txt :");
				while ((content = vin.read()) != -1)
					System.out.print((char) content);
				cin.close();
				vin.close();
				input.close();
			}
		} catch (Exception E) {
			System.out.println(E.getMessage());
		}
	}
}
