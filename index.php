<!DOCTYPE html>
<html lang="ru">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="styles.css" />
	<link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.css" />
	<link rel="stylesheet" href="https://cdn.datatables.net/buttons/3.2.3/css/buttons.dataTables.css" />
	<link rel="stylesheet" href="https://cdn.datatables.net/select/3.0.1/css/select.dataTables.css" />
	<link rel="stylesheet" href="https://cdn.datatables.net/datetime/1.5.5/css/dataTables.dateTime.min.css" />
	<link rel="stylesheet" href="Editor-PHP-2.4.2/css/editor.dataTables.css" />
	<link rel="stylesheet" href="https://cdn.datatables.net/v/dt/jqc-1.12.4/dt-2.3.2/b-3.2.3/sl-3.0.1/datatables.min.css"/>
 
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdn.datatables.net/2.3.2/js/dataTables.js"></script>
	<script src="https://cdn.datatables.net/buttons/3.2.3/js/dataTables.buttons.js"></script>
	<script src="https://cdn.datatables.net/buttons/3.2.3/js/buttons.dataTables.js"></script>
	<script src="https://cdn.datatables.net/select/3.0.1/js/dataTables.select.js"></script>
	<script src="https://cdn.datatables.net/select/3.0.1/js/select.dataTables.js"></script>
	<script src="https://cdn.datatables.net/datetime/1.5.5/js/dataTables.dateTime.min.js"></script>
	<script src="Editor-PHP-2.4.2/js/dataTables.editor.js"></script>
	<script src="Editor-PHP-2.4.2/js/editor.dataTables.js"></script>
	<script src="https://code.highcharts.com/highcharts.js"></script>

	<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/buttons/3.2.3/js/buttons.html5.min.js"></script>
	

	<title>Тестовое задание</title>
</head>

<body>
<?php
require_once 'mysql.php';
require_once 'currency.php';

$data = readData();
// var_export ( $data );

$currencys = [];
foreach ($data as $key => $value)
{
	if ( !in_array( $value['Currency'], $currencys ) )
		$currencys[] = $value['Currency'];
}

?>
	<h1>Roman</h1>

	<div class="grid-container">
		<!-- Верхний элемент: два блока (60% и 40%) -->
		<div class="block top-block left">
		<span class="subheader">Upload</span>
			<div class="content">
				<div class="inline-container">
					<div class="inline">
						<button class="drop-zone-btn" onclick="document.getElementById('fileInput').click()">Выбрать файл</button>
					</div>
					<div class="inline  drop-zone-wrapper">
						<div class="drop-zone" id="dropZone">
							<p>Перетащите файл сюда или нажмите кнопку</p>
							<input type="file" id="fileInput" multiple>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="block top-block right">
		<span class="subheader">Currency exchange rates</span>
			<div class="content">
					<p>CURRENT FX RATES<br>
					Value in CHF</p>
					<table>
						<tr>
							<th>Currency</th><th>FX Rate</th>
						</tr>
						<?php 
							foreach ($currencys as $key => $value)
							{
								if ( $value == 'CHF' )
									continue;
								echo "<tr><td>" . $value . "</td><td>" . currency_rate( $value ) . "</td></tr>\n"; 
							}
						?>
					</table>
			</div>
		</div>
		<!-- Нижние блоки: 100% ширины, разная высота -->
		<div class="block full-width block-1">
			<span class="subheader">List of bank accounts</span>
			<div class="content">
			<?php // require_once 'dataTables.php'; ?>
			<table id="banksTable" class="display">
		<thead>
			<tr>
				<th>Banks</th>
				<th>Currency</th>
				<th>Starting balance</th>
				<th>End balance</th>
				<th>End balance (CHF)</th>
			</tr>
		</thead>
	</table>
			</div>
		</div>
		<div class="block full-width block-2">
			<span class="subheader">Cash forecast</span>
			<div class="content">
			<div id="chartContainer" style="height: 400px;"></div>
			</div>
		</div>
		<div class="block full-width block-3">
			<span class="subheader">Transactions</span>
			<div class="content">
			<table id="example" class="display">
		<thead>
			<tr>
				<th>Account</th>
				<th>Transaction No</th>
				<th>Amount</th>
				<th>Currency</th>
				<th>Date</th>
				<th></th> <!-- для кнопки удаления -->
			</tr>
		</thead>
	</table>
			</div>
		</div>
	</div>

	<div class="grid">
	</div>

	<script  src="banks.js"></script>
	<script  src="dataTable.js"></script>
	
	<script>
		const dropZone = document.getElementById('dropZone');
		const fileInput = document.getElementById('fileInput');

		// Обработка событий drag-and-drop
		dropZone.addEventListener('dragover', (e) => {
			e.preventDefault();
			dropZone.classList.add('dragover');
		});

		dropZone.addEventListener('dragleave', () => {
			dropZone.classList.remove('dragover');
		});

		dropZone.addEventListener('drop', (e) => {
			e.preventDefault();
			dropZone.classList.remove('dragover');
			const files = e.dataTransfer.files;
			if (files.length > 0) {
				fileInput.files = files;
				uploadFiles(files);
			}
		});

		// Обработка выбора файла через кнопку
		fileInput.addEventListener('change', () => {
			const files = fileInput.files;
			if (files.length > 0) {
				uploadFiles(files);
			}
		});

		// Функция отправки файлов на сервер
		function uploadFiles(files)
		{
			const formData = new FormData();
			for (let i = 0; i < files.length; i++) {
				formData.append('files[]', files[i]);
			}

			fetch('upload.php',
			{
				method: 'POST',
				body: formData
			})
			.then(response => response.json())
			.then(data => {
				alert(data.message);
			})
			.catch(error => {
				console.error('Ошибка загрузки:', error);
				alert('Ошибка при загрузке файла');
			});
		}
	</script>
</body>
</html>

