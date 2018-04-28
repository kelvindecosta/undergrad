import java.util.Random;
import java.util.ArrayList;

class Details {
	// Current Length = 500
	static String namesString = "Lucille Marya Synthia Jackqueline Felton Jesus Janel Caprice Kimberely Lorinda Monty Solomon Reyna "
			+ "Jackelyn Cheree Keely Melinda Casie Naoma Theola Eleanore Malena Jolyn Efren Cesar Dahlia Leonie Towanda Bobbie "
			+ "Shemeka Berniece Pamila Isaiah Malka Thelma Dalene Ignacio Paula Buck Ena Lashonda Valrie Juanita Lora Loni "
			+ "Florencio Coy Soila Lora Ardelia Silvia Chadwick Katlyn Valery Hue Marilyn Charleen Dinah Jeni Leeann Jaime "
			+ "Berneice Modesta America Anja Conchita Billye Anissa Elvia Rikki Nikki Florinda Katina Carolyn Laurene Scotty "
			+ "Aletha Toya Asia Genevie Thora Leanna Russel Eliz Lashaunda Lela Leticia Adam Hilary Herman Artie Columbus Mathilda "
			+ "Kyra Taren Dreama Roni Eloise Angela Shante Paulina Dorthy Fabian Lani Cinda Missy Nikole Tai Cheryll Maranda Dean "
			+ "Vada Rachelle Yu Cheri Wilmer Eulah Judson Wynell Alejandrina Numbers Kimberely Danna Tanja Paris Rikki Shakia Emma "
			+ "Many Judith Caprice Kari Chrystal Marti Rosella Shanika Velva Dania Florence Zackary Jacque Hye Margarite Svetlana "
			+ "Oma Janetta Guy Joe Gidget Zaida Jere Andreas Alva Dara Temple Sibyl Norene Meri Lizeth Alexander Ezequiel Jenine "
			+ "Randolph Fanny Carola Ladonna Sandi Shaunte Abe Kacy Amalia Ilene Shakia Ivan Carma Elton Zonia Flo Cira Ron Marine "
			+ "Mao Hildegarde Elvira Lissa Terry Camellia Mary Agripina Emanuel Derek Tanna Gerri Carri Roger Racquel Emory Lynsey "
			+ "Andres Belle Lauralee Zuk Susie Ivery Karlyn Reaves Romana Kummer Graham Pierce Fermina Stonge Brant Treloar Sal Lucky "
			+ "Lasonya Cedano Ellen Bickerstaff Sherell Weiss Delmy Ferrante Faye Dorn Melida Waldrep Lory Pavao Jacquetta Bono Claretta "
			+ "Motter Aileen Pickle Bobbie Rendon Iraida Miguel Garfield Lease Juliet Coachman Tiara Mcneeley Selma Swoboda Shawnee "
			+ "Haines Lincoln Folse Collin Tomasello Clayton Hansen Ariane Trevizo Cori Mcnees Susy Singleterry Bette Corter Carroll "
			+ "Nellum Twyla Reinhart Helena Owen Kym Shilling Damon Hartig Kristan Zacarias Rocco Hagemann Aaron Trunzo Dorian Keffer "
			+ "Oma Abbot Toney Papageorge Ramonita Meier Leonia Sheroan Roselia Pentecost Anh Godlewski Trang Auston Beverlee Syring "
			+ "Palma Loiacono Lovella Mcclaran Felica Garoutte Rosena Dynes Larita Cleaver Samella Turcios Wonda Wilkin Raleigh Kimrey "
			+ "Inell Colmenero Marylyn Temblador Kai Kincheloe Latesha Belnap Felipe Vosburgh Hortencia Levier Concepcion Freels Iris "
			+ "Ingerson Linn Tardugno Vania Kea Ozella Nordby Fanny Venturini Lashaun Lemmond Les Sonnier Kathryn Serfass Eusebio Leitch "
			+ "Von Dostie Etta Gesell Armanda Lowther Hyun Qualey Bo Slaubaugh Malcolm Scicchitano Mathew Remmers Lynell Cothern Ewa Koen "
			+ "Bianca Blackwelder Domenica Oliphant Retha Seller Hong Chinn Morton Lesser Ida Fouche Priscila Zwick Ryann Fair Edda "
			+ "Perillo Giovanna Malcolm Jenee Caple Theola Garrison Vesta Astorga Necole Provenza Gene Kyer Sol Boynton Elinor Stauffer "
			+ "Hillary Arruda Aura Fenstermaker Sal Shelman Rosalina Berta Margaretta Widner Jerrie Klee Linwood Stryker Nikole Makris "
			+ "Sherman Slusher Nancie Herod Kasie Mascarenas Sarah Conwell Richard Woodrow Retta Lehrer Thomas Fajardo Anh Mastropietro "
			+ "Elenor Ton Vikki Done Jeanetta Province Brunilda Verdugo Cordie Zito Garland Leboeuf Charlena Pearsall Katina Walraven "
			+ "Christene Swope Jolyn Loza Agripina Bowie Miss Dworkin Alix Quinn Orpha Flansburg Eleonore Vanostrand Eladia Segovia "
			+ "Ethan Bunger Chi Bak Lula Winnett Donald Tinkler Brittany Casper Terese Peer Lashay Massi Rolande Gonsalves Tashina Kline "
			+ "Lizabeth Darst Afton Alkire Kerri Griffith Latina Redfern Hortencia Merrigan Norene Pullin Shyla Mcconkey Chan Mckinny "
			+ "Russel Marsico Briana Crandell";

	public String generateMobileNumber() {
		String s = "";
		String code[] = { "050", "055", "058" };
		Random rand = new Random();
		int i = new Random().nextInt(code.length);
		s += code[i];
		for (i = 0; i < 7; i++) {
			int randomNum = rand.nextInt((9 - 0) + 1) + 0;
			s += randomNum;
		}
		return s;
	}

	public String generateBDate() {
		String s = "";
		Random rand = new Random();
		int year = rand.nextInt((2018 - 1900) + 1) + 1900;
		int month = rand.nextInt((12 - 1) + 1) + 1;
		int day;
		if (month <= 7) {
			if (month == 2)
				day = rand.nextInt((28 - 1) + 1) + 1;
			else if (month % 2 != 0)
				day = rand.nextInt((31 - 1) + 1) + 1;
			else
				day = rand.nextInt((30 - 1) + 1) + 1;
		} else {
			if (month % 2 == 0)
				day = rand.nextInt((31 - 1) + 1) + 1;
			else
				day = rand.nextInt((30 - 1) + 1) + 1;
		}
		s += year + "-" + month + "-" + day;
		return s;
	}
}

class CustomerDetails extends Details {

	int numOfQueries = 100;
	String names[] = Details.namesString.split(" ");
	ArrayList<Integer> custID = new ArrayList<Integer>();
	ArrayList<String> fName = new ArrayList<String>();
	ArrayList<String> lName = new ArrayList<String>();
	ArrayList<String> bDate = new ArrayList<String>();
	ArrayList<String> mobNo = new ArrayList<String>();
	ArrayList<String> email = new ArrayList<String>();

	CustomerDetails() {
		// Customer ID
		for (int i = 0; i < numOfQueries; i++)
			custID.add(i + 1);

		// First Name
		for (int i = 0; i < numOfQueries; i++) {
			int index = new Random().nextInt(names.length);
			fName.add(names[index]);
		}

		// Last Name
		for (int i = 0; i < numOfQueries; i++) {
			int index;
			do {
				index = new Random().nextInt(names.length);
			} while (names[index] == fName.get(i)); // To avoid cases like David David as the name which may happen
			lName.add(names[index]);
		}

		// Mobile number
		for (int i = 0; i < numOfQueries; i++)
			mobNo.add(generateMobileNumber());

		// Email
		for (int i = 0; i < numOfQueries; i++)
			email.add(generateEmailAddress(fName.get(i), lName.get(i)));

		// Birthday
		for (int i = 0; i < numOfQueries; i++)
			bDate.add(generateBDate());
	}

	public void generateCustomerDetails() {
		for (int i = 0; i < numOfQueries; i++) {
			String s = "INSERT INTO CustomerDetails(custID,fName,lName,bDate,mobNo,email) VALUES(";
			s += custID.get(i) + ",\"" + fName.get(i) + "\",\"" + lName.get(i) + "\",'" + bDate.get(i) + "','"
					+ mobNo.get(i) + "',\"" + email.get(i) + "\");";
			System.out.println(s);
		}
		System.out.println();
	}

	public String generateEmailAddress(String fName, String lName) {
		String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_abcdefghijklmnopqrstuvwxyz";
		StringBuilder salt = new StringBuilder();
		Random rnd = new Random();
		while (salt.length() < 4) { // length of the random string.
			int index = (int) (rnd.nextFloat() * SALTCHARS.length());
			salt.append(SALTCHARS.charAt(index));
		}
		String saltStr = fName + salt.toString() + lName;
		String domain[] = { "@gmail.com", "@yahoo.com", "@hotmail.com", "@outlook.com" };
		int i = new Random().nextInt(domain.length);
		saltStr += domain[i];
		return saltStr;
	}

}

class EmployeeDetails extends Details {

	int numOfQueries = 100;
	String names[] = Details.namesString.split(" ");
	ArrayList<Integer> eID = new ArrayList<Integer>();
	ArrayList<String> fName = new ArrayList<String>();
	ArrayList<String> lName = new ArrayList<String>();
	ArrayList<String> bDate = new ArrayList<String>();
	ArrayList<String> mobNo = new ArrayList<String>();

	EmployeeDetails() {
		// Employee ID
		for (int i = 0; i < numOfQueries; i++)
			eID.add(i + 1);

		// First Name
		for (int i = 0; i < numOfQueries; i++) {
			int index = new Random().nextInt(names.length);
			fName.add(names[index]);
		}

		// Last Name
		for (int i = 0; i < numOfQueries; i++) {
			int index;
			do {
				index = new Random().nextInt(names.length);
			} while (names[index] == fName.get(i)); // To avoid cases like David David as the name which may happen
			lName.add(names[index]);
		}

		// Mobile number
		for (int i = 0; i < numOfQueries; i++)
			mobNo.add(generateMobileNumber());

		// Birthday
		for (int i = 0; i < numOfQueries; i++)
			bDate.add(generateBDate());
	}

	public void generateEmployeeDetails() {
		for (int i = 0; i < numOfQueries; i++) {
			String s = "INSERT INTO EmployeeDetails(eID,fName,lName,bDate,mobNo) VALUES(";
			s += eID.get(i) + ",\"" + fName.get(i) + "\",\"" + lName.get(i) + "\",'" + bDate.get(i) + "','"
					+ mobNo.get(i) + "');";
			System.out.println(s);
		}
		System.out.println();
	}

}

class RoomDetails {

	int floors = 50;
	int rooms = 20;
	int numOfQueries = floors * rooms;
	ArrayList<String> roomNos = new ArrayList<String>();
	ArrayList<String> type = new ArrayList<String>();

	RoomDetails() {
		// Room numbers
		for (int i = 1; i <= floors; i++) {
			for (int j = 1; j <= rooms; j++) {
				String s = "";
				if (i < 10)
					s += "0";
				s += i;
				if (j < 10)
					s += "0";
				s += j;
				roomNos.add(s);
			}
		}

		// Room types
		for (int i = 0; i < numOfQueries; i++) {
			String roomType[] = { "Single", "Double" };
			int index = new Random().nextInt(roomType.length);
			type.add(roomType[index]);
		}
	}

	public void generateRoomDetails() {
		for (int i = 0; i < numOfQueries; i++) {
			String s = "INSERT INTO RoomDetails(roomNo,type) VALUES('";
			s += roomNos.get(i) + "','" + type.get(i) + "');";
			System.out.println(s);
		}
		System.out.println();
	}
}

class CheckDetails {

	ArrayList<String> roomNos = new ArrayList<String>();
	ArrayList<Integer> custID = new ArrayList<Integer>();

	CheckDetails(ArrayList<Integer> custID, ArrayList<String> roomNos, int numOfQueries) {
		if (numOfQueries > custID.size() || numOfQueries > roomNos.size()) // This is an error
			return;

		Random rand = new Random();
		// Room numbers
		for (int i = 0; i < numOfQueries; i++) {
			boolean flag;
			int index;
			do {
				flag = false;
				index = rand.nextInt(roomNos.size());
				for (String roomNo : this.roomNos)
					if (roomNo.compareToIgnoreCase(roomNos.get(index)) == 0)
						flag = true;
			} while (flag);
			this.roomNos.add(roomNos.get(index));
		}

		// Customer ID
		for (int i = 0; i < numOfQueries; i++) {
			boolean flag;
			int index;
			do {
				flag = false;
				index = rand.nextInt(custID.size());
				for (int id : this.custID)
					if (id == custID.get(index))
						flag = true;
			} while (flag);
			this.custID.add(custID.get(index));
		}
	}

	public String generateCheckDate() {
		String s = "";
		Random rand = new Random();
		int year = rand.nextInt((2018 - 2005) + 1) + 2005;
		int month = rand.nextInt((12 - 1) + 1) + 1;
		int day;
		if (month <= 7) {
			if (month == 2)
				day = rand.nextInt((28 - 1) + 1) + 1;
			else if (month % 2 != 0)
				day = rand.nextInt((31 - 1) + 1) + 1;
			else
				day = rand.nextInt((30 - 1) + 1) + 1;
		} else {
			if (month % 2 == 0)
				day = rand.nextInt((31 - 1) + 1) + 1;
			else
				day = rand.nextInt((30 - 1) + 1) + 1;
		}
		int hour = rand.nextInt((23 - 0) + 0) + 0;
		int min = rand.nextInt((59 - 0) + 0) + 0;
		int sec = rand.nextInt((59 - 0) + 0) + 0;

		String years, months, days, hours, mins, secs;
		years = "" + year;
		months = days = hours = mins = secs = "";

		if (month < 10)
			months = "0" + month;
		else
			months += month;
		if (day < 10)
			days = "0" + day;
		else
			days += day;
		if (hour < 10)
			hours = "0" + hour;
		else
			hours += hour;
		if (min < 10)
			mins = "0" + min;
		else
			mins += min;
		if (sec < 10)
			secs = "0" + sec;
		else
			secs += sec;

		s += years + "-" + months + "-" + days + " " + hours + ":" + mins + ":" + secs;
		return s;
	}

}

class CheckIn extends CheckDetails {

	static int numOfQueries = 80;
	ArrayList<String> inDate = new ArrayList<String>();

	CheckIn(ArrayList<Integer> custID, ArrayList<String> roomNos) {
		super(custID, roomNos, numOfQueries);

		if (numOfQueries > custID.size())
			return;

		// inDate
		for (int i = 0; i < numOfQueries; i++)
			inDate.add(generateCheckDate());
	}

	public void generateCheckIn() {
		if (numOfQueries > custID.size())
			return;

		for (int i = 0; i < numOfQueries; i++) {
			String s = "INSERT INTO CheckIn(custID,roomNo,inDate) VALUES(";
			s += custID.get(i) + ",'" + roomNos.get(i) + "','" + inDate.get(i) + "');";
			System.out.println(s);
		}
		System.out.println();
	}

}

class CheckOut extends CheckDetails {

	static int numOfQueries = 50;
	ArrayList<String> outDate = new ArrayList<String>();

	CheckOut(ArrayList<Integer> custID, ArrayList<String> roomNos, ArrayList<String> inDate) {
		super(custID, roomNos, numOfQueries);

		if (numOfQueries > custID.size())
			return;

		// outDate
		for (int i = 0; i < numOfQueries; i++) {
			int index = 0;
			for (int j = 0; j < custID.size(); j++)
				if (custID.get(j) == this.custID.get(i))
					index = j;
			String s;
			do {
				s = generateCheckDate();
			} while (s.compareToIgnoreCase(inDate.get(index)) < 0);
			outDate.add(s);
		}
	}

	public void generateCheckOut() {
		if (numOfQueries > custID.size())
			return;

		for (int i = 0; i < numOfQueries; i++) {
			String s = "INSERT INTO CheckOut(custID,roomNo,outDate) VALUES(";
			s += custID.get(i) + ",'" + roomNos.get(i) + "','" + outDate.get(i) + "');";
			System.out.println(s);
		}
		System.out.println();
	}
}

class Department {

	String dID[];
	String dName[];

	Department() {
		String departmentID = "CTR ADM CS EVT";
		String departmentName = "Catering Administration Information_Technology Events";
		dID = departmentID.split(" ");
		dName = departmentName.split(" ");
	}

	public void generateDepartment() {
		for (int i = 0; i < dID.length; i++) {
			String s = "INSERT INTO Department(dID,dName) VALUES(\"";
			s += dID[i] + "\",\"" + dName[i] + "\");";
			System.out.println(s);
		}
		System.out.println();
	}
}

class DepartmentDetails {

	int numOfQueries = 50;
	String dID[];
	String posts[][];
	ArrayList<Integer> depIndex = new ArrayList<Integer>();
	ArrayList<String> depID = new ArrayList<String>();
	ArrayList<Integer> eID = new ArrayList<Integer>();
	ArrayList<String> empPost = new ArrayList<String>();
	ArrayList<String> joinDate = new ArrayList<String>();
	ArrayList<Integer> salary = new ArrayList<Integer>();

	DepartmentDetails(String dID[], ArrayList<Integer> eID) {
		Random rand = new Random();

		// dID
		this.dID = new String[dID.length];
		for (int i = 0; i < dID.length; i++)
			this.dID[i] = dID[i];

		// Post
		posts = new String[dID.length][];
		posts[0] = new String[] { "Cook", "Waiter" };
		posts[1] = new String[] { "Accountant", "Receptionist" };
		posts[2] = new String[] { "Software Engineer", "Data Analyst" };
		posts[3] = new String[] { "Photographer", "Videographer" };

		// depID
		for (int i = 0; i < numOfQueries; i++) {
			int index = new Random().nextInt(dID.length);
			depID.add(dID[index]);
			depIndex.add(index);
		}

		// eID
		for (int i = 0; i < numOfQueries; i++) {
			boolean flag;
			int index;
			do {
				flag = false;
				index = rand.nextInt(eID.size());
				for (int id : this.eID)
					if (id == eID.get(index))
						flag = true;
			} while (flag);
			this.eID.add(eID.get(index));
		}

		// empPost
		for (int i = 0; i < numOfQueries; i++) {
			int index1 = depIndex.get(i);
			int index2 = new Random().nextInt(posts[index1].length);
			empPost.add(posts[index1][index2]);
		}

		// joinDate
		for (int i = 0; i < numOfQueries; i++)
			joinDate.add(generateJoinDate());

		// Salary
		for (int i = 0; i < numOfQueries; i++) {
			int sal = rand.nextInt((100000 - 2000) + 1) + 2000;
			salary.add(sal);
		}
	}

	public String generateJoinDate() {
		String s = "";
		Random rand = new Random();
		int year = rand.nextInt((2018 - 2000) + 1) + 2000;
		int month = rand.nextInt((12 - 1) + 1) + 1;
		int day;
		if (month <= 7) {
			if (month == 2)
				day = rand.nextInt((28 - 1) + 1) + 1;
			else if (month % 2 != 0)
				day = rand.nextInt((31 - 1) + 1) + 1;
			else
				day = rand.nextInt((30 - 1) + 1) + 1;
		} else {
			if (month % 2 == 0)
				day = rand.nextInt((31 - 1) + 1) + 1;
			else
				day = rand.nextInt((30 - 1) + 1) + 1;
		}
		s += year + "-" + month + "-" + day;
		return s;
	}

	public void generateDepartmentDetails() {
		for (int i = 0; i < numOfQueries; i++) {
			String s = "INSERT INTO DepartmentDetails(dID,eID,post,joinDate,salary) VALUES(\"";
			s += depID.get(i) + "\"," + eID.get(i) + ",\"" + empPost.get(i) + "\",'" + joinDate.get(i) + "',"
					+ salary.get(i) + ");";
			System.out.println(s);
		}
		System.out.println();
	}
}

public class Program {

	public static void main(String[] args) {
		CustomerDetails custDetails = new CustomerDetails();
		EmployeeDetails empDetails = new EmployeeDetails();
		RoomDetails roomDetails = new RoomDetails();
		Department department = new Department();
		DepartmentDetails departmentDetails = new DepartmentDetails(department.dID, empDetails.eID);
		CheckIn checkIn = new CheckIn(custDetails.custID, roomDetails.roomNos);
		CheckOut checkOut = new CheckOut(checkIn.custID, roomDetails.roomNos, checkIn.inDate);
		custDetails.generateCustomerDetails();
		empDetails.generateEmployeeDetails();
		roomDetails.generateRoomDetails();
		checkIn.generateCheckIn();
		checkOut.generateCheckOut();
		department.generateDepartment();
		departmentDetails.generateDepartmentDetails();
	}

}
