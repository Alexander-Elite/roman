<?php
 
/*
 * Example PHP implementation used for the index.html example
 */
 
// DataTables PHP library
include( "Editor-PHP-2.4.2/lib/DataTables.php" );
 
// Alias Editor classes so they are easy to use
use
    DataTables\Editor,
    DataTables\Editor\Field,
    DataTables\Editor\Format,
    DataTables\Editor\Mjoin,
    DataTables\Editor\Options,
    DataTables\Editor\Upload,
    DataTables\Editor\Validate,
    DataTables\Editor\ValidateOptions;
 
// Build our Editor instance and process the data coming from _POST
Editor::inst( $db, 'transactions' )
    ->fields(
        Field::inst( 'Account' )
            ->validator( Validate::notEmpty( ValidateOptions::inst()
                ->message( 'A first name is required' ) 
            ) ),
        Field::inst( 'TransactionNo' )
            ->validator( Validate::notEmpty( ValidateOptions::inst()
                ->message( 'A last name is required' )  
            ) ),
        Field::inst( 'Amount' )
            ->set(Field::SET_EDIT),
        Field::inst( 'Currency' ),
        Field::inst( 'Date' ),

    )
    ->debug(true)
    ->process( $_POST )
    ->json();
