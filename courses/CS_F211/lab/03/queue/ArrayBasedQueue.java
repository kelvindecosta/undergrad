package queue;

class ArrayBasedQueue {
	int[] array;
	int base;
	int front;
	int rear;
	int size;

	ArrayBasedQueue(int base) {
		this.base = base;
		array = new int[base];
		front = rear = -1;
		size = 0;
	}

	public boolean isEmpty() {
		return size == 0;
	}

	public boolean isFull() {
		return size == base;
	}

	public void enq(int e) {
		if (isFull()) {
			System.out.println("Queue is full!");
			return;
		}

		rear = (rear + 1) % base;
		array[rear] = e;
		if (isEmpty())
			front = rear;
		size++;
	}

	public Integer deq() {
		if (isEmpty()) {
			System.out.println("Queue is empty!");
			return null;
		}
		int temp = array[front];
		front = (front + 1) % base;
		size--;
		if (isEmpty())
			rear = front;
		return temp;
	}

	public void print() {
		if (isEmpty()) {
			System.out.println("Queue is empty!");
			return;
		}
		System.out.print("Queue : [");
		int count = size;
		int index = front;
		while (count > 0) {
			System.out.print(array[index] + ", ");
			index = (index + 1) % base;
			count--;
		}
		System.out.println("]");
	}
}
