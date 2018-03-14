import java.util.*;

class DNS {
	String host;
	String IPAddress;

	DNS(String host, String IP) {
		this.host = host;
		this.IPAddress = IP;
	}

	DNS(DNS other) {
		this.host = other.host;
		this.IPAddress = other.IPAddress;
	}
}

class DNSHashMap {
	DNS map[];

	DNSHashMap() {
		map = new DNS[53];
	}

	public static long hashing(long key) {
		return key % 53L;
	}

	public static long polynomial(String host) {
		char[] data = host.toCharArray();
		long value = 0;
		int a = 33;

		for (int i = 0; i < data.length; i++) {
			value *= a;
			value += (int) data[data.length - 1 - i];
		}
		return value;
	}

	public void put(DNS dns) {
		int index = (int) hashing(polynomial(dns.host));
		int count = 0;
		while (count < 53) {
			int i = (index + count) % 53;
			if (map[i] == null) {
				map[i] = new DNS(dns);
				System.out.println("Successfully mapped at " + i + " from " + index + " !");
				return;
			}
			count++;
		}
		System.out.println("Could not enter DNS into mapping!");
	}

	public void displayAddress(String hostname) {
		int index = (int) hashing(polynomial(hostname));

		int count = 0;
		while (count < 53) {
			int i = (index + count) % 53;
			if (map[i] == null) {
				System.out.println("Not in mapping!");
				return;
			} else if (map[i].host.compareTo(hostname) == 0) {
				System.out.println("IP : " + map[i].IPAddress);
				return;
			}
			count++;
		}
		System.out.println("Not in mapping");
	}
}

class Program {

	static Scanner input;

	public static void main(String args[]) {
		DNSHashMap mapping = new DNSHashMap();
		input = new Scanner(System.in);
		int opt;
		do {
			clearScreen();
			System.out.println("DNS Mappings");
			System.out.println("[1] : Add new mapping");
			System.out.println("[2] : Find IP of hostname ");
			System.out.println("[0] : Exit");

			System.out.print("Option : ");
			opt = input.nextInt();
			input.nextLine();

			switch (opt) {
				case 1:
					System.out.print("Host Name : ");
					String host = input.nextLine();
					System.out.print("IP Address: ");
					String address = input.nextLine();
					mapping.put(new DNS(host, address));
					break;
				case 2:
					System.out.print("Host Name : ");
					String hostname = input.nextLine();
					mapping.displayAddress(hostname);
					break;
				case 0:
					break;
				default:
					System.out.println("Invalid Option");
			}
			pak();
		} while (opt != 0);

	}

	public static void clearScreen() {
		System.out.println("\033[J\033[2J");
		System.out.flush();
	}

	public static void pak() {
		System.out.println("Press any key to continue");
		input.nextLine();
	}
}
