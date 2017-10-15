package points;

class Point3D extends Point2D {
	private double z;

	public Point3D(double X, double Y, double Z) {
		super(X, Y);
		z = Z;
	}

	public Point3D() {
		this(0, 0, 0);
	}

	public double getZ() {
		return z;
	}

	public void setZ(double Z) {
		z = Z;
	}

	@Override
	public String toString() {
		return "(" + this.getX() + ", " + this.getY() + ", " + z + ")";
	}
}
