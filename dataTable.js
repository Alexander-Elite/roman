var editor = new DataTable.Editor({
	ajax: 'dataTables.php',
	fields: [
		{
			label: 'Account1:',
			name: 'Account1'
		},
		{
			label: 'TransactionNo:',
			name: 'TransactionNo', type: 'text'
		},
		{
			label: 'Amount:',
			name: 'Amount', type: 'text'
		},
		{
			label: 'Currency:',
			name: 'Currency'
		},
		{
			label: 'Date:',
			name: 'Date',
			type: 'datetime', type: 'datetime'
			// multiEditable: false
		},
	],
	table: '#example'
});
 
var table = $('#example').DataTable({
	ajax: 'dataTables.php',
	searching: false, // Отключаем поиск
	paging: true,      // включено (но рендерим только в topEnd)
	info: false,       // отключить нижнюю строку "Showing 1 to ..."
	dom:
	"<'top d-flex justify-content-between align-items-center' l p>" + // первая строка сверху: слева length, справа пагинация
	"<'top2 mb-2' B>" +                                              // вторая строка сверху: кнопки экспорта
	"t",                                                             // таблица
	buttons: [
		{
		  extend: 'excel',
		  title: 'Summary'
		},
		{
		  extend: 'pdf',
		  title: 'Summary'
		}
	  ],
	columns: [
		{ data: 'Account' },
		{ data: 'TransactionNo',  className: 'editable' },
		{ data: 'Amount',  className: 'editable' },
		{ data: 'Currency' },
		{ data: 'Date',  className: 'editable' },
		{
            data: null,
            className: "dt-center",
            defaultContent: '<span class="delete-btn">🗑</span>',
            orderable: false
        }
	],

	select: true,
	initComplete: function() {
		$('.top2 .dt-buttons').prepend('<span class="me-3">Export full table</span>');
		this.api().on('click', 'td.editable', function(e)
		{
			e.stopPropagation();
			editor.inline(this,
			{
				submit: 'allIfChanged',
				onBlur: 'submit'
			});
		});
	}

});

$('#example').on('click', '.delete-btn', function () {
    var row = table.row($(this).parents('tr'));
    editor
        .remove(row.index(), {
            title: 'Удалить запись',
            message: 'Вы уверены, что хотите удалить эту запись?',
            buttons: 'Удалить'
        });
});

/* 
$(document).ready(function(){
	var empDataTable = $('#example1').DataTable({
	//    dom: 'Blfrtip',
	   buttons: [
		 {  
			extend: 'copy'
		 },
		 {
			extend: 'pdf',
			exportOptions: {
			  columns: [0,1] // Column index which needs to export
			}
		 },
		 {
			extend: 'csv',
		 },
		 {
			extend: 'excel',
		 } 
	   ] 
  
	});
   
  });
  */