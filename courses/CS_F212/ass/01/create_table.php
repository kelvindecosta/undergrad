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

// sql to create table
$sql = "CREATE TABLE MyGuests (
ID INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
Fname VARCHAR(30) NOT NULL,
Lname VARCHAR(30) NOT NULL,
Address VARCHAR(30) NOT NULL,
Age INT UNSIGNED NOT NULL,
City VARCHAR(30) NOT NULL,
Mobile VARCHAR(20) NOT NULL
)";

if ($conn->query($sql) === TRUE) {
    echo "Table MyGuests created successfully";
} else {
    echo "Error creating table: " . $conn->error;
}

$conn->close();
