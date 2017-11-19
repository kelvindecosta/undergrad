import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.*;
import java.lang.*;

public class Program extends JFrame implements ActionListener {

  public static JLabel integer1;
  public static JLabel integer2;
  public static JLabel output;
  public static JTextField int1Text;
  public static JTextField int2Text;
  public static JTextArea outputText;
  public static JButton run;
  public static JPanel panel;

  public Program() {
    setTitle("Calculator");
    setSize(200, 400);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    setResizable(false);

    panel = new JPanel();

    integer1 = new JLabel("INTEGER 1 : ");
    integer2 = new JLabel("INTEGER 2 : ");
    int1Text = new JTextField(10);
    int2Text = new JTextField(10);

    output = new JLabel("OUTPUT : ");
    outputText = new JTextArea();

    run = new JButton("CALCULATE");
    run.addActionListener(this);

    panel.add(integer1);
    panel.add(int1Text);
    panel.add(integer2);
    panel.add(int2Text);

    panel.add(run);
    panel.add(output);
    panel.add(outputText);

    this.add(panel);
    this.setVisible(true);
  }

  public void actionPerformed(ActionEvent e) {
    int a = Integer.parseInt(int1Text.getText());
    int b = Integer.parseInt(int2Text.getText());
    outputText.setText("sum = " + (a + b) + "\ndiff = " + (a - b) + "\nprod = " + (a * b) + "\ndiv = " + (a / b));
  }

  public static void main(String args[]) {
    Program calc = new Program();
  }
}
