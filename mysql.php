<?php
global $mysqli;
try
{
	// подключаемся к серверу
	mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
	$mysqli = new mysqli("localhost", "root", "", "roman");
	// echo "Database connection established<br>";
	/* изменение набора символов на utf8mb4 */
	$mysqli->set_charset("utf8mb4");
}
catch (PDOException $e)
{
	echo "Connection failed: " . $e->getMessage();
}



function readData()
{
    global $mysqli;
    $sql = "SELECT * from transactions ORDER BY `Date`;";
    $res = $mysqli->query( $sql );
    $result = [];

    while ( $r = $res->fetch_assoc() )
    {
        $result[ $r['id'] ] = $r;
    }

    return $result ;
}
