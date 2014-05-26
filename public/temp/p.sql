-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: nix
-- ------------------------------------------------------
-- Server version	5.5.37-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `provinces`
--

DROP TABLE IF EXISTS `provinces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provinces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `region_id` int(11) DEFAULT NULL,
  `remark` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_provinces_on_name` (`name`),
  KEY `index_provinces_on_region_id` (`region_id`),
  KEY `index_provinces_on_remark` (`remark`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provinces`
--

LOCK TABLES `provinces` WRITE;
/*!40000 ALTER TABLE `provinces` DISABLE KEYS */;
INSERT INTO `provinces` VALUES (1,'北京市',1,'直辖市'),(2,'天津市',1,'直辖市'),(3,'河北省',1,'省份'),(4,'山西省',1,'省份'),(5,'内蒙古自治区',1,'自治区'),(6,'辽宁省',2,'省份'),(7,'吉林省',2,'省份'),(8,'黑龙江省',2,'省份'),(9,'上海市',3,'直辖市'),(10,'江苏省',3,'省份'),(11,'浙江省',3,'省份'),(12,'安徽省',3,'省份'),(13,'福建省',3,'省份'),(14,'江西省',3,'省份'),(15,'山东省',3,'省份'),(16,'河南省',5,'省份'),(17,'湖北省',5,'省份'),(18,'湖南省',5,'省份'),(19,'广东省',5,'省份'),(20,'海南省',5,'省份'),(21,'广西壮族自治区',5,'自治区'),(22,'甘肃省',6,'省份'),(23,'陕西省',6,'省份'),(24,'新疆维吾尔自治区',6,'自治区'),(25,'青海省',6,'省份'),(26,'宁夏回族自治区',6,'自治区'),(27,'重庆市',4,'直辖市'),(28,'四川省',4,'省份'),(29,'贵州省',4,'省份'),(30,'云南省',4,'省份'),(31,'西藏自治区',4,'自治区'),(32,'台湾省',7,'省份'),(33,'澳门特别行政区',7,'特别行政区'),(34,'香港特别行政区',7,'特别行政区');
/*!40000 ALTER TABLE `provinces` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-26 17:08:38
