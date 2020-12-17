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
    function generateRow($row, $columns)
    {
        echo "<tr>";

        
        for($i = 0; $i < count($columns); $i++)
        {
            $val = $row[$columns[$i]];
            echo "<td>";
            if(is_null($val))
            {
                echo "[No Data]";
            }
            else if($val == "1")
            {
                echo "<img src=\"checkImage.jpg\" class=\"checkImage\"/>";
            }
            else if($val == "0")
            {
                echo "<img src=\"crossImage.jpg\" class=\"crossImage\"/>";
            }
            else
            {
               echo "".$val;
            }
            echo "</td>";
        }
        echo "</tr>";
    }
    
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
          $stateID = $row["ID"];
        
          $columns = array("name", "masks", "distancing", "temps", "sanitation", "details");
        
          generateRow($row, $columns);
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