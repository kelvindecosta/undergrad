package polynomial;

import java.util.*;

class PolynomialImplementation {
    public static Scanner input;
    public static Polynomial p1;
    public static Polynomial p2;

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
        p1 = new Polynomial(1);
        p2 = new Polynomial(2);

        int opt;
        do {
            clearScreen();
            System.out.println("Polynomial Operations");
            p1.print();
            p2.print();

            System.out.println("[1] : Edit Polynomials");
            System.out.println("[2] : Polynomial Addition");
            System.out.println("[3] : Polynomial Subtraction");
            System.out.println("[0] : Exit");
            System.out.print("Option : ");
            opt = input.nextInt();
            input.nextLine();
            pak();
            clearScreen();

            switch (opt) {
                case 1:
                    editPolynomials();
                    break;
                case 2:
                    System.out.println("Polynomial Addition");
                    p1.addition(p2).print();
                    pak();
                    break;
                case 3:
                    System.out.println("Polynomail Subtraction");
                    p1.subtraction(p2).print();
                    pak();
                    break;
                case 0:
                    break;
                default:
                    System.out.println("Invalid Option!");
            }
        } while (opt != 0);
    }

    public static void editPolynomials() {

        int opt;
        do {
            clearScreen();
            System.out.println("Edit Polynomials");
            p1.print();
            p2.print();
            System.out.println("[1] : Add term to P1(x)");
            System.out.println("[2] : Add term to P2(x)");
            System.out.println("[0] : Return to Main Menu");
            System.out.print("Option : ");
            opt = input.nextInt();
            input.nextLine();

            switch (opt) {
                case 1:
                case 2:
                    System.out.println("Enter coefficient and degree of term : ");
                    System.out.print("Coefficient : ");
                    int coeff = input.nextInt();
                    input.nextLine();
                    System.out.print("Degree : ");
                    int degree = input.nextInt();
                    input.nextLine();
                    if (opt == 1)
                        p1.add(coeff, degree);
                    else
                        p2.add(coeff, degree);
                    break;
                case 0:
                    break;
            }
            pak();
        } while (opt != 0);
    }
}
