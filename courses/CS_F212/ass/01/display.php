<!DOCTYPE html>
<html>

<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">

</head>

<body>
    <h1>Details</h1>
    <table class="table table-dark">
        <thead>
            <tr>
                <th>ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Address</th>
                <th>Age</th>
                <th>City</th>
                <th>Mobile</th>
            </tr>
        </thead>
        <tbody>
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

            $sql = "SELECT * FROM MyGuests";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {

                while ($row = $result->fetch_assoc()) {
            ?>
                    <tr>
                        <td>
                            <?php
                            echo $row["ID"];
                            ?>
                        </td>

                        <td>
                            <?php
                            echo $row["Fname"]
                            ?>
                        </td>

                        <td>
                            <?php
                            echo $row["Lname"]
                            ?>
                        </td>

                        <td>
                            <?php
                            echo $row["Address"]
                            ?>
                        </td>

                        <td>
                            <?php
                            echo $row["Age"]
                            ?>
                        </td>

                        <td>
                            <?php
                            echo $row["City"];
                            ?>
                        </td>

                        <td>
                            <?php
                            echo $row["Mobile"];
                            ?>
                        </td>
                    </tr>
            <?php
                }
            } else {
                echo "0 results";
            }

            $conn->close();
            ?>
        </tbody>
    </table>
</body>

</html>