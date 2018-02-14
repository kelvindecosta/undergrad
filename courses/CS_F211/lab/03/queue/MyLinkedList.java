package queue;

class MyLinkedList {
  Node front;
  Node rear;

  public MyLinkedList() {
    this.front = this.rear = null;
  }

  class Node {
    int data;
    Node next;

    Node(int data) {
      this.data = data;
      this.next = null;
    }
  }

  public void add(int data) {
    Node temp = new Node(data);
    if (rear != null)
      rear.next = temp;
    rear = temp;

    if (front == null)
      front = rear;
  }

  public boolean isEmpty() {
    return front == null;
  }

  public Integer remove() {
    if (isEmpty())
      return null;

    Node temp = front;
    front = temp.next;
    if (front == null)
      rear = front;
    return temp.data;
  }

  public void print() {
    Node temp = front;
    System.out.print("[");
    while (temp != null) {
      System.out.print(temp.data + ", ");
      temp = temp.next;
    }
    System.out.println("]");
  }
}
