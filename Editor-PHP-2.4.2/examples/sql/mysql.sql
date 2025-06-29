--
--
-- MySQL tables used to run the Editor examples.
--
-- For more information about how the client and server-sides interact, please
-- refer to the Editor documentation: http://editor.datatables.net/manual .
--
--


--
-- To do list examples
--
DROP TABLE IF EXISTS todo;

CREATE TABLE `todo` (
    `id` int(10) NOT NULL auto_increment,
    `item` varchar(255) NOT NULL default '',
    `done` boolean NOT NULL default 0,
    `priority` integer NOT NULL default 1,
    PRIMARY KEY (`id`)
) CHARSET=utf8mb4;

INSERT INTO `todo` (`item`, `done`, `priority`)
    VALUES
        ( 'Send business plan to clients', 1, 1 ),
        ( 'Web-site copy revisions',       0, 2 ),
        ( 'Review client tracking',        0, 2 ),
        ( 'E-mail catchup',                0, 3 ),
        ( 'Complete worksheet',            0, 4 ),
        ( 'Prep sales presentation',       0, 5 );



--
-- Users table examples
--
DROP TRIGGER IF EXISTS users_insert;
DROP TRIGGER IF EXISTS users_update;
DROP TABLE IF EXISTS user_dept CASCADE;
DROP TABLE IF EXISTS user_permission CASCADE;
DROP TABLE IF EXISTS user_access CASCADE; -- legacy
DROP TABLE IF EXISTS users_files CASCADE;
DROP TABLE IF EXISTS users_visits CASCADE;

DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS dept CASCADE;
DROP TABLE IF EXISTS permission CASCADE;
DROP TABLE IF EXISTS sites CASCADE;
DROP TABLE IF EXISTS files CASCADE;

CREATE TABLE users (
    `id` mediumint(8) unsigned NOT NULL auto_increment, 
    `title` varchar(255) default NULL,
    `first_name` varchar(255) default NULL,
    `last_name` varchar(255) default NULL,
    `phone` varchar(100) default NULL,
    `city` varchar(50) default NULL,
    `zip` varchar(10) default NULL,
    `updated_date` datetime DEFAULT NULL,
    `registered_date` datetime default NULL,
    `removed_date` datetime default NULL, -- Used only for the soft delete example
    `active` boolean default NULL,
    `manager` int default NULL,
    `site` int default NULL,
    `image` int default NULL,
    `shift_start` time default NULL,
    `shift_end` time default NULL,
    `description` text default NULL,
    PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;

CREATE TRIGGER users_insert BEFORE INSERT ON `users`
    FOR EACH ROW SET NEW.updated_date = IFNULL(NEW.updated_date, NOW());

CREATE TRIGGER users_update BEFORE UPDATE ON `users`
    FOR EACH ROW SET NEW.updated_date = IFNULL(NEW.updated_date, NOW());

CREATE TABLE dept (
    `id` mediumint(8) unsigned NOT NULL auto_increment, 
    `name` varchar(250) default NULL,
    PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;

CREATE TABLE permission (
    `id` mediumint(8) unsigned NOT NULL auto_increment, 
    `name` varchar(250) default NULL,
    PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;

CREATE TABLE sites (
    `id` mediumint(8) unsigned NOT NULL auto_increment,
    `name` varchar(250) default NULL,
    `continent` varchar(250) default NULL,
    PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;

CREATE TABLE `files` (
  `id` int NOT NULL AUTO_INCREMENT,
  `filename` varchar(250) default '' NOT NULL,
  `filesize` int NOT NULL default 0,
  `web_path` varchar(250) default '' NOT NULL,
  `system_path` varchar(250) default '' NOT NULL,
  `test` boolean default false,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;


-- Expect only one dept per user
CREATE TABLE user_dept (
    `user_id` mediumint(8) unsigned NOT NULL,
    `dept_id` mediumint(8) unsigned NOT NULL,
    PRIMARY KEY (`user_id`, `dept_id`),
    UNIQUE KEY `user_id` (`user_id`),
    FOREIGN KEY (`user_id`) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (`dept_id`) REFERENCES dept(id) ON DELETE CASCADE
) CHARSET=utf8mb4;

-- Expect multiple permission per user
CREATE TABLE user_permission (
    `user_id` mediumint(8) unsigned NOT NULL,
    `permission_id` mediumint(8) unsigned NOT NULL,
    PRIMARY KEY (`user_id`, `permission_id`),
    FOREIGN KEY (`user_id`) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (`permission_id`) REFERENCES permission(id) ON DELETE CASCADE
) CHARSET=utf8mb4;

CREATE TABLE users_files (
    `user_id` int NOT NULL,
    `file_id` int NOT NULL
) CHARSET=utf8mb4;

CREATE OR REPLACE VIEW staff_newyork as
  select id, first_name, last_name, phone, city
  from users
  where site in (select id from sites where name = 'New York');

INSERT INTO `users` (`title`, `first_name`, `last_name`, `phone`, `city`, `zip`, `registered_date`, `active`, `manager`, `site`, `shift_start`, `shift_end`)
    VALUES
        ('Miss','Quynn',     'Contreras',    '1-971-977-4681', 'Slidell',               '81080',    '2012-04-06 18:53:00', 0, 1, 1, '08:00:00', '16:00:00'),
        ('Mr',  'Kaitlin',   'Smith',        '1-436-523-6103', 'Orlando',               'U5G 7J3',  '2012-11-20 05:58:25', 1, 1, 2, '09:00:00', '17:00:00'),
        ('Mrs', 'Cruz',      'Reynolds',     '1-776-102-6352', 'Lynn',                  'EJ89 9DQ', '2011-12-31 23:34:03', 0, 2, 3, '09:00:00', '17:00:00'),
        ('Dr',  'Sophia',    'Morris',       '1-463-224-1405', 'Belleville',            'T1F 2X1',  '2012-08-04 02:55:53', 0, 3, 4, '08:00:00', '15:30:00'),
        ('Miss','Kamal',     'Roberson',     '1-134-408-5227', 'Rehoboth Beach',        'V7I 6T5',  '2012-12-23 00:17:03', 1, 1, 5, '09:00:00', '17:00:00'),
        ('Dr',  'Dustin',    'Rosa',         '1-875-919-3188', 'Jersey City',           'E4 8ZE',   '2012-10-05 22:18:59', 0, 1, 6, '09:00:00', '17:00:00'),
        ('Dr',  'Xantha',    'George',       '1-106-884-4754', 'Billings',              'Y2I 6J7',  '2012-11-25 12:50:16', 0, 6, 1, '07:00:00', '15:00:00'),
        ('Mrs', 'Bryar',     'Long',         '1-918-114-8083', 'San Bernardino',        '82983',    '2012-05-14 23:32:25', 0, 1, 2, '09:00:00', '17:00:00'),
        ('Mrs', 'Kuame',     'Wynn',         '1-101-692-4039', 'Truth or Consequences', '21290',    '2011-06-21 16:27:07', 1, 2, 3, '06:00:00', '14:00:00'),
        ('Ms',  'Indigo',    'Brennan',      '1-756-756-8161', 'Moline',                'NO8 3UY',  '2011-02-19 12:51:08', 1, 5, 4, '12:00:00', '00:00:00'),
        ('Mrs', 'Avram',     'Allison',      '1-751-507-2640', 'Rancho Palos Verdes',   'I7Q 8H4',  '2012-12-30 17:02:10', 0, 1, 5, '09:00:00', '17:00:00'),
        ('Mr',  'Martha',    'Burgess',      '1-971-722-1203', 'Toledo',                'Q5R 9HI',  '2011-02-04 17:25:55', 1, 1, 6, '12:00:00', '00:00:00'),
        ('Miss','Lael',      'Kim',          '1-626-697-2194', 'Lake Charles',          '34209',    '2012-07-24 06:44:22', 1, 7, 1, '09:00:00', '17:00:00'),
        ('Dr',  'Lyle',      'Lewis',        '1-231-793-3520', 'Simi Valley',           'H9B 2H4',  '2012-08-30 03:28:54', 0, 1, 2, '00:00:00', '12:00:00'),
        ('Miss','Veronica',  'Marks',        '1-750-981-6759', 'Glens Falls',           'E3C 5D1',  '2012-08-14 12:09:24', 1, 2, 3, '09:00:00', '17:00:00'),
        ('Mrs', 'Wynne',     'Ruiz',         '1-983-744-5362', 'Branson',               'L9E 6E2',  '2012-11-06 01:04:07', 0, 1, 4, '12:00:00', '00:00:00'),
        ('Ms',  'Jessica',   'Bryan',        '1-949-932-6772', 'Boulder City',          'F5P 6NU',  '2013-02-01 20:22:33', 0, 5, 5, '09:00:00', '17:00:00'),
        ('Ms',  'Quinlan',   'Hyde',         '1-625-664-6072', 'Sheridan',              'Y8A 1LQ',  '2011-10-25 16:53:45', 1, 1, 6, '08:00:00', '15:00:00'),
        ('Miss','Mona',      'Terry',        '1-443-179-7343', 'Juneau',                'G62 1OF',  '2012-01-15 09:26:59', 0, 1, 1, '08:30:00', '16:30:00'),
        ('Mrs', 'Medge',     'Patterson',    '1-636-979-0497', 'Texarkana',             'I5U 6E0',  '2012-10-20 16:26:18', 1, 1, 2, '09:00:00', '17:00:00'),
        ('Mrs', 'Perry',     'Gamble',       '1-440-976-9560', 'Arcadia',               '98923',    '2012-06-06 02:03:49', 1, 2, 3, '00:00:00', '12:00:00'),
        ('Mrs', 'Pandora',   'Armstrong',    '1-197-431-4390', 'Glendora',              '34124',    '2011-08-29 01:45:06', 0, 7, 4, '21:00:00', '03:00:00'),
        ('Mr',  'Pandora',   'Briggs',       '1-278-288-9221', 'Oneida',                'T9M 4H9',  '2012-07-16 08:44:41', 1, 4, 5, '09:00:00', '17:00:00'),
        ('Mrs', 'Maris',     'Leblanc',      '1-936-114-2921', 'Cohoes',                'V1H 6Z7',  '2011-05-04 13:07:04', 1, 1, 6, '00:00:00', '12:00:00'),
        ('Mrs', 'Ishmael',   'Crosby',       '1-307-243-2684', 'Midwest City',          'T6 8PS',   '2011-07-02 23:11:11', 0, 3, 1, '09:00:00', '17:00:00'),
        ('Miss','Quintessa', 'Pickett',      '1-801-122-7471', 'North Tonawanda',       '09166',    '2013-02-05 10:33:22', 1, 1, 2, '12:00:00', '00:00:00'),
        ('Miss','Ifeoma',    'Mays',         '1-103-883-0962', 'Parkersburg',           '87377',    '2011-08-22 12:19:09', 0, 1, 3, '09:00:00', '17:00:00'),
        ('Mrs', 'Basia',     'Harrell',      '1-528-238-4178', 'Cody',                  'LJ54 1IU', '2012-05-07 14:42:55', 1, 1, 4, '09:00:00', '17:00:00'),
        ('Mrs', 'Hamilton',  'Blackburn',    '1-676-857-1423', 'Delta Junction',        'X5 9HE',   '2011-05-19 07:39:48', 0, 6, 5, '10:00:00', '18:00:00'),
        ('Ms',  'Dexter',    'Burton',       '1-275-332-8186', 'Gainesville',           '65914',    '2013-02-01 16:21:20', 1, 5, 6, '21:00:00', '03:00:00'),
        ('Mrs', 'Quinn',     'Mccall',       '1-808-916-4497', 'Fallon',                'X4 8UB',   '2012-03-24 19:31:51', 0, 1, 1, '09:00:00', '17:00:00'),
        ('Mr',  'Alexa',     'Wilder',       '1-727-307-1997', 'Johnson City',          '16765',    '2011-10-14 08:21:14', 0, 3, 2, '09:00:00', '17:00:00'),
        ('Ms',  'Rhonda',    'Harrell',      '1-934-906-6474', 'Minnetonka',            'I2R 1H2',  '2011-11-15 00:08:02', 1, 1, 3, '12:00:00', '00:00:00'),
        ('Mrs', 'Jocelyn',   'England',      '1-826-860-7773', 'Chico',                 '71102',    '2012-05-31 18:01:43', 1, 1, 4, '09:00:00', '17:00:00'),
        ('Dr',  'Vincent',   'Banks',        '1-225-418-0941', 'Palo Alto',             '03281',    '2011-08-07 07:22:43', 0, 1, 5, '18:00:00', '02:00:00'),
        ('Mrs', 'Stewart',   'Chan',         '1-781-793-2340', 'Grand Forks',           'L1U 3ED',  '2012-11-01 23:14:44', 1, 6, 6, '08:00:00', '16:00:00');

INSERT INTO `dept` (`name`)
    VALUES
        ( 'IT' ),
        ( 'Sales' ),
        ( 'Pre-Sales' ),
        ( 'Marketing' ),
        ( 'Senior Management' ),
        ( 'Accounts' ),
        ( 'Support' );

INSERT INTO `permission` (`name`)
    VALUES
        ( 'Printer' ),
        ( 'Servers' ),
        ( 'Desktop' ),
        ( 'VMs' ),
        ( 'Web-site' ),
        ( 'Accounts' );

INSERT INTO `user_dept` (`user_id`, `dept_id`)
    VALUES
        ( 1,  1 ),
        ( 2,  4 ),
        ( 3,  7 ),
        ( 4,  3 ),
        ( 5,  2 ),
        ( 6,  6 ),
        ( 7,  2 ),
        ( 8,  1 ),
        ( 9,  2 ),
        ( 10, 3 ),
        ( 11, 4 ),
        ( 12, 5 ),
        ( 13, 6 ),
        ( 14, 4 ),
        ( 15, 3 ),
        ( 16, 6 ),
        ( 17, 3 ),
        ( 18, 7 ),
        ( 19, 7 ),
        ( 20, 1 ),
        ( 21, 2 ),
        ( 22, 6 ),
        ( 23, 3 ),
        ( 24, 4 ),
        ( 25, 5 ),
        ( 26, 6 ),
        ( 27, 7 ),
        ( 28, 2 ),
        ( 29, 3 ),
        ( 30, 1 ),
        ( 31, 3 ),
        ( 32, 4 ),
        ( 33, 6 ),
        ( 34, 7 ),
        ( 35, 2 ),
        ( 36, 3 );

INSERT INTO `user_permission` (`user_id`, `permission_id`)
    VALUES
        ( 1,  1 ),
        ( 1,  3 ),
        ( 1,  4 ),
        ( 2,  4 ),
        ( 2,  1 ),
        ( 4,  3 ),
        ( 4,  4 ),
        ( 4,  5 ),
        ( 4,  6 ),
        ( 5,  2 ),
        ( 6,  6 ),
        ( 7,  2 ),
        ( 8,  1 ),
        ( 9,  2 ),
        ( 10, 3 ),
        ( 10, 2 ),
        ( 10, 1 ),
        ( 11, 4 ),
        ( 11, 6 ),
        ( 12, 5 ),
        ( 12, 1 ),
        ( 12, 2 ),
        ( 13, 1 ),
        ( 13, 2 ),
        ( 13, 3 ),
        ( 13, 6 ),
        ( 18, 3 ),
        ( 18, 2 ),
        ( 18, 1 ),
        ( 20, 1 ),
        ( 20, 2 ),
        ( 20, 3 ),
        ( 21, 2 ),
        ( 21, 4 ),
        ( 22, 6 ),
        ( 22, 3 ),
        ( 22, 2 ),
        ( 30, 1 ),
        ( 30, 5 ),
        ( 30, 3 ),
        ( 31, 3 ),
        ( 32, 4 ),
        ( 33, 6 ),
        ( 34, 1 ),
        ( 34, 2 ),
        ( 34, 3 ),
        ( 35, 2 ),
        ( 36, 3 );

INSERT INTO `sites` (`name`, `continent`)
    VALUES
        ( 'Edinburgh', 'Europe' ),
        ( 'London', 'Europe' ),
        ( 'Paris', 'Europe' ),
        ( 'New York', 'North America' ),
        ( 'Singapore', 'Asia' ),
        ( 'Los Angeles', 'North America' );

--
-- Cascading lists examples
--

DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS continent;

CREATE TABLE continent (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL default '',
    PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;

INSERT INTO `continent` (`name`)
    VALUES
		('Africa'),
		('Asia'),
		('Europe'),
		('N. America'),
		('Oceania'),
		('S. America'),
        ('Antarctica');


CREATE TABLE country (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL default '',
    `continent` int NOT NULL,
    `phone` int,
    `code` varchar(2),
    `flag` text,
    FOREIGN KEY (`continent`) REFERENCES continent(id) ON DELETE CASCADE,
    PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;

INSERT INTO `country` (`name`, `continent`, `phone`, `code`, `flag`)
    VALUES
        ( 'Andorra', 3, 376, 'AD', '🇦🇩'),
        ( 'United Arab Emirates', 2, 971, 'AE', '🇦🇪'),
        ( 'Afghanistan', 2, 93, 'AF', '🇦🇫'),
        ( 'Antigua and Barbuda', 4, 1268, 'AG', '🇦🇬'),
        ( 'Anguilla', 4, 1264, 'AI', '🇦🇮'),
        ( 'Albania', 3, 355, 'AL', '🇦🇱'),
        ( 'Armenia', 2, 374, 'AM', '🇦🇲'),
        ( 'Angola', 1, 244, 'AO', '🇦🇴'),
        ( 'Antarctica', 7, 672, 'AQ', '🇦🇶'),
        ( 'Argentina', 6, 54, 'AR', '🇦🇷'),
        ( 'American Samoa', 5, 1684, 'AS', '🇦🇸'),
        ( 'Austria', 3, 43, 'AT', '🇦🇹'),
        ( 'Australia', 5, 61, 'AU', '🇦🇺'),
        ( 'Aruba', 4, 297, 'AW', '🇦🇼'),
        ( 'Aland', 3, 358, 'AX', '🇦🇽'),
        ( 'Azerbaijan', 2, 994, 'AZ', '🇦🇿'),
        ( 'Bosnia and Herzegovina', 3, 387, 'BA', '🇧🇦'),
        ( 'Barbados', 4, 1246, 'BB', '🇧🇧'),
        ( 'Bangladesh', 2, 880, 'BD', '🇧🇩'),
        ( 'Belgium', 3, 32, 'BE', '🇧🇪'),
        ( 'Burkina Faso', 1, 226, 'BF', '🇧🇫'),
        ( 'Bulgaria', 3, 359, 'BG', '🇧🇬'),
        ( 'Bahrain', 2, 973, 'BH', '🇧🇭'),
        ( 'Burundi', 1, 257, 'BI', '🇧🇮'),
        ( 'Benin', 1, 229, 'BJ', '🇧🇯'),
        ( 'Saint Barthelemy', 4, 590, 'BL', '🇧🇱'),
        ( 'Bermuda', 4, 1441, 'BM', '🇧🇲'),
        ( 'Brunei', 2, 673, 'BN', '🇧🇳'),
        ( 'Bolivia', 6, 591, 'BO', '🇧🇴'),
        ( 'Bonaire', 4, 5997, 'BQ', '🇧🇶'),
        ( 'Brazil', 6, 55, 'BR', '🇧🇷'),
        ( 'Bahamas', 4, 1242, 'BS', '🇧🇸'),
        ( 'Bhutan', 2, 975, 'BT', '🇧🇹'),
        ( 'Bouvet Island', 7, 47, 'BV', '🇧🇻'),
        ( 'Botswana', 1, 267, 'BW', '🇧🇼'),
        ( 'Belarus', 3, 375, 'BY', '🇧🇾'),
        ( 'Belize', 4, 501, 'BZ', '🇧🇿'),
        ( 'Canada', 4, 1, 'CA', '🇨🇦'),
        ( 'Cocos (Keeling) Islands', 2, 61, 'CC', '🇨🇨'),
        ( 'Democratic Republic of the Congo', 1, 243, 'CD', '🇨🇩'),
        ( 'Central African Republic', 1, 236, 'CF', '🇨🇫'),
        ( 'Republic of the Congo', 1, 242, 'CG', '🇨🇬'),
        ( 'Switzerland', 3, 41, 'CH', '🇨🇭'),
        ( 'Ivory Coast', 1, 225, 'CI', '🇨🇮'),
        ( 'Cook Islands', 5, 682, 'CK', '🇨🇰'),
        ( 'Chile', 6, 56, 'CL', '🇨🇱'),
        ( 'Cameroon', 1, 237, 'CM', '🇨🇲'),
        ( 'China', 2, 86, 'CN', '🇨🇳'),
        ( 'Colombia', 6, 57, 'CO', '🇨🇴'),
        ( 'Costa Rica', 4, 506, 'CR', '🇨🇷'),
        ( 'Cuba', 4, 53, 'CU', '🇨🇺'),
        ( 'Cape Verde', 1, 238, 'CV', '🇨🇻'),
        ( 'Curacao', 4, 5999, 'CW', '🇨🇼'),
        ( 'Christmas Island', 2, 61, 'CX', '🇨🇽'),
        ( 'Cyprus', 3, 357, 'CY', '🇨🇾'),
        ( 'Czech Republic', 3, 420, 'CZ', '🇨🇿'),
        ( 'Germany', 3, 49, 'DE', '🇩🇪'),
        ( 'Djibouti', 1, 253, 'DJ', '🇩🇯'),
        ( 'Denmark', 3, 45, 'DK', '🇩🇰'),
        ( 'Dominica', 4, 1767, 'DM', '🇩🇲'),
        ( 'Dominican Republic', 4, 1809, 'DO', '🇩🇴'),
        ( 'Algeria', 1, 213, 'DZ', '🇩🇿'),
        ( 'Ecuador', 6, 593, 'EC', '🇪🇨'),
        ( 'Estonia', 3, 372, 'EE', '🇪🇪'),
        ( 'Egypt', 1, 20, 'EG', '🇪🇬'),
        ( 'Western Sahara', 1, 212, 'EH', '🇪🇭'),
        ( 'Eritrea', 1, 291, 'ER', '🇪🇷'),
        ( 'Spain', 3, 34, 'ES', '🇪🇸'),
        ( 'Ethiopia', 1, 251, 'ET', '🇪🇹'),
        ( 'Finland', 3, 358, 'FI', '🇫🇮'),
        ( 'Fiji', 5, 679, 'FJ', '🇫🇯'),
        ( 'Falkland Islands', 6, 500, 'FK', '🇫🇰'),
        ( 'Micronesia', 5, 691, 'FM', '🇫🇲'),
        ( 'Faroe Islands', 3, 298, 'FO', '🇫🇴'),
        ( 'France', 3, 33, 'FR', '🇫🇷'),
        ( 'Gabon', 1, 241, 'GA', '🇬🇦'),
        ( 'United Kingdom', 3, 44, 'GB', '🇬🇧'),
        ( 'Grenada', 4, 1473, 'GD', '🇬🇩'),
        ( 'Georgia', 2, 995, 'GE', '🇬🇪'),
        ( 'French Guiana', 6, 594, 'GF', '🇬🇫'),
        ( 'Guernsey', 3, 44, 'GG', '🇬🇬'),
        ( 'Ghana', 1, 233, 'GH', '🇬🇭'),
        ( 'Gibraltar', 3, 350, 'GI', '🇬🇮'),
        ( 'Greenland', 4, 299, 'GL', '🇬🇱'),
        ( 'Gambia', 1, 220, 'GM', '🇬🇲'),
        ( 'Guinea', 1, 224, 'GN', '🇬🇳'),
        ( 'Guadeloupe', 4, 590, 'GP', '🇬🇵'),
        ( 'Equatorial Guinea', 1, 240, 'GQ', '🇬🇶'),
        ( 'Greece', 3, 30, 'GR', '🇬🇷'),
        ( 'South Georgia and the South Sandwich Islands', 7, 500, 'GS', '🇬🇸'),
        ( 'Guatemala', 4, 502, 'GT', '🇬🇹'),
        ( 'Guam', 5, 1671, 'GU', '🇬🇺'),
        ( 'Guinea-Bissau', 1, 245, 'GW', '🇬🇼'),
        ( 'Guyana', 6, 592, 'GY', '🇬🇾'),
        ( 'Hong Kong', 2, 852, 'HK', '🇭🇰'),
        ( 'Heard Island and McDonald Islands', 7, 61, 'HM', '🇭🇲'),
        ( 'Honduras', 4, 504, 'HN', '🇭🇳'),
        ( 'Croatia', 3, 385, 'HR', '🇭🇷'),
        ( 'Haiti', 4, 509, 'HT', '🇭🇹'),
        ( 'Hungary', 3, 36, 'HU', '🇭🇺'),
        ( 'Indonesia', 2, 62, 'ID', '🇮🇩'),
        ( 'Ireland', 3, 353, 'IE', '🇮🇪'),
        ( 'Israel', 2, 972, 'IL', '🇮🇱'),
        ( 'Isle of Man', 3, 44, 'IM', '🇮🇲'),
        ( 'India', 2, 91, 'IN', '🇮🇳'),
        ( 'British Indian Ocean Territory', 2, 246, 'IO', '🇮🇴'),
        ( 'Iraq', 2, 964, 'IQ', '🇮🇶'),
        ( 'Iran', 2, 98, 'IR', '🇮🇷'),
        ( 'Iceland', 3, 354, 'IS', '🇮🇸'),
        ( 'Italy', 3, 39, 'IT', '🇮🇹'),
        ( 'Jersey', 3, 44, 'JE', '🇯🇪'),
        ( 'Jamaica', 4, 1876, 'JM', '🇯🇲'),
        ( 'Jordan', 2, 962, 'JO', '🇯🇴'),
        ( 'Japan', 2, 81, 'JP', '🇯🇵'),
        ( 'Kenya', 1, 254, 'KE', '🇰🇪'),
        ( 'Kyrgyzstan', 2, 996, 'KG', '🇰🇬'),
        ( 'Cambodia', 2, 855, 'KH', '🇰🇭'),
        ( 'Kiribati', 5, 686, 'KI', '🇰🇮'),
        ( 'Comoros', 1, 269, 'KM', '🇰🇲'),
        ( 'Saint Kitts and Nevis', 4, 1869, 'KN', '🇰🇳'),
        ( 'North Korea', 2, 850, 'KP', '🇰🇵'),
        ( 'South Korea', 2, 82, 'KR', '🇰🇷'),
        ( 'Kuwait', 2, 965, 'KW', '🇰🇼'),
        ( 'Cayman Islands', 4, 1345, 'KY', '🇰🇾'),
        ( 'Kazakhstan', 2, 7, 'KZ', '🇰🇿'),
        ( 'Laos', 2, 856, 'LA', '🇱🇦'),
        ( 'Lebanon', 2, 961, 'LB', '🇱🇧'),
        ( 'Saint Lucia', 4, 1758, 'LC', '🇱🇨'),
        ( 'Liechtenstein', 3, 423, 'LI', '🇱🇮'),
        ( 'Sri Lanka', 2, 94, 'LK', '🇱🇰'),
        ( 'Liberia', 1, 231, 'LR', '🇱🇷'),
        ( 'Lesotho', 1, 266, 'LS', '🇱🇸'),
        ( 'Lithuania', 3, 370, 'LT', '🇱🇹'),
        ( 'Luxembourg', 3, 352, 'LU', '🇱🇺'),
        ( 'Latvia', 3, 371, 'LV', '🇱🇻'),
        ( 'Libya', 1, 218, 'LY', '🇱🇾'),
        ( 'Morocco', 1, 212, 'MA', '🇲🇦'),
        ( 'Monaco', 3, 377, 'MC', '🇲🇨'),
        ( 'Moldova', 3, 373, 'MD', '🇲🇩'),
        ( 'Montenegro', 3, 382, 'ME', '🇲🇪'),
        ( 'Saint Martin', 4, 590, 'MF', '🇲🇫'),
        ( 'Madagascar', 1, 261, 'MG', '🇲🇬'),
        ( 'Marshall Islands', 5, 692, 'MH', '🇲🇭'),
        ( 'North Macedonia', 3, 389, 'MK', '🇲🇰'),
        ( 'Mali', 1, 223, 'ML', '🇲🇱'),
        ( 'Myanmar (Burma)', 2, 95, 'MM', '🇲🇲'),
        ( 'Mongolia', 2, 976, 'MN', '🇲🇳'),
        ( 'Macao', 2, 853, 'MO', '🇲🇴'),
        ( 'Northern Mariana Islands', 5, 1670, 'MP', '🇲🇵'),
        ( 'Martinique', 4, 596, 'MQ', '🇲🇶'),
        ( 'Mauritania', 1, 222, 'MR', '🇲🇷'),
        ( 'Montserrat', 4, 1664, 'MS', '🇲🇸'),
        ( 'Malta', 3, 356, 'MT', '🇲🇹'),
        ( 'Mauritius', 1, 230, 'MU', '🇲🇺'),
        ( 'Maldives', 2, 960, 'MV', '🇲🇻'),
        ( 'Malawi', 1, 265, 'MW', '🇲🇼'),
        ( 'Mexico', 4, 52, 'MX', '🇲🇽'),
        ( 'Malaysia', 2, 60, 'MY', '🇲🇾'),
        ( 'Mozambique', 1, 258, 'MZ', '🇲🇿'),
        ( 'Namibia', 1, 264, 'NA', '🇳🇦'),
        ( 'New Caledonia', 5, 687, 'NC', '🇳🇨'),
        ( 'Niger', 1, 227, 'NE', '🇳🇪'),
        ( 'Norfolk Island', 5, 672, 'NF', '🇳🇫'),
        ( 'Nigeria', 1, 234, 'NG', '🇳🇬'),
        ( 'Nicaragua', 4, 505, 'NI', '🇳🇮'),
        ( 'Netherlands', 3, 31, 'NL', '🇳🇱'),
        ( 'Norway', 3, 47, 'NO', '🇳🇴'),
        ( 'Nepal', 2, 977, 'NP', '🇳🇵'),
        ( 'Nauru', 5, 674, 'NR', '🇳🇷'),
        ( 'Niue', 5, 683, 'NU', '🇳🇺'),
        ( 'New Zealand', 5, 64, 'NZ', '🇳🇿'),
        ( 'Oman', 2, 968, 'OM', '🇴🇲'),
        ( 'Panama', 4, 507, 'PA', '🇵🇦'),
        ( 'Peru', 6, 51, 'PE', '🇵🇪'),
        ( 'French Polynesia', 5, 689, 'PF', '🇵🇫'),
        ( 'Papua New Guinea', 5, 675, 'PG', '🇵🇬'),
        ( 'Philippines', 2, 63, 'PH', '🇵🇭'),
        ( 'Pakistan', 2, 92, 'PK', '🇵🇰'),
        ( 'Poland', 3, 48, 'PL', '🇵🇱'),
        ( 'Saint Pierre and Miquelon', 4, 508, 'PM', '🇵🇲'),
        ( 'Pitcairn Islands', 5, 64, 'PN', '🇵🇳'),
        ( 'Puerto Rico', 4, 1787, 'PR', '🇵🇷'),
        ( 'Palestine', 2, 970, 'PS', '🇵🇸'),
        ( 'Portugal', 3, 351, 'PT', '🇵🇹'),
        ( 'Palau', 5, 680, 'PW', '🇵🇼'),
        ( 'Paraguay', 6, 595, 'PY', '🇵🇾'),
        ( 'Qatar', 2, 974, 'QA', '🇶🇦'),
        ( 'Reunion', 1, 262, 'RE', '🇷🇪'),
        ( 'Romania', 3, 40, 'RO', '🇷🇴'),
        ( 'Serbia', 3, 381, 'RS', '🇷🇸'),
        ( 'Russia', 2, 7, 'RU', '🇷🇺'),
        ( 'Rwanda', 1, 250, 'RW', '🇷🇼'),
        ( 'Saudi Arabia', 2, 966, 'SA', '🇸🇦'),
        ( 'Solomon Islands', 5, 677, 'SB', '🇸🇧'),
        ( 'Seychelles', 1, 248, 'SC', '🇸🇨'),
        ( 'Sudan', 1, 249, 'SD', '🇸🇩'),
        ( 'Sweden', 3, 46, 'SE', '🇸🇪'),
        ( 'Singapore', 2, 65, 'SG', '🇸🇬'),
        ( 'Saint Helena', 1, 290, 'SH', '🇸🇭'),
        ( 'Slovenia', 3, 386, 'SI', '🇸🇮'),
        ( 'Svalbard and Jan Mayen', 3, 4779, 'SJ', '🇸🇯'),
        ( 'Slovakia', 3, 421, 'SK', '🇸🇰'),
        ( 'Sierra Leone', 1, 232, 'SL', '🇸🇱'),
        ( 'San Marino', 3, 378, 'SM', '🇸🇲'),
        ( 'Senegal', 1, 221, 'SN', '🇸🇳'),
        ( 'Somalia', 1, 252, 'SO', '🇸🇴'),
        ( 'Suriname', 6, 597, 'SR', '🇸🇷'),
        ( 'South Sudan', 1, 211, 'SS', '🇸🇸'),
        ( 'Sao Tome and Principe', 1, 239, 'ST', '🇸🇹'),
        ( 'El Salvador', 4, 503, 'SV', '🇸🇻'),
        ( 'Sint Maarten', 4, 1721, 'SX', '🇸🇽'),
        ( 'Syria', 2, 963, 'SY', '🇸🇾'),
        ( 'Eswatini', 1, 268, 'SZ', '🇸🇿'),
        ( 'Turks and Caicos Islands', 4, 1649, 'TC', '🇹🇨'),
        ( 'Chad', 1, 235, 'TD', '🇹🇩'),
        ( 'French Southern Territories', 7, 262, 'TF', '🇹🇫'),
        ( 'Togo', 1, 228, 'TG', '🇹🇬'),
        ( 'Thailand', 2, 66, 'TH', '🇹🇭'),
        ( 'Tajikistan', 2, 992, 'TJ', '🇹🇯'),
        ( 'Tokelau', 5, 690, 'TK', '🇹🇰'),
        ( 'East Timor', 5, 670, 'TL', '🇹🇱'),
        ( 'Turkmenistan', 2, 993, 'TM', '🇹🇲'),
        ( 'Tunisia', 1, 216, 'TN', '🇹🇳'),
        ( 'Tonga', 5, 676, 'TO', '🇹🇴'),
        ( 'Turkey', 2, 90, 'TR', '🇹🇷'),
        ( 'Trinidad and Tobago', 4, 1868, 'TT', '🇹🇹'),
        ( 'Tuvalu', 5, 688, 'TV', '🇹🇻'),
        ( 'Taiwan', 2, 886, 'TW', '🇹🇼'),
        ( 'Tanzania', 1, 255, 'TZ', '🇹🇿'),
        ( 'Ukraine', 3, 380, 'UA', '🇺🇦'),
        ( 'Uganda', 1, 256, 'UG', '🇺🇬'),
        ( 'U.S. Minor Outlying Islands', 5, 1, 'UM', '🇺🇲'),
        ( 'United States', 4, 1, 'US', '🇺🇸'),
        ( 'Uruguay', 6, 598, 'UY', '🇺🇾'),
        ( 'Uzbekistan', 2, 998, 'UZ', '🇺🇿'),
        ( 'Vatican City', 3, 379, 'VA', '🇻🇦'),
        ( 'Saint Vincent and the Grenadines', 4, 1784, 'VC', '🇻🇨'),
        ( 'Venezuela', 6, 58, 'VE', '🇻🇪'),
        ( 'British Virgin Islands', 4, 1284, 'VG', '🇻🇬'),
        ( 'U.S. Virgin Islands', 4, 1340, 'VI', '🇻🇮'),
        ( 'Vietnam', 2, 84, 'VN', '🇻🇳'),
        ( 'Vanuatu', 5, 678, 'VU', '🇻🇺'),
        ( 'Wallis and Futuna', 5, 681, 'WF', '🇼🇫'),
        ( 'Samoa', 5, 685, 'WS', '🇼🇸'),
        ( 'Kosovo', 3, 377, 'XK', '🇽🇰'),
        ( 'Yemen', 2, 967, 'YE', '🇾🇪'),
        ( 'Mayotte', 1, 262, 'YT', '🇾🇹'),
        ( 'South Africa', 1, 27, 'ZA', '🇿🇦'),
        ( 'Zambia', 1, 260, 'ZM', '🇿🇲'),
        ( 'Zimbabwe', 1, 263, 'ZW', '🇿🇼');

CREATE TABLE `team` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL default '',
    `continent` int NOT NULL,
    `country` int NOT NULL,
    FOREIGN KEY (`continent`) REFERENCES continent(id) ON DELETE CASCADE,
    FOREIGN KEY (`country`) REFERENCES country(id) ON DELETE CASCADE,
    PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;

INSERT INTO `team` (`name`, `continent`, `country`)
    VALUES
		('Caesar Vance', 4, 168 ),
		('Cara Stevens', 4, 168 ),
		('Doris Wilder', 5, 169 ),
		('Herrod Chandler', 4, 168 ),
		('Martena Mccray', 3, 144 );


--
-- Reading list example table
--
DROP TABLE IF EXISTS audiobooks;

CREATE TABLE `audiobooks` (
    `id` int NOT NULL AUTO_INCREMENT,
    `title` varchar(250) NOT NULL,
    `author` varchar(250) NOT NULL,
    `duration` int NOT NULL,
    `readingOrder` int NOT NULL,
    PRIMARY KEY (`id`)
) AUTO_INCREMENT=1 CHARSET=utf8mb4;

INSERT INTO `audiobooks` (`title`, `author`, `duration`, `readingOrder`)
    VALUES
        ( 'The Final Empire: Mistborn', 'Brandon Sanderson', 1479, 1 ),
        ( 'The Name of the Wind', 'Patrick Rothfuss', 983, 2 ),
        ( 'The Blade Itself: The First Law', 'Joe Abercrombie', 1340, 3 ),
        ( 'The Heroes', 'Joe Abercrombie', 1390, 4 ),
        ( 'Assassin\'s Apprentice: The Farseer Trilogy', 'Robin Hobb', 1043, 5 ),
        ( 'The Eye of the World: Wheel of Time', 'Robert Jordan', 1802, 6 ),
        ( 'The Wise Man\'s Fear', 'Patrick Rothfuss', 1211, 7 ),
        ( 'The Way of Kings: The Stormlight Archive', 'Brandon Sanderson', 2734, 8 ),
        ( 'The Lean Startup', 'Eric Ries', 523, 9 ),
        ( 'House of Suns', 'Alastair Reynolds', 1096, 10 ),
        ( 'The Lies of Locke Lamora', 'Scott Lynch', 1323, 11 ),
        ( 'Best Served Cold', 'Joe Abercrombie', 1592, 12 ),
        ( 'Thinking, Fast and Slow', 'Daniel Kahneman', 1206, 13 ),
        ( 'The Dark Tower I: The Gunslinger', 'Stephen King', 439, 14 ),
        ( 'Theft of Swords: Riyria Revelations', 'Michael J. Sullivan', 1357, 15 ),
        ( 'The Emperor\'s Blades: Chronicle of the Unhewn Throne', 'Brian Staveley', 1126, 16 ),
        ( 'The Magic of Recluce: Saga of Recluce', 'L. E. Modesitt Jr.', 1153, 17 ),
        ( 'Red Country', 'Joe Abercrombie', 1196, 18 ),
        ( 'Warbreaker', 'Brandon Sanderson', 1496, 19 ),
        ( 'Magician', 'Raymond E. Feist', 2173, 20 ),
        ( 'Blood Song', 'Anthony Ryan', 1385, 21 ),
        ( 'Half a King', 'Joe Abercrombie', 565, 22 ),
        ( 'Prince of Thorns: Broken Empire', 'Mark Lawrence', 537, 23 ),
        ( 'The Immortal Prince: Tide Lords', 'Jennifer Fallon', 1164, 24 ),
        ( 'Medalon: Demon Child', 'Jennifer Fallon', 1039, 25 ),
        ( 'The Black Company: Chronicles of The Black Company', 'Glen Cook', 654, 26 );


--
-- Compound key examples
--
DROP TABLE IF EXISTS users_visits;

CREATE TABLE users_visits (
    user_id int NOT NULL,
    site_id int NOT NULL,
    visit_date date NOT NULL,
    PRIMARY KEY (user_id, visit_date)
) CHARSET=utf8mb4;


INSERT INTO `users_visits` (`user_id`, `site_id`, `visit_date`)
    VALUES
        ( 1, 1, '2016-08-12' ),
        ( 1, 4, '2016-08-14' ),
        ( 1, 7, '2016-08-19' ),
        ( 2, 3, '2016-07-12' ),
        ( 2, 2, '2016-07-07' ),
        ( 2, 6, '2016-07-01' ),
        ( 2, 1, '2016-07-30' ),
        ( 3, 1, '2016-06-26' ),
        ( 3, 2, '2016-12-05' ),
        ( 4, 3, '2016-11-21' ),
        ( 4, 4, '2016-10-10' ),
        ( 5, 5, '2016-08-02' ),
        ( 6, 6, '2016-08-05' );

--
-- DataTables Ajax and server-side processing database (MySQL)
--

DROP TABLE IF EXISTS `datatables_demo`;

CREATE TABLE `datatables_demo` (
	`id`         int(10) NOT NULL auto_increment,
	`first_name` varchar(250) NOT NULL default '',
	`last_name`  varchar(250) NOT NULL default '',
	`position`   varchar(250) NOT NULL default '',
	`email`      varchar(250) NOT NULL default '',
	`office`     varchar(250) NOT NULL default '',
	`start_date` datetime default NULL,
	`age`        int(8),
	`salary`     int(8),
	`seq`        int(8),
	`extn`       varchar(8) NOT NULL default '',
	PRIMARY KEY  (`id`),
	INDEX (`seq`)
);

INSERT INTO `datatables_demo`
		( id, first_name, last_name, age, position, salary, start_date, extn, email, office, seq ) 
	VALUES
		( 1, 'Tiger', 'Nixon', 61, 'System Architect', 320800, '2011-04-25', 5421, 't.nixon@datatables.net', 'Edinburgh', 2 ),
		( 2, 'Garrett', 'Winters', 63, 'Accountant', 170750, '2011-07-25', 8422, 'g.winters@datatables.net', 'Tokyo', 22 ),
		( 3, 'Ashton', 'Cox', 66, 'Junior Technical Author', 86000, '2009-01-12', 1562, 'a.cox@datatables.net', 'San Francisco', 6 ),
		( 4, 'Cedric', 'Kelly', 22, 'Senior Javascript Developer', 433060, '2012-03-29', 6224, 'c.kelly@datatables.net', 'Edinburgh', 41 ),
		( 5, 'Airi', 'Satou', 33, 'Accountant', 162700, '2008-11-28', 5407, 'a.satou@datatables.net', 'Tokyo', 55 ),
		( 6, 'Brielle', 'Williamson', 61, 'Integration Specialist', 372000, '2012-12-02', 4804, 'b.williamson@datatables.net', 'New York', 21 ),
		( 7, 'Herrod', 'Chandler', 59, 'Sales Assistant', 137500, '2012-08-06', 9608, 'h.chandler@datatables.net', 'San Francisco', 46 ),
		( 8, 'Rhona', 'Davidson', 55, 'Integration Specialist', 327900, '2010-10-14', 6200, 'r.davidson@datatables.net', 'Tokyo', 50 ),
		( 9, 'Colleen', 'Hurst', 39, 'Javascript Developer', 205500, '2009-09-15', 2360, 'c.hurst@datatables.net', 'San Francisco', 26 ),
		( 10, 'Sonya', 'Frost', 23, 'Software Engineer', 103600, '2008-12-13', 1667, 's.frost@datatables.net', 'Edinburgh', 18 ),
		( 11, 'Jena', 'Gaines', 30, 'Office Manager', 90560, '2008-12-19', 3814, 'j.gaines@datatables.net', 'London', 13 ),
		( 12, 'Quinn', 'Flynn', 22, 'Support Lead', 342000, '2013-03-03', 9497, 'q.flynn@datatables.net', 'Edinburgh', 23 ),
		( 13, 'Charde', 'Marshall', 36, 'Regional Director', 470600, '2008-10-16', 6741, 'c.marshall@datatables.net', 'San Francisco', 14 ),
		( 14, 'Haley', 'Kennedy', 43, 'Senior Marketing Designer', 313500, '2012-12-18', 3597, 'h.kennedy@datatables.net', 'London', 12 ),
		( 15, 'Tatyana', 'Fitzpatrick', 19, 'Regional Director', 385750, '2010-03-17', 1965, 't.fitzpatrick@datatables.net', 'London', 54 ),
		( 16, 'Michael', 'Silva', 66, 'Marketing Designer', 198500, '2012-11-27', 1581, 'm.silva@datatables.net', 'London', 37 ),
		( 17, 'Paul', 'Byrd', 64, 'Chief Financial Officer (CFO)', 725000, '2010-06-09', 3059, 'p.byrd@datatables.net', 'New York', 32 ),
		( 18, 'Gloria', 'Little', 59, 'Systems Administrator', 237500, '2009-04-10', 1721, 'g.little@datatables.net', 'New York', 35 ),
		( 19, 'Bradley', 'Greer', 41, 'Software Engineer', 132000, '2012-10-13', 2558, 'b.greer@datatables.net', 'London', 48 ),
		( 20, 'Dai', 'Rios', 35, 'Personnel Lead', 217500, '2012-09-26', 2290, 'd.rios@datatables.net', 'Edinburgh', 45 ),
		( 21, 'Jenette', 'Caldwell', 30, 'Development Lead', 345000, '2011-09-03', 1937, 'j.caldwell@datatables.net', 'New York', 17 ),
		( 22, 'Yuri', 'Berry', 40, 'Chief Marketing Officer (CMO)', 675000, '2009-06-25', 6154, 'y.berry@datatables.net', 'New York', 57 ),
		( 23, 'Caesar', 'Vance', 21, 'Pre-Sales Support', 106450, '2011-12-12', 8330, 'c.vance@datatables.net', 'New York', 29 ),
		( 24, 'Doris', 'Wilder', 23, 'Sales Assistant', 85600, '2010-09-20', 3023, 'd.wilder@datatables.net', 'Sydney', 56 ),
		( 25, 'Angelica', 'Ramos', 47, 'Chief Executive Officer (CEO)', 1200000, '2009-10-09', 5797, 'a.ramos@datatables.net', 'London', 36 ),
		( 26, 'Gavin', 'Joyce', 42, 'Developer', 92575, '2010-12-22', 8822, 'g.joyce@datatables.net', 'Edinburgh', 5 ),
		( 27, 'Jennifer', 'Chang', 28, 'Regional Director', 357650, '2010-11-14', 9239, 'j.chang@datatables.net', 'Singapore', 51 ),
		( 28, 'Brenden', 'Wagner', 28, 'Software Engineer', 206850, '2011-06-07', 1314, 'b.wagner@datatables.net', 'San Francisco', 20 ),
		( 29, 'Fiona', 'Green', 48, 'Chief Operating Officer (COO)', 850000, '2010-03-11', 2947, 'f.green@datatables.net', 'San Francisco', 7 ),
		( 30, 'Shou', 'Itou', 20, 'Regional Marketing', 163000, '2011-08-14', 8899, 's.itou@datatables.net', 'Tokyo', 1 ),
		( 31, 'Michelle', 'House', 37, 'Integration Specialist', 95400, '2011-06-02', 2769, 'm.house@datatables.net', 'Sydney', 39 ),
		( 32, 'Suki', 'Burks', 53, 'Developer', 114500, '2009-10-22', 6832, 's.burks@datatables.net', 'London', 40 ),
		( 33, 'Prescott', 'Bartlett', 27, 'Technical Author', 145000, '2011-05-07', 3606, 'p.bartlett@datatables.net', 'London', 47 ),
		( 34, 'Gavin', 'Cortez', 22, 'Team Leader', 235500, '2008-10-26', 2860, 'g.cortez@datatables.net', 'San Francisco', 52 ),
		( 35, 'Martena', 'Mccray', 46, 'Post-Sales support', 324050, '2011-03-09', 8240, 'm.mccray@datatables.net', 'Edinburgh', 8 ),
		( 36, 'Unity', 'Butler', 47, 'Marketing Designer', 85675, '2009-12-09', 5384, 'u.butler@datatables.net', 'San Francisco', 24 ),
		( 37, 'Howard', 'Hatfield', 51, 'Office Manager', 164500, '2008-12-16', 7031, 'h.hatfield@datatables.net', 'San Francisco', 38 ),
		( 38, 'Hope', 'Fuentes', 41, 'Secretary', 109850, '2010-02-12', 6318, 'h.fuentes@datatables.net', 'San Francisco', 53 ),
		( 39, 'Vivian', 'Harrell', 62, 'Financial Controller', 452500, '2009-02-14', 9422, 'v.harrell@datatables.net', 'San Francisco', 30 ),
		( 40, 'Timothy', 'Mooney', 37, 'Office Manager', 136200, '2008-12-11', 7580, 't.mooney@datatables.net', 'London', 28 ),
		( 41, 'Jackson', 'Bradshaw', 65, 'Director', 645750, '2008-09-26', 1042, 'j.bradshaw@datatables.net', 'New York', 34 ),
		( 42, 'Olivia', 'Liang', 64, 'Support Engineer', 234500, '2011-02-03', 2120, 'o.liang@datatables.net', 'Singapore', 4 ),
		( 43, 'Bruno', 'Nash', 38, 'Software Engineer', 163500, '2011-05-03', 6222, 'b.nash@datatables.net', 'London', 3 ),
		( 44, 'Sakura', 'Yamamoto', 37, 'Support Engineer', 139575, '2009-08-19', 9383, 's.yamamoto@datatables.net', 'Tokyo', 31 ),
		( 45, 'Thor', 'Walton', 61, 'Developer', 98540, '2013-08-11', 8327, 't.walton@datatables.net', 'New York', 11 ),
		( 46, 'Finn', 'Camacho', 47, 'Support Engineer', 87500, '2009-07-07', 2927, 'f.camacho@datatables.net', 'San Francisco', 10 ),
		( 47, 'Serge', 'Baldwin', 64, 'Data Coordinator', 138575, '2012-04-09', 8352, 's.baldwin@datatables.net', 'Singapore', 44 ),
		( 48, 'Zenaida', 'Frank', 63, 'Software Engineer', 125250, '2010-01-04', 7439, 'z.frank@datatables.net', 'New York', 42 ),
		( 49, 'Zorita', 'Serrano', 56, 'Software Engineer', 115000, '2012-06-01', 4389, 'z.serrano@datatables.net', 'San Francisco', 27 ),
		( 50, 'Jennifer', 'Acosta', 43, 'Junior Javascript Developer', 75650, '2013-02-01', 3431, 'j.acosta@datatables.net', 'Edinburgh', 49 ),
		( 51, 'Cara', 'Stevens', 46, 'Sales Assistant', 145600, '2011-12-06', 3990, 'c.stevens@datatables.net', 'New York', 15 ),
		( 52, 'Hermione', 'Butler', 47, 'Regional Director', 356250, '2011-03-21', 1016, 'h.butler@datatables.net', 'London', 9 ),
		( 53, 'Lael', 'Greer', 21, 'Systems Administrator', 103500, '2009-02-27', 6733, 'l.greer@datatables.net', 'London', 25 ),
		( 54, 'Jonas', 'Alexander', 30, 'Developer', 86500, '2010-07-14', 8196, 'j.alexander@datatables.net', 'San Francisco', 33 ),
		( 55, 'Shad', 'Decker', 51, 'Regional Director', 183000, '2008-11-13', 6373, 's.decker@datatables.net', 'Edinburgh', 43 ),
		( 56, 'Michael', 'Bruce', 29, 'Javascript Developer', 183000, '2011-06-27', 5384, 'm.bruce@datatables.net', 'Singapore', 16 ),
		( 57, 'Donna', 'Snider', 27, 'Customer Support', 112000, '2011-01-25', 4226, 'd.snider@datatables.net', 'New York', 19 );