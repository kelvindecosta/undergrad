package doublylinkedlist;

class MyDoublyLinkedList {
    Node head;
    Node tail;
    int size;

    MyDoublyLinkedList() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }

    class Node {
        int data;
        Node prev;
        Node next;

        Node(int data) {
            this.data = data;
            this.prev = null;
            this.next = null;
        }
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public void insertFirst(int e) {
        Node temp = new Node(e);
        temp.next = head;
        head = temp;
        if (isEmpty())
            tail = temp;
        else
            temp.next.prev = temp;
        size++;
    }

    public void insertLast(int e) {
        Node temp = new Node(e);
        temp.prev = tail;
        tail = temp;
        if (isEmpty())
            head = temp;
        else
            temp.prev.next = temp;
        size++;
    }

    public void insertAtPos(int e, int p) {
        if (p > size) {
            System.out.println("Position out of bounds!");
            return;
        } else if (p == 0)
            insertFirst(e);
        else if (p == size)
            insertLast(e);
        else {
            Node temp = new Node(e);
            Node pos = head;
            while (pos != null) {
                p--;
                if (p == 0) {
                    temp.next = pos.next;
                    temp.next.prev = temp;
                    pos.next = temp;
                    temp.prev = pos;
                    size++;
                    break;
                }
                pos = pos.next;
            }
        }
    }

    public Integer remove(int p) {
        if (isEmpty()) {
            System.out.println("List is empty!");
            return null;
        }
        if (p >= size) {
            System.out.println("Position out of bounds!");
            return null;
        }

        Node temp = new Node(0);
        if (p == 0) {
            temp = head;
            head = head.next;
            if (head != null)
                head.prev = null;
            size--;
            if (isEmpty())
                tail = head;

        } else if (p == size - 1) {
            temp = tail;
            tail = tail.prev;
            if (tail != null)
                tail.next = null;
            size--;
            if (isEmpty())
                head = tail;
        } else {
            Node pos = head;
            while (pos != null) {
                p--;
                if (p == 0) {
                    temp = pos.next;
                    temp.next.prev = pos;
                    temp.prev.next = temp.next;
                    size--;
                }
                pos = pos.next;
            }
        }
        return temp.data;
    }

    public int size() {
        return this.size;
    }

    public void printForward() {
        Node temp = head;
        System.out.print("Forward Print : [");
        while (temp != null) {
            System.out.print(temp.data + ", ");
            temp = temp.next;
        }
        System.out.println("]");
    }

    public void printReverse() {

        Node temp = tail;
        System.out.print("Reverse Print : [");
        while (temp != null) {
            System.out.print(temp.data + ", ");
            temp = temp.prev;
        }
        System.out.println("]");
    }
}
