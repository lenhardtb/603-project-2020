<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Home Page</title>

<link rel="stylesheet" href="covidProjectCSS.css">

</head>

<body>

<h2>Welcome to Our Homepage</h2>
<h3> Please click on a state to learn more about their COVID-19 regulations. </h3>

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
    

    $sql = "SELECT name, masks, distancing, temps, sanitation, details FROM areas INNER JOIN states ON areas.ID = states.areaID ORDER BY name";
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

            if($columns[$i] == "name")
            {
                echo "<a href='/regulations.php?state=".$row["name"]."'>";
        
            }


            if(is_null($row[$columns[$i]]))
            {
                echo "[No Data]";
            }
            else
            {
               echo $row[$columns[$i]];
            }

            if($columns[$i] == "name")
            {
                echo "</a>";
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