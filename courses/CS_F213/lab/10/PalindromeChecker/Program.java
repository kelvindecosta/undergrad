import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.*;
import java.lang.*;

public class Program extends JFrame implements ActionListener {

  public static JLabel input;
  public static JLabel output;
  public static JButton run;
  public static JTextField inputText;
  public static JTextField outputText;
  public static JPanel panel;

  public static void main(String[] args) {
    Program palindrome = new Program();
  }

  public Program() {
    setTitle("Palindrome Checker");
    setSize(300, 200);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    setResizable(false);

    panel = new JPanel();

    input = new JLabel("INPUT ");

    inputText = new JTextField(20);
    inputText.setText("Enter a word!");
    inputText.requestFocus();

    output = new JLabel("OUTPUT");

    outputText = new JTextField(20);
    outputText.setEditable(false);

    run = new JButton("CHECK");
    run.addActionListener(this);

    panel.add(input);
    panel.add(inputText);
    panel.add(output);
    panel.add(outputText);
    panel.add(run);

    this.add(panel);
    this.setVisible(true);
  }

  public void actionPerformed(ActionEvent e) {
    String word = inputText.getText();
    if (word.equals(new StringBuilder(word).reverse().toString()))
      outputText.setText(word + " is a palindrome!");
    else
      outputText.setText(word + " is not a palindrome");
  }
}
