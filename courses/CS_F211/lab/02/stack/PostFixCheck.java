package stack;

import java.util.*;

class DoubleStack {
  double[] array;
  int size;
  int front;

  public DoubleStack(int s) {
    size = s;
    array = new double[s];
    front = -1;
  }

  public void push(double e) {
    if (front == size - 1) {
      System.out.println("Stack Full!");
      return;
    }
    array[++front] = e;
  }

  public double pop() {
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

class PostFixCheck {
  public static boolean isOperator(char test) {
    switch (test) {
      case '+':
      case '-':
      case '*':
      case '/':
        return true;
      default:
        return false;
    }
  }

  public static void main(String args[]) {
    Scanner input = new Scanner(System.in);

    System.out.println("Enter a postfix expression : ");
    String expression = input.nextLine();
    System.out.println("Evaulated : " + evaluate(expression));
  }

  public static double evaluate(String expression) {
    String[] symbols = expression.split("\\s+");
    DoubleStack stack = new DoubleStack(symbols.length);
    for (int i = 0; i < symbols.length; i++) {
      char ch = symbols[i].charAt(0);
      if (isOperator(ch)) {
        double op2 = stack.pop();
        double op1 = stack.pop();
        switch (ch) {
          case '+':
            stack.push(op1 + op2);
            break;
          case '-':
            stack.push(op1 - op2);
            break;
          case '*':
            stack.push(op1 * op2);
            break;
          case '/':
            stack.push(op1 / op2);
            break;
        }
      } else
        stack.push(Double.parseDouble(symbols[i]));
    }
    return stack.pop();
  }

}
