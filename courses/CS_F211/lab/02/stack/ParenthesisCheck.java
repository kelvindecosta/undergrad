package stack;

import java.util.*;
import java.io.*;

class ParenthesisCheck {
  public static boolean isClose(char test) {
    switch (test) {
      case ')':
      case '}':
      case ']':
      case '>':
        return true;
      default:
        return false;
    }
  }

  public static boolean isOpen(char test) {
    switch (test) {
      case '(':
      case '{':
      case '[':
      case '<':
        return true;
      default:
        return false;
    }
  }

  public static boolean isSame(char open, char close) {
    if (isOpen(open) && isClose(close)) {
      boolean check = false;
      if (open == '(' && close == ')')
        check = true;
      if (open == '{' && close == '}')
        check = true;
      if (open == '[' && close == ']')
        check = true;
      if (open == '<' && close == '>')
        check = true;
      return check;
    }
    return false;
  }

  public static void main(String args[]) {
    File file = new File(args[0]);
    MyStack stack = new MyStack(20);

    if (!file.exists()) {
      System.out.println(args[0] + " does not exist.");
      return;
    }
    try {
      FileInputStream fis = new FileInputStream(file);
      char current;
      while (fis.available() > 0) {
        current = (char) fis.read();

        if (isOpen(current))
          stack.push(current);

        if (isClose(current)) {
          char popped = stack.pop();
          if (popped == 0) {
            System.out.println("Encountered closing bracket " + current + " before open bracket!");
            return;
          } else if (!isSame(popped, current)) {
            System.out.println("Encountered mismatched pair of brackets (\'" + popped + "\',\'" + current + "\'");
            return;
          }
        }
      }
      if (stack.pop() == 0)
        System.out.println("Parenthesis check on file " + args[0] + " was succesful!");
      else
        System.out.println("Missing closing brackets!");
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}
