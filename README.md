Код писался в процедурном стиле, обычно я работаю в ООП, но для этого создаётся окружение полностью, поэтому
не очень это всё правильно. Но, главное - работает.

Итак, таблицы:

Представление banks
```
select `t`.`Account` AS `Banks`,`t`.`Currency` AS `Currency`,0 AS `StartingBalance`,coalesce(sum(`t`.`Amount`),0) AS `EndBalance`,coalesce((sum(`t`.`Amount`) * coalesce(min(`er`.`RateToCHF`),1)),0) AS `EndBalanceCHF` from (`transactions` `t` left join `exchange_rates` `er` on((`t`.`Currency` = `er`.`Currency`))) group by `t`.`Account`,`t`.`Currency`,`er`.`RateToCHF`
```
даёт возможность визуализировать данные

```
-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               5.7.33 - MySQL Community Server (GPL)
-- Операционная система:         Win64
-- HeidiSQL Версия:              11.3.0.6390
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Дамп структуры для таблица roman.exchange_rates
CREATE TABLE IF NOT EXISTS `exchange_rates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Currency` tinytext COLLATE utf8mb4_unicode_ci NOT NULL,
  `RateToCHF` float NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы roman.exchange_rates: ~3 rows (приблизительно)
DELETE FROM `exchange_rates`;
INSERT INTO `exchange_rates` (`id`, `Currency`, `RateToCHF`) VALUES
	(1, 'EUR', 0.95),
	(2, 'USD', 0.85),
	(3, 'CHF', 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
```
Для загрузки данных по валютам используется 2 источника. Склоняюсь к использованию в SQL, т.к. он даёт больше мобильности.
Загружаем данные с сайта в JS (по крону), и автоматически перекидываем данные в эту таблицу (тут не реализовано)

И таблица транзакций:
```
CREATE TABLE `transactions` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`Account` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`TransactionNo` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`Amount` FLOAT NULL DEFAULT NULL,
	`Currency` TINYTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`Date` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COMMENT='транзакции'
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
AUTO_INCREMENT=536
;
```



