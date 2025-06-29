$(document).ready(function() {
    // Хранилище изменённых данных
    let editedData = {};
	let chart = null; // Для хранения экземпляра Chart.js
	const monthNames = [
        'Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
        'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'
    ];

    let editor = new $.fn.dataTable.Editor({
        // ajax: 'banks.php',
        table: '#banksTable',
        fields: [
            { label: 'Banks', name: 'banks.Banks', type: 'text' },
            { label: 'Currency', name: 'banks.Currency', type: 'readonly' },
            { label: 'Starting Balance', name: 'banks.StartingBalance', type: 'text' },
        ]
    });

    let table = $('#banksTable').DataTable({
        dom: 't', // Только таблица, без поиска и пагинации
        searching: false, // Отключаем поиск
        paging: false, // Отключаем пагинацию
		ajax: {
			url: 'banks.php',
			dataSrc: function(json) {
				console.log('Loaded banks data:', json);
				if (!json.data) {
					console.warn('No data in banks response:', json);
					return [];
				}
				editedData = {};
				json.data.forEach(row => {
					let rowId = row.banks.Banks;
					editedData[rowId] = {
						Banks: row.banks.Banks,
						StartingBalance: parseFloat(row.banks.StartingBalance) || 0,
						EndBalanceCHF: parseFloat(row.banks.EndBalanceCHF) || 0
					};
					row.DT_RowId = rowId;
					console.log('Row DT_RowId:', row.DT_RowId, 'Row data:', row);
				});
				console.log('Initialized editedData:', editedData);
				setTimeout(updateChart, 0);
				return json.data;
			},
			error: function(xhr, status, error) {
				console.error('Error loading banks:', error, xhr.responseText);
			}
		},
        columns: [
            { data: 'banks.Banks', title: 'Banks',  className: 'editable' },
            { data: 'banks.Currency', title: 'Currency' },
            { 
                data: 'banks.StartingBalance', 
                title: 'Starting Balance',
                className: 'editable'
            },
            { data: 'banks.EndBalance', title: 'End Balance' },
            { data: 'banks.EndBalanceCHF', title: 'End Balance (CHF)' },
        ],
        select: true,
        initComplete: function() {
            this.api().on('click', 'td.editable', function(e) {
                e.stopPropagation();
                let cell = table.cell(this);
                let row = table.row(cell.index().row);
                let rowData = row.data();
                editor.inline(this, {
                    submit: 'allIfChanged',
                    onBlur: 'submit'
                });
            });
        }
    });

    // Перехватываем успешное завершение редактирования
    editor.on('postSubmit', function(e, json, data, action) {
		console.log('postSubmit triggered:', { data, json, action });
	
		// Получаем имя поля (например, "banks.Banks" или "banks.StartingBalance")
		let fieldName = Object.keys(data.data)[0];
		let rowDataObj = data.data[fieldName];
	
		// Извлекаем rowId из editor.modifier() или data
		let rowNode = editor.modifier(); // Получаем DOM-узел ячейки
		if (!rowNode) {
			console.error('No row or cell being edited');
			return;
		}
	
		let row = table.row(rowNode.closest('tr')); // Находим строку
		if (!row.any()) {
			console.error('Row not found for edited cell');
			return;
		}
	
		let rowData = row.data();
		let rowId = rowData.DT_RowId || rowData.banks.Banks; // Используем DT_RowId или Banks
		if (!rowId) {
			console.error('Row ID not found in rowData:', rowData);
			return;
		}
	
		let oldId = rowData.banks.Banks;
		let newId = data.data[fieldName][rowId] ? data.data[fieldName][rowId]['banks.Banks'] || oldId : oldId;
		let newValue = data.data[fieldName][rowId] ? parseFloat(data.data[fieldName][rowId]['banks.StartingBalance']) || rowData.banks.StartingBalance || 0 : rowData.banks.StartingBalance || 0;
	
		// Обновляем editedData
		if (oldId !== newId) {
			editedData[newId] = editedData[oldId] || {};
			editedData[newId].Banks = newId;
			editedData[newId].StartingBalance = newValue;
			editedData[newId].EndBalanceCHF = parseFloat(rowData.banks.EndBalanceCHF) || 0;
			delete editedData[oldId];
		} else {
			editedData[oldId].StartingBalance = newValue;
		}
	
		// Обновляем данные в таблице
		rowData.banks.Banks = newId;
		rowData.banks.StartingBalance = newValue;
		row.data(rowData).draw(false);
	
		console.log('Updated editedData:', editedData);
		updateChart();
	});

	

	function updateChart() {
		console.log('updateChart called. Edited data:', editedData);
		console.log('Transactions data:', transactionsData);
	
		let accounts = Object.keys(editedData);
		if (!accounts.length) {
			console.warn('No accounts available in editedData, skipping chart update.');
			$('#chartContainer').html('<p>Ожидание данных счетов...</p>');
			return;
		}
		if (!transactionsData.length) {
			console.warn('No transactions available, skipping chart update.');
			$('#chartContainer').html('<p>Нет данных транзакций</p>');
			return;
		}
	
		let monthYearMap = new Map();
		transactionsData.forEach(t => {
			let [year, month] = t.Date.split('-').slice(0, 2);
			let monthYear = `${year}-${month}`;
			if (!monthYearMap.has(monthYear)) {
				monthYearMap.set(monthYear, []);
			}
			monthYearMap.get(monthYear).push(t);
		});
	
		let monthYears = [...monthYearMap.keys()].sort();
		let formattedDates = monthYears.map(my => {
			let [year, month] = my.split('-');
			return `${monthNames[parseInt(month) - 1]}.${year.slice(2)}`.toLowerCase();
		});
		console.log('MonthYears:', monthYears);
		console.log('Formatted dates:', formattedDates);
	
		if (!monthYears.length) {
			console.warn('No month-years available, skipping chart update.');
			$('#chartContainer').html('<p>Нет данных для построения графика</p>');
			return;
		}
	
		let series = accounts.map((account, index) => {
			let data = monthYears.map(monthYear => {
				let startingBalance = parseFloat(editedData[account]?.StartingBalance || 0);
				let transactions = (monthYearMap.get(monthYear) || [])
					.filter(t => t.Account === editedData[account].Banks) // Используем актуальное имя банка
					.reduce((sum, t) => sum + parseFloat(t.Amount || 0), 0);
				let balance = startingBalance + transactions;
				console.log(`Balance for ${editedData[account].Banks} in ${monthYear}: starting=${startingBalance}, transactions=${transactions}, total=${balance}`);
				return isNaN(balance) ? 0 : balance;
			});
			console.log(`Series for ${editedData[account].Banks}:`, data);
			return {
				name: editedData[account].Banks, // Используем актуальное имя банка для легенды
				data: data,
				color: index % 2 === 0 ? '#0000FF' : '#800080',
				marker: { enabled: false }
			};
		});
	
		let validSeries = series.filter(s => s.data.some(d => d !== 0));
		if (!validSeries.length) {
			console.warn('No valid series data, skipping chart update.');
			$('#chartContainer').html('<p>Нет ненулевых данных для счетов</p>');
			return;
		}
	
		$('#chartContainer').empty();
		Highcharts.chart('chartContainer', {
			chart: { type: 'line' },
			title: { text: 'Баланс по счетам' },
			xAxis: {
				categories: formattedDates,
				title: { text: 'Дата' }
			},
			yAxis: {
				title: { text: 'Баланс (CHF)' },
				allowDecimals: true
			},
			series: validSeries,
			credits: { enabled: false },
			tooltip: {
				shared: true,
				formatter: function() {
					let s = `<b>${this.x}</b>`;
					this.points.forEach(point => {
						s += `<br/><span style="color:${point.series.color}">${point.series.name}</span>: ${point.y.toFixed(2)} CHF`;
					});
					return s;
				}
			}
		});
	}



	    // Загружаем данные транзакций
		$.ajax({
			url: 'transactions.php',
			dataType: 'json',
			success: function(json) {
				transactionsData = json.data;
				updateChart(); // Инициализируем график после загрузки
			},
			error: function(xhr, status, error) {
				console.error('Error loading transactions:', error);
			}
		});

});