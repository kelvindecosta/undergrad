package doublylinkedlist;

import java.util.*;

class DLListImplementation {
    public static Scanner input;

    public static void clearScreen() {
        System.out.print("\033[H\033[2J");
        System.out.flush();
    }

    public static void pak() {
        System.out.println("Press any key to continue!");
        input.nextLine();
    }

    public static void main(String args[]) {
        input = new Scanner(System.in);
        MyDoublyLinkedList list = new MyDoublyLinkedList();

        int opt;
        do {
            clearScreen();
            System.out.println("Double Linked List Operations");
            System.out.println("[1] : Insert Element");
            System.out.println("[2] : Remove Element");
            System.out.println("[3] : Print Forward");
            System.out.println("[4] : Print Reverse");
            System.out.println("[0] : Exit");
            System.out.print("Option : ");

            opt = input.nextInt();
            input.nextLine();
            Integer e;
            int pos;

            switch (opt) {
                case 1:
                    System.out.println("Element Insertion");
                    list.printForward();
                    System.out.print("Element  : ");
                    e = input.nextInt();
                    input.nextLine();
                    System.out.print("Position : ");
                    pos = input.nextInt();
                    input.nextLine();
                    list.insertAtPos(e, pos);
                    list.printForward();
                    break;
                case 2:
                    System.out.println("Element Removal");
                    list.printForward();
                    System.out.print("Position : ");
                    pos = input.nextInt();
                    input.nextLine();
                    e = list.remove(pos);
                    if (e != null)
                        list.printForward();
                    break;
                case 3:
                    list.printForward();
                    break;
                case 4:
                    list.printReverse();
                    break;
                case 0:
                    break;
                default:
                    System.out.println("Invalid Option!");
            }
            pak();
        } while (opt != 0);
    }
}
