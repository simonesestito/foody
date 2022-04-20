-- MariaDB dump 10.19  Distrib 10.6.4-MariaDB, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: foody
-- ------------------------------------------------------
-- Server version	10.6.4-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Allergene`
--

DROP TABLE IF EXISTS `Allergene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Allergene` (
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Allergene`
--

LOCK TABLES `Allergene` WRITE;
/*!40000 ALTER TABLE `Allergene` DISABLE KEYS */;
INSERT INTO `Allergene` VALUES ('arachidi'),('cereali'),('crostacei'),('latte'),('lupini'),('molluschi'),('noci'),('pesce'),('sedano'),('senape'),('sesamo'),('soia'),('solfiti'),('uova');
/*!40000 ALTER TABLE `Allergene` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AllergeniProdotto`
--

DROP TABLE IF EXISTS `AllergeniProdotto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AllergeniProdotto` (
  `prodotto` int(11) NOT NULL,
  `allergene` varchar(100) NOT NULL,
  PRIMARY KEY (`prodotto`,`allergene`),
  KEY `allergene` (`allergene`),
  CONSTRAINT `AllergeniProdotto_ibfk_1` FOREIGN KEY (`prodotto`) REFERENCES `Prodotto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `AllergeniProdotto_ibfk_2` FOREIGN KEY (`allergene`) REFERENCES `Allergene` (`nome`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AllergeniProdotto`
--

LOCK TABLES `AllergeniProdotto` WRITE;
/*!40000 ALTER TABLE `AllergeniProdotto` DISABLE KEYS */;
INSERT INTO `AllergeniProdotto` VALUES (12,'latte'),(13,'cereali');
/*!40000 ALTER TABLE `AllergeniProdotto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Carrello`
--

DROP TABLE IF EXISTS `Carrello`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Carrello` (
  `utente` int(11) NOT NULL,
  `prodotto` int(11) NOT NULL,
  `quantita` int(11) NOT NULL CHECK (`quantita` > 0 and `quantita` <= 10),
  PRIMARY KEY (`utente`,`prodotto`),
  KEY `prodotto` (`prodotto`),
  CONSTRAINT `Carrello_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Carrello_ibfk_2` FOREIGN KEY (`prodotto`) REFERENCES `Prodotto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Carrello`
--

LOCK TABLES `Carrello` WRITE;
/*!40000 ALTER TABLE `Carrello` DISABLE KEYS */;
/*!40000 ALTER TABLE `Carrello` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CategoriaMenu`
--

DROP TABLE IF EXISTS `CategoriaMenu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CategoriaMenu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titolo` varchar(255) NOT NULL,
  `menu` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `menu` (`menu`),
  CONSTRAINT `CategoriaMenu_ibfk_1` FOREIGN KEY (`menu`) REFERENCES `Menu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CategoriaMenu`
--

LOCK TABLES `CategoriaMenu` WRITE;
/*!40000 ALTER TABLE `CategoriaMenu` DISABLE KEYS */;
INSERT INTO `CategoriaMenu` VALUES (1,'Primi',1),(2,'Secondi',1),(3,'Antipasti',2),(4,'Primi',2),(5,'Pizze',3),(6,'Antipasti',3);
/*!40000 ALTER TABLE `CategoriaMenu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContenutoCategoriaMenu`
--

DROP TABLE IF EXISTS `ContenutoCategoriaMenu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ContenutoCategoriaMenu` (
  `categoria` int(11) NOT NULL,
  `prodotto` int(11) NOT NULL,
  KEY `categoria` (`categoria`),
  KEY `prodotto` (`prodotto`),
  CONSTRAINT `ContenutoCategoriaMenu_ibfk_1` FOREIGN KEY (`categoria`) REFERENCES `CategoriaMenu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ContenutoCategoriaMenu_ibfk_2` FOREIGN KEY (`prodotto`) REFERENCES `Prodotto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContenutoCategoriaMenu`
--

LOCK TABLES `ContenutoCategoriaMenu` WRITE;
/*!40000 ALTER TABLE `ContenutoCategoriaMenu` DISABLE KEYS */;
INSERT INTO `ContenutoCategoriaMenu` VALUES (1,7),(1,8),(2,9),(2,10),(3,11),(3,12),(4,7),(4,8),(5,13),(5,14),(6,16);
/*!40000 ALTER TABLE `ContenutoCategoriaMenu` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER IF NOT EXISTS contenuto_categoria_stesso_ristorante
    BEFORE INSERT
    ON ContenutoCategoriaMenu
    FOR EACH ROW
BEGIN
    IF EXISTS(SELECT *
              FROM CategoriaMenu, Menu, Prodotto
              WHERE CategoriaMenu.id = NEW.categoria
                AND Menu.id = CategoriaMenu.menu
                AND Prodotto.id = NEW.prodotto
                AND Prodotto.ristorante <> Menu.ristorante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Una categoria deve contenere prodotti dello stesso ristorante del menù';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ContenutoOrdine`
--

DROP TABLE IF EXISTS `ContenutoOrdine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ContenutoOrdine` (
  `prodotto` int(11) NOT NULL,
  `ordine_ristorante` int(11) NOT NULL,
  `quantita` int(11) NOT NULL CHECK (`quantita` > 0 and `quantita` < 10),
  PRIMARY KEY (`prodotto`,`ordine_ristorante`),
  KEY `ordine_ristorante` (`ordine_ristorante`),
  CONSTRAINT `ContenutoOrdine_ibfk_1` FOREIGN KEY (`prodotto`) REFERENCES `Prodotto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ContenutoOrdine_ibfk_2` FOREIGN KEY (`ordine_ristorante`) REFERENCES `OrdineRistorante` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContenutoOrdine`
--

LOCK TABLES `ContenutoOrdine` WRITE;
/*!40000 ALTER TABLE `ContenutoOrdine` DISABLE KEYS */;
INSERT INTO `ContenutoOrdine` VALUES (13,5,1),(13,7,1),(16,6,4);
/*!40000 ALTER TABLE `ContenutoOrdine` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER IF NOT EXISTS ordinazione_singolo_ristorante_insert
    AFTER INSERT
    ON ContenutoOrdine
    FOR EACH ROW
BEGIN
    IF (SELECT COUNT(DISTINCT ristorante) FROM Prodotto, ContenutoOrdine WHERE NEW.ordine_ristorante = ContenutoOrdine.ordine_ristorante AND ContenutoOrdine.prodotto = Prodotto.id) > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un ordine non deve contenere prodotti di ristoranti diversi';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `DettagliRistorante`
--

DROP TABLE IF EXISTS `DettagliRistorante`;
/*!50001 DROP VIEW IF EXISTS `DettagliRistorante`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `DettagliRistorante` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `pubblicato` tinyint NOT NULL,
  `indirizzo_via` tinyint NOT NULL,
  `indirizzo_civico` tinyint NOT NULL,
  `indirizzo_citta` tinyint NOT NULL,
  `indirizzo_latitudine` tinyint NOT NULL,
  `indirizzo_longitudine` tinyint NOT NULL,
  `apertura` tinyint NOT NULL,
  `chiusura` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `telefono` tinyint NOT NULL,
  `voto_medio` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `EmailUtente`
--

DROP TABLE IF EXISTS `EmailUtente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmailUtente` (
  `utente` int(11) NOT NULL,
  `email` varchar(255) NOT NULL CHECK (`email` regexp '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*\\.[a-zA-Z]{2,4}$'),
  PRIMARY KEY (`email`),
  KEY `utente` (`utente`),
  CONSTRAINT `EmailUtente_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmailUtente`
--

LOCK TABLES `EmailUtente` WRITE;
/*!40000 ALTER TABLE `EmailUtente` DISABLE KEYS */;
INSERT INTO `EmailUtente` VALUES (1,'mario@rossi.it'),(2,'paolo@bianchi.it');
/*!40000 ALTER TABLE `EmailUtente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GestioneOrdini`
--

DROP TABLE IF EXISTS `GestioneOrdini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GestioneOrdini` (
  `data_inizio` datetime NOT NULL,
  `data_fine` datetime DEFAULT NULL,
  `utente` int(11) NOT NULL,
  `ristorante` int(11) NOT NULL,
  PRIMARY KEY (`utente`,`ristorante`,`data_inizio`),
  KEY `ristorante` (`ristorante`),
  CONSTRAINT `GestioneOrdini_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `GestioneOrdini_ibfk_2` FOREIGN KEY (`ristorante`) REFERENCES `Ristorante` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `data_inizio_fine` CHECK (`data_fine` is null or `data_fine` > `data_inizio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GestioneOrdini`
--

LOCK TABLES `GestioneOrdini` WRITE;
/*!40000 ALTER TABLE `GestioneOrdini` DISABLE KEYS */;
INSERT INTO `GestioneOrdini` VALUES ('2022-04-18 12:52:55',NULL,1,2);
/*!40000 ALTER TABLE `GestioneOrdini` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Menu`
--

DROP TABLE IF EXISTS `Menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titolo` varchar(255) NOT NULL,
  `pubblicato` tinyint(1) NOT NULL DEFAULT 0,
  `ristorante` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ristorante` (`ristorante`),
  CONSTRAINT `Menu_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `Ristorante` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Menu`
--

LOCK TABLES `Menu` WRITE;
/*!40000 ALTER TABLE `Menu` DISABLE KEYS */;
INSERT INTO `Menu` VALUES (1,'A',1,1),(2,'B',0,1),(3,'Menu del giorno',1,2);
/*!40000 ALTER TABLE `Menu` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER IF NOT EXISTS menu_pubblicato_non_vuoto_insert
    BEFORE INSERT
    ON Menu
    FOR EACH ROW
BEGIN
    IF NEW.pubblicato = 1 THEN
        -- Rimuovi categorie vuote
        DELETE
        FROM CategoriaMenu
        WHERE menu = NEW.id
          AND id NOT IN (
            -- Categorie con almeno un prodotto
            SELECT CategoriaMenu.id
            FROM CategoriaMenu
                     JOIN ContenutoCategoriaMenu on CategoriaMenu.id = ContenutoCategoriaMenu.categoria);

        -- Controlla che sia rimasta una categoria
        IF NOT EXISTS(SELECT * FROM CategoriaMenu WHERE menu = NEW.id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Impossibile pubblicare un menu vuoto';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER ristorante_max_menu_pubblicato_insert
    BEFORE INSERT
    ON Menu
    FOR EACH ROW BEGIN
    IF NEW.pubblicato = 1 AND EXISTS(SELECT * FROM Menu WHERE pubblicato = 1 AND ristorante = NEW.ristorante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esiste già un altro menu pubblicato.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER IF NOT EXISTS menu_pubblicato_non_vuoto_update
    BEFORE UPDATE
    ON Menu
    FOR EACH ROW
BEGIN
    IF NEW.pubblicato = 1 AND OLD.pubblicato = 0 THEN
        -- Rimuovi categorie vuote
        DELETE
        FROM CategoriaMenu
        WHERE menu = NEW.id
          AND id NOT IN (
            -- Categorie con almeno un prodotto
            SELECT CategoriaMenu.id
            FROM CategoriaMenu
                     JOIN ContenutoCategoriaMenu on CategoriaMenu.id = ContenutoCategoriaMenu.categoria);

        -- Controlla che sia rimasta almeno una categoria
        IF NOT EXISTS(SELECT * FROM CategoriaMenu WHERE menu = NEW.id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Impossibile pubblicare un menu vuoto';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER ristorante_max_menu_pubblicato_update
    BEFORE UPDATE
    ON Menu
    FOR EACH ROW BEGIN
    IF NEW.pubblicato = 1 AND OLD.pubblicato = 0 AND
       EXISTS(SELECT * FROM Menu WHERE pubblicato = 1 AND ristorante = NEW.ristorante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esiste già un altro menu pubblicato.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `OrariDiApertura`
--

DROP TABLE IF EXISTS `OrariDiApertura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrariDiApertura` (
  `giorno` int(11) NOT NULL CHECK (`giorno` >= 0 and `giorno` <= 6),
  `apertura` time NOT NULL,
  `chiusura` time NOT NULL,
  `ristorante` int(11) NOT NULL,
  PRIMARY KEY (`giorno`,`ristorante`,`apertura`),
  KEY `ristorante` (`ristorante`),
  CONSTRAINT `OrariDiApertura_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `Ristorante` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `apertura_chiusura` CHECK (`chiusura` > `apertura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrariDiApertura`
--

LOCK TABLES `OrariDiApertura` WRITE;
/*!40000 ALTER TABLE `OrariDiApertura` DISABLE KEYS */;
INSERT INTO `OrariDiApertura` VALUES (0,'18:30:00','23:00:00',1),(0,'12:30:00','15:30:00',2),(0,'16:53:00','23:53:00',2),(1,'12:30:00','15:30:00',1),(1,'18:30:00','23:00:00',1),(1,'12:30:00','15:30:00',2),(1,'18:30:00','23:00:00',2),(2,'12:30:00','15:30:00',1),(2,'18:30:00','23:00:00',1),(2,'12:30:00','15:30:00',2),(2,'18:30:00','23:00:00',2),(3,'12:30:00','15:30:00',1),(3,'18:30:00','23:00:00',1),(3,'12:30:00','15:30:00',2),(3,'18:30:00','23:00:00',2),(4,'12:30:00','15:30:00',1),(4,'18:30:00','23:00:00',1),(4,'12:30:00','15:30:00',2),(4,'18:30:00','23:00:00',2),(5,'12:30:00','15:30:00',1),(5,'18:30:00','23:00:00',1),(5,'12:30:00','15:30:00',2),(5,'18:30:00','23:00:00',2),(6,'12:30:00','15:30:00',1),(6,'12:30:00','15:30:00',2);
/*!40000 ALTER TABLE `OrariDiApertura` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER IF NOT EXISTS orario_apertura_sovrapposto_insert
    BEFORE INSERT
    ON OrariDiApertura
    FOR EACH ROW
BEGIN
    -- Check sulla sovrapposizione di orari
    IF EXISTS(SELECT *
              FROM OrariDiApertura
              WHERE ristorante = NEW.ristorante
                AND giorno = NEW.giorno
                AND (apertura BETWEEN NEW.apertura AND NEW.chiusura OR
                     chiusura BETWEEN NEW.apertura AND NEW.chiusura)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflitto nel nuovo orario, si presenta sovrapposizione';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER IF NOT EXISTS orario_apertura_sovrapposto_update
    BEFORE UPDATE
    ON OrariDiApertura
    FOR EACH ROW
BEGIN
    -- Check sulla sovrapposizione di orari
    IF EXISTS(SELECT *
              FROM OrariDiApertura
              WHERE ristorante = NEW.ristorante
                AND giorno = NEW.giorno
                AND apertura <> OLD.apertura -- Non lo stesso orario
                AND (apertura BETWEEN NEW.apertura AND NEW.chiusura OR
                     chiusura BETWEEN NEW.apertura AND NEW.chiusura)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflitto nel nuovo orario, si presenta sovrapposizione';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `OrdineRistorante`
--

DROP TABLE IF EXISTS `OrdineRistorante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrdineRistorante` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stato` int(11) NOT NULL DEFAULT 100,
  `creazione` datetime NOT NULL DEFAULT current_timestamp(),
  `note` varchar(255) DEFAULT NULL,
  `indirizzo_via` varchar(255) NOT NULL,
  `indirizzo_civico` varchar(10) DEFAULT NULL CHECK (`indirizzo_civico` is null or `indirizzo_civico` regexp '^([1-9][0-9]*)([-/]?[a-zA-z]*)?$'),
  `indirizzo_citta` varchar(64) NOT NULL,
  `indirizzo_latitudine` float(10,6) NOT NULL,
  `indirizzo_longitudine` float(10,6) NOT NULL,
  `utente` int(11) DEFAULT NULL,
  `servizio_rider` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stato` (`stato`),
  KEY `utente` (`utente`),
  KEY `servizio_rider` (`servizio_rider`),
  CONSTRAINT `OrdineRistorante_ibfk_1` FOREIGN KEY (`stato`) REFERENCES `StatoOrdine` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `OrdineRistorante_ibfk_2` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `OrdineRistorante_ibfk_3` FOREIGN KEY (`servizio_rider`) REFERENCES `ServizioRider` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrdineRistorante`
--

LOCK TABLES `OrdineRistorante` WRITE;
/*!40000 ALTER TABLE `OrdineRistorante` DISABLE KEYS */;
INSERT INTO `OrdineRistorante` VALUES (5,400,'2022-04-12 16:32:43',NULL,'via via','1','napoli',14.193528,40.848259,1,NULL),(6,300,'2022-04-12 16:53:45','ciao ciao ciaoooo','via via','1','napoli',14.193528,40.848259,2,NULL),(7,100,'2022-04-12 16:55:15',NULL,'via viaaa','34','napoli',11.587610,44.395672,1,NULL);
/*!40000 ALTER TABLE `OrdineRistorante` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER IF NOT EXISTS stato_ordinazione_crescente
    BEFORE UPDATE
    ON OrdineRistorante
    FOR EACH ROW
BEGIN
    IF (NEW.stato < OLD.stato) THEN SET NEW.stato = OLD.stato; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Prodotto`
--

DROP TABLE IF EXISTS `Prodotto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Prodotto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `descrizione` varchar(255) DEFAULT NULL,
  `prezzo` float(10,2) NOT NULL CHECK (`prezzo` > 0),
  `ristorante` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ristorante` (`ristorante`),
  CONSTRAINT `Prodotto_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `Ristorante` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Prodotto`
--

LOCK TABLES `Prodotto` WRITE;
/*!40000 ALTER TABLE `Prodotto` DISABLE KEYS */;
INSERT INTO `Prodotto` VALUES (7,'Pasta','Pasta buona',6.50,1),(8,'Riso','Riso meno buono',5.80,1),(9,'Carne','Bisteccona ignorante',9.70,1),(10,'Pesce','Fresco di giornata',12.50,1),(11,'Salumi','Salumi assortiti',4.00,1),(12,'Formaggi','Tanti tipi',5.50,1),(13,'Pizza Margherita','La classica pizza che ti aspetti',6.51,2),(14,'Pizza Boscaiola','Con quel tocco di creatività',7.80,2),(16,'Carciofo alla Giudia','Specialità ebraica',3.00,2);
/*!40000 ALTER TABLE `Prodotto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Recensione`
--

DROP TABLE IF EXISTS `Recensione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Recensione` (
  `creazione` datetime NOT NULL,
  `voto` int(11) NOT NULL CHECK (`voto` > 0 and `voto` < 6),
  `titolo` varchar(255) DEFAULT NULL,
  `testo` varchar(255) DEFAULT NULL,
  `ristorante` int(11) NOT NULL,
  `utente` int(11) NOT NULL,
  PRIMARY KEY (`utente`,`ristorante`),
  KEY `ristorante` (`ristorante`),
  CONSTRAINT `Recensione_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `Ristorante` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Recensione_ibfk_2` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Recensione`
--

LOCK TABLES `Recensione` WRITE;
/*!40000 ALTER TABLE `Recensione` DISABLE KEYS */;
INSERT INTO `Recensione` VALUES ('2022-04-18 07:47:15',1,'Brutto','Non mi piace proprio per nulla!!\n\n\nNOOOOO',2,1);
/*!40000 ALTER TABLE `Recensione` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER IF NOT EXISTS recensione_da_cliente
    BEFORE INSERT
    ON Recensione
    FOR EACH ROW
BEGIN
    IF NOT EXISTS(SELECT *
                  FROM OrdineRistorante
                           JOIN ContenutoOrdine on OrdineRistorante.id = ContenutoOrdine.ordine_ristorante
                           JOIN Prodotto on ContenutoOrdine.prodotto = Prodotto.id
                  WHERE OrdineRistorante.utente = NEW.utente
                    AND Prodotto.ristorante = NEW.ristorante
                    AND OrdineRistorante.stato >= 400) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Una recensione può essere scritta solo su ristoranti presso cui sono stati fatti ordini consegnati';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `RecensioneCompleta`
--

DROP TABLE IF EXISTS `RecensioneCompleta`;
/*!50001 DROP VIEW IF EXISTS `RecensioneCompleta`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `RecensioneCompleta` (
  `creazione` tinyint NOT NULL,
  `voto` tinyint NOT NULL,
  `titolo` tinyint NOT NULL,
  `testo` tinyint NOT NULL,
  `ristorante` tinyint NOT NULL,
  `utente` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `pubblicato` tinyint NOT NULL,
  `indirizzo_via` tinyint NOT NULL,
  `indirizzo_civico` tinyint NOT NULL,
  `indirizzo_citta` tinyint NOT NULL,
  `indirizzo_latitudine` tinyint NOT NULL,
  `indirizzo_longitudine` tinyint NOT NULL,
  `nome_utente` tinyint NOT NULL,
  `cognome_utente` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Ristorante`
--

DROP TABLE IF EXISTS `Ristorante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ristorante` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `pubblicato` tinyint(1) NOT NULL DEFAULT 1,
  `indirizzo_via` varchar(255) NOT NULL,
  `indirizzo_civico` varchar(10) DEFAULT NULL CHECK (`indirizzo_civico` is null or `indirizzo_civico` regexp '^([1-9][0-9]*)([-/]?[a-zA-z]*)?$'),
  `indirizzo_citta` varchar(64) NOT NULL,
  `indirizzo_latitudine` float(10,6) NOT NULL,
  `indirizzo_longitudine` float(10,6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ristorante`
--

LOCK TABLES `Ristorante` WRITE;
/*!40000 ALTER TABLE `Ristorante` DISABLE KEYS */;
INSERT INTO `Ristorante` VALUES (1,'Peppino',1,'Lungomare Toscanelli','23/a','Ostia, Roma',41.730793,12.272553),(2,'Pizzeria Casetta',1,'Via dei Marrucini','52','Roma',41.900562,12.511505);
/*!40000 ALTER TABLE `Ristorante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `RistorantiConMenu`
--

DROP TABLE IF EXISTS `RistorantiConMenu`;
/*!50001 DROP VIEW IF EXISTS `RistorantiConMenu`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `RistorantiConMenu` (
  `id` tinyint NOT NULL,
  `nome` tinyint NOT NULL,
  `pubblicato` tinyint NOT NULL,
  `indirizzo_via` tinyint NOT NULL,
  `indirizzo_civico` tinyint NOT NULL,
  `indirizzo_citta` tinyint NOT NULL,
  `indirizzo_latitudine` tinyint NOT NULL,
  `indirizzo_longitudine` tinyint NOT NULL,
  `apertura` tinyint NOT NULL,
  `chiusura` tinyint NOT NULL,
  `giorno` tinyint NOT NULL,
  `telefono` tinyint NOT NULL,
  `voto_medio` tinyint NOT NULL,
  `titolo_menu` tinyint NOT NULL,
  `menu_pubblicato` tinyint NOT NULL,
  `menu_id` tinyint NOT NULL,
  `categoria_id` tinyint NOT NULL,
  `categoria_titolo` tinyint NOT NULL,
  `prodotto_id` tinyint NOT NULL,
  `prodotto_nome` tinyint NOT NULL,
  `prodotto_descrizione` tinyint NOT NULL,
  `prodotto_prezzo` tinyint NOT NULL,
  `allergene` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `RuoliUtente`
--

DROP TABLE IF EXISTS `RuoliUtente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RuoliUtente` (
  `ruolo` varchar(16) NOT NULL,
  `utente` int(11) NOT NULL,
  PRIMARY KEY (`ruolo`,`utente`),
  KEY `utente` (`utente`),
  CONSTRAINT `RuoliUtente_ibfk_1` FOREIGN KEY (`ruolo`) REFERENCES `RuoloUtente` (`ruolo`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `RuoliUtente_ibfk_2` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RuoliUtente`
--

LOCK TABLES `RuoliUtente` WRITE;
/*!40000 ALTER TABLE `RuoliUtente` DISABLE KEYS */;
/*!40000 ALTER TABLE `RuoliUtente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RuoloUtente`
--

DROP TABLE IF EXISTS `RuoloUtente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RuoloUtente` (
  `ruolo` varchar(16) NOT NULL,
  PRIMARY KEY (`ruolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RuoloUtente`
--

LOCK TABLES `RuoloUtente` WRITE;
/*!40000 ALTER TABLE `RuoloUtente` DISABLE KEYS */;
INSERT INTO `RuoloUtente` VALUES ('admin'),('cliente'),('manager'),('rider');
/*!40000 ALTER TABLE `RuoloUtente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ServizioRider`
--

DROP TABLE IF EXISTS `ServizioRider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ServizioRider` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `utente` int(11) NOT NULL,
  `ora_inizio` datetime NOT NULL,
  `latitudine_inizio` float(10,6) NOT NULL,
  `longitudine_inizio` float(10,6) NOT NULL,
  `ora_fine` datetime DEFAULT NULL,
  `latitudine_fine` float(10,6) DEFAULT NULL,
  `longitudine_fine` float(10,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `utente` (`utente`,`ora_inizio`),
  CONSTRAINT `ServizioRider_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ora_inizio_fine` CHECK (`ora_fine` is null or `ora_fine` > `ora_inizio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ServizioRider`
--

LOCK TABLES `ServizioRider` WRITE;
/*!40000 ALTER TABLE `ServizioRider` DISABLE KEYS */;
/*!40000 ALTER TABLE `ServizioRider` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`foody`@`%`*/ /*!50003 TRIGGER utente_rider_max_servizi_in_corso
    BEFORE INSERT
    ON ServizioRider
    FOR EACH ROW
BEGIN
    IF EXISTS(SELECT Utente.id
              FROM ServizioRider
                       JOIN Utente ON ServizioRider.utente = Utente.id
              WHERE ServizioRider.ora_fine IS NULL -- In corso
              GROUP BY Utente.id
              HAVING COUNT(DISTINCT ServizioRider.id) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esiste già un servizio in corso per il rider';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `SessioneLogin`
--

DROP TABLE IF EXISTS `SessioneLogin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SessioneLogin` (
  `token` varchar(60) NOT NULL,
  `agent` varchar(255) NOT NULL,
  `ip` varchar(39) NOT NULL,
  `creazione` datetime NOT NULL DEFAULT current_timestamp(),
  `ultimo_uso` datetime NOT NULL DEFAULT current_timestamp(),
  `utente` int(11) NOT NULL,
  PRIMARY KEY (`token`),
  KEY `utente` (`utente`),
  CONSTRAINT `SessioneLogin_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SessioneLogin`
--

LOCK TABLES `SessioneLogin` WRITE;
/*!40000 ALTER TABLE `SessioneLogin` DISABLE KEYS */;
INSERT INTO `SessioneLogin` VALUES ('-kMmTT3Ls7VpCyTWuir7Z63tF08','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-12 18:31:41','2022-04-12 16:32:43',1),('1pLBnzdpEN3LXKE_R4FuWhYOPkg','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 10:20:26','2022-04-18 08:38:25',1),('23JfwGV6I_85CQgmQp6N2efC5jA','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-13 11:30:41','2022-04-13 09:30:45',1),('6O5RnWq2mqAHznJOLIeEaHaZ97g','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:41:57','2022-04-18 14:42:01',1),('86yrbsVpJUaEQFKkgQf0URr_N8c','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:26:36','2022-04-18 14:26:27',1),('8XjRrzQa22d_g8c2Ye8yRfP00NI','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-12 16:24:17','2022-04-12 14:24:17',1),('9Y5bgnTrSwmRVQFr5aNMmzVrCSs','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 09:45:21','2022-04-18 07:52:27',1),('a5cPcwW2bib8T7R68GgPYeQjc-E','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 10:15:51','2022-04-18 08:16:38',1),('b0HJugSfQFhxCBEtOo-F5CUgSD8','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-13 11:11:39','2022-04-13 09:11:53',1),('bC22lhBbLkDwTWeqtGnL47YO8U4','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','62.211.202.231','2022-04-18 07:53:57','2022-04-18 07:54:34',1),('bI8ulkhjaBSLauNaBMmR6I59v6I','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-20 09:54:21','2022-04-20 07:54:22',1),('bWmWZxFxK3RMB47FAACsZzzQhhg','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-13 11:54:00','2022-04-13 09:54:23',1),('bxe1B6wRvRGu1LTdYCHUFqqXXKM','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:51:17','2022-04-18 14:53:20',1),('B_T7cUHi2NEzdwizRFdgC3C7WTg','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 15:46:37','2022-04-18 13:47:48',1),('B_yGsuBS-vVFZRUDgQILDFNR-24','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-13 11:04:09','2022-04-13 09:06:05',1),('cj1zRfDIrDemSrTM2snBE0lGGmk','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 14:52:13','2022-04-18 13:06:32',1),('dA1fxNUtoOteIlqtnU3skwrjCOc','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-20 09:49:20','2022-04-20 07:49:23',1),('e5PWb5kUjkKUW14kC8sr6YvwGcQ','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-13 11:26:44','2022-04-13 09:26:50',1),('ec4bN2oowUSynCYFnmJ41PgJvqw','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-12 17:38:26','2022-04-12 15:40:19',1),('FhaoeHTpcAJMyr25Z4cVBkAZcw4','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 15:53:59','2022-04-18 13:53:52',1),('FMCeW1fWnOe1CRO3balIQkwtUBc','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 09:41:07','2022-04-18 07:41:07',1),('gPm-54S5v1LLgJ1Ux06Nv4_WU88','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-13 11:22:55','2022-04-13 09:23:01',1),('ISqNA-GzTjwQuswste-mO11m5QQ','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:44:54','2022-04-18 14:45:01',1),('k1qyPJBK6uC6ZcQvWKGA0-9t3kc','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:09:21','2022-04-18 14:09:13',1),('KnwyzZc1jMwqF2sVjxjGRAAZmKY','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 13:06:42','2022-04-18 11:14:02',1),('KPr3-d1pSY3m2eL_N44WCqJsBmA','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:21:07','2022-04-18 14:21:00',1),('kqYZDfAmMq0IUdki9G9Z18xSdZs','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:23:38','2022-04-18 14:23:29',1),('lGy8saWxfI1jbcaxrfA3l3k8QeM','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-12 17:54:25','2022-04-12 16:22:15',1),('Lp6tAsMent7uD8y9Temlk0Hvwpw','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-20 10:36:58','2022-04-20 08:37:05',1),('Mt-LWZ7dXNQSXyA0B0UrbUKm800','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:34:50','2022-04-18 14:34:41',1),('nthmB7IgP3uOcf2aX0jwQZLmbbQ','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-12 17:47:00','2022-04-12 15:47:48',1),('qfClAMGr8q1f49jmz-ysko4A0UQ','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-12 18:53:16','2022-04-12 16:55:15',1),('rPSnw-WxH6djyu7fhpB_3OwK_1E','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-12 16:32:41','2022-04-12 15:32:41',1),('SSI_H8zG_QYM9Q3dkJ-70ymlPJw','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:32:03','2022-04-18 14:31:54',1),('swL1vqxpk_vSp4DiAwbdy-PhD8E','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-13 12:29:07','2022-04-13 10:29:13',1),('TJnBz114SNwPdH_DhRnIhIsblyo','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 12:55:30','2022-04-18 11:03:12',1),('uB8OY4QuaRfC-Y03COGX8dhTs9U','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-20 10:09:05','2022-04-20 08:09:06',1),('VFj7XoUg9jgd_G8mXPbPxLQlj30','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 12:51:50','2022-04-18 10:55:21',1),('vTEBJKQm7i7r6X7Zu6tR8WxR8Sc','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-12 18:25:01','2022-04-12 16:26:20',1),('VYNWekIUzmDXAm3FK5Ro4SU7SWM','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 15:10:37','2022-04-18 13:12:21',1),('w46RDotCnSUzWsmi30xP07ZD34w','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 09:37:13','2022-04-18 07:38:18',1),('wEk8AkVUUPwqicu1e73pLxquCas','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-20 09:51:45','2022-04-20 07:51:46',1),('Y5MtDep6TyGfcrZRtW6q9x44VXw','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-13 11:14:44','2022-04-13 09:18:17',1),('y7H8tGi1YweEJ881ibz1Hiw1dRU','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:47:52','2022-04-18 14:47:47',1),('YYGZBK06m4yz02Dkx3OXjqgnklE','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-20 10:11:06','2022-04-20 08:11:08',1),('ZaV9mXmiUy7EwlyLGan6usgmnoo','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-20 10:44:32','2022-04-20 09:57:13',1),('zK_G7esq2dttcMHLrM-xIv_ocIA','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:05:35','2022-04-18 14:05:28',1),('_MNANSNDgX1AQ95zLHLrr_a2ja8','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36','0:0:0:0:0:0:0:1','2022-04-18 16:15:39','2022-04-18 14:15:31',1);
/*!40000 ALTER TABLE `SessioneLogin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StatoOrdine`
--

DROP TABLE IF EXISTS `StatoOrdine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StatoOrdine` (
  `id` int(11) NOT NULL,
  `nome` varchar(16) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StatoOrdine`
--

LOCK TABLES `StatoOrdine` WRITE;
/*!40000 ALTER TABLE `StatoOrdine` DISABLE KEYS */;
INSERT INTO `StatoOrdine` VALUES (400,'delivered'),(300,'delivering'),(200,'prepared'),(100,'preparing');
/*!40000 ALTER TABLE `StatoOrdine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TelefonoRistorante`
--

DROP TABLE IF EXISTS `TelefonoRistorante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TelefonoRistorante` (
  `telefono` varchar(14) NOT NULL CHECK (`telefono` regexp '^[+]?([0-9]{6}[0-9]*)$'),
  `ristorante` int(11) NOT NULL,
  PRIMARY KEY (`telefono`,`ristorante`),
  KEY `ristorante` (`ristorante`),
  CONSTRAINT `TelefonoRistorante_ibfk_1` FOREIGN KEY (`ristorante`) REFERENCES `Ristorante` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TelefonoRistorante`
--

LOCK TABLES `TelefonoRistorante` WRITE;
/*!40000 ALTER TABLE `TelefonoRistorante` DISABLE KEYS */;
INSERT INTO `TelefonoRistorante` VALUES ('06062233',2);
/*!40000 ALTER TABLE `TelefonoRistorante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TelefonoUtente`
--

DROP TABLE IF EXISTS `TelefonoUtente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TelefonoUtente` (
  `utente` int(11) NOT NULL,
  `telefono` varchar(14) NOT NULL CHECK (`telefono` regexp '^[+]?([0-9]{6}[0-9]*)$'),
  PRIMARY KEY (`telefono`),
  KEY `utente` (`utente`),
  CONSTRAINT `TelefonoUtente_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `Utente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TelefonoUtente`
--

LOCK TABLES `TelefonoUtente` WRITE;
/*!40000 ALTER TABLE `TelefonoUtente` DISABLE KEYS */;
INSERT INTO `TelefonoUtente` VALUES (2,'333123123');
/*!40000 ALTER TABLE `TelefonoUtente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Utente`
--

DROP TABLE IF EXISTS `Utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Utente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `cognome` varchar(255) NOT NULL,
  `password` varchar(60) NOT NULL CHECK (octet_length(`password`) = 60),
  `rider` tinyint(1) NOT NULL DEFAULT 0,
  `admin` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utente`
--

LOCK TABLES `Utente` WRITE;
/*!40000 ALTER TABLE `Utente` DISABLE KEYS */;
INSERT INTO `Utente` VALUES (1,'Mario','Rossi','$2a$10$/NrOwkVDhkvs7AnGI762ruYD7RDjRGyOW5dhIAlZPZBcSsJh5Wj4e',0,0),(2,'Paolo','Bianchi','$2a$10$a6aI4PYrlDltZLgxdHOwyuNbaXJQMd9ke.lOHoqsrSHJ3V2XCC3JW',0,0);
/*!40000 ALTER TABLE `Utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `DettagliRistorante`
--

/*!50001 DROP TABLE IF EXISTS `DettagliRistorante`*/;
/*!50001 DROP VIEW IF EXISTS `DettagliRistorante`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`foody`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `DettagliRistorante` AS select `foody`.`Ristorante`.`id` AS `id`,`foody`.`Ristorante`.`nome` AS `nome`,`foody`.`Ristorante`.`pubblicato` AS `pubblicato`,`foody`.`Ristorante`.`indirizzo_via` AS `indirizzo_via`,`foody`.`Ristorante`.`indirizzo_civico` AS `indirizzo_civico`,`foody`.`Ristorante`.`indirizzo_citta` AS `indirizzo_citta`,`foody`.`Ristorante`.`indirizzo_latitudine` AS `indirizzo_latitudine`,`foody`.`Ristorante`.`indirizzo_longitudine` AS `indirizzo_longitudine`,`foody`.`OrariDiApertura`.`apertura` AS `apertura`,`foody`.`OrariDiApertura`.`chiusura` AS `chiusura`,`foody`.`OrariDiApertura`.`giorno` AS `giorno`,`foody`.`TelefonoRistorante`.`telefono` AS `telefono`,`R`.`voto_medio` AS `voto_medio` from (((`foody`.`OrariDiApertura` left join `foody`.`Ristorante` on(`foody`.`Ristorante`.`id` = `foody`.`OrariDiApertura`.`ristorante`)) left join `foody`.`TelefonoRistorante` on(`foody`.`Ristorante`.`id` = `foody`.`TelefonoRistorante`.`ristorante`)) left join (select `foody`.`Ristorante`.`id` AS `id`,avg(`foody`.`Recensione`.`voto`) AS `voto_medio` from (`foody`.`Ristorante` left join `foody`.`Recensione` on(`foody`.`Ristorante`.`id` = `foody`.`Recensione`.`ristorante`))) `R` on(`foody`.`Ristorante`.`id` = `R`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `RecensioneCompleta`
--

/*!50001 DROP TABLE IF EXISTS `RecensioneCompleta`*/;
/*!50001 DROP VIEW IF EXISTS `RecensioneCompleta`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`foody`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `RecensioneCompleta` AS select `Recensione`.`creazione` AS `creazione`,`Recensione`.`voto` AS `voto`,`Recensione`.`titolo` AS `titolo`,`Recensione`.`testo` AS `testo`,`Recensione`.`ristorante` AS `ristorante`,`Recensione`.`utente` AS `utente`,`Ristorante`.`nome` AS `nome`,`Ristorante`.`pubblicato` AS `pubblicato`,`Ristorante`.`indirizzo_via` AS `indirizzo_via`,`Ristorante`.`indirizzo_civico` AS `indirizzo_civico`,`Ristorante`.`indirizzo_citta` AS `indirizzo_citta`,`Ristorante`.`indirizzo_latitudine` AS `indirizzo_latitudine`,`Ristorante`.`indirizzo_longitudine` AS `indirizzo_longitudine`,`Utente`.`nome` AS `nome_utente`,`Utente`.`cognome` AS `cognome_utente` from ((`Recensione` join `Ristorante` on(`Ristorante`.`id` = `Recensione`.`ristorante`)) join `Utente` on(`Utente`.`id` = `Recensione`.`utente`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `RistorantiConMenu`
--

/*!50001 DROP TABLE IF EXISTS `RistorantiConMenu`*/;
/*!50001 DROP VIEW IF EXISTS `RistorantiConMenu`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`foody`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `RistorantiConMenu` AS select `DettagliRistorante`.`id` AS `id`,`DettagliRistorante`.`nome` AS `nome`,`DettagliRistorante`.`pubblicato` AS `pubblicato`,`DettagliRistorante`.`indirizzo_via` AS `indirizzo_via`,`DettagliRistorante`.`indirizzo_civico` AS `indirizzo_civico`,`DettagliRistorante`.`indirizzo_citta` AS `indirizzo_citta`,`DettagliRistorante`.`indirizzo_latitudine` AS `indirizzo_latitudine`,`DettagliRistorante`.`indirizzo_longitudine` AS `indirizzo_longitudine`,`DettagliRistorante`.`apertura` AS `apertura`,`DettagliRistorante`.`chiusura` AS `chiusura`,`DettagliRistorante`.`giorno` AS `giorno`,`DettagliRistorante`.`telefono` AS `telefono`,`DettagliRistorante`.`voto_medio` AS `voto_medio`,`foody`.`Menu`.`titolo` AS `titolo_menu`,`foody`.`Menu`.`pubblicato` AS `menu_pubblicato`,`foody`.`Menu`.`id` AS `menu_id`,`MC`.`id` AS `categoria_id`,`MC`.`titolo` AS `categoria_titolo`,`P`.`id` AS `prodotto_id`,`P`.`nome` AS `prodotto_nome`,`P`.`descrizione` AS `prodotto_descrizione`,`P`.`prezzo` AS `prodotto_prezzo`,`AP`.`allergene` AS `allergene` from (((((`foody`.`DettagliRistorante` left join `foody`.`Menu` on(`foody`.`Menu`.`ristorante` = `DettagliRistorante`.`id`)) left join `foody`.`CategoriaMenu` `MC` on(`foody`.`Menu`.`id` = `MC`.`menu`)) left join `foody`.`ContenutoCategoriaMenu` `MCC` on(`MC`.`id` = `MCC`.`categoria`)) left join `foody`.`Prodotto` `P` on(`P`.`id` = `MCC`.`prodotto`)) left join `foody`.`AllergeniProdotto` `AP` on(`P`.`id` = `AP`.`prodotto`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-04-20 12:59:05
