
CREATE TABLE `meter_readings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `version` tinyint(4) DEFAULT NULL,
  `send_at` datetime NOT NULL,
  `meter_in_normal` double NOT NULL,
  `meter_in_low` double NOT NULL,
  `power_in` double NOT NULL,
  `l1` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
