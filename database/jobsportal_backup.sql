-- MySQL dump 10.13  Distrib 26.7.0, for macos26.6 (arm64)
--
-- Host: localhost    Database: jobsportal
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'f7387b4a-1e9e-11f1-9a80-3fc82f9354e8:1-46';

--
-- Current Database: `jobsportal`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `jobsportal` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `jobsportal`;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'admin','ktm','admin','admin');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `job_id` int NOT NULL,
  `applied_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_job` (`user_id`,`job_id`),
  KEY `fk_applications_job` (`job_id`),
  CONSTRAINT `fk_applications_job` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_applications_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,1,2,'2026-09-10 11:33:06','Rejected'),(4,5,13,'2026-09-15 23:56:42','Rejected'),(5,3,13,'2026-09-16 00:11:22','Hired');
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `company` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `location` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `salary` decimal(12,2) DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (1,'IT','Nepal IT solution','ktm',40000.00,'Knowledge of both frontend and backend','Full-time'),(2,'UI/UX','Nepal It Solution','pkh',50000.00,'good design','Full-time'),(4,'Technical Support Representative','Bhagya Laxmi International Pvt. Ltd.','Kathmandu',45000.00,'Provide front-line technical helpdesk and IT support for enterprise clients. Diagnose software and hardware issues, configure network systems, and maintain customer satisfaction with timely issue resolution.','Full-time'),(5,'Graphic Designer & Content Creator','Himalaya Media Solutions','Lalitpur',42000.00,'Design high-impact visual graphics, digital marketing creatives, website UI banners, and brand identity materials using Adobe Illustrator, Photoshop, and Figma.','Full-time'),(6,'AI-Assisted Software Engineer','Robotics Association of Nepal','Pokhara',75000.00,'Participate in intermediate software engineering projects leveraging modern AI tools, Python, REST APIs, and automated code review workflows. Deliver technical workshops and software modules.','Full-time'),(7,'Biomedical Engineer (Sales & Service)','KNS Enterprises Pvt Ltd','Kathmandu',55000.00,'Responsible for the installation, calibration, and preventive maintenance of advanced biomedical diagnostic equipment across hospitals in Nepal. Provide technical demonstrations and user training.','Full-time'),(8,'Communication and Outreach Officer','Youth Innovation Lab','Lalitpur',60000.00,'Lead communication campaigns, create content for digital outreach, draft impact stories, and coordinate public relations for disaster risk reduction and technological innovation initiatives.','Full-time'),(9,'Data Integration Specialist (Bipad Portal)','Sajag Nepal Project','Kathmandu',85000.00,'Design data pipelines for integrating geohazard datasets into the national Bipad portal. Work with PostgreSQL/PostGIS, Python backend services, and spatial data visualization tools.','Remote'),(10,'Admin and Finance Officer (AFO)','SOSEC Nepal','Dailekh',50000.00,'Manage project accounting, prepare financial statements, coordinate with statutory auditors, and ensure strict compliance with institutional and donor procurement standards.','Full-time'),(11,'Sales Executive Officer','NIP Holdings Pvt Ltd','Kathmandu',38000.00,'Drive B2B sales growth, manage corporate client accounts, conduct product pitches, and hit monthly sales quotas in FMCG and hospitality sectors.','Full-time'),(12,'Project Coordinator','National Federation of the Disabled Nepal','Kathmandu',70000.00,'Coordinate advocacy projects, organize capacity development workshops, collaborate with local municipalities, and submit monthly monitoring progress reports.','Full-time'),(13,'Client Relations Officer','JobsNepal Direct Recruitment','Kathmandu',35000.00,'Coordinate with hiring partners and candidates, schedule interviews, screen resumes, and facilitate smooth onboarding processes for job seekers.','Full-time'),(14,'Emergency Food Security & Livelihoods Officer','Oxfam in Nepal','Birgunj',68000.00,'Implement field-level cash transfer programming, vulnerable household assessments, market monitoring, and emergency response distributions.','Full-time'),(15,'Sustainable Infrastructure Specialist','WWF Nepal','Kathmandu',95000.00,'Advise on green infrastructure development, environmental impact assessments, and ecological corridors to align national infrastructure projects with biodiversity preservation.','Full-time');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `resume` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'ram','ram@gmail.com','ram','ram','90999999999',NULL),(3,'Om Prakash Sah','shahomprakash2004@gmail.com','admin','admin','9761819137','uploads/Screenshot 2026-09-15 at 23.57.01.png'),(5,'Dhirendra Kumar Gupta','dhirendragupta572@gmail.com','login','login','9820960396',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-16  0:41:29
