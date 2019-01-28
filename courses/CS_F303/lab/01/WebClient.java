import java.io.*;
import java.net.*;

public class WebClient {

    public static void main(String[] args) {
        // since exceptions are thrown
        try {
            // server url
            String host = "kelvindecosta.com";
            int port = 80; // address of web server
            Socket client = new Socket(host, port);
            // connection between client and server sockets established

            // print writer to send
            PrintWriter writer = new PrintWriter(client.getOutputStream(), true);

            // buffered reader to receive response
            BufferedReader reader = new BufferedReader(new InputStreamReader(client.getInputStream()));

            writer.println("Get / HTTP/1.1"); // 1st
            writer.println("Host: " + host); // 2nd
            writer.println(); // blank

            String input;
            while ((input = reader.readLine()) != null) {
                System.out.println(input);
            }

            writer.close();
            reader.close();
            client.close();
        } catch (Exception e) {
            System.out.println("Error");
        }

        System.exit(1);

    }
}