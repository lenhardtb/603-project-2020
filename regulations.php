<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Home Page</title>

<link rel="stylesheet" href="covidProjectCSS.css">

</head>

<body>

<h2>Details in this state:</h2>

<?php

    
    $servername = "localhost";
    $username = "public";
    $password = "password";
    $dbname = "covid_regulations";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn -> connect_error) 
    {
        die("Connection failed: " . $conn->connect_error);
    }
    
    echo "The state is: ".$_GET['state'];
    $sql = "SELECT name, masks, distancing, temps, sanitation, details FROM areas INNER JOIN states ON areas.ID = states.areaID WHERE name=\"".$_GET['state']."\"";
    $result = $conn->query($sql);
    
    echo "<br>";
    if ($result->num_rows > 0) 
    {
      // output data of each row
      echo "<table> <tr> <th>State</th><th>Masks</th><th>6ft. Distance</th><th>Temp Checks</th><th>Sanitation Measures</th><th>Details</th></tr>";
      while($row = $result->fetch_assoc()) 
      {
        echo "<tr>";

        $columns = array("name", "masks", "distancing", "temps", "sanitation", "details");
        
        for($i = 0; $i < 6; $i++)
        {
            echo "<td>";
            if(is_null($row[$columns[$i]]))
            {
                echo "[No Data]";
            }
            else
            {
               echo $row[$columns[$i]];
            }
            echo "</td>";
        }
        echo "</tr>";
      }
      echo "</table>";
    } 
    else 
    {
      echo "No results";
    }

    $conn ->close();

    ?>
</body>
</html>