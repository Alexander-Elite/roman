<?php

// ensure DataTables.php was included
// this file must not be included when installed using composer
if (!defined('DATATABLES')) {
	exit(1);
}

// Enable error reporting for debugging (remove for production)
error_reporting(\E_ALL);
ini_set('display_errors', '1');

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Database user / pass
 */
$sql_details = [
	'type' => 'Mysql',     // Database type: "Mysql", "Postgres", "Sqlserver", "Sqlite" or "Oracle"
	'user' => 'root',          // Database user name
	'pass' => '',          // Database password
	'host' => '127.0.0.1', // Database host
	'port' => '',          // Database connection port (can be left empty for default)
	'db' => 'roman',          // Database name
	'dsn' => '',          // PHP DSN extra information. Set as `charset=utf8mb4` if you are using MySQL
	'pdoAttr' => [],   // PHP PDO attributes array. See the PHP documentation for all options
];

// This is included for the development and deploy environment used on the DataTables
// server. You can delete this block - it just includes my own user/pass without making
// them public!
if (is_file($_SERVER['DOCUMENT_ROOT'] . '/datatables/pdo.php')) {
	include $_SERVER['DOCUMENT_ROOT'] . '/datatables/pdo.php';
}
// /End development include
