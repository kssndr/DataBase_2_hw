
CREATE DATABASE geodata;
USE geodata;
SOURCE /Users/mac/Desktop/Database/Lesson2/tables.sql;
SOURCE /Users/mac/Desktop/Database/Lesson2/ _countries.sql;
SOURCE /Users/mac/Desktop/Database/Lesson2/_regions.sql;
SOURCE /Users/mac/Desktop/Database/Lesson2/_cities.sql;
DESCRIBE _countries;
ALTER TABLE _countries DROP title_ua, DROP title_be, DROP title_en, DROP title_es, DROP title_pt, DROP title_de, DROP title_fr, DROP title_it, 
DROP title_pl, DROP title_ja, DROP title_lt, DROP title_lv, DROP title_cz;
ALTER TABLE _countries CHANGE COLUMN `country_id` id INT;
ALTER TABLE _countries MODIFY id INT NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (id);
ALTER TABLE _countries CHANGE COLUMN `title_ru` title VARCHAR(150);
ALTER TABLE _countries MODIFY title VARCHAR (150) NOT NULL;
ALTER TABLE _countries ADD INDEX (title);
DESCRIBE _regions;
ALTER TABLE _regions DROP title_ua, DROP title_be, DROP title_en, DROP title_es, DROP title_pt, DROP title_de, DROP title_fr, DROP title_it, 
DROP title_pl, DROP title_ja, DROP title_lt, DROP title_lv, DROP title_cz;
ALTER TABLE _regions CHANGE COLUMN `region_id` id INT;
ALTER TABLE _regions MODIFY id INT NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (id);
ALTER TABLE _regions CHANGE COLUMN `title_ru` title VARCHAR(150);
ALTER TABLE _regions MODIFY title VARCHAR (150) NOT NULL;
ALTER TABLE _regions ADD INDEX (title);
ALTER TABLE _regions ADD FOREIGN KEY (country_id) REFERENCES _countries (id);
DESCRIBE _cities;
ALTER TABLE _cities DROP area_ru, DROP area_ua, DROP area_be, DROP area_en, DROP area_es, DROP area_pt, DROP area_de, DROP area_fr, DROP area_it, 
DROP area_pl, DROP area_ja, DROP area_lt, DROP area_lv, DROP area_cz;
ALTER TABLE _cities DROP region_ua, DROP region_ru, DROP region_be, DROP region_en, DROP region_es, DROP region_pt, 
DROP region_de, DROP region_fr, DROP region_it, DROP region_pl, DROP region_ja, DROP region_lt, DROP region_lv, DROP region_cz;
ALTER TABLE _cities DROP title_ua, DROP title_be, DROP title_en, DROP title_es, DROP title_pt, DROP title_de, DROP title_fr, DROP title_it, 
DROP title_pl, DROP title_ja, DROP title_lt, DROP title_lv, DROP title_cz;
ALTER TABLE _cities CHANGE COLUMN `title_ru` title VARCHAR(150) NOT NULL;
ALTER TABLE _cities ADD INDEX (title);
ALTER TABLE `_cities` ADD FOREIGN KEY (`country_id`) REFERENCES `_countries` (`id`);
ALTER TABLE `_cities` ADD FOREIGN KEY (`region_id`) REFERENCES `_regions` (`id`);
ALTER TABLE _cities CHANGE COLUMN `city_id` id INT;
ALTER TABLE _cities MODIFY id INT NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (id);
