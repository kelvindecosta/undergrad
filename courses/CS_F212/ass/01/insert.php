<!DOCTYPE html>
<html>

<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">

</head>
<body">
    <?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "f20160006db";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $sql = "INSERT INTO MyGuests 
(Fname, Lname, Address, Age, City, Mobile)
VALUES (
'" . $_POST["fname"] . "',
'" . $_POST["lname"] . "',
'" . $_POST["address"] . "',
" . $_POST["age"] . ",
'" . $_POST["city"] . "',
'" . $_POST["mobile"] . "'
)";

    if ($conn->query($sql) === TRUE) {
    ?>
        <p>New record created successfully</p>
    <?php
    } else {
    ?>
        <p>Error</p>
    <?php
    }

    $conn->close();
    ?>
    <a href="display.php" role="button" class="btn btn-primary">View Database</a>