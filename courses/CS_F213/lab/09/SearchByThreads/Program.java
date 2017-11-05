import java.util.*;

class SearchThread implements Runnable {
	static int[] data = new int[10];
	int start;
	int end;
	static boolean found = false;
	static int targetIndex;
	static int target;

	public SearchThread(int start, int end) {
		this.start = start;
		this.end = end;
	}

	public void run() {
		for (int i = start; i <= end && i < data.length; i++) {
			if (found)
				return;
			else {
				if (target == data[i]) {
					found = true;
					targetIndex = i;
				}
			}
		}
	}

	public static void setTarget(int tar) {
		target = tar;
		targetIndex = -1;
	}

	public static boolean isFound() {
		return found;
	}

	public static int getIndex() {
		return targetIndex;
	}
}

class Program {
	public static void main(String args[]) {
		Scanner input = new Scanner(System.in);
		System.out.println("Enter elements : ");
		for (int i = 0; i < SearchThread.data.length; i++) {
			System.out.print("[" + i + "] : ");
			SearchThread.data[i] = input.nextInt();
		}

		ArrayList<SearchThread> searches = new ArrayList<SearchThread>();
		ArrayList<Thread> threads = new ArrayList<Thread>();

		System.out.print("Enter the target : ");
		int target = input.nextInt();

		SearchThread.setTarget(target);

		System.out.print("Enter number of threads : ");
		int t = input.nextInt();

		int count = SearchThread.data.length / t;
		int buffer = 0;
		while (buffer <= SearchThread.data.length) {
			searches.add(new SearchThread(buffer, buffer + count));
			buffer += count;
		}

		for (int i = 0; i < searches.size(); i++) {
			threads.add(new Thread(searches.get(i)));
			threads.get(i).start();
		}

		System.out.println("Number of threads = " + threads.size());

		boolean check = true;
		while (check) {
			check = false;
			for (int i = 0; i < threads.size(); i++) {
				if (!threads.get(i).isAlive()) {
					if (SearchThread.isFound()) {
						System.out.println("Target : " + target + " found at " + SearchThread.getIndex());
						return;
					}
				} else {
					check = true;
				}

			}
		}
		System.out.println("Target : " + target + " not in array!");
	}
}
