<!DOCTYPE html>
<html>

<head>
	<title>New Record</title>
	<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
</head>

<body>
	<form action="insert.php" method="post">
		<div class="form-group col-md-5">
			<label for="fname">First Name</label>
			<input type="text" name="fname" class="form-control" id="fname" placeholder="Kelvin">
		</div>

		<div class="form-group col-md-5">
			<label for="lname">Last Name</label>
			<input type="text" name="lname" class="form-control" id="lname" placeholder="DeCosta">
		</div>

		<div class="form-group col-md-5">
			<label for="address">Address</label>
			<input type="text" name="address" class="form-control" id="address" placeholder="BITS Pilani">
		</div>

		<div class="form-group col-md-5">
			<label for="age">Age</label>
			<input type="number" name="age" class="form-control" id="age">
		</div>

		<div class="form-group col-md-5">
			<label for="city">City</label>
			<input type="text" name="city" class="form-control" id="city" placeholder="Dubai">
		</div>

		<div class="form-group col-md-5">
			<label for="mobile">Mobile</label>
			<input type="text" name="mobile" class="form-control" id="mobile" placeholder="0525061180">
		</div>
		<button type="submit" class="btn btn-primary">Create</button>
	</form>

	<script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>

	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
</body>

</html>