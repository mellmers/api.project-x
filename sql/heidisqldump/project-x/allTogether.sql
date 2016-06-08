-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.13-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win32
-- HeidiSQL Version:             9.3.0.5083
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for project-x
DROP DATABASE IF EXISTS `project-x`;
CREATE DATABASE IF NOT EXISTS `project-x` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `project-x`;

-- Dumping structure for table project-x.bet
DROP TABLE IF EXISTS `bet`;
CREATE TABLE IF NOT EXISTS `bet` (
  `user_id` int(11) unsigned NOT NULL,
  `lobby_id` int(11) unsigned NOT NULL,
  `amount` int(11) NOT NULL,
  `team` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`lobby_id`),
  KEY `fk_bet_lobby1_idx` (`lobby_id`),
  CONSTRAINT `fk_bet_lobby1` FOREIGN KEY (`lobby_id`) REFERENCES `lobby` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_bet_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table project-x.bet: ~6 rows (approximately)
DELETE FROM `bet`;
/*!40000 ALTER TABLE `bet` DISABLE KEYS */;
INSERT INTO `bet` (`user_id`, `lobby_id`, `amount`, `team`) VALUES
	(1, 1, 500, 1),
	(1, 2, 500, 1),
	(2, 1, 500, 2),
	(2, 3, 500, 1),
	(3, 2, 500, 2),
	(3, 3, 500, 2);
/*!40000 ALTER TABLE `bet` ENABLE KEYS */;

-- Dumping structure for table project-x.game
DROP TABLE IF EXISTS `game`;
CREATE TABLE IF NOT EXISTS `game` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `typ` varchar(45) NOT NULL,
  `logoData` longblob,
  `logoType` varchar(20) NOT NULL,
  `rules` text NOT NULL,
  `genre` varchar(100) NOT NULL,
  `timelimit` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`logoType`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_game_img_type1_idx` (`logoType`),
  CONSTRAINT `fk_game_img_type1` FOREIGN KEY (`logoType`) REFERENCES `img_type` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Dumping data for table project-x.game: ~4 rows (approximately)
DELETE FROM `game`;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;
INSERT INTO `game` (`id`, `name`, `typ`, `logoData`, `logoType`, `rules`, `genre`, `timelimit`) VALUES
	(1, 'League of Legends', '1vs1', NULL, 'bmp', '', 'MOBA', '2016-05-28 21:34:36'),
	(2, 'Counter Strike Global Offensive', '1vs1', NULL, 'bmp', '', 'Shooter', '2016-05-28 21:35:11'),
	(3, 'Overwatch', '1vs1', NULL, 'bmp', '', 'Shooter', '2016-05-28 21:35:40'),
	(4, 'Overwatch', '6vs6', NULL, 'bmp', '', 'Shooter', '2016-05-28 21:36:02');
/*!40000 ALTER TABLE `game` ENABLE KEYS */;

-- Dumping structure for table project-x.gameaccount
DROP TABLE IF EXISTS `gameaccount`;
CREATE TABLE IF NOT EXISTS `gameaccount` (
  `user_id` int(11) unsigned NOT NULL,
  `_type` varchar(200) NOT NULL,
  `userIdentifier` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`_type`),
  KEY `fk_gameaccount_gameaccount_types1_idx` (`_type`),
  CONSTRAINT `fk_gameaccount_gameaccount_types1` FOREIGN KEY (`_type`) REFERENCES `gameaccount_type` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_gameaccount_user1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table project-x.gameaccount: ~5 rows (approximately)
DELETE FROM `gameaccount`;
/*!40000 ALTER TABLE `gameaccount` DISABLE KEYS */;
INSERT INTO `gameaccount` (`user_id`, `_type`, `userIdentifier`) VALUES
	(1, 'battle.net', 'dorbird#2378'),
	(1, 'League of Legends', 'BIRDTheBest'),
	(1, 'Origin', 'dorbird'),
	(1, 'Steam', 'dor_bird'),
	(1, 'Uplay', 'dorbird');
/*!40000 ALTER TABLE `gameaccount` ENABLE KEYS */;

-- Dumping structure for table project-x.gameaccount_type
DROP TABLE IF EXISTS `gameaccount_type`;
CREATE TABLE IF NOT EXISTS `gameaccount_type` (
  `name` varchar(200) NOT NULL,
  `icondata` longblob,
  `iconType` varchar(20) NOT NULL,
  PRIMARY KEY (`name`,`iconType`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `fk_gameaccount_type_img_type1_idx` (`iconType`),
  CONSTRAINT `fk_gameaccount_type_img_type1` FOREIGN KEY (`iconType`) REFERENCES `img_type` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table project-x.gameaccount_type: ~5 rows (approximately)
DELETE FROM `gameaccount_type`;
/*!40000 ALTER TABLE `gameaccount_type` DISABLE KEYS */;
INSERT INTO `gameaccount_type` (`name`, `icondata`, `iconType`) VALUES
	('battle.net', NULL, 'bmp'),
	('League of Legends', NULL, 'bmp'),
	('Origin', NULL, 'bmp'),
	('Steam', NULL, 'bmp'),
	('Uplay', NULL, 'bmp');
/*!40000 ALTER TABLE `gameaccount_type` ENABLE KEYS */;

-- Dumping structure for table project-x.img_type
DROP TABLE IF EXISTS `img_type`;
CREATE TABLE IF NOT EXISTS `img_type` (
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table project-x.img_type: ~4 rows (approximately)
DELETE FROM `img_type`;
/*!40000 ALTER TABLE `img_type` DISABLE KEYS */;
INSERT INTO `img_type` (`name`) VALUES
	('bmp'),
	('gif'),
	('jpeg'),
	('png');
/*!40000 ALTER TABLE `img_type` ENABLE KEYS */;

-- Dumping structure for table project-x.lobby
DROP TABLE IF EXISTS `lobby`;
CREATE TABLE IF NOT EXISTS `lobby` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) unsigned NOT NULL,
  `game_id` int(11) unsigned NOT NULL,
  `winnerteam` int(11) DEFAULT NULL,
  `screenshotData` longblob,
  `screenshotType` varchar(20) NOT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `starttime` varchar(45) DEFAULT NULL,
  `endtime` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`,`screenshotType`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_lobby_game1_idx` (`game_id`),
  KEY `fk_lobby_user1_idx` (`owner_id`),
  KEY `fk_lobby_img_type1_idx` (`screenshotType`),
  CONSTRAINT `fk_lobby_game1` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_lobby_img_type1` FOREIGN KEY (`screenshotType`) REFERENCES `img_type` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_lobby_user1` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table project-x.lobby: ~3 rows (approximately)
DELETE FROM `lobby`;
/*!40000 ALTER TABLE `lobby` DISABLE KEYS */;
INSERT INTO `lobby` (`id`, `owner_id`, `game_id`, `winnerteam`, `screenshotData`, `screenshotType`, `createdAt`, `starttime`, `endtime`) VALUES
	(1, 1, 1, NULL, NULL, 'bmp', '2016-05-28 21:36:30', NULL, NULL),
	(2, 3, 2, NULL, NULL, 'bmp', '2016-05-28 21:37:04', NULL, NULL),
	(3, 2, 3, NULL, NULL, 'bmp', '2016-05-28 21:37:03', NULL, NULL);
/*!40000 ALTER TABLE `lobby` ENABLE KEYS */;

-- Dumping structure for table project-x.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(200) NOT NULL,
  `username` varchar(200) NOT NULL,
  `trusted` tinyint(1) DEFAULT NULL,
  `password` varchar(50) NOT NULL,
  `iconData` longblob,
  `iconType` varchar(20) NOT NULL,
  `coins` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`iconType`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `iduser_UNIQUE` (`id`),
  KEY `fk_user_img_type1_idx` (`iconType`),
  CONSTRAINT `fk_user_img_type1` FOREIGN KEY (`iconType`) REFERENCES `img_type` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table project-x.user: ~3 rows (approximately)
DELETE FROM `user`;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`id`, `email`, `username`, `trusted`, `password`, `iconData`, `iconType`, `coins`) VALUES
	(1, 'jonas@oja.de', 'jonasoja', NULL, 'geheim', NULL, 'bmp', 10000),
	(2, 'max@mustermann.de', 'maxmusterman', NULL, '1234', NULL, 'bmp', NULL),
	(3, 'example@email.com', 'exampleuser', NULL, 'examplepassword', NULL, 'bmp', NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;