package stack;

import java.util.*;

class MyStack {
  char[] array;
  int size;
  int front;

  public MyStack(int s) {
    size = s;
    array = new char[s];
    front = -1;
  }

  public void push(char e) {
    if (front == size - 1) {
      System.out.println("Stack Full!");
      return;
    }
    array[++front] = e;
  }

  public char pop() {
    if (front < 0) {
      System.out.println("Stack Empty!");
      return 0;
    }
    return array[front--];
  }

  public void print() {
    if (front < 0) {
      System.out.println("Stack Empty!");
      return;
    }

    System.out.print("Stack : [");
    for (int i = front; i >= 0; i--)
      System.out.print(array[i] + ", ");
    System.out.println("]");
  }
}
