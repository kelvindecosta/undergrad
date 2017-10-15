import java.util.*;

abstract class Shape {
	String color;
	boolean filled;

	Shape(String color, boolean fill) {
		this.color = color;
		this.filled = fill;
	}

	Shape() {
		this("red", true);
	}

	abstract double getArea();

	abstract double getPerimeter();

	public abstract String toString();

	public String getColor() {
		return color;
	}

	public void setColor(String c) {
		color = c;
	}

	public boolean isFilled() {
		return filled;
	}

	public void setFill(boolean f) {
		filled = f;
	}
}

class Circle extends Shape {
	double radius;

	public Circle(double radius, String color, boolean fill) {
		super(color, fill);
		this.radius = radius;
	}

	public Circle() {
		this(1, "red", true);
	}

	public double getArea() {
		return 3.14159 * radius * radius;
	}

	public double getPerimeter() {
		return 2 * 3.14159 * radius;
	}

	public String toString() {
		String shape = color + " colored ";
		if (!this.filled)
			shape += "un";
		shape += "filled circle of radius " + radius + "units.";
		return shape;
	}

	public double getRadius() {
		return radius;
	}

	public void setRadius(double r) {
		radius = r;
	}
}

class Rectangle extends Shape {
	double width;
	double length;

	public Rectangle(double len, double wid, String color, boolean fill) {
		super(color, fill);
		this.length = len;
		this.width = width;
	}

	public Rectangle() {
		this(1, 1, "red", true);
	}

	public double getArea() {
		return length * width;
	}

	public double getPerimeter() {
		return 2 * (length + width);
	}

	public String toString() {
		String shape = color + " colored ";
		if (!this.filled)
			shape += "un";
		shape += "filled rectangle of length " + length + " and width " + width + " units.";
		return shape;
	}

	public double getWidth() {
		return width;
	}

	public double getLength() {
		return length;
	}

	public void setWidth(double w) {
		width = w;
	}

	public void setLength(double l) {
		length = l;
	}
}

class Square extends Rectangle {
	double side;

	public Square(double side, String color, boolean fill) {
		super(side, side, color, fill);
	}

	public Square() {
		this(1, "red", true);
	}

	public String toString() {
		String shape = color + " colored ";
		if (!this.filled)
			shape += "un";
		shape += "filled square of side " + side + " units.";
		return shape;
	}

	public void setSide(double s) {
		side = s;
	}

	public double getSide() {
		return side;
	}
}

class Program {
	static ArrayList<Shape> shapes;

	public static void main(String args[]) {
		shapes = new ArrayList<Shape>();
		shapes.add(new Circle());
		shapes.add(new Rectangle());
		shapes.add(new Square());
		listShapes();
	}

	public static void listShapes() {
		if (shapes.isEmpty()) {
			System.out.println("There are no shapes in the collection!");
			return;
		}
		System.out.println("Shapes : ");

		for (int i = 0; i < shapes.size(); i++)
			System.out.println("[" + i + "] : " + shapes.get(i).toString());
	}
}
