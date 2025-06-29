<?php
// require 'vendor/autoload.php';
include( "Editor-PHP-2.4.2/lib/DataTables.php" );
use
    DataTables\Editor,
    DataTables\Editor\Field,
    DataTables\Editor\Format,
    DataTables\Editor\Mjoin,
    DataTables\Editor\Options,
    DataTables\Editor\Upload,
    DataTables\Editor\Validate,
    DataTables\Editor\ValidateOptions;

    Editor::inst($db, 'banks', 'Banks') // Используем представление banks, Banks как ключ
    ->fields(
        Field::inst('banks.Banks')
            ->validator(Validate::notEmpty(ValidateOptions::inst()
                ->message('Banks cannot be empty')))
            ->setFormatter(Format::ifEmpty(0))
            ->set(Field::SET_EDIT),
        Field::inst('banks.Currency')
            ->validator(Validate::notEmpty(ValidateOptions::inst()
                ->message('Currency cannot be empty')))
            ->set(false), // Запрещаем редактирование Currency
        Field::inst('banks.StartingBalance')
            ->validator(Validate::numeric(ValidateOptions::inst()
                ->message('Starting Balance must be a number')))
            ->setFormatter(Format::ifEmpty(0))
            ->set(Field::SET_EDIT), // Разрешаем редактирование только StartingBalance
        Field::inst('banks.EndBalance')
            ->set(false), // Только чтение
        Field::inst('banks.EndBalanceCHF')
            ->set(false) // Только чтение
    )
    ->on('preEdit', function ($editor, $id, $values) use ($db) {
        $account = $values['banks.Banks'];
        $currency = $values['banks.Currency'];
        $startingBalance = $values['banks.StartingBalance'];
        $db->sql(
            'INSERT INTO banks (Account, Currency, StartingBalance) VALUES (?, ?, ?) ' .
            'ON DUPLICATE KEY UPDATE StartingBalance = ?, Currency = ?',
            [$account, $currency, $startingBalance, $startingBalance, $currency]
        );
    })
    ->process($_POST)
    ->json();