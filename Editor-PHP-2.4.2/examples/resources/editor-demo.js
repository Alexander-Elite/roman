
document.addEventListener('dt-demo-run', function () {
	if (!window.$) {
		return;
	}

	$(document).on('initEditor', function (e, editor) {
		// Show and syntax highlight submit and return data
		editor.on('preSubmit', function (e, data) {
			$('div.ajax-data-send div.syntaxhighlighter').remove();
			$('div.ajax-data-send').append(
				$('<code class="multiline language-js"/>').text( decodeURI(
					jQuery.param( data ).replace(/&/g, '\n').replace(/\+/g, ' ')
				) )
			);
			SyntaxHighlighter.highlight( {}, $('div.ajax-data-send code')[0] );
		} );

		editor.on('postSubmit', function (e, json, data) {
			$('div.ajax-data-receive div.syntaxhighlighter').remove();
			$('div.ajax-data-receive').append(
				$('<code class="multiline language-js"/>').text( JSON.stringify( json, null, 2 ) )
			);
			SyntaxHighlighter.highlight( {}, $('div.ajax-data-receive code')[0] );
		} );

		// Server-side script - replace the DataTables script display with
		// one customised for Editor. This is actually tab index 4 from the
		// DT tabs, but due to the reorder above it gets moved down one
		var server = $('div.dt-tabs > div').eq(3);

		//
		// Modify the tabs from the DataTables default examples to show the
		// extras information we want for Editor
		//

		// Ajax load data - rename and move to the end
		$('ul.dt-tabs li').eq(3).html('Ajax load').appendTo( 'ul.dt-tabs' );
		$('div.dt-tabs > div').eq(3).appendTo( 'div.dt-tabs' );

		// Ajax data interchange between Editor and the server
		$('ul.dt-tabs').append( '<li>Ajax data</li>' );
		$(
			'<div class="ajax-data">'+
				'<p>Editor submits and retrieves information by Ajax requests. The two blocks below show the data that Editor submits and receives, to and from the server. This is updated live as you interact with Editor so you can see what is submitted.</p>'+
				'<div class="column_half ajax-data-send">'+
					'<h3>Submitted data:</h3>'+
					'<p>The following shows the data that has been submitted to the server when a request is made to add, edit or delete data from the table.</p>'+
					'<code class="multiline language-js">// No data yet submitted</code>'+
				'</div>'+
				'<div class="column_half ajax-data-receive">'+
					'<h3>Server response:</h3>'+
					'<p>The following shows the data that has been returned by the server in response to the data submitted on the left and is then acted upon.</p>'+
					'<code class="multiline language-js">// No data yet received</code>'+
				'</div>'+
				'<div class="clear"></div>'+
			'</div>'
		).appendTo( 'div.dt-tabs' );

		var ssFetched = false;
		$('#example').on('preXhr.dt', function () {
			if (ssFetched) {
				return;
			}

			var table = $('#example').DataTable();
			var url = table.ajax.url();

			if ( url && url.indexOf('php') !== -1 ) {
				$('ul.dt-tabs li').eq(3).html('Server script').css('display', 'block');
				server.find('p').eq(0).html( 'The following script is used by DataTables and Editor to process the data requests sent by the client on the server-side.' );

				$.ajax( {
					url: '../resources/examples.php',
					data: {
						src: table.ajax.url()
					},
					dataType: 'text',
					type: 'post',
					success: function ( txt ) {
						$('div.dt-tabs > div.php').append(
							$('<code class="multiline language-php"/>').text(txt)
						);
						SyntaxHighlighter.highlight( {}, $('div.dt-tabs div.php code')[0] );
						ssFetched = true;
					}
				} );
			}
		});

		// Expose so we can access it externally
		dt_demo.editor = editor;
	});
});
