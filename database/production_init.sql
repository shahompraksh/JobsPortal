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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,1,2,'2026-09-10 11:33:06','Hired'),(4,5,13,'2026-09-15 23:56:42','Hired'),(5,3,13,'2026-09-16 00:11:22','Rejected'),(6,3,1,'2026-09-16 08:13:56','Rejected'),(7,3,16,'2026-09-16 10:09:12','Hired'),(8,1,1,'2026-09-16 19:44:41','Hired'),(9,3,14,'2026-09-16 19:52:19','Shortlisted'),(10,1,22,'2026-09-17 07:27:49','Rejected'),(11,1,25,'2026-09-17 11:21:06','Shortlisted');
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (1,'IT','Nepal IT solution','ktm',40000.00,'Knowledge of both frontend and backend','Full-time'),(2,'UI/UX','Nepal It Solution','pkh',50000.00,'good design','Full-time'),(4,'Technical Support Representative','Bhagya Laxmi International Pvt. Ltd.','Kathmandu',45000.00,'Provide front-line technical helpdesk and IT support for enterprise clients. Diagnose software and hardware issues, configure network systems, and maintain customer satisfaction with timely issue resolution.','Full-time'),(5,'Graphic Designer & Content Creator','Himalaya Media Solutions','Lalitpur',42000.00,'Design high-impact visual graphics, digital marketing creatives, website UI banners, and brand identity materials using Adobe Illustrator, Photoshop, and Figma.','Full-time'),(6,'AI-Assisted Software Engineer','Robotics Association of Nepal','Pokhara',75000.00,'Participate in intermediate software engineering projects leveraging modern AI tools, Python, REST APIs, and automated code review workflows. Deliver technical workshops and software modules.','Full-time'),(7,'Biomedical Engineer (Sales & Service)','KNS Enterprises Pvt Ltd','Kathmandu',55000.00,'Responsible for the installation, calibration, and preventive maintenance of advanced biomedical diagnostic equipment across hospitals in Nepal. Provide technical demonstrations and user training.','Full-time'),(8,'Communication and Outreach Officer','Youth Innovation Lab','Lalitpur',60000.00,'Lead communication campaigns, create content for digital outreach, draft impact stories, and coordinate public relations for disaster risk reduction and technological innovation initiatives.','Full-time'),(9,'Data Integration Specialist (Bipad Portal)','Sajag Nepal Project','Kathmandu',85000.00,'Design data pipelines for integrating geohazard datasets into the national Bipad portal. Work with PostgreSQL/PostGIS, Python backend services, and spatial data visualization tools.','Remote'),(10,'Admin and Finance Officer (AFO)','SOSEC Nepal','Dailekh',50000.00,'Manage project accounting, prepare financial statements, coordinate with statutory auditors, and ensure strict compliance with institutional and donor procurement standards.','Full-time'),(11,'Sales Executive Officer','NIP Holdings Pvt Ltd','Kathmandu',38000.00,'Drive B2B sales growth, manage corporate client accounts, conduct product pitches, and hit monthly sales quotas in FMCG and hospitality sectors.','Full-time'),(12,'Project Coordinator','National Federation of the Disabled Nepal','Kathmandu',70000.00,'Coordinate advocacy projects, organize capacity development workshops, collaborate with local municipalities, and submit monthly monitoring progress reports.','Full-time'),(13,'Client Relations Officer','JobsNepal Direct Recruitment','Kathmandu',35000.00,'Coordinate with hiring partners and candidates, schedule interviews, screen resumes, and facilitate smooth onboarding processes for job seekers.','Full-time'),(14,'Emergency Food Security & Livelihoods Officer','Oxfam in Nepal','Birgunj',68000.00,'Implement field-level cash transfer programming, vulnerable household assessments, market monitoring, and emergency response distributions.','Full-time'),(15,'Sustainable Infrastructure Specialist','WWF Nepal','Kathmandu',95000.00,'Advise on green infrastructure development, environmental impact assessments, and ecological corridors to align national infrastructure projects with biodiversity preservation.','Full-time'),(16,'UI/UX','Software Company','Nepal, Kathmandu',60000.00,'08am-05pm','Internship'),(17,'Virtual Teachers for Mathematics, Science, and English','TurnKey Development Group','Kathmandu',45000.00,'Responsible for conducting interactive online classes in Mathematics, Science, and English for secondary level students across Nepal. Preparing comprehensive digital lesson plans, monitoring student engagement, grading assessments, and providing regular feedback.','Remote'),(18,'Operations Manager','International Federation of Red Cross and Red Crescent Societies (IFRC)','Kathmandu',110000.00,'Lead, coordinate, and oversee comprehensive humanitarian disaster relief operations, community resilience initiatives, and risk mitigation strategies across disaster-prone zones in Nepal. Liaise with government authorities and partners.','Full-time'),(19,'Marketing Manager / Sales Executive','Diplomat Nepal Pvt. Ltd.','Kathmandu',52000.00,'Drive institutional and corporate sales outreach across Nepal, identify emerging market opportunities, manage promotional brand campaigns, negotiate commercial supply contracts, and oversee customer relationship management.','Full-time'),(20,'Research, Monitoring and Evaluation Coordinator','FAIRMED Foundation Nepal','Lalitpur',80000.00,'Design, manage, and execute systematic Monitoring, Evaluation, and Learning (MEL) frameworks for maternal/child health programs. Develop quantitative survey instruments, conduct statistical analyses, and draft donor impact reports.','Full-time'),(21,'Part-Time Bookkeeper - Remote','Andmine','Remote',35000.00,'Manage day-to-day accounts payable and receivable, perform regular bank reconciliations, prepare accurate invoicing, and generate monthly profit/loss reports using cloud accounting tools.','Part-time'),(22,'Associate at a Law Firm','Reputed Legal Consultancy','Kathmandu',48000.00,'Conduct detailed legal research, draft commercial agreements and employment contracts, prepare litigation briefs, and represent corporate clients before regulatory authorities and tribunals in Nepal.','Full-time'),(23,'District Project Manager','Action For Nepal','Taplejung',75000.00,'Direct district-level program operations, supervise field teams, oversee multi-sector community development initiatives, manage project budgets, and foster constructive partnerships with local governments.','Full-time'),(24,'Traineeship Opportunities in Project Administration','World Vision International Nepal','Lalitpur',28000.00,'Fast-track professional traineeship program for fresh graduates. Hands-on learning in project coordination, community outreach, digital documentation, and humanitarian program administration.','Internship'),(25,'Client Relations & Order Processing Officer','Kamal Rug','Pokhara',40000.00,'Oversee international and domestic client communications, coordinate custom handicraft order tracking, liaise with production workshops, and ensure high quality delivery and client satisfaction.','Full-time');
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `message` text NOT NULL,
  `contact_method` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT 'Unread',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'Binod Acharya','binod.acharya@everesttech.np','+977-9841234567','Hello Elevate Team, we are looking to post 10+ Senior Engineering vacancies this quarter. Can we discuss an enterprise hiring subscription?','email','2026-09-16 19:30:52','Unread'),(2,'Sunita Maharjan','sunita.m@gmail.com','+977-9801234567','Hi, I recently created a candidate profile. I would like to verify if my contact phone number is masked from public listings until I apply.','phone','2026-09-16 19:30:52','Unread'),(3,'Kiran Karki','kiran@vertexlabs.io','+977-9856012345','We are organizing a Hackathon and Tech Career Fair in Pokhara next month and would love to partner with Elevate Workforce Solutions.','email','2026-09-16 19:30:52','Read'),(4,'Rajesh Hamal','rajesh@cinema.np','+977-9800000000','Looking to inquire about branding and executive hiring partnerships.','email','2026-09-16 19:38:44','Unread'),(5,'Om Prakash Sah','shahomprakash2004@gmail.com','9761819137','I need a break','email','2026-09-16 23:17:30','Unread');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth_accounts`
--

DROP TABLE IF EXISTS `oauth_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth_accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `provider` varchar(32) NOT NULL,
  `provider_user_id` varchar(255) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_provider_uid` (`provider`,`provider_user_id`),
  KEY `idx_oa_user` (`user_id`),
  CONSTRAINT `fk_oa_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth_accounts`
--

LOCK TABLES `oauth_accounts` WRITE;
/*!40000 ALTER TABLE `oauth_accounts` DISABLE KEYS */;
INSERT INTO `oauth_accounts` VALUES (1,13,'google','mock_google_id','google.candidate@elevate.local','2026-09-17 10:31:57'),(2,14,'linkedin','mock_linkedin_id','linkedin.candidate@elevate.local','2026-09-17 10:32:07'),(3,15,'facebook','mock_facebook_id','facebook.candidate@elevate.local','2026-09-17 10:32:07'),(4,16,'apple','mock_apple_id','apple.candidate@elevate.local','2026-09-17 10:32:07');
/*!40000 ALTER TABLE `oauth_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_rate_limits`
--

DROP TABLE IF EXISTS `otp_rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp_rate_limits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(150) NOT NULL,
  `attempt_count` tinyint NOT NULL DEFAULT '1',
  `window_start` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_rl_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_rate_limits`
--

LOCK TABLES `otp_rate_limits` WRITE;
/*!40000 ALTER TABLE `otp_rate_limits` DISABLE KEYS */;
INSERT INTO `otp_rate_limits` VALUES (1,'kit24i.ops@ismt.edu.np',3,'2026-09-17 08:15:40'),(2,'shahomprakash2002@gmail.com',1,'2026-09-17 10:43:20');
/*!40000 ALTER TABLE `otp_rate_limits` ENABLE KEYS */;
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
  `is_verified` tinyint(1) NOT NULL DEFAULT '1',
  `profile_image` varchar(512) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resume` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'ram','ram@gmail.com','ram','$pbkdf2$310000$pVcfy5oNPE6MCMYOHnfU8A==$QkLeKWFyNbD1j0dqvJvCRyycSyuyM0Eib+n0Dvgg31U=','90999999999',1,NULL,'2026-09-17 07:51:51','uploads/Screenshot 2026-09-17 at 07.07.04.png'),(3,'Om Prakash Sah','shahomprakash2004@gmail.com','admin','$pbkdf2$310000$wVl+QWMxcGA/4oAJvzsetw==$jTLOqnc5xNIRjqwTX3rWKex+qFiK1qdw1FD2OPkIW+o=','9761819137',1,NULL,'2026-09-17 07:51:51','uploads/Screenshot 2026-09-15 at 23.57.01.png'),(5,'Dhirendra Kumar Gupta','dhirendragupta572@gmail.com','login','login','9820960396',1,NULL,'2026-09-17 07:51:51','uploads/Screenshot 2026-09-11 at 09.31.40.png'),(6,'Sabin Mandal','sabinmandal189@gmail.com','Sabin','Sabin','',1,NULL,'2026-09-17 07:51:51',NULL),(7,'Arbind Yadav','yadavarbind0205@gmail.com','Arbind','$pbkdf2$310000$HHoeuf5kfjEMqVSsYhl2Bw==$riQzZiOB9mRzlZ6WmVFWOHwv85SBoi1Ea/33xE7ssFU=','9814820942',1,NULL,'2026-09-17 08:11:16',NULL),(8,'Om Prakash Sah','kit24i.ops@ismt.edu.np','Omey','$pbkdf2$310000$P3Fi+12HoA5ODE2qPqbI/g==$JIp5FhRSJdnScF5dKitWeWY7riAs/NAnx3RXpqWed5E=','+9779827750314',1,NULL,'2026-09-17 08:14:10',NULL),(12,'Om Prakash Sah','shahomprakash2002@gmail.com','Hari','$pbkdf2$310000$jqkngXwKiMR5TGD7GoDOLA==$4KodCP3iCXhdW5tAKmkOcA539IJcCS6JefPvM0LRJ0M=','+9779827750314',1,NULL,'2026-09-17 09:44:36',NULL),(13,'Google Candidate','google.candidate@elevate.local','googlecandidate','OAUTH_NO_PASSWORD',NULL,1,'images/candidate-portrait.jpg','2026-09-17 10:31:57',NULL),(14,'LinkedIn Candidate','linkedin.candidate@elevate.local','linkedincandidat','OAUTH_NO_PASSWORD',NULL,1,'images/candidate-portrait.jpg','2026-09-17 10:32:06',NULL),(15,'Facebook Candidate','facebook.candidate@elevate.local','facebookcandidat','OAUTH_NO_PASSWORD',NULL,1,'images/candidate-portrait.jpg','2026-09-17 10:32:07',NULL),(16,'Apple Candidate','apple.candidate@elevate.local','applecandidate','OAUTH_NO_PASSWORD',NULL,1,'images/candidate-portrait.jpg','2026-09-17 10:32:07',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verification_otps`
--

DROP TABLE IF EXISTS `verification_otps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verification_otps` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `otp_hash` varchar(128) NOT NULL,
  `expires_at` datetime NOT NULL,
  `attempts` tinyint NOT NULL DEFAULT '0',
  `used` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_otp_user` (`user_id`),
  CONSTRAINT `fk_otp_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verification_otps`
--

LOCK TABLES `verification_otps` WRITE;
/*!40000 ALTER TABLE `verification_otps` DISABLE KEYS */;
INSERT INTO `verification_otps` VALUES (1,7,'7e72d5d5d4d26322927cf9ca84097f2a:cc96f2eb77512f494f29a711fd072730d020f4b0b0eaccf14e4fab69dcaafb19','2026-09-17 02:36:17',0,0,'2026-09-17 08:11:16'),(2,8,'739e4df0bd5aedce479e03d7d6fcf723:76d7373a65bc471ff1d412b1578b1c3e27f66938d8669eaf76ba4db31a078685','2026-09-17 02:39:10',1,1,'2026-09-17 08:14:10'),(3,8,'6dc4bfe4685e9795c9aae36d345e75e0:db89bd8119f56cdd6df1845615f829646054d54b236a1879f0a8a5661757e7c3','2026-09-17 02:40:41',0,1,'2026-09-17 08:15:40'),(4,8,'049de23c23aace8c1240f0324f369193:1e7aebf55abbcb718437c2c00b34b6f40e9289752d1cebcbd01447291e6cd28d','2026-09-17 02:49:02',0,1,'2026-09-17 08:24:02'),(6,8,'dc874255dd3b2cbe3cff85b045c59e0a:754b2632e1f652704be47a87dcedd58a5973304848d20ccb590b81e7a63d0cf9','2026-09-17 03:27:55',0,1,'2026-09-17 09:02:54'),(7,8,'af3a1b2777d0c1a0a1e50de05aa58cbd:24a7dd8e08b638970771c731abc07574056b55852b851c06db488ffbea3ae7ea','2026-09-17 03:29:08',0,1,'2026-09-17 09:04:07'),(8,8,'2f1b76816bbc5eee19536f2d4e91cbce:d9847569f040a58781c41f7514f91ad9f72e578588500ffbe594cb0b17bf5d7d','2026-09-17 03:58:33',0,1,'2026-09-17 09:33:32'),(11,12,'982c50ccbb96a71046305a0b37b73dc1:92a196eeba2456dae30eb214135ce3d6830d3618b39ca198dc93d6c452916015','2026-09-17 06:03:57',0,1,'2026-09-17 09:44:36'),(12,12,'8544c45d29c2c44c2abaa2f358ed5e73:187738b06c94fa645abf7021ebc284ed0410a7f753f8818ecff6171513b530af','2026-09-17 05:01:01',4,1,'2026-09-17 10:36:00'),(13,12,'e29a98c9c023ed84c828ba304bef6539:c81ec76833244db3b96b1a441dd900467e50568eea22eaef39a2c07470f43e75','2026-09-17 05:08:20',0,1,'2026-09-17 10:43:20'),(14,12,'63136554aeab829bec664bebd70320e3:c734282a9354ae36c571b12ee3c42e5b38b5644c83c95fe3fcf3626f267720ef','2026-09-17 07:04:47',1,1,'2026-09-17 10:47:48'),(15,12,'b13cd2e0fb87895dd41b64e6be16dd43:9a8f3b979acdb34c7efab686092dd24c75e6ebe440b80429391367939d107738','2026-09-17 05:16:05',1,0,'2026-09-17 10:51:04'),(16,8,'0ae9126195d8725bc2346e9a03acd38e:ca094386d2c2a032498790c09f47db44612ddab3a69630349027731008c2e41a','2026-09-17 05:16:47',0,0,'2026-09-17 10:51:46'),(17,1,'4fbd843a309283fda99a06df21ad5e4b:569fed9a5bb0ddc0b6e221fc43db7e44dc0fb94b450ad53d023463f88109096a','2026-09-17 05:16:52',0,1,'2026-09-17 10:51:51'),(18,3,'ae15fc06b2d819bc778942d38c0992f5:97c46891df4fc0436b12393899c6b77fbb57975116c4e969aaa07058e5444db3','2026-09-17 05:17:18',0,1,'2026-09-17 10:52:18'),(19,3,'f2788e7ca7b3fd890ef0aaa59036a426:2a60bca5517ce58a34e295d2011591e0b2c4d0622c9a0ed596a32be61480e50f','2026-09-17 05:35:01',0,0,'2026-09-17 11:10:01'),(20,1,'4ba619c96f1cbe617608df94cc813cd7:4da4098f81533c2860043fd0edf389e90425b9b0129c9dc407c2a24aa780fb4a','2026-09-17 05:36:00',0,0,'2026-09-17 11:11:00');
/*!40000 ALTER TABLE `verification_otps` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-17 11:30:13
