-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: base_list
-- ------------------------------------------------------
-- Server version	11.7.2-MariaDB

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can view permission',1,'view_permission'),(5,'Can add group',2,'add_group'),(6,'Can change group',2,'change_group'),(7,'Can delete group',2,'delete_group'),(8,'Can view group',2,'view_group'),(9,'Can add content type',3,'add_contenttype'),(10,'Can change content type',3,'change_contenttype'),(11,'Can delete content type',3,'delete_contenttype'),(12,'Can view content type',3,'view_contenttype'),(13,'Can add user',4,'add_disenador'),(14,'Can change user',4,'change_disenador'),(15,'Can delete user',4,'delete_disenador'),(16,'Can view user',4,'view_disenador'),(17,'Can add proyecto',5,'add_proyecto'),(18,'Can change proyecto',5,'change_proyecto'),(19,'Can delete proyecto',5,'delete_proyecto'),(20,'Can view proyecto',5,'view_proyecto'),(21,'Can add tarea',6,'add_tarea'),(22,'Can change tarea',6,'change_tarea'),(23,'Can delete tarea',6,'delete_tarea'),(24,'Can view tarea',6,'view_tarea'),(25,'Can add log entry',7,'add_logentry'),(26,'Can change log entry',7,'change_logentry'),(27,'Can delete log entry',7,'delete_logentry'),(28,'Can view log entry',7,'view_logentry'),(29,'Can add session',8,'add_session'),(30,'Can change session',8,'change_session'),(31,'Can delete session',8,'delete_session'),(32,'Can view session',8,'view_session'),(33,'Can add disponibilidad',9,'add_disponibilidad'),(34,'Can change disponibilidad',9,'change_disponibilidad'),(35,'Can delete disponibilidad',9,'delete_disponibilidad'),(36,'Can view disponibilidad',9,'view_disponibilidad'),(37,'Can add comentario',10,'add_comentario'),(38,'Can change comentario',10,'change_comentario'),(39,'Can delete comentario',10,'delete_comentario'),(40,'Can view comentario',10,'view_comentario');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_list_disenador_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_list_disenador_id` FOREIGN KEY (`user_id`) REFERENCES `list_disenador` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (7,'admin','logentry'),(2,'auth','group'),(1,'auth','permission'),(3,'contenttypes','contenttype'),(10,'list','comentario'),(4,'list','disenador'),(9,'list','disponibilidad'),(5,'list','proyecto'),(6,'list','tarea'),(8,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-03-10 12:28:13.245222'),(2,'contenttypes','0002_remove_content_type_name','2025-03-10 12:28:13.288988'),(3,'auth','0001_initial','2025-03-10 12:28:13.448676'),(4,'auth','0002_alter_permission_name_max_length','2025-03-10 12:28:13.478888'),(5,'auth','0003_alter_user_email_max_length','2025-03-10 12:28:13.482693'),(6,'auth','0004_alter_user_username_opts','2025-03-10 12:28:13.486299'),(7,'auth','0005_alter_user_last_login_null','2025-03-10 12:28:13.495402'),(8,'auth','0006_require_contenttypes_0002','2025-03-10 12:28:13.498113'),(9,'auth','0007_alter_validators_add_error_messages','2025-03-10 12:28:13.510260'),(10,'auth','0008_alter_user_username_max_length','2025-03-10 12:28:13.515212'),(11,'auth','0009_alter_user_last_name_max_length','2025-03-10 12:28:13.520312'),(12,'auth','0010_alter_group_name_max_length','2025-03-10 12:28:13.537803'),(13,'auth','0011_update_proxy_permissions','2025-03-10 12:28:13.543789'),(14,'auth','0012_alter_user_first_name_max_length','2025-03-10 12:28:13.547924'),(15,'list','0001_initial','2025-03-10 12:28:13.924184'),(16,'list','0002_alter_disenador_cargo','2025-03-10 12:28:13.932812'),(17,'admin','0001_initial','2025-03-10 12:29:17.600050'),(18,'admin','0002_logentry_remove_auto_add','2025-03-10 12:29:17.615676'),(19,'admin','0003_logentry_add_action_flag_choices','2025-03-10 12:29:17.615676'),(20,'sessions','0001_initial','2025-03-10 12:29:17.652540'),(21,'list','0003_tarea_creador','2025-03-10 13:15:35.368760'),(22,'list','0004_alter_disenador_cargo','2025-03-10 14:05:07.855706'),(23,'list','0005_disponibilidad','2025-03-10 16:16:27.226867'),(24,'list','0006_delete_disponibilidad','2025-03-10 16:52:17.810223'),(25,'list','0007_disenador_disponibilidad','2025-03-10 17:37:52.703638'),(26,'list','0008_comentario','2025-03-18 13:50:11.250436'),(27,'list','0009_alter_comentario_fecha_creacion','2025-03-18 14:28:05.896486');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0o4hk5cr6a2ne3k52bk8np3e5zsr8qj1','.eJxVjMsKwyAQRf_FdZH4iI8uu883yOiMNW1RiMmq9N-LkEULd3XP4bxZgGMv4ei0hRXZlSl2-f0ipCfVAfAB9d54anXf1siHwk_a-dKQXrfT_QsU6GVkMdqxLARpO6MT1iMm76XV0aCQ0usJkJJKM0FWxgptcpxcstpFR-zzBfaPOEY:1tre9F:8PA9PTsBOzHhTjXlroYz5mHRx53yGhDrQtbgGIGFG_I','2025-03-24 14:30:29.076566'),('29p44lmwa5nrm5g5zahtbqmtb7voa2t1','.eJxVjMsOwiAQRf-FtSE8MkBduvcbyDAMUjWQlHZl_Hdt0oVu7znnvkTEba1xG7zEOYuz0OL0uyWkB7cd5Du2W5fU27rMSe6KPOiQ1575eTncv4OKo35rRZb8pAsGD8F5RdlCKVCQmcGalHDSNhiy7DNCAlLOA1jWOiRQxon3B-9CN9E:1trfU0:8BQDsk9hRgsjfwxXxRsWXppTG8s3K2I9FVPKqT4MiPo','2025-03-24 15:56:00.683552'),('b3wdtv8kiye8s2xbatwqvy2226osdcor','.eJxVjMsKwyAQRf_FdZH4iI8uu883yOiMNW1RiMmq9N-LkEULd3XP4bxZgGMv4ei0hRXZlSl2-f0ipCfVAfAB9d54anXf1siHwk_a-dKQXrfT_QsU6GVkMdqxLARpO6MT1iMm76XV0aCQ0usJkJJKM0FWxgptcpxcstpFR-zzBfaPOEY:1tuWOt:byRvKW75DEuDIo5euVBcYKj809M5sHEuFIBi0h5ImKc','2025-04-01 12:50:31.523924'),('bzlln4ayj9y8g1u8d3ci0ukeghk9qsuf','.eJxVjMsOwiAQRf-FtSHA8HTp3m8gMAxSNTQp7cr479qkC93ec859sZi2tcVt0BKnws5Ms9PvlhM-qO-g3FO_zRznvi5T5rvCDzr4dS70vBzu30FLo31rNAEANEhrCbTzVWRwXocUwJH3UtUs0AVSDqU0TiGGLFI1wpbiJQB7fwCvnzbC:1tucUn:avhBLs0J2ncGQyPFr2rSoE_W86M-Sm_1NouQDinyiSA','2025-04-01 19:21:01.123591'),('e1uwudsfpbwikv0tcx1tci3tayig1u1g','.eJxVjEEOwiAQRe_C2pABoViX7j0DGWYGqRpISrsy3l2bdKHb_977LxVxXUpcu8xxYnVWTh1-t4T0kLoBvmO9NU2tLvOU9KbonXZ9bSzPy-7-HRTs5VtbFhaBMZMNlskD0-hcyEmInBhD7CHbhMYGGSQEAvZBjoAJ8GRxUO8PHV85Dg:1trhP5:93aT15G0xJvJ7g-VVLVwJsAIAFULOEHGGgTY12TVjjo','2025-03-24 17:59:03.416796'),('ftgjfeaxjez1lgv5f1crckh7wv9e5921','.eJxVjMsOwiAQRf-FtSE8MkBduvcbyDAMUjWQlHZl_Hdt0oVu7znnvkTEba1xG7zEOYuz0OL0uyWkB7cd5Du2W5fU27rMSe6KPOiQ1575eTncv4OKo35rRZb8pAsGD8F5RdlCKVCQmcGalHDSNhiy7DNCAlLOA1jWOiRQxon3B-9CN9E:1txVAu:7mAWNDCgrHRLJIXud2rrWNl605mE_Ts69S31DewUQs4','2025-04-09 18:08:24.791122'),('g97o2ykwqbe5n1oxgaio82kryse5fgf3','.eJxVjEEOwiAQRe_C2pABoViX7j0DGWYGqRpISrsy3l2bdKHb_977LxVxXUpcu8xxYnVWTh1-t4T0kLoBvmO9NU2tLvOU9KbonXZ9bSzPy-7-HRTs5VtbFhaBMZMNlskD0-hcyEmInBhD7CHbhMYGGSQEAvZBjoAJ8GRxUO8PHV85Dg:1tuW30:aInw7nP90bWa892bmCteOFrXSJh38bKl2XEc35stmtM','2025-04-01 12:27:54.335897'),('j6zdpbd9zsca4o6euq3kff770jcl32au','.eJxVjMsOwiAQRf-FtSHA8HTp3m8gMAxSNTQp7cr479qkC93ec859sZi2tcVt0BKnws5Ms9PvlhM-qO-g3FO_zRznvi5T5rvCDzr4dS70vBzu30FLo31rNAEANEhrCbTzVWRwXocUwJH3UtUs0AVSDqU0TiGGLFI1wpbiJQB7fwCvnzbC:1tucB9:3YtGVJAMinYKZHoSWYXW_iHoSed_6KXLaFyvwuIM1mQ','2025-04-01 19:00:43.090634'),('jhlj23tpzjyaz7ublnlu7c9ygk7nj4bf','.eJxVjMsKwyAQRf_FdZH4iI8uu883yOiMNW1RiMmq9N-LkEULd3XP4bxZgGMv4ei0hRXZlSl2-f0ipCfVAfAB9d54anXf1siHwk_a-dKQXrfT_QsU6GVkMdqxLARpO6MT1iMm76XV0aCQ0usJkJJKM0FWxgptcpxcstpFR-zzBfaPOEY:1tuDNf:Z7g7ULRuKm4KwGBn2GLBuwMHH6_teAmg1jjqJRLH4E4','2025-03-31 16:31:59.616449'),('m66xg8z5lpiu27dx1cd6sbd8mv6ju95s','.eJxVjMsOwiAQRf-FtSE8MkBduvcbyDAMUjWQlHZl_Hdt0oVu7znnvkTEba1xG7zEOYuz0OL0uyWkB7cd5Du2W5fU27rMSe6KPOiQ1575eTncv4OKo35rRZb8pAsGD8F5RdlCKVCQmcGalHDSNhiy7DNCAlLOA1jWOiRQxon3B-9CN9E:1trdRq:ppD1YW6JFQavIbhpfFYLd6L2s9XLB_0ixTL68TyyqpE','2025-03-24 13:45:38.222776'),('s0a6fni4groehs7yms7zpdt5nd55n1p7','.eJxVjMsOwiAQRf-FtSE8MkBduvcbyDAMUjWQlHZl_Hdt0oVu7znnvkTEba1xG7zEOYuz0OL0uyWkB7cd5Du2W5fU27rMSe6KPOiQ1575eTncv4OKo35rRZb8pAsGD8F5RdlCKVCQmcGalHDSNhiy7DNCAlLOA1jWOiRQxon3B-9CN9E:1tuDHo:TKEy9IGw4KtDD4PdMRbRWGTCgZNHqAwSUcxGXMG2MLA','2025-03-31 16:25:56.210387'),('tbec9pk64781aetrb5cj9oj19kgzghhz','.eJxVjMsOwiAQRf-FtSHA8HTp3m8gMAxSNTQp7cr479qkC93ec859sZi2tcVt0BKnws5Ms9PvlhM-qO-g3FO_zRznvi5T5rvCDzr4dS70vBzu30FLo31rNAEANEhrCbTzVWRwXocUwJH3UtUs0AVSDqU0TiGGLFI1wpbiJQB7fwCvnzbC:1txU6A:k0mritph6QpsVXokCNK4UkZZ7_QMV9aPkRfRv4elv-g','2025-04-09 16:59:26.832079'),('y9kouonldooeczv5g0jlheof9hjwpm7c','.eJxVjMsOwiAQRf-FtSE8MkBduvcbyDAMUjWQlHZl_Hdt0oVu7znnvkTEba1xG7zEOYuz0OL0uyWkB7cd5Du2W5fU27rMSe6KPOiQ1575eTncv4OKo35rRZb8pAsGD8F5RdlCKVCQmcGalHDSNhiy7DNCAlLOA1jWOiRQxon3B-9CN9E:1txUD9:aXTpButaVg790s9uWdDj04KNL3409XEM46KTJ7SS1lg','2025-04-09 17:06:39.230184'),('ygzqoj8u3fuyh5jqn9uapzhu31lnyagr','.eJxVjMsOwiAQRf-FtSHA8HTp3m8gMAxSNTQp7cr479qkC93ec859sZi2tcVt0BKnws5Ms9PvlhM-qO-g3FO_zRznvi5T5rvCDzr4dS70vBzu30FLo31rNAEANEhrCbTzVWRwXocUwJH3UtUs0AVSDqU0TiGGLFI1wpbiJQB7fwCvnzbC:1tucLN:GuIeFddFGndUK_4pcvXySEMWcfm7VxHj8uD5KhEPlGo','2025-04-01 19:11:17.092083');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_comentario`
--

DROP TABLE IF EXISTS `list_comentario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list_comentario` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `contenido` longtext NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `proyecto_id` bigint(20) DEFAULT NULL,
  `tarea_id` bigint(20) DEFAULT NULL,
  `usuario_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `list_comentario_proyecto_id_4b974510_fk_list_proyecto_id` (`proyecto_id`),
  KEY `list_comentario_tarea_id_ca2eb5f1_fk_list_tarea_id` (`tarea_id`),
  KEY `list_comentario_usuario_id_8926cb6f_fk_list_disenador_id` (`usuario_id`),
  CONSTRAINT `list_comentario_proyecto_id_4b974510_fk_list_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `list_proyecto` (`id`),
  CONSTRAINT `list_comentario_tarea_id_ca2eb5f1_fk_list_tarea_id` FOREIGN KEY (`tarea_id`) REFERENCES `list_tarea` (`id`),
  CONSTRAINT `list_comentario_usuario_id_8926cb6f_fk_list_disenador_id` FOREIGN KEY (`usuario_id`) REFERENCES `list_disenador` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_comentario`
--

LOCK TABLES `list_comentario` WRITE;
/*!40000 ALTER TABLE `list_comentario` DISABLE KEYS */;
INSERT INTO `list_comentario` VALUES (26,'@isabel@correo.com oli','2025-03-18 18:36:35.399923',NULL,21,1),(31,'@administrador@correo.com cakita','2025-03-18 19:14:56.391066',NULL,21,4),(34,'falopa','2025-03-18 19:24:41.022084',NULL,8,4),(35,'tolueno','2025-03-26 16:57:19.324671',NULL,8,1),(36,'tolueno','2025-03-26 17:08:20.733465',NULL,22,4);
/*!40000 ALTER TABLE `list_comentario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_comentario_menciones`
--

DROP TABLE IF EXISTS `list_comentario_menciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list_comentario_menciones` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `comentario_id` bigint(20) NOT NULL,
  `disenador_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `list_comentario_mencione_comentario_id_disenador__3b1fe36b_uniq` (`comentario_id`,`disenador_id`),
  KEY `list_comentario_menc_disenador_id_8795cebe_fk_list_dise` (`disenador_id`),
  CONSTRAINT `list_comentario_menc_comentario_id_7326074d_fk_list_come` FOREIGN KEY (`comentario_id`) REFERENCES `list_comentario` (`id`),
  CONSTRAINT `list_comentario_menc_disenador_id_8795cebe_fk_list_dise` FOREIGN KEY (`disenador_id`) REFERENCES `list_disenador` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_comentario_menciones`
--

LOCK TABLES `list_comentario_menciones` WRITE;
/*!40000 ALTER TABLE `list_comentario_menciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `list_comentario_menciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_disenador`
--

DROP TABLE IF EXISTS `list_disenador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list_disenador` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `cargo` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(254) NOT NULL,
  `supervisor_id` bigint(20) DEFAULT NULL,
  `disponibilidad` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `correo` (`correo`),
  KEY `list_disenador_supervisor_id_349a0b73_fk_list_disenador_id` (`supervisor_id`),
  CONSTRAINT `list_disenador_supervisor_id_349a0b73_fk_list_disenador_id` FOREIGN KEY (`supervisor_id`) REFERENCES `list_disenador` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_disenador`
--

LOCK TABLES `list_disenador` WRITE;
/*!40000 ALTER TABLE `list_disenador` DISABLE KEYS */;
INSERT INTO `list_disenador` VALUES (1,'pbkdf2_sha256$870000$NUToTmBijxwtcicTdIunr5$Df7SQoAW13PvCCLk9FTSp023Bb+nkDRLI2m2dUFAcjg=','2025-03-26 18:08:24.791122',0,'jordan@correo.com','','','',0,1,'2025-03-10 12:29:40.537264','PROJECT MANAGER','jordan','jordan@correo.com',NULL,40),(2,'pbkdf2_sha256$870000$zzh1hD7CSPlfy9ThDelxVH$Ir0x7W/nDWi+VRopQbma/MgUC+vGyaFhbK0PX3nG/x0=','2025-03-26 16:57:49.891744',0,'santiago@correo.com','','','',0,1,'2025-03-10 12:31:16.577949','DISENADOR','santiago','santiago@correo.com',5,283.625),(3,'pbkdf2_sha256$870000$hFnbBOGEsLErny100F1wL2$HsYDPBO47En42rfgw0SmYXilbjWOt0rz66tcDjGjj0E=','2025-03-26 17:06:11.987245',0,'administrador@correo.com','','','',0,1,'2025-03-10 14:16:25.706158','ADMINISTRADOR','administrador','administrador@correo.com',NULL,40),(4,'pbkdf2_sha256$870000$esHBeBsw9L9QmGVjgX7rDl$0wo9OSukSCXbVskDl8g8rAaDRu14q8xtdawBqvRg+zY=','2025-03-26 16:59:26.830077',0,'isabel@correo.com','','','',0,1,'2025-03-10 17:59:02.930735','DISENADOR','isabel','isabel@correo.com',5,297.625),(5,'pbkdf2_sha256$870000$vglIg1LnU9WGh71JoKTBgw$tFMeqoJYekI1bH27DxfZwnnM2VFIFdZ2PLq3tcbebvY=','2025-03-18 18:47:09.269160',0,'gorila@correo.com','','','',0,1,'2025-03-18 18:47:08.946108','SUPERVISOR','gorila','gorila@correo.com',NULL,40);
/*!40000 ALTER TABLE `list_disenador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_disenador_groups`
--

DROP TABLE IF EXISTS `list_disenador_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list_disenador_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `disenador_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `list_disenador_groups_disenador_id_group_id_d48a55db_uniq` (`disenador_id`,`group_id`),
  KEY `list_disenador_groups_group_id_ecb5e8a6_fk_auth_group_id` (`group_id`),
  CONSTRAINT `list_disenador_groups_disenador_id_89125df1_fk_list_disenador_id` FOREIGN KEY (`disenador_id`) REFERENCES `list_disenador` (`id`),
  CONSTRAINT `list_disenador_groups_group_id_ecb5e8a6_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_disenador_groups`
--

LOCK TABLES `list_disenador_groups` WRITE;
/*!40000 ALTER TABLE `list_disenador_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `list_disenador_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_disenador_user_permissions`
--

DROP TABLE IF EXISTS `list_disenador_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list_disenador_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `disenador_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `list_disenador_user_perm_disenador_id_permission__e31e0e41_uniq` (`disenador_id`,`permission_id`),
  KEY `list_disenador_user__permission_id_c8798aea_fk_auth_perm` (`permission_id`),
  CONSTRAINT `list_disenador_user__disenador_id_f91909a4_fk_list_dise` FOREIGN KEY (`disenador_id`) REFERENCES `list_disenador` (`id`),
  CONSTRAINT `list_disenador_user__permission_id_c8798aea_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_disenador_user_permissions`
--

LOCK TABLES `list_disenador_user_permissions` WRITE;
/*!40000 ALTER TABLE `list_disenador_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `list_disenador_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_proyecto`
--

DROP TABLE IF EXISTS `list_proyecto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list_proyecto` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` longtext NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` varchar(10) NOT NULL,
  `creador_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `list_proyecto_creador_id_3f8e65a5_fk_list_disenador_id` (`creador_id`),
  CONSTRAINT `list_proyecto_creador_id_3f8e65a5_fk_list_disenador_id` FOREIGN KEY (`creador_id`) REFERENCES `list_disenador` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_proyecto`
--

LOCK TABLES `list_proyecto` WRITE;
/*!40000 ALTER TABLE `list_proyecto` DISABLE KEYS */;
INSERT INTO `list_proyecto` VALUES (4,'st paul','prueba disponibilidad','2025-03-17','2025-03-18','RTS',1),(5,'texas','texas project','2025-03-24','2025-03-31','RTS',1),(6,'Santiago','Test','2025-03-26','2025-04-03','RTS',1);
/*!40000 ALTER TABLE `list_proyecto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_tarea`
--

DROP TABLE IF EXISTS `list_tarea`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list_tarea` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tipo_tarea` varchar(50) NOT NULL,
  `descripcion` longtext NOT NULL,
  `estado` varchar(20) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `cantidad_graficos` int(10) unsigned NOT NULL CHECK (`cantidad_graficos` >= 0),
  `horas_estimadas` double DEFAULT NULL,
  `horas_manuales` tinyint(1) NOT NULL,
  `horas_reales` int(10) unsigned DEFAULT NULL CHECK (`horas_reales` >= 0),
  `proyecto_id` bigint(20) NOT NULL,
  `creador_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `list_tarea_proyecto_id_d130d355_fk_list_proyecto_id` (`proyecto_id`),
  KEY `list_tarea_creador_id_0cfa91c8_fk_list_disenador_id` (`creador_id`),
  CONSTRAINT `list_tarea_creador_id_0cfa91c8_fk_list_disenador_id` FOREIGN KEY (`creador_id`) REFERENCES `list_disenador` (`id`),
  CONSTRAINT `list_tarea_proyecto_id_d130d355_fk_list_proyecto_id` FOREIGN KEY (`proyecto_id`) REFERENCES `list_proyecto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_tarea`
--

LOCK TABLES `list_tarea` WRITE;
/*!40000 ALTER TABLE `list_tarea` DISABLE KEYS */;
INSERT INTO `list_tarea` VALUES (8,'3D FLOORPLAN','prueba','PENDIENTE','2025-03-17','2025-03-18',9,24.75,0,NULL,4,1),(20,'2D FLOORPLAN','1','PENDIENTE','2025-03-17','2025-03-18',13,29.25,0,NULL,4,1),(21,'3D FLOORPLAN','floor 1\r\nfloor 2\r\nfloor 3\r\nfloor 4\r\nfloor 5','PENDIENTE','2025-03-24','2025-03-31',5,13.75,0,NULL,5,1),(22,'3D FLOORPLAN','Floor 1\r\nfloor 2\r\nfloor 3','EN_PROGRESO','2025-03-26','2025-04-03',3,8.25,0,NULL,6,1);
/*!40000 ALTER TABLE `list_tarea` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_tarea_disenadores`
--

DROP TABLE IF EXISTS `list_tarea_disenadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `list_tarea_disenadores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tarea_id` bigint(20) NOT NULL,
  `disenador_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `list_tarea_disenadores_tarea_id_disenador_id_38cdc419_uniq` (`tarea_id`,`disenador_id`),
  KEY `list_tarea_disenador_disenador_id_7e739aef_fk_list_dise` (`disenador_id`),
  CONSTRAINT `list_tarea_disenador_disenador_id_7e739aef_fk_list_dise` FOREIGN KEY (`disenador_id`) REFERENCES `list_disenador` (`id`),
  CONSTRAINT `list_tarea_disenadores_tarea_id_73b8ac78_fk_list_tarea_id` FOREIGN KEY (`tarea_id`) REFERENCES `list_tarea` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_tarea_disenadores`
--

LOCK TABLES `list_tarea_disenadores` WRITE;
/*!40000 ALTER TABLE `list_tarea_disenadores` DISABLE KEYS */;
INSERT INTO `list_tarea_disenadores` VALUES (26,8,4),(27,20,4),(28,21,4),(29,22,4);
/*!40000 ALTER TABLE `list_tarea_disenadores` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-04 10:18:53
