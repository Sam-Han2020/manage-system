drop schema if exists web;

create schema web;


use web;

-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: word
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '标题',
  `content` text NOT NULL COMMENT '内容',
  `author_name` varchar(50) NOT NULL COMMENT '作者名',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_author_name` (`author_name`),
  CONSTRAINT `fk_author_name` FOREIGN KEY (`author_name`) REFERENCES `authort` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` VALUES (4,'数据库：MySQL 索引优化策略','分析 MySQL 索引原理及优化方法...','author1','2023-04-25 16:15:00','2025-04-16 10:52:04'),(5,'算法解析：快速排序算法实现','详细讲解快速排序的原理和代码实现...','author5','2023-05-30 09:00:00','2023-05-30 09:00:00'),(6,'设计模式：工厂模式应用场景','介绍工厂模式在软件开发中的实际应用...','author6','2023-06-10 11:20:00','2023-06-10 11:20:00'),(7,'移动端开发：Flutter 布局实战','分享 Flutter 布局组件的使用技巧...','author7','2023-07-18 13:40:00','2023-07-18 13:40:00'),(8,'大数据：Hadoop 集群搭建指南','详细步骤讲解 Hadoop 集群的搭建过程...','author8','2023-08-25 15:50:00','2023-08-25 15:50:00'),(9,'人工智能：深度学习入门教程','介绍深度学习的基本概念和框架...','author9','2023-09-05 08:30:00','2023-09-05 08:30:00'),(10,'云计算：AWS 服务器配置经验','分享 AWS 服务器部署和配置的经验...','author10','2023-10-12 10:45:00','2023-10-12 10:45:00'),(11,'网络安全：常见攻击类型及防护','分析 SQL 注入、XSS 等攻击的原理和防护...','author11','2024-01-01 14:00:00','2024-01-01 14:00:00'),(12,'区块链：智能合约开发实践','讲解 Solidity 智能合约的编写和部署...','author12','2024-02-15 16:30:00','2024-02-15 16:30:00'),(13,'DevOps：持续集成与部署实践','介绍 Jenkins 在 CI/CD 中的应用...','author13','2024-03-20 09:15:00','2024-03-20 09:15:00'),(14,'物联网：传感器数据采集方案','分享物联网传感器数据采集的技术实现...','author14','2024-04-25 11:40:00','2024-04-25 11:40:00'),(15,'设计分享：UI 配色方案指南','讲解 UI 设计中色彩搭配的原则和案例...','author15','2024-05-30 13:55:00','2024-05-30 13:55:00'),(16,'产品经理：需求分析方法论','介绍需求分析的步骤和常用工具...','author16','2024-06-10 15:20:00','2024-06-10 15:20:00'),(17,'运营实战：用户增长策略分享','探讨互联网产品用户增长的有效策略...','author17','2024-07-18 08:45:00','2024-07-18 08:45:00'),(18,'职场技巧：高效时间管理方法','分享提升工作效率的时间管理技巧...','author18','2024-08-25 10:10:00','2024-08-25 10:10:00'),(19,'生活百科：健康饮食搭配建议','介绍合理饮食和营养搭配的知识...','author19','2024-09-05 14:30:00','2024-09-05 14:30:00'),(20,'文学创作：短篇小说写作技巧','分享短篇小说的构思和写作方法...','author20','2024-10-12 16:45:00','2024-10-12 16:45:00'),(22,'士大夫33','啊手动阀','author1','2025-04-16 13:05:06','2025-04-16 13:05:06'),(23,'啊手动阀啊','啊手动阀','author2','2025-04-16 13:05:17','2025-04-16 13:05:17'),(24,'士大夫','啊手动阀手动阀','author1','2025-04-16 15:12:29','2025-04-16 15:12:29');
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authort`
--

DROP TABLE IF EXISTS `authort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authort` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '作者名',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `money` decimal(10,2) DEFAULT '0.00' COMMENT '余额',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `article_count` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authort`
--

LOCK TABLES `authort` WRITE;
/*!40000 ALTER TABLE `authort` DISABLE KEYS */;
# INSERT INTO `authort` VALUES (1,'author1','author1@example.com',100.00,'2000-01-01','http://localhost:8081/images/ca4f5c36-adb9-4d55-9ad0-24f8ee77531e.jpg',23),(2,'author2','author2@example.com',150.50,'2001-03-15','http://localhost:8081/images/bec2cbb6-dd59-46bd-9e04-15a76db88690.jpg',1),(3,'author3','author3@example.com',200.99,'1998-06-20','http://localhost:8081/images/bec2cbb6-dd59-46bd-9e04-15a76db88690.jpg',2),(4,'author4','author4@example.com',300.00,'2005-09-10','https://example.com/avatar4.png',4),(5,'author5','author5@example.com',450.75,'1995-12-25','https://example.com/avatar5.png',5),(6,'author6','author6@example.com',500.20,'2010-04-05','https://example.com/avatar6.png',6),(7,'author7','author7@example.com',600.66,'2012-07-18','https://example.com/avatar7.png',7),(8,'author8','author8@example.com',700.10,'2015-11-30','https://example.com/avatar8.png',8),(9,'author9','author9@example.com',800.45,'1990-02-28','https://example.com/avatar9.png',9),(10,'author10','author10@example.com',900.88,'1985-08-08','https://example.com/avatar10.png',10),(11,'author11','author11@example.com',1000.00,'2008-05-12','http://localhost:8081/images/bec2cbb6-dd59-46bd-9e04-15a76db88690.jpg',11),(12,'author12','author12@example.com',1500.50,'2018-10-01','https://example.com/avatar12.png',12),(13,'author13','author13@example.com',2000.99,'2020-03-20','https://example.com/avatar13.png',5),(14,'author14','author14@example.com',2500.00,'1993-07-04','https://example.com/avatar14.png',0),(15,'author15','author15@example.com',3000.75,'1997-11-11','https://example.com/avatar15.png',4),(16,'author16','author16@example.com',3500.20,'2014-01-19','https://example.com/avatar16.png',5),(17,'author17','author17@example.com',4000.66,'2016-06-06','https://example.com/avatar17.png',7),(18,'author18','author18@example.com',4500.10,'2019-09-29','https://example.com/avatar18.png',8),(19,'author19','author19@example.com',5000.45,'1988-12-31','https://example.com/avatar19.png',9),(20,'author20','author20@example.com',5500.88,'2003-04-16','https://example.com/avatar20.png',10);
/*!40000 ALTER TABLE `authort` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_region`
--

DROP TABLE IF EXISTS `t_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_region` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `level` tinyint NOT NULL COMMENT '1-省 2-市',
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_region`
--

LOCK TABLES `t_region` WRITE;
/*!40000 ALTER TABLE `t_region` DISABLE KEYS */;
INSERT INTO `t_region` VALUES
(1,'北京市',1,NULL),
(2,'上海市',1,NULL),
(3,'天津市',1,NULL),
(4,'重庆市',1,NULL),
(5,'河北省',1,NULL),
(6,'山西省',1,NULL),
(7,'辽宁省',1,NULL),
(8,'吉林省',1,NULL),
(9,'黑龙江省',1,NULL),
(10,'江苏省',1,NULL),
(11,'浙江省',1,NULL),
(12,'安徽省',1,NULL),
(13,'福建省',1,NULL),
(14,'江西省',1,NULL),
(15,'山东省',1,NULL),
(16,'河南省',1,NULL),
(17,'湖北省',1,NULL),
(18,'湖南省',1,NULL),
(19,'广东省',1,NULL),
(20,'海南省',1,NULL),
(21,'四川省',1,NULL),
(22,'贵州省',1,NULL),
(23,'云南省',1,NULL),
(24,'陕西省',1,NULL),
(25,'甘肃省',1,NULL),
(26,'青海省',1,NULL),
(27,'台湾省',1,NULL),
(28,'内蒙古自治区',1,NULL),
(29,'广西壮族自治区',1,NULL),
(30,'西藏自治区',1,NULL),
(31,'宁夏回族自治区',1,NULL),
(32,'新疆维吾尔自治区',1,NULL),
(33,'香港特别行政区',1,NULL),
(34,'澳门特别行政区',1,NULL),
(35,'北京市',2,1),
(36,'上海市',2,2),
(37,'天津市',2,3),
(38,'重庆市',2,4),
(39,'石家庄市',2,5),
(40,'唐山市',2,5),
(41,'邯郸市',2,5),
(42,'山西省太原市',2,6),
(43,'大同市',2,6),
(44,'阳泉市',2,6),
(45,'沈阳市',2,7),
(46,'大连市',2,7),
(47,'鞍山市',2,7),
(48,'长春市',2,8),
(49,'吉林市',2,8),
(50,'四平市',2,8),
(51,'哈尔滨市',2,9),
(52,'齐齐哈尔市',2,9),
(53,'鸡西市',2,9),
(54,'南京市',2,10),
(55,'无锡市',2,10),
(56,'徐州市',2,10),
(57,'杭州市',2,11),
(58,'宁波市',2,11),
(59,'温州市',2,11),
(60,'合肥市',2,12),
(61,'芜湖市',2,12),
(62,'蚌埠市',2,12),
(63,'福州市',2,13),
(64,'厦门市',2,13),
(65,'莆田市',2,13),
(66,'南昌市',2,14),
(67,'景德镇市',2,14),
(68,'萍乡市',2,14),
(69,'济南市',2,15),
(70,'青岛市',2,15),
(71,'淄博市',2,15),
(72,'郑州市',2,16),
(73,'开封市',2,16),
(74,'洛阳市',2,16),
(75,'武汉市',2,17),
(76,'黄石市',2,17),
(77,'十堰市',2,17),
(78,'长沙市',2,18),
(79,'株洲市',2,18),
(80,'湘潭市',2,18),
(81,'广州市',2,19),
(82,'深圳市',2,19),
(83,'珠海市',2,19),
(84,'海口市',2,20),
(85,'三亚市',2,20),
(86,'三沙市',2,20),
(87,'成都市',2,21),
(88,'自贡市',2,21),
(89,'攀枝花市',2,21),
(90,'贵阳市',2,22),
(91,'遵义市',2,22),
(92,'安顺市',2,22),
(93,'昆明市',2,23),
(94,'曲靖市',2,23),
(95,'玉溪市',2,23),
(96,'西安市',2,24),
(97,'铜川市',2,24),
(98,'宝鸡市',2,24),
(99,'兰州市',2,25),
(100,'嘉峪关市',2,25),
(101,'金昌市',2,25),
(102,'西宁市',2,26),
(103,'海东市',2,26),
(104,'海北藏族自治州',2,26),
(105,'台北市',2,27),
(106,'高雄市',2,27),
(107,'新北市',2,27),
(108,'呼和浩特市',2,28),
(109,'包头市',2,28),
(110,'乌海市',2,28),
(111,'南宁市',2,29),
(112,'柳州市',2,29),
(113,'桂林市',2,29),
(114,'拉萨市',2,30),
(115,'那曲市',2,30),
(116,'昌都市',2,30),
(117,'银川市',2,31),
(118,'石嘴山市',2,31),
(119,'吴忠市',2,31),
(120,'乌鲁木齐市',2,32),
(121,'克拉玛依市',2,32),
(122,'吐鲁番市',2,32),
(123,'香港岛',2,33),
(124,'九龙',2,33),
(125,'新界',2,33),
(126,'澳门半岛',2,34),
(127,'氹仔岛',2,34),
(128,'路环岛',2,34);
/*!40000 ALTER TABLE `t_region` ENABLE KEYS */;
UNLOCK TABLES;
--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `name` varchar(45) NOT NULL,
  `province` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `address` varchar(45) DEFAULT NULL,
  `zip` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (31,'2023-01-10','张十二','福建','福州市','鼓楼区五四路158号','350000'),(32,'2023-01-11','陈十三','河北','石家庄市','长安区中山东路303号','050000'),(33,'2023-01-12','杨十四','湖南','长沙市','芙蓉区五一大道635号','410000'),(34,'2023-01-13','黄十五','河南','郑州市','金水区花园路39号','450000'),(35,'2023-01-14','孙十六','辽宁','沈阳市','和平区南京南街100号','110000'),(36,'2023-01-15','胡十七','安徽','合肥市','蜀山区长江西路189号','230000'),(37,'2023-01-16','朱十八','重庆','重庆市','渝中区解放碑街道邹容路100号','400000'),(38,'2023-01-17','马十九','天津','天津市','和平区南京路233号','300000'),(39,'2023-01-18','郭二十','云南','昆明市','五华区东风西路162号','650000'),(40,'2023-01-19','林二一','广西','南宁市','青秀区民族大道131号','530000'),(41,'2023-01-20','何二二','江西','南昌市','东湖区八一大道357号','330000'),(42,'2025-04-15','冉茂奇','广东省','珠海市','sdf','588950'),(43,'2025-04-16','冉茂奇','广东省','深圳市','sdf','588950'),(44,'2025-04-16','冉茂奇','广东省','深圳市','sdf','588950'),(45,'2025-04-16','李十一33','广东省','深圳市','碑林区南大街30号','710000');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usert`
--

DROP TABLE IF EXISTS `usert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usert` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `money` decimal(10,2) DEFAULT '0.00',
  `avatar` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usert`
--

LOCK TABLES `usert` WRITE;
/*!40000 ALTER TABLE `usert` DISABLE KEYS */;
INSERT INTO `usert` VALUES (17,'0000','Ranran00000','22@qq.com','Wed Apr 23 2025 00:00:00 GMT+0800 (中国标准时间) 00:00:00',33,'http://localhost:8081/images/ca4f5c36-adb9-4d55-9ad0-24f8ee77531e.jpg'),(18,'0001','0000',NULL,'Thu Apr 24 2025 00:00:00 GMT+0800 (中国标准时间) 00:00:00',0,'http://localhost:8081/images/ca4f5c36-adb9-4d55-9ad0-24f8ee77531e.jpg'),(19,'0002','0000',NULL,'Thu Apr 24 2025 00:00:00 GMT+0800 (中国标准时间) 00:00:00',0,'http://localhost:8081/images/ca4f5c36-adb9-4d55-9ad0-24f8ee77531e.jpg'),(21,'00002','0000',NULL,NULL,0,''),(22,'ranmaoqi','Ranran00000','23@163.com','Tue Apr 22 2025 00:00:00 GMT+0800 (中国标准时间) 00:00:00',0,'http://localhost:8081/images/bec2cbb6-dd59-46bd-9e04-15a76db88690.jpg'),(23,'123','Ran00000',NULL,'Tue Apr 29 2025 00:00:00 GMT+0800 (中国标准时间) 00:00:00',NULL,'http://localhost:8081/images/a2ffc58f-48f0-42aa-850d-464a909994c0.jpg'),(24,'1111','1111',NULL,'Tue Apr 22 2025 00:00:00 GMT+0800 (中国标准时间) 00:00:00',NULL,'http://localhost:8081/images/2d1aab37-65bc-45a0-b704-9b3768ae21c2.png');
/*!40000 ALTER TABLE `usert` ENABLE KEYS */;
UNLOCK TABLES;

INSERT INTO `usert` (`name`, `password`, `email`, `birthday`, `money`, `avatar`) VALUES
('author1', 'password123', 'author1@example.com', '2000-01-01', 100.00, 'http://example.com/avatar1.png '),
('author2', 'password456', 'author2@example.com', '2001-03-15', 150.50, 'http://example.com/avatar2.png '),
('author3', 'password789', 'author3@example.com', '1998-06-20', 200.99, 'http://example.com/avatar3.png '),
('author4', 'password101', 'author4@example.com', '2005-09-10', 300.00, 'http://example.com/avatar4.png '),
('author5', 'password112', 'author5@example.com', '1995-12-25', 450.75, 'http://example.com/avatar5.png ');

INSERT INTO `article` (`title`, `content`, `author_name`, `create_time`, `update_time`) VALUES
('数据库：MySQL 索引优化策略', '分析 MySQL 索引原理及优化方法...', 'author1', '2023-04-25 16:15:00', '2025-04-16 10:52:04'),
('算法解析：快速排序算法实现', '详细讲解快速排序的原理和代码实现...', 'author5', '2023-05-30 09:00:00', '2023-05-30 09:00:00'),
('设计模式：工厂模式应用场景', '介绍工厂模式在软件开发中的实际应用...', 'author3', '2023-06-10 11:20:00', '2023-06-10 11:20:00'),
('移动端开发：Flutter 布局实战', '分享 Flutter 布局组件的使用技巧...', 'author2', '2023-07-18 13:40:00', '2023-07-18 13:40:00'),
('大数据：Hadoop 集群搭建指南', '详细步骤讲解 Hadoop 集群的搭建过程...', 'author4', '2023-08-25 15:50:00', '2023-08-25 15:50:00'),
('人工智能：深度学习入门教程', '介绍深度学习的基本概念和框架...', 'author1', '2023-09-05 08:30:00', '2023-09-05 08:30:00'),
('云计算：AWS 服务器配置经验', '分享 AWS 服务器部署和配置的经验...', 'author5', '2023-10-12 10:45:00', '2023-10-12 10:45:00'),
('网络安全：常见攻击类型及防护', '分析 SQL 注入、XSS 等攻击的原理和防护...', 'author3', '2024-01-01 14:00:00', '2024-01-01 14:00:00'),
('区块链：智能合约开发实践', '讲解 Solidity 智能合约的编写和部署...', 'author2', '2024-02-15 16:30:00', '2024-02-15 16:30:00'),
('DevOps：持续集成与部署实践', '介绍 Jenkins 在 CI/CD 中的应用...', 'author4', '2024-03-20 09:15:00', '2024-03-20 09:15:00'),
('物联网：传感器数据采集方案', '分享物联网传感器数据采集的技术实现...', 'author1', '2024-04-25 11:40:00', '2024-04-25 11:40:00'),
('设计分享：UI 配色方案指南', '讲解 UI 设计中色彩搭配的原则和案例...', 'author5', '2024-05-30 13:55:00', '2024-05-30 13:55:00'),
('产品经理：需求分析方法论', '介绍需求分析的步骤和常用工具...', 'author3', '2024-06-10 15:20:00', '2024-06-10 15:20:00'),
('运营实战：用户增长策略分享', '探讨互联网产品用户增长的有效策略...', 'author2', '2024-07-18 08:45:00', '2024-07-18 08:45:00'),
('职场技巧：高效时间管理方法', '分享提升工作效率的时间管理技巧...', 'author4', '2024-08-25 10:10:00', '2024-08-25 10:10:00'),
('生活百科：健康饮食搭配建议', '介绍合理饮食和营养搭配的知识...', 'author1', '2024-09-05 14:30:00', '2024-09-05 14:30:00');

-- 创建触发器，当向 usert 表插入新用户时，同时向 authort 表插入数据
DELIMITER $$
CREATE TRIGGER after_user_insert
AFTER INSERT ON usert
FOR EACH ROW
BEGIN
    INSERT INTO authort (
        name,
        password,
        email,
        money,
        birthday,
        avatar,
        article_count
    ) VALUES (
        NEW.name,          -- 使用新插入的用户名
        NEW.password,      -- 使用新插入的密码
        NEW.email,         -- 使用新插入的邮箱
        NEW.money,         -- 使用新插入的余额
        NEW.birthday,      -- 使用新插入的生日
        NEW.avatar,        -- 使用新插入的头像URL
        0                  -- article_count 默认为 0
    );
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_user_delete
AFTER DELETE ON usert
FOR EACH ROW
BEGIN
    -- 删除 authort 表中对应的作者记录
    DELETE FROM authort
    WHERE name = OLD.name;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_article_insert
AFTER INSERT ON article
FOR EACH ROW
BEGIN
    -- 更新 authort 表中对应作者的文章数量
    UPDATE authort
    SET article_count = article_count + 1
    WHERE name = NEW.author_name;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_article_delete
AFTER DELETE ON article
FOR EACH ROW
BEGIN
    -- 更新 authort 表中对应作者的文章数量
    UPDATE authort
    SET article_count = GREATEST(article_count - 1, 0)
    WHERE name = OLD.author_name;
END$$
DELIMITER ;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-16 16:04:22
