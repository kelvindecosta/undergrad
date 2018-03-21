import java.util.*;

class DNS {
	String host;
	String IPAddress;

	DNS(String host, String IP) {
		this.host = host;
		this.IPAddress = IP;
	}
}

class DNSHashMap {
	ArrayList<DNS> map[];

	DNSHashMap() {
		map = new ArrayList[53];
		for (int i = 0; i < map.length; i++)
			map[i] = new ArrayList<DNS>();
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
		map[index].add(dns);
	}

	public void displayAddress(String hostname) {
		int index = (int) hashing(polynomial(hostname));
		if (map[index] == null) {
			System.out.println("Index not in mapping");
			return;
		}

		ArrayList<DNS> mapList = map[index];

		for (int i = 0; i < mapList.size(); i++)
			if (mapList.get(i).host.compareTo(hostname) == 0) {
				System.out.println(mapList.get(i).IPAddress);
				return;
			}

		System.out.println("Not in mapping");
	}
}

class Program {

	static Scanner input;

	public static void main(String args[]) {
		DNSHashMap mapping = new DNSHashMap();
		mapping.put(new DNS("google.com", "10.1.34.56"));
		mapping.put(new DNS("bbc.co.uk", "212.58.241.131"));
		mapping.put(new DNS("aljazeera.com", "198.78.201.252"));
		mapping.displayAddress("google");
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
