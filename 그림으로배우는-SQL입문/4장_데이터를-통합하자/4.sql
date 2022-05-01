INSERT INTO `test_db`.`inquiry_location` (`id`, `pref`, `age`, `start`) VALUES ('1', '서울시', '20', '2');
INSERT INTO `test_db`.`inquiry_location` (`id`, `pref`, `age`, `start`) VALUES ('2', '충청도', '30', '5');
INSERT INTO `test_db`.`inquiry_location` (`id`, `pref`, `age`, `start`) VALUES ('3', '경기도', '40', '3');
INSERT INTO `test_db`.`inquiry_location` (`id`, `pref`, `age`, `start`) VALUES ('4', '충청도', '20', '4');
INSERT INTO `test_db`.`inquiry_location` (`id`, `pref`, `age`, `start`) VALUES ('5', '서울시', '30', '4');
INSERT INTO `test_db`.`inquiry_location` (`id`, `pref`, `age`, `start`) VALUES ('6', '서울시', '20', '1');

-- table name 변경
ALTER TABLE `test_db`.`inquery_location` 
RENAME TO  `test_db`.`inquiry_location` ;
