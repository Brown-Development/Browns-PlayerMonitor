CREATE TABLE IF NOT EXISTS `monitored_players` (
  `player_identifier` varchar(255) DEFAULT NULL,
  `admin_responsible` varchar(255) DEFAULT NULL,
  `time_added` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE IF NOT EXISTS `monitored_player_logs` (
  `player_identifier` varchar(255) DEFAULT NULL,
  `time_logged` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `log_number` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`log_number`),
  KEY `log_number` (`log_number`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
