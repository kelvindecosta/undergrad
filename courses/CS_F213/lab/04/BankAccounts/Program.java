import java.util.*;

class Program {
	public static void main(String args[]) {
		Bank bank = new Bank();
		clearScreen();
		System.out.println("BANK OF KELVINOPOLIS v1.3.3.7");
		System.out.print("Enter the starting number of accounts : ");
		int num = bank.input.nextInt();

		for (int i = 0; i < num; i++) {
			bank.addAccount();
			clearScreen();
		}

		int opt;
		do {
			System.out.println("BANK OF KELVINOPOLIS v1.3.3.7");
			System.out.println("Choose the following options : ");
			System.out.println("[1] : Add a new account");
			System.out.println("[2] : Search & Display an account's details");
			System.out.println("[3] : Withrdawal on an account");
			System.out.println("[4] : Deposit into an accout");
			System.out.println("[5] : Exit menu");
			System.out.print("\nCurrent option : ");
			opt = bank.input.nextInt();

			switch (opt) {
				case 1:
					bank.addAccount();
					break;
				case 2:
					bank.displayAccount();
					break;
				case 3:
					bank.withdrawFromAccount();
					break;
				case 4:
					bank.depositIntoAccount();
					break;
				default:
					opt = 5;
			}

			System.out.println("Press ENTER to continue!");
			bank.input.nextLine();
			clearScreen();

		} while (opt != 5);
		System.out.println("Thanks - Rick Sanchez , C-137");
	}

	public static void clearScreen() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
	}

}

class Bank {
	ArrayList<BankAccount> accounts;
	Scanner input;

	Bank() {
		accounts = new ArrayList<BankAccount>();
		input = new Scanner(System.in);
	}

	public void addAccount() {
		System.out.println("New Account Details : ");
		long id = accounts.size() + 1;
		System.out.println("ID : " + id);

		System.out.print("NAME : ");
		input.nextLine();
		String name = input.nextLine();

		System.out.print("ADDRESS : ");
		String address = input.nextLine();

		double balance;
		while (true) {
			System.out.print("BALANCE : ");
			balance = input.nextDouble();
			if (balance >= 0)
				break;
			System.out.println("Please enter a valid amount!");
		}
		BankAccount b = new BankAccount(id, name, address, balance);
		this.accounts.add(b);
		System.out.println();
		input.nextLine();
	}

	public void message(int opt) {
		if (opt != -1)
			System.out.println("Account with ID : " + (opt + 1) + " found!");
		else
			System.out.println("Account not in records!");
	}

	public int searchAccount() {
		System.out.println("Searching Existing Accounts : ");
		System.out.print("ID : ");
		long testId = input.nextLong();
		int index = -1;

		if (testId > this.accounts.size())
			return index;

		Iterator check = this.accounts.iterator();
		while (check.hasNext()) {
			BankAccount test = (BankAccount) check.next();
			if (test.id == testId) {
				index = this.accounts.indexOf(test);
				break;
			}
		}

		return index;
	}

	public void displayAccount() {
		int index = searchAccount();
		message(index);
		if (index == -1) {
			input.nextLine();
			return;
		}

		this.accounts.get(index).display();
		input.nextLine();
	}

	public void withdrawFromAccount() {
		int index = searchAccount();
		message(index);
		if (index == -1)
			return;
		this.accounts.get(index).withdraw(input);
		input.nextLine();
	}

	public void depositIntoAccount() {
		int index = searchAccount();
		message(index);
		if (index == -1)
			return;
		this.accounts.get(index).deposit(input);
		input.nextLine();
	}
}

class BankAccount {
	long id;
	String name;
	String address;
	double balance;

	BankAccount(long id, String name, String address, double balance) {
		this.id = id;
		this.name = name;
		this.address = address;
		this.balance = balance;
	}

	public void display() {
		System.out.println("Account Details : ");
		System.out.println("ID      : " + this.id);
		System.out.println("NAME    : " + this.name);
		System.out.println("ADDRESS : " + this.address);
		System.out.println("BALANCE : " + "AED " + this.balance);
		System.out.println();
	}

	public void withdraw(Scanner input) {
		this.display();
		System.out.println("Withdrawal : ");
		double withdrawal;
		while (true) {
			System.out.print("Amount to be withdrawn : ");
			withdrawal = input.nextDouble();
			if (withdrawal >= 0)
				break;
			System.out.println("Invalid Amount!");
		}

		if (this.balance - withdrawal < 100) {
			System.out.println("Insufficient Balance!");
			return;
		} else {
			System.out.println("Withdrwal Successful!");
			System.out.println("Previous BALANCE : " + this.balance);
			this.balance -= withdrawal;
			System.out.println("Current BALANCE  : " + this.balance);
		}
		System.out.println();
	}

	public void deposit(Scanner input) {
		this.display();
		System.out.println("Deposit : ");
		double deposit;
		while (true) {
			System.out.print("Amount to be depositted : ");
			deposit = input.nextDouble();
			if (deposit >= 0)
				break;
			System.out.println("Invalid Amount!");
		}

		System.out.println("Deposit Successful!");
		System.out.println("Previous BALANCE : " + this.balance);
		this.balance += deposit;
		System.out.println("Current BALANCE  : " + this.balance);
	}
}
