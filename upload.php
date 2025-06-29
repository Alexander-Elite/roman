<?php
require_once 'vendor/autoload.php';
use PhpOffice\PhpSpreadsheet\IOFactory;


$response = ['message' => '', 'success' => false];

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_FILES['files']))
{
	$uploadDir = __DIR__ . '/uploads/';
	if (!is_dir($uploadDir))
	{
		mkdir($uploadDir, 0755, true);
	}

	foreach ($_FILES['files']['name'] as $key => $name)
	{
		// Проверка файла на спам (например, если это текстовый файл)
		$tmpName = $_FILES['files']['tmp_name'][$key];

		// Проверка размера и типа файла
		if ($_FILES['files']['size'][$key] > 5 * 1024 * 1024) { // Лимит 5 МБ
			$response['message'] = "Файл $name слишком большой";
			echo json_encode($response);
			exit;
		}

		$ext = pathinfo($name, PATHINFO_EXTENSION);
		$allowed = ['csv', 'xls', 'xlsx'];
		if (!in_array(strtolower($ext), $allowed))
		{
			$response['message'] = "Недопустимый формат файла: $name";
			echo json_encode($response);
			exit;
		}

		// Сохранение файла
		$filePath = $uploadDir . uniqid() . '.' . $ext;
		if ( move_uploaded_file($tmpName, $filePath) )
		{
			// Логирование в базу

			$data = null;
			if ( $ext == 'xlsx' )
				$data = loadXLS ( $filePath );
			elseif ( $ext == 'csv' )
				$data = loadCSV ( $filePath );

			save( $data );

			// $logger->log("Файл загружен: $name -> $filePath");
			$response['message'] = "Файл $name успешно загружен";
			$response['success'] = true;
		}
		else
		{
			// $logger->log("Ошибка загрузки файла: $name");
			$response['message'] = "Ошибка при загрузке файла $name";
		}
	}
}
else
{
	$response['message'] = 'Файлы не отправлены';
}
echo json_encode($response);


function loadXLS ( $file )
{
	 // Чтение XLS-файла
	 $spreadsheet = IOFactory::load( $file );
	 $worksheet = $spreadsheet->getActiveSheet();
	 $data = $worksheet->toArray();
	return $data;
}

function loadCSV ( $file )
{
	return file( $file , FILE_SKIP_EMPTY_LINES | FILE_IGNORE_NEW_LINES);
}


function save ( $data )
{
	if ( $data )
	{
		require_once 'mysql.php';
		global $mysqli;

		$sql = "TRUNCATE transactions;";
		$mysqli->query( $sql );
		// echo $sql . PHP_EOL;
		
		$sql = 'INSERT INTO transactions (`Account`, `TransactionNo`, `Amount`, `Currency`, `Date`) VALUES ';
		
		foreach ($data as $key => $line)
		{
			if ( !$key )
				continue;

			if ( is_string( $line ) )
				$data = explode (",", $line);
			else
				$data = $line;
			$data = array_slice ( $data , 0, 5 );
		
			if ( $data[4] == '0000-00-00 00:00:00' )		// даты с нулями не должно быть, пропускаем строку, либо заменяем дату
				continue;
		
			$values = "'" . implode( "','", $data ) . "'";
			$sqldata[] =  "($values)";
		}
		$sql .= implode (",", $sqldata );
		// echo "$sql\n";
		// echo "Данные загружены...\n";
		$mysqli->query( $sql );
	}
}