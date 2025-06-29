<?php
# загружаем курсы валют (не автоматизирую, экономлю время)
function currency_rate ( string $valute_name )
{
    $data = file_get_contents("daily_json.js");
    $cur = json_decode( $data, 0 );

    $CHF = $cur->Valute->CHF->Value / $cur->Valute->CHF->Nominal;
    // $EUR = $cur->Valute->EUR->Value / $cur->Valute->EUR->Nominal;
    // $USD = $cur->Valute->USD->Value / $cur->Valute->USD->Nominal;



    $valute = $cur->Valute->{$valute_name}->Value / $cur->Valute->{$valute_name}->Nominal;
    return round (  $valute / $CHF , 4);
}
