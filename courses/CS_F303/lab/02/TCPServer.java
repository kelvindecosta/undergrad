import java.io.*;
import java.net.*;

public class TCPServer {
    public static void main(String[] args) {
        try {
            ServerSocket welcomeSocket = new ServerSocket(6969);
            // blocking call ; wait for incoming connection from client
            Socket connectionSocket = welcomeSocket.accept();

            // open input and output streams
            BufferedReader reader = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
            PrintWriter writer = new PrintWriter(connectionSocket.getOutputStream());

            String input = reader.readLine();
            System.out.println(input);
            writer.write(input.toUpperCase());

            writer.flush();
            welcomeSocket.close();
            connectionSocket.close();
            writer.close();
            reader.close();
        } catch (Exception e) {
            System.out.println(e);
            System.exit(1);
        }
    }
}