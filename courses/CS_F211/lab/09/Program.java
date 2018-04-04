import java.util.*;

class Process {
	int id;
	int time;

	Process(int id, int time) {
		this.id = id;
		this.time = time;
	}

	Process(Process other) {
		id = other.id;
		time = other.time;
	}

	public static void swap(Process a, Process b) {
		Process temp = new Process(a);
		a.id = b.id;
		a.time = b.time;
		b.id = temp.id;
		b.time = temp.time;
	}

	public String toString() {
		return "Process #" + id + " , time : " + time;
	}
}

class Scheduler {
	Process processes[];
	int capacity;
	int size;

	Scheduler(int cap) {
		capacity = cap;
		processes = new Process[capacity];
		size = 0;
	}

	public static int parent(int index) {
		return (index - 1) / 2;
	}

	public static int right(int index) {
		return index * 2 + 2;
	}

	public static int left(int index) {
		return index * 2 + 1;
	}

	boolean isFull() {
		return size == capacity;
	}

	void insert(int burst_time) {
		size++;
		int i = size - 1;
		processes[i] = new Process(i + 1, burst_time);

		while (i != 0 && processes[parent(i)].time > processes[i].time) {
			Process.swap(processes[i], processes[parent(i)]);
			i = parent(i);
		}
	}

	Process remove() {
		if (size == 0)
			return null;

		if (size == 1) {
			size--;
			return processes[0];
		}

		Process root = processes[0];
		processes[0] = processes[size - 1];
		size--;
		MinHeapify(0);
		return root;
	}

	void MinHeapify(int i) {
		int l = left(i);
		int r = right(i);
		int smallest = i;

		if (l < size && processes[l].time < processes[i].time)
			smallest = l;
		if (r < size && processes[r].time < processes[smallest].time)
			smallest = r;
		if (smallest != i) {
			Process.swap(processes[i], processes[smallest]);
			MinHeapify(smallest);
		}
	}

	void print() {
		for (int i = 0; i < size; i++) {
			System.out.println(processes[i].toString());
		}
	}

}

class Program {
	public static void main(String args[]) {
		Scheduler heap = new Scheduler(9);
		int times[] = { 27, 14, 1, 4, 5, 13, 8, 20, 25 };

		for (int i = 0; i < times.length; i++)
			heap.insert(times[i]);

		System.out.println("Process Heap : ");
		heap.print();

		System.out.println("\nProcess order : ");
		while (heap.size != 0) {
			System.out.println(heap.remove().toString());
		}
	}
}
