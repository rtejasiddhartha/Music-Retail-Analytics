SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO country (country_id,country_name)
Values (1,'Canada'),
(2,'United States');

INSERT INTO province (province_id, province_name, country_id) VALUES
(1, 'Alberta', 1),
(2, 'British Columbia', 1),
(3, 'Manitoba', 1),
(4, 'New Brunswick', 1),
(5, 'Newfoundland and Labrador', 1),
(6, 'Northwest Territories', 1),
(7, 'Nova Scotia', 1),
(8, 'Nunavut', 1),
(9, 'Ontario', 1),
(10, 'Prince Edward Island', 1),
(11, 'Quebec', 1),
(12, 'Saskatchewan', 1),
(13, 'Yukon', 1),
(14, 'Alabama', 2),
(15, 'Alaska', 2),
(16, 'Arizona', 2),
(17, 'Arkansas', 2),
(18, 'California', 2),
(19, 'Colorado', 2),
(20, 'Connecticut', 2),
(21, 'Delaware', 2),
(22, 'Florida', 2),
(23, 'Georgia', 2),
(24, 'Hawaii', 2),
(25, 'Idaho', 2),
(26, 'Illinois', 2),
(27, 'Indiana', 2),
(28, 'Iowa', 2),
(29, 'Kansas', 2),
(30, 'Kentucky', 2),
(31, 'Louisiana', 2),
(32, 'Maine', 2),
(33, 'Maryland', 2),
(34, 'Massachusetts', 2),
(35, 'Michigan', 2),
(36, 'Minnesota', 2),
(37, 'Mississippi', 2),
(38, 'Missouri', 2),
(39, 'Montana', 2),
(40, 'Nebraska', 2),
(41, 'Nevada', 2),
(42, 'New Hampshire', 2),
(43, 'New Jersey', 2),
(44, 'New Mexico', 2),
(45, 'New York', 2),
(46, 'North Carolina', 2),
(47, 'North Dakota', 2),
(48, 'Ohio', 2),
(49, 'Oklahoma', 2),
(50, 'Oregon', 2),
(51, 'Pennsylvania', 2),
(52, 'Rhode Island', 2),
(53, 'South Carolina', 2),
(54, 'South Dakota', 2),
(55, 'Tennessee', 2),
(56, 'Texas', 2),
(57, 'Utah', 2),
(58, 'Vermont', 2),
(59, 'Virginia', 2),
(60, 'Washington', 2),
(61, 'West Virginia', 2),
(62, 'Wisconsin', 2),
(63, 'Wyoming', 2),
(64, 'District of Columbia', 2);

ALTER TABLE city
DROP INDEX city_name_UNIQUE;

ALTER TABLE city
ADD UNIQUE INDEX uq_city_province (city_name, province_id);

INSERT INTO city (city_id, city_name, province_id) VALUES
(1,'Calgary',1),
(2,'Edmonton',1),
(3,'Red Deer',1),
(4,'Lethbridge',1),
(5,'Medicine Hat',1),
(6,'Airdrie',1),
(7,'Cochrane',1),
(8,'Okotoks',1),
(9,'Fort McMurray',1),
(10,'Spruce Grove',1);

INSERT INTO city (city_id, city_name, province_id) VALUES
(11,'Vancouver',2),
(12,'Surrey',2),
(13,'Burnaby',2),
(14,'Richmond',2),
(15,'Coquitlam',2),
(16,'New Westminster',2),
(17,'North Vancouver',2),
(18,'West Vancouver',2),
(19,'Delta',2),
(20,'Langley',2),
(21,'Abbotsford',2),
(22,'Chilliwack',2);

INSERT INTO city (city_id, city_name, province_id) VALUES
(23,'Winnipeg',3),
(24,'Brandon',3),
(25,'Steinbach',3),
(26,'Portage la Prairie',3),
(27,'Selkirk',3),
(28,'Thompson',3);

INSERT INTO city (city_id, city_name, province_id) VALUES
(29,'Moncton',4),
(30,'Saint John',4),
(31,'Fredericton',4),
(32,'Dieppe',4),
(33,'Miramichi',4);

INSERT INTO city (city_id, city_name, province_id) VALUES
(34,'St. John''s',5),
(35,'Mount Pearl',5),
(36,'Corner Brook',5),
(37,'Gander',5),
(38,'Grand Falls-Windsor',5);

INSERT INTO city (city_id, city_name, province_id) VALUES
(39,'Yellowknife',6);

INSERT INTO city (city_id, city_name, province_id) VALUES
(40,'Halifax',7),
(41,'Dartmouth',7),
(42,'Sydney',7),
(43,'Truro',7),
(44,'New Glasgow',7),
(45,'Kentville',7);

INSERT INTO city (city_id, city_name, province_id) VALUES
(46,'Iqaluit',8);

INSERT INTO city (city_id, city_name, province_id) VALUES
(47,'Toronto',9),
(48,'Mississauga',9),
(49,'Brampton',9),
(50,'Hamilton',9),
(51,'London',9),
(52,'Kitchener',9),
(53,'Waterloo',9),
(54,'Guelph',9),
(55,'Cambridge',9),
(56,'Oakville',9),
(57,'Burlington',9),
(58,'Milton',9),
(59,'Markham',9),
(60,'Vaughan',9),
(61,'Richmond Hill',9);

INSERT INTO city (city_id, city_name, province_id) VALUES
(62,'Charlottetown',10),
(63,'Summerside',10),
(64,'Stratford',10),
(65,'Cornwall',10);

INSERT INTO city (city_id, city_name, province_id) VALUES
(66,'Montreal',11),
(67,'Laval',11),
(68,'Longueuil',11),
(69,'Quebec City',11),
(70,'Sherbrooke',11),
(71,'Trois-Rivieres',11),
(72,'Gatineau',11),
(73,'Brossard',11),
(74,'Drummondville',11),
(75,'Granby',11);

INSERT INTO city (city_id, city_name, province_id) VALUES
(76,'Saskatoon',12),
(77,'Regina',12),
(78,'Prince Albert',12),
(79,'Moose Jaw',12),
(80,'Yorkton',12);

INSERT INTO city (city_id, city_name, province_id) VALUES
(81,'Whitehorse',13);

INSERT INTO city (city_id, city_name, province_id) VALUES
(82,'Birmingham',14),
(83,'Montgomery',14),
(84,'Mobile',14),
(85,'Huntsville',14),
(86,'Tuscaloosa',14);

INSERT INTO city (city_id, city_name, province_id) VALUES
(87,'Anchorage',15),
(88,'Fairbanks',15),
(89,'Juneau',15);

INSERT INTO city (city_id, city_name, province_id) VALUES
(90,'Phoenix',16),
(91,'Tucson',16),
(92,'Mesa',16),
(93,'Chandler',16),
(94,'Scottsdale',16),
(95,'Tempe',16);

INSERT INTO city (city_id, city_name, province_id) VALUES
(96,'Little Rock',17),
(97,'Fayetteville',17),
(98,'Fort Smith',17),
(99,'Springdale',17);

INSERT INTO city (city_id, city_name, province_id) VALUES
(100,'Los Angeles',18),
(101,'San Diego',18),
(102,'San Jose',18),
(103,'San Francisco',18),
(104,'Oakland',18),
(105,'Berkeley',18),
(106,'Palo Alto',18),
(107,'Mountain View',18),
(108,'Sunnyvale',18),
(109,'Santa Clara',18),
(110,'Sacramento',18),
(111,'Fremont',18),
(112,'Irvine',18),
(113,'Pasadena',18),
(114,'Santa Monica',18);

INSERT INTO city (city_id, city_name, province_id) VALUES
(115,'Denver',19),
(116,'Aurora',19),
(117,'Boulder',19),
(118,'Fort Collins',19),
(119,'Lakewood',19),
(120,'Colorado Springs',19);

INSERT INTO city (city_id, city_name, province_id) VALUES

-- Connecticut (20)
(121,'Bridgeport',20),(122,'New Haven',20),(123,'Stamford',20),(124,'Hartford',20),(125,'Waterbury',20),

-- Delaware (21)
(126,'Wilmington',21),(127,'Dover',21),(128,'Newark',21),(129,'Middletown',21),

-- Florida (22)
(130,'Miami',22),(131,'Orlando',22),(132,'Tampa',22),(133,'St. Petersburg',22),
(134,'Jacksonville',22),(135,'Fort Lauderdale',22),(136,'Hollywood',22),(137,'Boca Raton',22),

-- Georgia (23)
(138,'Atlanta',23),(139,'Decatur',23),(140,'Marietta',23),(141,'Alpharetta',23),
(142,'Sandy Springs',23),(143,'Roswell',23),

-- Hawaii (24)
(144,'Honolulu',24),(145,'Hilo',24),(146,'Kailua',24),(147,'Kapolei',24),

-- Idaho (25)
(148,'Boise',25),(149,'Meridian',25),(150,'Nampa',25),(151,'Idaho Falls',25),

-- Illinois (26)
(152,'Chicago',26),(153,'Naperville',26),(154,'Aurora',26),(155,'Evanston',26),
(156,'Schaumburg',26),(157,'Oak Park',26),

-- Indiana (27)
(158,'Indianapolis',27),(159,'Fort Wayne',27),(160,'Evansville',27),(161,'South Bend',27),

-- Iowa (28)
(162,'Des Moines',28),(163,'Cedar Rapids',28),(164,'Davenport',28),(165,'Sioux City',28),(166,'Iowa City',28),

-- Kansas (29)
(167,'Wichita',29),(168,'Overland Park',29),(169,'Kansas City',29),(170,'Olathe',29),(171,'Topeka',29),

-- Kentucky (30)
(172,'Louisville',30),(173,'Lexington',30),(174,'Bowling Green',30),(175,'Owensboro',30),

-- Louisiana (31)
(176,'New Orleans',31),(177,'Baton Rouge',31),(178,'Shreveport',31),(179,'Lafayette',31),(180,'Lake Charles',31),

-- Maine (32)
(181,'Portland',32),(182,'Lewiston',32),(183,'Bangor',32),(184,'Augusta',32),

-- Maryland (33)
(185,'Baltimore',33),(186,'Rockville',33),(187,'Gaithersburg',33),(188,'Bethesda',33),(189,'Silver Spring',33),

-- Massachusetts (34)
(190,'Boston',34),(191,'Cambridge',34),(192,'Somerville',34),(193,'Brookline',34),
(194,'Newton',34),(195,'Quincy',34),

-- Michigan (35)
(196,'Detroit',35),(197,'Grand Rapids',35),(198,'Ann Arbor',35),(199,'Lansing',35),(200,'Flint',35),

-- Minnesota (36)
(201,'Minneapolis',36),(202,'St. Paul',36),(203,'Bloomington',36),(204,'Duluth',36),

-- Mississippi (37)
(205,'Jackson',37),(206,'Gulfport',37),(207,'Hattiesburg',37),(208,'Biloxi',37),

-- Missouri (38)
(209,'St. Louis',38),(210,'Kansas City',38),(211,'Springfield',38),(212,'Columbia',38),(213,'Independence',38),

-- Montana (39)
(214,'Billings',39),(215,'Missoula',39),(216,'Bozeman',39),

-- Nebraska (40)
(217,'Omaha',40),(218,'Lincoln',40),(219,'Bellevue',40),(220,'Grand Island',40),

-- Nevada (41)
(221,'Las Vegas',41),(222,'Henderson',41),(223,'Reno',41),(224,'Carson City',41),

-- New Hampshire (42)
(225,'Manchester',42),(226,'Nashua',42),(227,'Concord',42),(228,'Derry',42),

-- New Jersey (43)
(229,'Newark',43),(230,'Jersey City',43),(231,'Paterson',43),(232,'Elizabeth',43),(233,'Edison',43),

-- New Mexico (44)
(234,'Albuquerque',44),(235,'Santa Fe',44),(236,'Las Cruces',44),(237,'Rio Rancho',44),

-- New York (45)
(238,'New York City',45),(239,'Brooklyn',45),(240,'Queens',45),(241,'Bronx',45),
(242,'Manhattan',45),(243,'Buffalo',45),(244,'Rochester',45),(245,'Albany',45),

-- North Carolina (46)
(246,'Charlotte',46),(247,'Raleigh',46),(248,'Durham',46),(249,'Chapel Hill',46),(250,'Greensboro',46),

-- North Dakota (47)
(251,'Fargo',47),(252,'Bismarck',47),(253,'Grand Forks',47),

-- Ohio (48)
(254,'Columbus',48),(255,'Cleveland',48),(256,'Cincinnati',48),(257,'Dayton',48),(258,'Toledo',48),

-- Oklahoma (49)
(259,'Oklahoma City',49),(260,'Tulsa',49),(261,'Norman',49),(262,'Broken Arrow',49),

-- Oregon (50)
(263,'Portland',50),(264,'Eugene',50),(265,'Salem',50),(266,'Beaverton',50),

-- Pennsylvania (51)
(267,'Philadelphia',51),(268,'Pittsburgh',51),(269,'Allentown',51),(270,'Bethlehem',51),(271,'Scranton',51),

-- Rhode Island (52)
(272,'Providence',52),(273,'Cranston',52),(274,'Warwick',52),(275,'Pawtucket',52),

-- South Carolina (53)
(276,'Charleston',53),(277,'Columbia',53),(278,'Greenville',53),(279,'Spartanburg',53),

-- South Dakota (54)
(280,'Sioux Falls',54),(281,'Rapid City',54),(282,'Brookings',54),

-- Tennessee (55)
(283,'Nashville',55),(284,'Memphis',55),(285,'Knoxville',55),(286,'Chattanooga',55),(287,'Clarksville',55),

-- Texas (56)
(288,'Houston',56),(289,'Dallas',56),(290,'Austin',56),(291,'San Antonio',56),
(292,'Fort Worth',56),(293,'Plano',56),(294,'Irving',56),(295,'Arlington',56),

-- Utah (57)
(296,'Salt Lake City',57),(297,'Provo',57),(298,'Orem',57),(299,'Ogden',57),

-- Vermont (58)
(300,'Burlington',58),(301,'South Burlington',58),(302,'Rutland',58),

-- Virginia (59)
(303,'Richmond',59),(304,'Norfolk',59),(305,'Virginia Beach',59),(306,'Alexandria',59),(307,'Arlington',59),

-- Washington (60)
(308,'Seattle',60),(309,'Bellevue',60),(310,'Redmond',60),(311,'Tacoma',60),(312,'Everett',60),

-- West Virginia (61)
(313,'Charleston',61),(314,'Huntington',61),(315,'Morgantown',61),

-- Wisconsin (62)
(316,'Milwaukee',62),(317,'Madison',62),(318,'Green Bay',62),(319,'Kenosha',62),

-- Wyoming (63)
(320,'Cheyenne',63),(321,'Casper',63),(322,'Laramie',63),

-- District of Columbia (64)
(323,'Washington',64);

SET FOREIGN_KEY_CHECKS = 1;

-- Verify country master list
SELECT country_id, country_name
FROM country;

-- Check number of provinces per country
SELECT 
    c.country_name,
    COUNT(p.province_id) AS province_count
FROM country c
LEFT JOIN province p ON c.country_id = p.country_id
GROUP BY c.country_name;

-- Provinces that currently have no cities
SELECT 
    p.province_id,
    p.province_name,
    c.country_name
FROM province p
LEFT JOIN city ci ON p.province_id = ci.province_id
JOIN country c ON p.country_id = c.country_id
WHERE ci.city_id IS NULL
ORDER BY c.country_name, p.province_name;

-- Number of cities per province/state
SELECT 
    p.province_name,
    COUNT(ci.city_id) AS city_count
FROM province p
LEFT JOIN city ci ON p.province_id = ci.province_id
GROUP BY p.province_name
ORDER BY city_count DESC;

-- Same city names in different provinces/states
SELECT 
    city_name,
    COUNT(DISTINCT province_id) AS province_count
FROM city
GROUP BY city_name
HAVING COUNT(DISTINCT province_id) > 1
ORDER BY province_count DESC;

-- Duplicate city names within the same province (should return ZERO rows)
SELECT 
    city_name,
    province_id,
    COUNT(*) AS cnt
FROM city
GROUP BY city_name, province_id
HAVING COUNT(*) > 1;
