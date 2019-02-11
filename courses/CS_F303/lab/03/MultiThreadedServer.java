import java.io.*;
import java.net.*;

// This program allows multiple clients to be connected to the server at a time
public class MultiThreadedServer implements Runnable {
	// Runnable Interface supports run() method

	Socket Toclient;

	public MultiThreadedServer(Socket client) {
		Toclient = client;
	}

	public void run() { // new Thread of server will start executing from run method
		// have the code for communication with client using respective connection
		// socket
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(Toclient.getInputStream()));
			PrintWriter writer = new PrintWriter(Toclient.getOutputStream());

			while (true) { // while loop for multiple time communication
				String ReadData = reader.readLine(); // read a line of data from client

				// Display the read data in server console
				System.out.println(ReadData);
				String modified = ReadData.toUpperCase();

				writer.println(modified);
				writer.flush();
			}
		} catch (Exception e) {
			System.out.println("Error");
		} // end of try-catch
	} // end of the run method()

	public static void main(String[] args) throws Exception {
		// open a welcome server socket and wait for connection from client
		// for every client who calls accept() method create a thread to serve him via
		// its connection socket

		ServerSocket welcomesocket = new ServerSocket(26969);
		while (true) {
			// wait for connnection from client
			Socket Connectionsocket = welcomesocket.accept();
			// create a Thread at server to serve every client via its connection socket
			MultiThreadedServer instance1 = new MultiThreadedServer(Connectionsocket);
			Thread ThreadForclient = new Thread(instance1);
			// above thread will look for run method within the class MultiThreadedServer
			ThreadForclient.start();
		}
	} // end of main
} // end of class
