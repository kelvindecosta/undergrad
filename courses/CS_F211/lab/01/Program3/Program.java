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
		time -= System.currentTimeMillis();
		time *= -1;
		System.out.println("Executed in " + time + " ms");
	}

	public static void main(String[] args)
	{
		Scanner input = new Scanner(System.in);
		System.out.print("Enter the array size : ");
		int n = input.nextInt();
		int A[] = new int[n];

		System.out.println("Enter the array : ");
		for(int i = 0; i< n ; i++)
		{
			System.out.print("[" + i  + "] : ");
			A[i] = input.nextInt();
		}

		start();
		checkDuplicates(A, n);
		end();
	}

	public static void checkDuplicates(int[] A, int n)
	{
		Map<Integer, Integer>  map  = new HashMap<Integer, Integer>();
		for(int i = 0 ; i < n; i++)
			if( map.isEmpty())
				map.put(A[i], i);
			else if (map.get(A[i]) == null)
				map.put(A[i], i);
			else 
			{
				System.out.println("Array has duplicate " + A[i] + " at " + map.get(A[i]) + " and " + i);
				return;
			}
		System.out.println("Array has no duyplicates !");
	}
}
