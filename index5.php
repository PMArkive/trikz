<?php
	//Step1
	$db = mysqli_connect('localhost','root','','fakeexpert')
	or die('Error connecting to MySQL server.');
?>

<html>
<head>Trikz Timer</head>
<body>
	<h1>PHP connect to MySQL</h1>

	<?php
		//Step2
		$query = "SELECT * FROM records ORDER BY time";
		mysqli_query($db, $query) or die('Error querying database.');

		//Step3
		$result = mysqli_query($db, $query);
		$row = mysqli_fetch_array($result);

		while($row = mysqli_fetch_array($result))
		{
			$query2 = "SELECT username FROM users WHERE steamid = ".$row['playerid']."";
			mysqli_query($db, $query2) or die('Error querying in table.');
			$result2 = mysqli_query($db, $query2);
			$row2 = mysqli_fetch_array($result2);
			//echo $row2['username'] . ' ';
			//$row2 = mysqli_fetch_field($result2);
			//while ($row2 = mysqli_fetch_array($result2))
			{
				$query3 = "SELECT username FROM users WHERE steamid = ".$row['partnerid']."";
				mysqli_query($db, $query3) or die('Error querying in table.');
				$result3 = mysqli_query($db, $query3);
				$row3 = mysqli_fetch_array($result3);
				//echo $row3['username'] . ' ';
				//$row3 = mysqli_fetch_field($result3);
				//while($row3 = mysqli_fetch_array($result3))
				{
					//echo $row2['username'] . ' ' . $row3['username'] . ' ';
					//printf("%s %s" $row2, $row3);
					//printf("%s", mysqli_fetch_field($result2));
				}
			}
			
			//echo $row['id'] . ' ' . $row['playerid'] . ' ' . $row['partnerid'] . ' ' . $row['time'] . ' ' . $row['map'] . ' ' . $row['date'] . '<br />';
			$formatedDate = date("Y-m-d H:i:s", (int)$row['date']);
			//echo $row['time'] . ' ' . $row['map'] . ' ' . $row['date'] . '<br>'; //https://code-boxx.com/format-unix-timestamp-date-time-php/#:~:text=We%20can%20use%20the%20date%20function%20to%20format,date%20%28%22D%2C%20j%20F%20Y%20h%3Ai%3As%20A%22%2C%20%24UNIX%29%3B
			if(strlen($row2['username']) > 0 && strlen($row3['username']) > 0) //https://www.bing.com/search?q=%26%26+php&qs=n&form=QBRE&sp=-1&pq=%26%26+&sc=8-3&sk=&cvid=7A930573B6A242F29BE4D868A8ECA9DE
				echo $row2['username'] . ' ' . $row3['username'] . ' ' . $row['time'] . ' ' . $row['map'] . ' ' . $formatedDate . '<br>';
		}//https://github.com/egulias/EmailValidator/pull/228/commits/7694cc94bd1e0836051e5542963d08c7976637da
		//Step 4
		mysqli_close($db);
	?>

	</body>
</html>

//https://stackoverflow.com/questions/9494209/how-to-link-mysql-to-html
