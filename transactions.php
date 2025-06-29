<?php
require_once 'mysql.php';

$sql = "SELECT Account, Amount, DATE(Date) AS Date from transactions ORDER BY `Date`;";
$res = $mysqli->query( $sql );
$transactions = [];

while ( $r = $res->fetch_assoc() )
{
    $transactions[] = $r;
}

header('Content-Type: application/json');
echo json_encode(['data' => $transactions]);
?>