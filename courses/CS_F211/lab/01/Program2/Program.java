import java.util.*;

class Program
{
	static long time;
	public static void start()
	{
		time = System.currentTimeMillis(); 
	}

	public static void end()
	{
		time = System.currentTimeMillis() - time;
		System.out.println("Executed in " + time +" ms");
	}

	public static void main(String args[])
	{
		char[] A;
		Scanner input = new Scanner(System.in);
		System.out.print("Enter the character array : ");
		A = (input.nextLine()).toCharArray();
		int n = A.length;
		start();
		checkParenthesis(A, n);
		end();

	}

	public static void checkParenthesis(char[] A, int n)
	{
		
		int balance = 0;
		for(int i = 0; i < n; i++)
			if(A[i] == ')')
				balance++;
			else if(A[i] == '(')
				balance--;

		if(balance == 0)
			System.out.println("Equation is balanced.");
		else
			System.out.println("Equation is unbalanced.");
				
	}
}
