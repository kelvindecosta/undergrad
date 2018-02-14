package queue;

class LListBasedQueue {
  MyLinkedList list;

  public boolean isEmpty() {
    return list.isEmpty();
  }

  public void enq(int e) {
    list.add(e);
  }

  public Integer deq() {
    if (isEmpty()) {
      System.out.println("Queue is empty!");
      return null;
    }
    return list.remove();
  }

  public void print() {
    if (isEmpty()) {
      System.out.println("Queue is empty!");
      return;
    }
    list.print();
  }
}
