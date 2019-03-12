import java.util.*;
import java.io.*;

class SymbolTable {
    ArrayList<String> table[];

    SymbolTable() {
        table = new ArrayList[6];
        for (int i = 0; i < table.length; i++) {
            table[i] = new ArrayList<String>();
        }
    }

    public int hash(String val) {
        int sum = 0;
        for (int i = 0; i < val.length(); i++) {
            if (Character.isLetter(val.charAt(i))) {
                sum += (int) val.charAt(i);
            } else if (Character.isDigit(val.charAt(i))) {
                sum += 2 * (int) val.charAt(i);
            }
        }

        return (sum * 17 + 5) % 6;
    }

    public void insert(String id) {
        table[hash(id)].add(id);
    }

    public void display() {
        System.out.println("Contents of Symbol Table");
        for (int i = 0; i < table.length; i++) {
            System.out.println("\tIndex " + i + ":");
            for (int j = 0; j < table[i].size(); j++) {
                System.out.println("\t\t" + table[i].get(j));
            }
            System.out.println("");
        }
    }

    public static void main(String[] args) {
        try {
            SymbolTable t = new SymbolTable();
            File file = new File(args[0]);
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String input;

            while ((input = reader.readLine()) != null) {
                t.insert(input);
            }

            reader.close();
            t.display();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
