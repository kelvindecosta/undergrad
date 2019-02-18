import java.io.*;
import java.net.*;

public class HTTPUrlUsage {
    public static void main(String[] args) throws Exception {
        // String urlString =
        // "https://universe.bits-pilani.ac.in/Uploads/Campus/BITS_university_logo.gif";
        String urlString = "https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg";
        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        int responseCode = connection.getResponseCode();

        // always check HTTP response code first
        if (responseCode == HttpURLConnection.HTTP_OK) {
            String fileName = "";
            String disposition = connection.getHeaderField("Content-Disposition");
            String contentType = connection.getContentType();
            int contentLength = connection.getContentLength();

            if (disposition != null) {
                // extracts file name from header field
                int index = disposition.indexOf("filename=");
                if (index > 0) {
                    fileName = disposition.substring(index + 10, disposition.length() - 1);
                }
            } else {
                // extracts file name from URL
                fileName = urlString.substring(urlString.lastIndexOf("/") + 1, urlString.length());
            }

            System.out.println("Content-Type = " + contentType);
            System.out.println("Content-Disposition = " + disposition);
            System.out.println("Content-Length = " + contentLength);
            System.out.println("fileName = " + fileName);

            // opens input stream from the HTTP connection
            InputStream inputStream = connection.getInputStream();
            String saveFilePath = "." + File.separator + fileName;

            // opens an output stream to save into file
            FileOutputStream outputStream = new FileOutputStream(saveFilePath);

            int bytesRead = -1;
            byte[] buffer = new byte[4096];
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            outputStream.close();
            inputStream.close();

            System.out.println("File downloaded");
        } else {
            System.out.println("No file to download. Server replied HTTP code: " + responseCode);
        }
        connection.disconnect();
    }
}