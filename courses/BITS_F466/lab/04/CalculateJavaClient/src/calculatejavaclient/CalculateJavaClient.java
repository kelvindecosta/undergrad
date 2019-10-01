/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package calculatejavaclient;

import java.util.*;
import java.util.Scanner;
/**
 *
 * @author Admin
 */
public class CalculateJavaClient {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)
    {
        Scanner inp = new Scanner(System.in);
        System.out.println("Calculator\n\t[1] : Add\n\t[2] : Subtract\n\t[3] : Multiply\n\t[4] : Divide");
        int choose = inp.nextInt();
        
        System.out.print("\nOperands\n\t[1] : ");
        int num1 = inp.nextInt();
        System.out.print("\t[2] : ");
        int num2 = inp.nextInt();
        int ans;
        
        switch (choose){
        case 1:
            ans = add(num1, num2);
            break;
        case 2:
            ans = subtract(num1, num2);
            break;      
        case 3:
            ans = multiply(num1, num2);
            break;
        case 4:
            ans = divide(num1, num2);
            break;
        default:
            System.out.println("Illigal Operation");
            return ;
        }
        
        System.out.println("Answer : " + ans);
    }

    private static Integer add(java.lang.Integer operand1, java.lang.Integer operand2) {
        kelvin.org.soc.Calculate_Service service = new kelvin.org.soc.Calculate_Service();
        kelvin.org.soc.Calculate port = service.getCalculatePort();
        return port.add(operand1, operand2);
    }

    private static Integer divide(java.lang.Integer operand1, java.lang.Integer operand2) {
        kelvin.org.soc.Calculate_Service service = new kelvin.org.soc.Calculate_Service();
        kelvin.org.soc.Calculate port = service.getCalculatePort();
        return port.divide(operand1, operand2);
    }

    private static Integer multiply(java.lang.Integer operand1, java.lang.Integer operand2) {
        kelvin.org.soc.Calculate_Service service = new kelvin.org.soc.Calculate_Service();
        kelvin.org.soc.Calculate port = service.getCalculatePort();
        return port.multiply(operand1, operand2);
    }

    private static Integer subtract(java.lang.Integer operand1, java.lang.Integer operand2) {
        kelvin.org.soc.Calculate_Service service = new kelvin.org.soc.Calculate_Service();
        kelvin.org.soc.Calculate port = service.getCalculatePort();
        return port.subtract(operand1, operand2);
    }
    
}
