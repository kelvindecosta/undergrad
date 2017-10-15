package points;

class Point2D {
	private double x;
	private double y;

	public Point2D(double X, double Y) {
		x = X;
		y = Y;
	}

	public Point2D() {
		this(0, 0);
	}

	public double getX() {
		return x;
	}

	public void setX(double X) {
		x = X;
	}

	public double getY() {
		return y;
	}

	public void setY(double Y) {
		y = Y;
	}

	public String toString() {
		return "(" + x + ", " + y + ")";
	}
}
