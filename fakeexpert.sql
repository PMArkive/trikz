-- MariaDB dump 10.19  Distrib 10.4.19-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: fakeexpert
-- ------------------------------------------------------
-- Server version	10.4.19-MariaDB

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
-- Table structure for table `cp`
--

DROP TABLE IF EXISTS `cp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cpnum` int(11) DEFAULT NULL,
  `cpx` float DEFAULT NULL,
  `cpy` float DEFAULT NULL,
  `cpz` float DEFAULT NULL,
  `cpx2` float DEFAULT NULL,
  `cpy2` float DEFAULT NULL,
  `cpz2` float DEFAULT NULL,
  `map` varchar(192) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cp`
--

LOCK TABLES `cp` WRITE;
/*!40000 ALTER TABLE `cp` DISABLE KEYS */;
INSERT INTO `cp` VALUES (7,1,8283.97,9991.97,-143.96,7549.7,9512.03,-143.96,'trikz_cyrus'),(8,2,9719.03,9968.04,-1730.97,10199,10492.3,-1730.97,'trikz_cyrus'),(9,3,-4849.14,-9283.97,-3902.97,-6733.97,-8732.01,-3903.97,'trikz_cyrus'),(10,4,-7637.97,-5939.97,-5157.97,-7158.03,-5576.15,-5157.97,'trikz_cyrus'),(12,0,2510.37,2232.03,64.0312,NULL,NULL,NULL,'trikz_adventure'),(13,1,2512.47,2232.03,64.0312,2098.14,2695.97,64.0312,'trikz_adventure'),(14,2,12766,-3069.92,28.0312,12302,-3405.48,28.0312,'trikz_adventure'),(15,3,5352.02,-2521.72,-451.969,5755.37,-2918.97,-451.997,'trikz_adventure'),(16,4,1914.74,-7098.97,744.031,1495.28,-6763,744.031,'trikz_adventure'),(17,5,-5758.88,-251.031,1621.03,-5423.03,-400.95,1621.03,'trikz_adventure'),(18,1,1664.03,-2927.97,15360,2271.97,-2439.9,15360,'trikz_eonia'),(19,2,6319.97,15800,5952.03,5712.03,15442.6,5952.03,'trikz_eonia'),(20,3,-9808.03,14196.7,3232.03,-11056,13333.7,3232.03,'trikz_eonia'),(21,4,4799.97,-6767.97,-4287.97,3862.68,-4752.03,-4287.97,'trikz_eonia'),(22,2,4847.97,12079.7,1472.71,4672.92,12944.1,1472.22,'trikz_kyoto_final'),(23,1,-6640.03,9200.03,-607.969,-7695.97,9759.5,-607.969,'trikz_soft'),(24,2,-128.031,2691.97,-239.969,-414.566,2402.5,-239.969,'trikz_soft'),(25,3,-5359.97,-14712,384.031,-3599.74,-16184,384.031,'trikz_soft'),(26,1,12656,15024,512.031,11664,14594.2,512.031,'trikz_alpha'),(27,2,-2679.22,-15248,576.031,-2184.69,-16240,576.031,'trikz_alpha'),(28,3,-13168,-2927.97,-319.969,-12182.1,-1939.35,-319.969,'trikz_alpha'),(29,4,-13168,8239.97,96.0312,-12176,7749.45,96.0312,'trikz_alpha'),(30,1,1373.03,7749.47,1877.53,2215.43,6983.53,1877.53,'trikz_greg'),(31,2,4834.97,6131.97,1930.03,3958.01,4966.43,1930.03,'trikz_greg'),(32,3,251.973,1600.03,-3223.97,-326.154,2542.97,-3223.97,'trikz_greg'),(33,4,9522.03,-8564.97,-2219.97,10475,-8063.49,-2219.97,'trikz_greg'),(34,1,-11392,824.59,-191.969,-10775.8,272.031,-191.969,'trikz_measuregeneric'),(35,2,-2479.97,5328.03,-31.9688,-713.114,6063.97,-31.9688,'trikz_measuregeneric'),(36,3,13232,10832,-1263.97,12496,9127.45,-1263.97,'trikz_measuregeneric'),(38,4,6688.03,-2608.03,-2383.97,7199.97,-3256.77,-2383.97,'trikz_measuregeneric'),(39,1,-447.969,-176.031,-735.969,399.861,-887.969,-735.969,'trikz_learn_hard'),(40,2,-479.969,-1016.03,-1055.97,4.74182,-1707.97,-1055.97,'trikz_learn_hard'),(41,3,15313,-4193.35,-1983.97,16020,-3150.09,-1983.97,'trikz_learn_hard'),(42,1,5071.97,4832.03,-1695.97,4056.57,5951.97,-1695.53,'trikz_penguin'),(43,2,4937.85,8415.97,-3871.97,3961.91,6838.64,-3871.97,'trikz_penguin'),(44,3,5344.03,2688.03,816.031,5983.97,3464.14,816.031,'trikz_penguin'),(45,4,1616.03,-659.969,-3831.97,2104,271.969,-3831.97,'trikz_penguin'),(46,1,-10496,-7271.97,-3647.97,-9952.03,-6557.33,-3647.97,'trikz_reality'),(47,2,-13976,-7928.03,-5551.97,-14760,-8706.92,-5551.97,'trikz_reality'),(48,3,-3919.97,15166,13681,-3428.03,14311.3,13681,'trikz_reality'),(49,4,-13738.2,-48.0312,224.031,-14177.1,-335.969,224.031,'trikz_reality'),(50,5,1493.03,969.122,-1071.97,1900.97,599.85,-1071.97,'trikz_reality'),(51,6,-13827.8,-4380.97,-8933.97,-14659.7,-3437.54,-8933.97,'trikz_reality'),(52,7,-4959.97,13622.7,5072.03,-4016.01,14344.3,5072.03,'trikz_reality'),(53,1,4431.04,4048.03,5632.03,4910.6,5039.97,5632.03,'trikz_RandomRaider'),(54,2,-6063.97,-592.365,5504.03,-5072.03,-1071.81,5504.03,'trikz_RandomRaider'),(55,3,-10767.9,14288,-447.969,-10352,15280,-447.969,'trikz_RandomRaider'),(56,4,6928.13,9360.03,-447.969,7407.2,10288,-447.969,'trikz_RandomRaider'),(57,1,-3823.97,5640,648.031,-3242.85,4368.03,648.031,'trikz_asdfsda_final'),(58,2,-4160.03,9960.03,352.031,-4927.97,11335,352.031,'trikz_asdfsda_final'),(59,3,4959.97,11244,-495.969,4192.03,10611.1,-495.969,'trikz_asdfsda_final'),(60,1,-4847.97,-6728.3,64.0312,-4136.6,-7478.59,64.0312,'trikz_dust_fix'),(61,2,-2922.31,15662.2,-2047.97,-2499.49,15248,-2047.97,'trikz_dust_fix'),(62,3,-12432,13840,-9151.97,-13040,13104,-9151.97,'trikz_dust_fix'),(63,4,4042.13,-1680.03,-13056,5136.47,-4207.97,-13056,'trikz_dust_fix'),(64,5,2031.97,-1664.03,7072.03,1552.03,-2047.97,7072.03,'trikz_dust_fix'),(66,1,-495.969,-7248.03,64.0312,47.9688,-7663.97,64.0312,'trikz_minecraft'),(67,2,3149.26,-198.535,-3007.97,2782.8,-596.48,-3007.97,'trikz_minecraft'),(68,3,7431.97,283.161,-5567.97,5904,-223.797,-5567.97,'trikz_minecraft'),(69,4,-8528.66,10981.1,4160.03,-7787.6,10372.9,4160.03,'trikz_minecraft'),(70,5,-7077.19,6169.82,-10223,-6563.62,6604.25,-10223,'trikz_minecraft');
/*!40000 ALTER TABLE `cp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cp1`
--

DROP TABLE IF EXISTS `cp1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cp1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cpnum` int(11) DEFAULT NULL,
  `cpx` float DEFAULT NULL,
  `cpy` float DEFAULT NULL,
  `cpz` float DEFAULT NULL,
  `cpx2` float DEFAULT NULL,
  `cpy2` float DEFAULT NULL,
  `cpz2` float DEFAULT NULL,
  `map` varchar(192) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cp1`
--

LOCK TABLES `cp1` WRITE;
/*!40000 ALTER TABLE `cp1` DISABLE KEYS */;
/*!40000 ALTER TABLE `cp1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `records`
--

DROP TABLE IF EXISTS `records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) DEFAULT NULL,
  `partnerid` int(11) DEFAULT NULL,
  `time` float DEFAULT NULL,
  `cp1` float DEFAULT NULL,
  `cp2` float DEFAULT NULL,
  `cp3` float DEFAULT NULL,
  `cp4` float DEFAULT NULL,
  `cp5` float DEFAULT NULL,
  `cp6` float DEFAULT NULL,
  `cp7` float DEFAULT NULL,
  `cp8` float DEFAULT NULL,
  `cp9` float DEFAULT NULL,
  `cp10` float DEFAULT NULL,
  `map` varchar(192) DEFAULT NULL,
  `date` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES (14,18496618,120192594,590.328,80.7344,155.562,234.352,507.938,0,0,0,0,0,0,'trikz_eonia',1625387183),(15,146118177,120192594,430.031,45.6875,96.9844,167.031,382.75,0,0,0,0,0,0,'trikz_eonia',1624993908),(16,12298050,120192594,923.199,54.8281,0,0,0,0,0,0,0,0,0,'trikz_eonia',1622704296),(17,120192594,12298050,993.188,0,0,0,0,0,0,0,0,0,0,'trikz_eonia',1623048572),(18,120192594,97826675,456.48,46.6602,0,0,0,0,0,0,0,0,0,'trikz_eonia',1622706681),(19,120192594,61148119,373.906,55.9844,102.562,186.375,333.234,0,0,0,0,0,0,'trikz_eonia',1622886847),(20,120192594,41217631,477.695,65.6641,137.805,219.633,434.32,0,0,0,0,0,0,'trikz_eonia',1626034961),(21,64150955,120192594,4184.31,123.047,347.734,574.172,1745.84,0,0,0,0,0,0,'trikz_eonia',1622822784),(22,120192594,58075991,678,54.5703,100.602,259.266,476.172,0,0,0,0,0,0,'trikz_eonia',1625223406),(23,120192594,61148119,317.969,63.7188,154.844,233.781,301.125,0,0,0,0,0,0,'trikz_cyrus',1623067815),(24,146118177,120192594,1138.06,42.6875,157.75,389.188,682.438,1013.88,0,0,0,0,0,'trikz_adventure',1623227432),(25,146118177,120192594,1776.13,256.125,830.5,1663.42,0,0,0,0,0,0,0,'trikz_soft',1623685420),(26,120192594,58075991,1191.24,93.6875,792.008,1077.26,0,0,0,0,0,0,0,'trikz_soft',1623691212),(27,120192594,180930334,1305.36,233.219,646.25,1194.52,0,0,0,0,0,0,0,'trikz_soft',1623753201),(28,120192594,119414284,649.875,54.5312,121.812,187.469,437.25,0,0,0,0,0,0,'trikz_eonia',1624709629),(29,180930334,120192594,680.844,69.0234,148.609,275.945,569.211,0,0,0,0,0,0,'trikz_eonia',1626034273),(30,67230908,120192594,1229.45,66.3203,186.469,513.359,970.336,0,0,0,0,0,0,'trikz_eonia',1625219492),(31,67230908,120192594,4105,113.25,430.031,1437,3198.66,0,0,0,0,0,0,'trikz_greg',1624628501),(32,41217631,120192594,1353.28,55.3438,166.125,461.562,1217.22,0,0,0,0,0,0,'trikz_greg',1624549969),(33,120192594,41217631,1934.91,163.469,333.844,471.844,1819.16,0,0,0,0,0,0,'trikz_cyrus',1624552389),(34,146118177,120192594,478.75,94.5,272.25,349.281,437,0,0,0,0,0,0,'trikz_cyrus',1624561150),(35,146118177,120192594,1174.41,89.9375,134.719,849.375,1129.19,0,0,0,0,0,0,'trikz_greg',1624620199),(36,120192594,58075991,1300.83,104.828,316.578,688.594,890.781,0,0,0,0,0,0,'trikz_cyrus',1625064398),(37,120192594,1099009937,469.047,54.5156,108.969,229.172,427.578,0,0,0,0,0,0,'trikz_eonia',1624955718),(38,1099009937,120192594,658.859,59.1406,147.703,369.969,641.047,0,0,0,0,0,0,'trikz_measuregeneric',1624956512),(39,120192594,146118177,343.25,39.7188,116.234,230.328,0,0,0,0,0,0,0,'trikz_learn_hard',1625048219),(40,67230908,120192594,524,54.3125,110.594,422.516,0,0,0,0,0,0,0,'trikz_learn_hard',1625049742),(41,67230908,120192594,3089.53,112.781,1979.98,2054.89,3069.17,0,0,0,0,0,0,'trikz_cyrus',1625056432),(42,120192594,180930334,1220.81,78.6562,246.719,517.062,848.594,0,0,0,0,0,0,'trikz_penguin',1625125043),(43,120192594,371538929,610.891,59.0156,116.359,241.562,503.938,0,0,0,0,0,0,'trikz_eonia',1626083181),(44,120192594,371538929,555.438,116.141,348.109,410.141,543.391,545.969,0,0,0,0,0,'trikz_cyrus',1626168084),(45,371538929,120192594,294.375,60.8125,137.125,246.938,605.812,0,0,0,0,0,0,'trikz_learn_hard',1625866671),(46,371538929,120192594,2251.94,61,330.75,534.688,1934.12,0,0,0,0,0,0,'trikz_RandomRaider',1625869404),(47,120192594,371538929,563.859,61.4219,246.859,371.844,439.328,545.969,0,0,0,0,0,'trikz_minecraft',1626167485),(48,120192594,371538929,1175.95,114.625,341.141,885.344,1117.58,700.656,0,0,0,0,0,'trikz_greg',1626087002);
/*!40000 ALTER TABLE `records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `records1`
--

DROP TABLE IF EXISTS `records1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `records1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) DEFAULT NULL,
  `partnerid` int(11) DEFAULT NULL,
  `time` float DEFAULT NULL,
  `cp1` float DEFAULT NULL,
  `cp2` float DEFAULT NULL,
  `cp3` float DEFAULT NULL,
  `cp4` float DEFAULT NULL,
  `cp5` float DEFAULT NULL,
  `cp6` float DEFAULT NULL,
  `cp7` float DEFAULT NULL,
  `cp8` float DEFAULT NULL,
  `cp9` float DEFAULT NULL,
  `cp10` float DEFAULT NULL,
  `map` varchar(192) DEFAULT NULL,
  `date` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records1`
--

LOCK TABLES `records1` WRITE;
/*!40000 ALTER TABLE `records1` DISABLE KEYS */;
/*!40000 ALTER TABLE `records1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL,
  `steamid` int(11) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Nick Jurevich',120192594,3360),(2,'????aaaaa',12298050,560),(3,'Нурик',18496618,600),(4,'бойчик',11070,200),(5,'rinnemaru',1108684233,240),(6,'1',135236385,NULL),(7,'VerMon',180930334,40),(8,'1',205045939,NULL),(9,'1',954285328,NULL),(10,'1',185554338,NULL),(11,'unnamed',97826675,NULL),(12,'1',77893865,NULL),(13,'LOn',58075991,40),(14,'1',189222381,NULL),(15,'Mati',146118177,360),(16,'FL3PPY',61148119,120),(17,'1',27128328,NULL),(18,'1',17384004,NULL),(19,'1',1135423021,NULL),(20,'1',14622106,NULL),(21,'tad bit washed',346817812,NULL),(22,'1',80810556,NULL),(23,'RazoOm',108383178,NULL),(24,'1',69740861,NULL),(25,'????aaaaa',0,NULL),(26,'RUST1C',1106894729,NULL),(27,'ÐšÐžÐ ÐÐ‘Ð›Ð˜Ðš Ð›Ð®Ð‘Ð’Ð˜',77029426,NULL),(28,'SAV1TAR',41217631,40),(29,'Colos Enough !?',240717259,NULL),(30,'DEF',64150955,200),(31,'remember',83111642,NULL),(32,'SEJIYâˆ† * sejiya.ru',54149780,NULL),(33,'meowRin',60226812,NULL),(34,'Zaint',148371419,NULL),(35,'mTi',101384907,NULL),(36,'2b or not 2b',128329572,NULL),(37,'Ð¥Ð¾Ñ€Ð¾ÑˆÐ¸Ð¹',89001873,NULL),(38,'kek',1063610467,NULL),(39,'MC45',125147826,NULL),(40,'LETOXYLITAKZARKO?',388517539,NULL),(41,'☆haku☆',41126676,NULL),(42,'detihueti.ucoz keofly',66390315,NULL),(43,'Kjeldfanger',119414284,NULL),(44,'van der hui',1099009937,0),(45,'no koJIna4ky?',67230908,40),(46,'vepamusoroo',1151715255,NULL),(47,'am4039583',1146515441,NULL),(48,'.Rushaway',44340774,NULL),(49,'CLOWN',867599089,NULL),(50,'☂',127924723,NULL),(51,'virgin!Hunter',1020837288,NULL),(52,'Mete Han',1043715727,NULL),(53,'dolbuyawp youi',1196065543,NULL),(54,'iisakky',478609475,NULL),(55,'GaiMi',1059264057,NULL),(56,'觀自在菩薩行深般若波?',51129478,NULL),(57,'LixPlay19',1032630067,NULL),(58,'spikeface',909774138,NULL),(59,'mOLY',394798675,NULL),(60,'[UA] Zhuzhik',1003325396,NULL),(61,'3feettall',396050657,NULL),(62,'Beolls',143546614,NULL),(63,'xworrl',78489204,NULL),(64,'❤.ytgster|',156370518,NULL),(65,'aNDRUSHKA',26660300,NULL),(66,'poly1305',87562979,NULL),(67,'bLAck-STar [Trikz<3]',52677391,NULL),(68,'Yuko',232068882,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zones`
--

DROP TABLE IF EXISTS `zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `map` varchar(128) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `possition_x` float DEFAULT NULL,
  `possition_y` float DEFAULT NULL,
  `possition_z` float DEFAULT NULL,
  `possition_x2` float DEFAULT NULL,
  `possition_y2` float DEFAULT NULL,
  `possition_z2` float DEFAULT NULL,
  `tier` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zones`
--

LOCK TABLES `zones` WRITE;
/*!40000 ALTER TABLE `zones` DISABLE KEYS */;
INSERT INTO `zones` VALUES (1,'trikz_kyoto_final',0,-6864.03,4143.97,1408.03,-7471.97,3241.55,1408.03,5),(2,'trikz_kyoto_final',1,912.031,-3308.72,-2303.97,1775.97,-2708.79,-2303.97,NULL),(5,'trikz_cyrus',0,5742.53,6600.03,4.03125,5010.03,7087.97,4.03125,2),(6,'trikz_cyrus',1,491.975,2068.03,-2921.97,-1003.97,3563.97,-2921.97,NULL),(9,'trikz_adventure',0,231.969,-179.969,64.0312,-231.996,125.881,64.0312,2),(10,'trikz_adventure',1,-15002,9250.03,2134.03,-14552.4,9802.43,2134.04,NULL),(11,'trikz_eonia',0,2688.03,3071.97,7664.03,3295.97,2720.03,7664.03,NULL),(12,'trikz_eonia',1,59.5152,6450.97,9104.03,780.202,7279.8,9104.03,NULL),(13,'trikz_soft',0,8446.72,1886.04,32.0312,8257.61,1634.51,32.0312,NULL),(14,'trikz_soft',1,11945.2,-6105.7,384.031,12213.5,-6341.6,384.031,NULL),(15,'trikz_alpha',0,-1402.97,-14148.8,64.0312,-1157.42,-14394.7,64.0312,NULL),(16,'trikz_alpha',1,5829.72,15802.5,-1983.97,6074.92,15301.2,-1983.97,NULL),(17,'trikz_greg',0,-4715.97,9063.47,-6731.97,-4326.86,8401.51,-6732.47,NULL),(18,'trikz_greg',1,2348.53,-7286.53,680.031,6689.47,-10363.5,680.031,NULL),(19,'trikz_measuregeneric',0,-559.969,16.0312,48.0312,-16.0312,559.969,48.0312,NULL),(20,'trikz_measuregeneric',1,560.031,-176.031,64.0312,1007.97,-623.969,64.0312,NULL),(21,'trikz_learn_hard',0,-447.969,479.969,-735.969,79.9688,-95.9688,-735.969,NULL),(22,'trikz_learn_hard',1,5514.03,-3759.97,-2428.97,6574.97,-2819.03,-2428.97,NULL),(23,'trikz_penguin',0,-1071.97,1375.97,-1695.97,-516.248,640.031,-1695.97,NULL),(24,'trikz_penguin',1,1136,2310.03,-3469.97,94.0312,3351.97,-3469.97,NULL),(25,'trikz_reality',0,1336.03,14728,7680.03,1688.62,15464,7680.03,NULL),(26,'trikz_reality',1,-12632,2583.97,-3962.97,-13136.6,2392.03,-3962.97,NULL),(27,'trikz_RandomRaider',0,80.0312,-47.9688,5888.03,1071.97,432.195,5888.03,NULL),(28,'trikz_RandomRaider',1,10176,9158.77,-1055.97,10208,9429.86,-1055.97,NULL),(29,'trikz_asdfsda_final',0,-5176.03,7119.97,8.03125,-5711.97,6648.03,8.03125,NULL),(30,'trikz_asdfsda_final',1,6744.03,11253,640.031,7207.97,11989,640.031,NULL),(31,'trikz_dust_fix',0,-13744,-7000.03,206.658,-13376.9,-7287.97,219.927,NULL),(32,'trikz_dust_fix',1,-8113.82,7763.83,11152.1,-8782.75,7439.59,11142.4,NULL),(33,'trikz_minecraft',0,431.969,-911.969,0.03125,-143.969,-528.031,0.03125,NULL),(34,'trikz_minecraft',1,974.861,2447.63,-1535.97,-750.877,4588.32,-1535.97,NULL);
/*!40000 ALTER TABLE `zones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zones1`
--

DROP TABLE IF EXISTS `zones1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zones1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `map` varchar(128) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `possition_x` float DEFAULT NULL,
  `possition_y` float DEFAULT NULL,
  `possition_z` float DEFAULT NULL,
  `possition_x2` float DEFAULT NULL,
  `possition_y2` float DEFAULT NULL,
  `possition_z2` float DEFAULT NULL,
  `tier = 1` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zones1`
--

LOCK TABLES `zones1` WRITE;
/*!40000 ALTER TABLE `zones1` DISABLE KEYS */;
/*!40000 ALTER TABLE `zones1` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-13 13:51:30
