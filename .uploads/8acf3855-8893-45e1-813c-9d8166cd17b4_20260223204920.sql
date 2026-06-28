/*
MySQL Backup
Database: exercise_system
Backup Time: 2026-02-23 20:49:20
*/

SET FOREIGN_KEY_CHECKS=0;
SET SESSION sql_mode=NO_AUTO_VALUE_ON_ZERO;
DROP TABLE IF EXISTS `exercise_system`.`collection`;
DROP TABLE IF EXISTS `exercise_system`.`exam_detail`;
DROP TABLE IF EXISTS `exercise_system`.`exam_question`;
DROP TABLE IF EXISTS `exercise_system`.`exam_record`;
DROP TABLE IF EXISTS `exercise_system`.`exercise_book`;
DROP TABLE IF EXISTS `exercise_system`.`question`;
DROP TABLE IF EXISTS `exercise_system`.`question_record`;
DROP TABLE IF EXISTS `exercise_system`.`question_type`;
DROP TABLE IF EXISTS `exercise_system`.`sys_user`;
CREATE TABLE `collection`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_question`(`user_id` ASC, `question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收藏表' ROW_FORMAT = Dynamic;
CREATE TABLE `exam_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `exam_id` bigint NOT NULL COMMENT '考试记录ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `user_answer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户答案',
  `is_correct` tinyint NULL DEFAULT 0 COMMENT '是否正确',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试详情表' ROW_FORMAT = Dynamic;
CREATE TABLE `exam_question`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `exam_id` bigint NOT NULL COMMENT '考试ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `question_seq` int NULL DEFAULT NULL COMMENT '试卷内题目序号',
  `user_answer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户答案',
  `is_correct` tinyint NULL DEFAULT 0 COMMENT '是否正确：1-正确，0-错误',
  `is_answered` tinyint NULL DEFAULT 0 COMMENT '是否作答：0-未作答，1-已作答',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_exam_id`(`exam_id` ASC) USING BTREE,
  INDEX `idx_question_id`(`question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 211 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试题目关联表' ROW_FORMAT = Dynamic;
CREATE TABLE `exam_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `book_id` bigint NULL DEFAULT NULL COMMENT '习题册ID',
  `exam_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '考试名称',
  `total_count` int NULL DEFAULT 0 COMMENT '总题数',
  `start_time` datetime NULL DEFAULT NULL COMMENT '考试开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '考试结束时间',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-未完成，1-已完成',
  `correct_count` int NULL DEFAULT 0 COMMENT '正确数',
  `score` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '得分',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '考试时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试记录表' ROW_FORMAT = Dynamic;
CREATE TABLE `exercise_book`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `book_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '习题册名称',
  `book_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '习题册描述',
  `type_id` bigint NULL DEFAULT NULL COMMENT '题型分类ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `creator_id` bigint NULL DEFAULT NULL COMMENT '创建者ID',
  `is_public` tinyint NULL DEFAULT 1 COMMENT '是否公开：1-公开，0-私有',
  `content_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '题目图片URL',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '习题册表' ROW_FORMAT = Dynamic;
CREATE TABLE `question`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `book_id` bigint NOT NULL COMMENT '习题册ID',
  `type_id` bigint NOT NULL COMMENT '题型ID：1-单选，2-多选，3-判断，4-简答',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题干内容',
  `content_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '题目图片URL',
  `options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '选项，JSON格式存储，如[\"A.xxx\",\"B.xxx\",\"C.xxx\",\"D.xxx\"]',
  `answer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '答案',
  `analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '解析',
  `difficulty` tinyint NULL DEFAULT 1 COMMENT '难度：1-易，2-中，3-难',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `options_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '选项图片URL',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '题目表' ROW_FORMAT = Dynamic;
CREATE TABLE `question_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `book_id` bigint NOT NULL COMMENT '习题册ID',
  `question_seq` int NULL DEFAULT NULL COMMENT '题目在当前习题册中的序号',
  `answer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户作答',
  `is_correct` tinyint NULL DEFAULT 0 COMMENT '是否正确：1-正确，0-错误',
  `is_answered` tinyint NULL DEFAULT 0 COMMENT '是否已答：0-未答，1-已答',
  `do_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作答时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '做题记录表' ROW_FORMAT = Dynamic;
CREATE TABLE `question_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题型名称：单选/多选/判断/简答',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '题型分类表' ROW_FORMAT = Dynamic;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'user' COMMENT '角色：user-普通用户，admin-管理员',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;
BEGIN;
LOCK TABLES `exercise_system`.`collection` WRITE;
DELETE FROM `exercise_system`.`collection`;
INSERT INTO `exercise_system`.`collection` (`id`,`user_id`,`question_id`,`create_time`) VALUES (2, 1, 9, '2026-02-23 13:11:04')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `exercise_system`.`exam_detail` WRITE;
DELETE FROM `exercise_system`.`exam_detail`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `exercise_system`.`exam_question` WRITE;
DELETE FROM `exercise_system`.`exam_question`;
INSERT INTO `exercise_system`.`exam_question` (`id`,`exam_id`,`question_id`,`question_seq`,`user_answer`,`is_correct`,`is_answered`,`create_time`) VALUES (1, 1, 3, 1, 'B', 0, 1, '2026-02-23 11:31:47'),(2, 1, 9, 2, 'ABC', 0, 1, '2026-02-23 11:31:47'),(3, 1, 2, 3, 'C', 0, 1, '2026-02-23 11:31:47'),(4, 1, 5, 4, '正确', 0, 1, '2026-02-23 11:31:47'),(5, 1, 10, 5, '正确', 0, 1, '2026-02-23 11:31:47'),(6, 1, 7, 6, 'w', 0, 1, '2026-02-23 11:31:47'),(7, 1, 1, 7, 'A', 0, 1, '2026-02-23 11:31:47'),(8, 1, 6, 8, '正确', 0, 1, '2026-02-23 11:31:47'),(9, 1, 8, 9, 'A', 0, 1, '2026-02-23 11:31:47'),(10, 1, 4, 10, 'ABCD', 0, 1, '2026-02-23 11:31:47'),(11, 2, 8, 1, NULL, 0, 0, '2026-02-23 12:07:54'),(12, 2, 10, 2, NULL, 0, 0, '2026-02-23 12:07:54'),(13, 2, 3, 3, NULL, 0, 0, '2026-02-23 12:07:54'),(14, 2, 5, 4, NULL, 0, 0, '2026-02-23 12:07:54'),(15, 2, 4, 5, NULL, 0, 0, '2026-02-23 12:07:54'),(16, 2, 1, 6, NULL, 0, 0, '2026-02-23 12:07:54'),(17, 2, 2, 7, NULL, 0, 0, '2026-02-23 12:07:54'),(18, 2, 7, 8, NULL, 0, 0, '2026-02-23 12:07:54'),(19, 2, 6, 9, NULL, 0, 0, '2026-02-23 12:07:54'),(20, 2, 9, 10, NULL, 0, 0, '2026-02-23 12:07:54'),(21, 3, 2, 1, NULL, 0, 0, '2026-02-23 12:12:28'),(22, 3, 4, 2, NULL, 0, 0, '2026-02-23 12:12:28'),(23, 3, 7, 3, NULL, 0, 0, '2026-02-23 12:12:28'),(24, 3, 6, 4, NULL, 0, 0, '2026-02-23 12:12:28'),(25, 3, 1, 5, NULL, 0, 0, '2026-02-23 12:12:28'),(26, 3, 10, 6, NULL, 0, 0, '2026-02-23 12:12:28'),(27, 3, 8, 7, NULL, 0, 0, '2026-02-23 12:12:28'),(28, 3, 9, 8, NULL, 0, 0, '2026-02-23 12:12:28'),(29, 3, 3, 9, NULL, 0, 0, '2026-02-23 12:12:28'),(30, 3, 5, 10, NULL, 0, 0, '2026-02-23 12:12:28'),(31, 4, 4, 1, NULL, 0, 0, '2026-02-23 12:16:17'),(32, 4, 7, 2, NULL, 0, 0, '2026-02-23 12:16:17'),(33, 4, 1, 3, NULL, 0, 0, '2026-02-23 12:16:17'),(34, 4, 10, 4, NULL, 0, 0, '2026-02-23 12:16:17'),(35, 4, 2, 5, NULL, 0, 0, '2026-02-23 12:16:17'),(36, 4, 5, 6, NULL, 0, 0, '2026-02-23 12:16:17'),(37, 4, 9, 7, NULL, 0, 0, '2026-02-23 12:16:17'),(38, 4, 8, 8, NULL, 0, 0, '2026-02-23 12:16:17'),(39, 4, 6, 9, NULL, 0, 0, '2026-02-23 12:16:17'),(40, 4, 3, 10, NULL, 0, 0, '2026-02-23 12:16:17'),(41, 5, 1, 1, NULL, 0, 0, '2026-02-23 12:48:09'),(42, 5, 3, 2, NULL, 0, 0, '2026-02-23 12:48:09'),(43, 5, 6, 3, '错误', 0, 1, '2026-02-23 12:48:09'),(44, 5, 10, 4, NULL, 0, 0, '2026-02-23 12:48:09'),(45, 5, 5, 5, NULL, 0, 0, '2026-02-23 12:48:09'),(46, 5, 9, 6, NULL, 0, 0, '2026-02-23 12:48:09'),(47, 5, 7, 7, NULL, 0, 0, '2026-02-23 12:48:09'),(48, 5, 2, 8, NULL, 0, 0, '2026-02-23 12:48:09'),(49, 5, 4, 9, NULL, 0, 0, '2026-02-23 12:48:09'),(50, 5, 8, 10, NULL, 0, 0, '2026-02-23 12:48:09'),(51, 6, 9, 1, NULL, 0, 0, '2026-02-23 12:48:22'),(52, 6, 10, 2, NULL, 0, 0, '2026-02-23 12:48:22'),(53, 6, 2, 3, NULL, 0, 0, '2026-02-23 12:48:22'),(54, 6, 3, 4, NULL, 0, 0, '2026-02-23 12:48:22'),(55, 6, 1, 5, NULL, 0, 0, '2026-02-23 12:48:22'),(56, 6, 4, 6, NULL, 0, 0, '2026-02-23 12:48:22'),(57, 6, 8, 7, NULL, 0, 0, '2026-02-23 12:48:22'),(58, 6, 5, 8, NULL, 0, 0, '2026-02-23 12:48:22'),(59, 6, 6, 9, NULL, 0, 0, '2026-02-23 12:48:22'),(60, 6, 7, 10, NULL, 0, 0, '2026-02-23 12:48:22'),(61, 7, 1, 1, NULL, 0, 0, '2026-02-23 12:54:52'),(62, 7, 3, 2, NULL, 0, 0, '2026-02-23 12:54:52'),(63, 7, 4, 3, NULL, 0, 0, '2026-02-23 12:54:52'),(64, 7, 9, 4, NULL, 0, 0, '2026-02-23 12:54:52'),(65, 7, 6, 5, NULL, 0, 0, '2026-02-23 12:54:52'),(66, 7, 5, 6, NULL, 0, 0, '2026-02-23 12:54:52'),(67, 7, 2, 7, NULL, 0, 0, '2026-02-23 12:54:52'),(68, 7, 7, 8, NULL, 0, 0, '2026-02-23 12:54:52'),(69, 7, 10, 9, NULL, 0, 0, '2026-02-23 12:54:52'),(70, 7, 8, 10, NULL, 0, 0, '2026-02-23 12:54:52'),(71, 8, 2, 1, NULL, 0, 0, '2026-02-23 12:54:57'),(72, 8, 8, 2, NULL, 0, 0, '2026-02-23 12:54:57'),(73, 8, 5, 3, NULL, 0, 0, '2026-02-23 12:54:57'),(74, 8, 7, 4, NULL, 0, 0, '2026-02-23 12:54:57'),(75, 8, 6, 5, NULL, 0, 0, '2026-02-23 12:54:57'),(76, 8, 9, 6, NULL, 0, 0, '2026-02-23 12:54:57'),(77, 8, 4, 7, NULL, 0, 0, '2026-02-23 12:54:57'),(78, 8, 1, 8, NULL, 0, 0, '2026-02-23 12:54:57'),(79, 8, 3, 9, NULL, 0, 0, '2026-02-23 12:54:57'),(80, 8, 10, 10, NULL, 0, 0, '2026-02-23 12:54:57'),(81, 9, 5, 1, NULL, 0, 0, '2026-02-23 12:55:08'),(82, 9, 9, 2, NULL, 0, 0, '2026-02-23 12:55:08'),(83, 9, 4, 3, NULL, 0, 0, '2026-02-23 12:55:08'),(84, 9, 7, 4, NULL, 0, 0, '2026-02-23 12:55:08'),(85, 9, 2, 5, NULL, 0, 0, '2026-02-23 12:55:08'),(86, 9, 6, 6, NULL, 0, 0, '2026-02-23 12:55:08'),(87, 9, 3, 7, NULL, 0, 0, '2026-02-23 12:55:08'),(88, 9, 1, 8, NULL, 0, 0, '2026-02-23 12:55:08'),(89, 9, 8, 9, NULL, 0, 0, '2026-02-23 12:55:08'),(90, 9, 10, 10, NULL, 0, 0, '2026-02-23 12:55:08'),(91, 10, 5, 1, NULL, 0, 0, '2026-02-23 13:02:43'),(92, 10, 3, 2, NULL, 0, 0, '2026-02-23 13:02:43'),(93, 10, 8, 3, NULL, 0, 0, '2026-02-23 13:02:43'),(94, 10, 2, 4, NULL, 0, 0, '2026-02-23 13:02:43'),(95, 10, 7, 5, NULL, 0, 0, '2026-02-23 13:02:43'),(96, 10, 10, 6, NULL, 0, 0, '2026-02-23 13:02:43'),(97, 10, 1, 7, NULL, 0, 0, '2026-02-23 13:02:43'),(98, 10, 6, 8, NULL, 0, 0, '2026-02-23 13:02:43'),(99, 10, 4, 9, NULL, 0, 0, '2026-02-23 13:02:43'),(100, 10, 9, 10, NULL, 0, 0, '2026-02-23 13:02:43'),(101, 11, 1, 1, NULL, 0, 0, '2026-02-23 13:03:46'),(102, 11, 5, 2, NULL, 0, 0, '2026-02-23 13:03:46'),(103, 11, 10, 3, NULL, 0, 0, '2026-02-23 13:03:46'),(104, 11, 4, 4, NULL, 0, 0, '2026-02-23 13:03:46'),(105, 11, 8, 5, NULL, 0, 0, '2026-02-23 13:03:46'),(106, 11, 3, 6, NULL, 0, 0, '2026-02-23 13:03:46'),(107, 11, 7, 7, NULL, 0, 0, '2026-02-23 13:03:46'),(108, 11, 9, 8, NULL, 0, 0, '2026-02-23 13:03:46'),(109, 11, 2, 9, NULL, 0, 0, '2026-02-23 13:03:46'),(110, 11, 6, 10, NULL, 0, 0, '2026-02-23 13:03:46'),(111, 12, 7, 1, NULL, 0, 0, '2026-02-23 13:11:46'),(112, 12, 3, 2, NULL, 0, 0, '2026-02-23 13:11:46'),(113, 12, 8, 3, NULL, 0, 0, '2026-02-23 13:11:46'),(114, 12, 9, 4, NULL, 0, 0, '2026-02-23 13:11:46'),(115, 12, 6, 5, NULL, 0, 0, '2026-02-23 13:11:46'),(116, 12, 5, 6, NULL, 0, 0, '2026-02-23 13:11:46'),(117, 12, 2, 7, NULL, 0, 0, '2026-02-23 13:11:46'),(118, 12, 10, 8, NULL, 0, 0, '2026-02-23 13:11:46'),(119, 12, 1, 9, NULL, 0, 0, '2026-02-23 13:11:46'),(120, 12, 4, 10, NULL, 0, 0, '2026-02-23 13:11:46'),(121, 13, 2, 1, NULL, 0, 0, '2026-02-23 13:24:43'),(122, 13, 7, 2, NULL, 0, 0, '2026-02-23 13:24:43'),(123, 13, 10, 3, NULL, 0, 0, '2026-02-23 13:24:43'),(124, 13, 3, 4, NULL, 0, 0, '2026-02-23 13:24:43'),(125, 13, 6, 5, NULL, 0, 0, '2026-02-23 13:24:43'),(126, 13, 5, 6, NULL, 0, 0, '2026-02-23 13:24:43'),(127, 13, 1, 7, NULL, 0, 0, '2026-02-23 13:24:43'),(128, 13, 4, 8, NULL, 0, 0, '2026-02-23 13:24:43'),(129, 13, 8, 9, NULL, 0, 0, '2026-02-23 13:24:43'),(130, 13, 9, 10, NULL, 0, 0, '2026-02-23 13:24:43'),(131, 14, 4, 1, 'ABCD', 1, 1, '2026-02-23 13:24:57'),(132, 14, 2, 2, 'C', 1, 1, '2026-02-23 13:24:57'),(133, 14, 9, 3, 'A', 0, 1, '2026-02-23 13:24:57'),(134, 14, 3, 4, NULL, 0, 0, '2026-02-23 13:24:57'),(135, 14, 8, 5, NULL, 0, 0, '2026-02-23 13:24:57'),(136, 14, 1, 6, NULL, 0, 0, '2026-02-23 13:24:57'),(137, 14, 10, 7, NULL, 0, 0, '2026-02-23 13:24:57'),(138, 14, 6, 8, NULL, 0, 0, '2026-02-23 13:24:57'),(139, 14, 5, 9, NULL, 0, 0, '2026-02-23 13:24:57'),(140, 14, 7, 10, NULL, 0, 0, '2026-02-23 13:24:57'),(141, 15, 1, 1, 'C', 0, 1, '2026-02-23 16:20:05'),(142, 15, 7, 2, NULL, 0, 0, '2026-02-23 16:20:05'),(143, 15, 10, 3, NULL, 0, 0, '2026-02-23 16:20:05'),(144, 15, 9, 4, NULL, 0, 0, '2026-02-23 16:20:05'),(145, 15, 8, 5, NULL, 0, 0, '2026-02-23 16:20:05'),(146, 15, 2, 6, NULL, 0, 0, '2026-02-23 16:20:05'),(147, 15, 6, 7, NULL, 0, 0, '2026-02-23 16:20:05'),(148, 15, 5, 8, NULL, 0, 0, '2026-02-23 16:20:05'),(149, 15, 4, 9, NULL, 0, 0, '2026-02-23 16:20:05'),(150, 15, 3, 10, NULL, 0, 0, '2026-02-23 16:20:05'),(151, 16, 2, 1, NULL, 0, 0, '2026-02-23 16:20:50'),(152, 16, 5, 2, NULL, 0, 0, '2026-02-23 16:20:50'),(153, 16, 9, 3, NULL, 0, 0, '2026-02-23 16:20:50'),(154, 16, 4, 4, NULL, 0, 0, '2026-02-23 16:20:50'),(155, 16, 3, 5, NULL, 0, 0, '2026-02-23 16:20:50'),(156, 16, 8, 6, NULL, 0, 0, '2026-02-23 16:20:50'),(157, 16, 1, 7, NULL, 0, 0, '2026-02-23 16:20:50'),(158, 16, 6, 8, NULL, 0, 0, '2026-02-23 16:20:50'),(159, 16, 7, 9, NULL, 0, 0, '2026-02-23 16:20:50'),(160, 16, 10, 10, NULL, 0, 0, '2026-02-23 16:20:50'),(161, 17, 2, 1, NULL, 0, 0, '2026-02-23 16:24:27'),(162, 17, 3, 2, NULL, 0, 0, '2026-02-23 16:24:27'),(163, 17, 10, 3, NULL, 0, 0, '2026-02-23 16:24:27'),(164, 17, 8, 4, NULL, 0, 0, '2026-02-23 16:24:27'),(165, 17, 9, 5, NULL, 0, 0, '2026-02-23 16:24:27'),(166, 17, 5, 6, NULL, 0, 0, '2026-02-23 16:24:27'),(167, 17, 1, 7, NULL, 0, 0, '2026-02-23 16:24:27'),(168, 17, 6, 8, NULL, 0, 0, '2026-02-23 16:24:27'),(169, 17, 7, 9, NULL, 0, 0, '2026-02-23 16:24:27'),(170, 17, 4, 10, NULL, 0, 0, '2026-02-23 16:24:27'),(171, 18, 10, 1, '正确', 0, 1, '2026-02-23 16:36:54'),(172, 18, 5, 2, '错误', 1, 1, '2026-02-23 16:36:54'),(173, 18, 9, 3, 'ABC', 0, 1, '2026-02-23 16:36:54'),(174, 18, 7, 4, '1', 0, 1, '2026-02-23 16:36:54'),(175, 18, 6, 5, '正确', 1, 1, '2026-02-23 16:36:54'),(176, 18, 3, 6, 'B', 1, 1, '2026-02-23 16:36:54'),(177, 18, 1, 7, 'A', 1, 1, '2026-02-23 16:36:54'),(178, 18, 2, 8, 'C', 1, 1, '2026-02-23 16:36:54'),(179, 18, 8, 9, 'A', 1, 1, '2026-02-23 16:36:54'),(180, 18, 4, 10, 'ABCD', 1, 1, '2026-02-23 16:36:54'),(181, 19, 4, 1, NULL, 0, 0, '2026-02-23 16:38:21'),(182, 19, 2, 2, NULL, 0, 0, '2026-02-23 16:38:21'),(183, 19, 9, 3, NULL, 0, 0, '2026-02-23 16:38:21'),(184, 19, 7, 4, NULL, 0, 0, '2026-02-23 16:38:21'),(185, 19, 8, 5, NULL, 0, 0, '2026-02-23 16:38:21'),(186, 19, 5, 6, NULL, 0, 0, '2026-02-23 16:38:21'),(187, 19, 3, 7, NULL, 0, 0, '2026-02-23 16:38:21'),(188, 19, 1, 8, NULL, 0, 0, '2026-02-23 16:38:21'),(189, 19, 10, 9, NULL, 0, 0, '2026-02-23 16:38:21'),(190, 19, 6, 10, NULL, 0, 0, '2026-02-23 16:38:21'),(191, 20, 9, 1, NULL, 0, 0, '2026-02-23 16:39:55'),(192, 20, 8, 2, NULL, 0, 0, '2026-02-23 16:39:55'),(193, 20, 7, 3, NULL, 0, 0, '2026-02-23 16:39:55'),(194, 20, 6, 4, NULL, 0, 0, '2026-02-23 16:39:55'),(195, 20, 1, 5, NULL, 0, 0, '2026-02-23 16:39:55'),(196, 20, 2, 6, NULL, 0, 0, '2026-02-23 16:39:55'),(197, 20, 5, 7, NULL, 0, 0, '2026-02-23 16:39:55'),(198, 20, 3, 8, NULL, 0, 0, '2026-02-23 16:39:55'),(199, 20, 10, 9, NULL, 0, 0, '2026-02-23 16:39:55'),(200, 20, 4, 10, NULL, 0, 0, '2026-02-23 16:39:55'),(201, 21, 1, 1, NULL, 0, 0, '2026-02-23 16:47:50'),(202, 21, 2, 2, NULL, 0, 0, '2026-02-23 16:47:50'),(203, 21, 10, 3, NULL, 0, 0, '2026-02-23 16:47:50'),(204, 21, 3, 4, NULL, 0, 0, '2026-02-23 16:47:50'),(205, 21, 5, 5, NULL, 0, 0, '2026-02-23 16:47:50'),(206, 21, 4, 6, NULL, 0, 0, '2026-02-23 16:47:50'),(207, 21, 8, 7, NULL, 0, 0, '2026-02-23 16:47:50'),(208, 21, 9, 8, NULL, 0, 0, '2026-02-23 16:47:50'),(209, 21, 7, 9, NULL, 0, 0, '2026-02-23 16:47:50'),(210, 21, 6, 10, NULL, 0, 0, '2026-02-23 16:47:50')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `exercise_system`.`exam_record` WRITE;
DELETE FROM `exercise_system`.`exam_record`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `exercise_system`.`exercise_book` WRITE;
DELETE FROM `exercise_system`.`exercise_book`;
INSERT INTO `exercise_system`.`exercise_book` (`id`,`book_name`,`book_desc`,`type_id`,`create_time`,`status`,`creator_id`,`is_public`,`content_image`) VALUES (1, 'Java基础练习题', 'Java语言基础知识练习，包含变量、数据类型、运算符等', 1, '2026-02-23 11:24:39', 1, 1, 1, NULL),(2, '数据库原理习题', '数据库SQL语句练习，包含查询、增删改等操作', 1, '2026-02-23 11:24:39', 1, 1, 1, NULL),(3, '数据结构与算法', '常见数据结构和算法练习题', 1, '2026-02-23 11:24:39', 1, 1, 1, NULL),(4, '软考中级习题册', '想要报考中级软考的同学请刷题\n', NULL, '2026-02-23 14:48:04', 1, 2, 1, NULL)
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `exercise_system`.`question` WRITE;
DELETE FROM `exercise_system`.`question`;
INSERT INTO `exercise_system`.`question` (`id`,`book_id`,`type_id`,`content`,`content_image`,`options`,`answer`,`analysis`,`difficulty`,`create_time`,`options_image`) VALUES (1, 1, 1, 'Java中哪个关键字用于定义类？', NULL, '[\"A. class\", \"B. struct\", \"C. define\", \"D. type\"]', 'A', 'Java使用class关键字来定义类，这是Java面向对象编程的基础。', 1, '2026-02-23 11:24:39', NULL),(2, 1, 1, 'Java中int类型占用多少字节？', NULL, '[\"A. 1字节\", \"B. 2字节\", \"C. 4字节\", \"D. 8字节\"]', 'C', 'Java中int类型固定占用4个字节（32位），这是Java跨平台特性的体现。', 1, '2026-02-23 11:24:39', NULL),(3, 1, 1, '以下哪个不是Java的基本数据类型？', NULL, '[\"A. int\", \"B. String\", \"C. boolean\", \"D. double\"]', 'B', 'String是引用类型，不是基本数据类型。Java有8种基本数据类型：byte、short、int、long、float、double、char、boolean。', 1, '2026-02-23 11:24:39', NULL),(4, 1, 2, 'Java中面向对象的特性包括哪些？', NULL, '[\"A. 封装\", \"B. 继承\", \"C. 多态\", \"D. 以上都是\"]', 'ABCD', '面向对象的三大特性是封装、继承、多态，这是OOP编程的核心概念。', 2, '2026-02-23 11:24:39', NULL),(5, 1, 3, 'Java是一种解释型语言。', NULL, '[]', '错误', 'Java是半编译半解释型语言。Java源代码先编译成字节码，然后由JVM解释执行或JIT编译执行。', 2, '2026-02-23 11:24:39', NULL),(6, 1, 3, 'Java程序必须包含main方法才能运行。', NULL, '[]', '正确', 'main方法是Java程序的入口点，格式为public static void main(String[] args)。', 1, '2026-02-23 11:24:39', NULL),(7, 1, 4, '请简述Java中==和equals的区别。', NULL, '[]', '==比较的是引用（内存地址），equals比较的是内容。对于基本数据类型，==比较值；对于引用类型，==比较内存地址。equals方法默认比较内存地址，但很多类（如String）重写了equals方法来比较内容。', '==是运算符，equals是方法。==比较基本类型时比较值，比较引用类型时比较内存地址。equals默认比较内存地址，但String等类重写了该方法比较内容。', 3, '2026-02-23 11:24:39', NULL),(8, 1, 1, 'Java中用于输出内容到控制台的方法是？', NULL, '[\"A. System.out.println()\", \"B. Console.write()\", \"C. print()\", \"D. output()\"]', 'A', 'Java使用System.out.println()方法输出内容到控制台。', 1, '2026-02-23 11:24:39', NULL),(9, 1, 2, 'Java中的访问修饰符有哪些？', NULL, '[\"A. public\", \"B. private\", \"C. protected\", \"D. default\"]', 'ABCD', 'Java有四种访问修饰符：public（公共）、private（私有）、protected（受保护）、default（默认，不写修饰符）。', 2, '2026-02-23 11:24:39', NULL),(10, 1, 3, 'Java支持多重继承。', NULL, '[]', '错误', 'Java不支持类的多重继承，但可以实现多个接口。这样设计是为了避免菱形继承问题。', 2, '2026-02-23 11:24:39', NULL),(11, 2, 1, 'SQL中用于查询数据的关键字是？', NULL, '[\"A. SELECT\", \"B. INSERT\", \"C. UPDATE\", \"D. DELETE\"]', 'A', 'SELECT语句用于从数据库中查询数据，是最常用的SQL语句之一。', 1, '2026-02-23 11:24:39', NULL),(12, 2, 1, 'SQL中用于删除表数据的命令是？', NULL, '[\"A. DROP\", \"B. DELETE\", \"C. TRUNCATE\", \"D. REMOVE\"]', 'B', 'DELETE用于删除表中的数据，DROP用于删除整个表结构，TRUNCATE用于删除表中所有数据但保留表结构。', 2, '2026-02-23 11:24:39', NULL),(13, 2, 2, '以下哪些是SQL的聚合函数？', NULL, '[\"A. COUNT\", \"B. SUM\", \"C. AVG\", \"D. MAX\"]', 'ABCD', 'SQL聚合函数包括COUNT（计数）、SUM（求和）、AVG（平均值）、MAX（最大值）、MIN（最小值）等。', 1, '2026-02-23 11:24:39', NULL),(14, 2, 3, '主键可以包含NULL值。', NULL, '[]', '错误', '主键（PRIMARY KEY）不能包含NULL值，且必须唯一。这是主键的基本约束条件。', 1, '2026-02-23 11:24:39', NULL),(15, 2, 3, '外键用于建立表与表之间的关联关系。', NULL, '[]', '正确', '外键（FOREIGN KEY）用于建立和加强两个表之间的链接，保证数据的一致性和完整性。', 1, '2026-02-23 11:24:39', NULL),(16, 2, 4, '请简述SQL中WHERE和HAVING的区别。', NULL, '[]', 'WHERE在分组前过滤数据，不能使用聚合函数；HAVING在分组后过滤数据，可以使用聚合函数。WHERE作用于行，HAVING作用于组。', 'WHERE和HAVING都是过滤条件，但WHERE在GROUP BY之前执行，不能使用聚合函数；HAVING在GROUP BY之后执行，可以使用聚合函数进行过滤。', 3, '2026-02-23 11:24:39', NULL),(17, 2, 1, '数据库事务的ACID特性中，I代表什么？', NULL, '[\"A. 原子性\", \"B. 一致性\", \"C. 隔离性\", \"D. 持久性\"]', 'C', 'ACID中：A-原子性(Atomicity)、C-一致性(Consistency)、I-隔离性(Isolation)、D-持久性(Durability)。', 2, '2026-02-23 11:24:39', NULL),(18, 2, 2, '以下哪些是数据库的隔离级别？', NULL, '[\"A. 读未提交\", \"B. 读已提交\", \"C. 可重复读\", \"D. 串行化\"]', 'ABCD', '数据库四种隔离级别：读未提交(Read Uncommitted)、读已提交(Read Committed)、可重复读(Repeatable Read)、串行化(Serializable)。', 3, '2026-02-23 11:24:39', NULL),(19, 2, 1, 'SQL中用于排序的关键字是？', NULL, '[\"A. ORDER BY\", \"B. GROUP BY\", \"C. SORT BY\", \"D. ARRANGE\"]', 'A', 'ORDER BY用于对查询结果进行排序，可配合ASC（升序）或DESC（降序）使用。', 1, '2026-02-23 11:24:39', NULL),(20, 2, 3, 'UNION和UNION ALL的结果是相同的。', NULL, '[]', '错误', 'UNION会去除重复记录，UNION ALL保留所有记录包括重复的。UNION ALL性能更好。', 2, '2026-02-23 11:24:39', NULL),(21, 3, 1, '栈的特点是？', NULL, '[\"A. 先进先出\", \"B. 先进后出\", \"C. 随机访问\", \"D. 双向访问\"]', 'B', '栈是一种后进先出（LIFO）的数据结构，最后入栈的元素最先出栈。', 1, '2026-02-23 11:24:39', NULL),(22, 3, 1, '队列的特点是？', NULL, '[\"A. 先进先出\", \"B. 先进后出\", \"C. 随机访问\", \"D. 单向访问\"]', 'A', '队列是一种先进先出（FIFO）的数据结构，先入队的元素先出队。', 1, '2026-02-23 11:24:39', NULL),(23, 3, 2, '以下哪些是常见的排序算法？', NULL, '[\"A. 冒泡排序\", \"B. 快速排序\", \"C. 归并排序\", \"D. 二分查找\"]', 'ABC', '冒泡排序、快速排序、归并排序都是排序算法，二分查找是查找算法不是排序算法。', 1, '2026-02-23 11:24:39', NULL),(24, 3, 3, '二分查找要求数据必须有序。', NULL, '[]', '正确', '二分查找算法要求数据必须是有序的，每次比较中间元素，将搜索范围缩小一半。', 1, '2026-02-23 11:24:39', NULL),(25, 3, 3, '链表支持随机访问。', NULL, '[]', '错误', '链表不支持随机访问，要访问第n个元素必须从头节点开始遍历n次。数组才支持随机访问。', 2, '2026-02-23 11:24:39', NULL),(26, 3, 4, '请简述数组和链表的区别。', NULL, '[]', '数组：连续内存，支持随机访问，插入删除效率低。链表：非连续内存，不支持随机访问，插入删除效率高。', '数组在内存中连续存储，支持O(1)随机访问，但插入删除需要O(n)时间。链表通过指针连接，插入删除只需O(1)，但访问需要O(n)遍历。', 2, '2026-02-23 11:24:39', NULL),(27, 3, 1, '快速排序的平均时间复杂度是？', NULL, '[\"A. O(n)\", \"B. O(nlogn)\", \"C. O(n²)\", \"D. O(logn)\"]', 'B', '快速排序平均时间复杂度为O(nlogn)，最坏情况（已排序数组）为O(n²)。', 2, '2026-02-23 11:24:39', NULL),(28, 3, 2, '以下哪些是树形结构？', NULL, '[\"A. 二叉树\", \"B. B树\", \"C. 堆\", \"D. 哈希表\"]', 'ABC', '二叉树、B树、堆都是树形结构，哈希表是基于数组的数据结构。', 2, '2026-02-23 11:24:39', NULL),(29, 3, 1, '哈希表查找的平均时间复杂度是？', NULL, '[\"A. O(1)\", \"B. O(n)\", \"C. O(logn)\", \"D. O(nlogn)\"]', 'A', '哈希表通过哈希函数直接定位元素位置，平均查找时间复杂度为O(1)。', 1, '2026-02-23 11:24:39', NULL),(30, 3, 3, '递归算法必须有终止条件。', NULL, '[]', '正确', '递归算法必须有终止条件（基准情况），否则会无限递归导致栈溢出。', 1, '2026-02-23 11:24:39', NULL)
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `exercise_system`.`question_record` WRITE;
DELETE FROM `exercise_system`.`question_record`;
INSERT INTO `exercise_system`.`question_record` (`id`,`user_id`,`question_id`,`book_id`,`question_seq`,`answer`,`is_correct`,`is_answered`,`do_time`) VALUES (1, 2, 1, 1, 1, 'A', 1, 1, '2026-02-23 11:31:33'),(2, 2, 2, 1, 2, 'C', 1, 1, '2026-02-23 11:31:37'),(3, 2, 3, 1, 3, 'C', 0, 1, '2026-02-23 11:31:41'),(4, 2, 2, 1, 2, 'B', 0, 1, '2026-02-23 12:07:42'),(5, 2, 5, 1, 5, '正确', 0, 1, '2026-02-23 12:14:43'),(6, 1, 9, 1, 9, 'D', 0, 1, '2026-02-23 13:11:05'),(7, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 13:27:42'),(8, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 13:27:50'),(9, 2, 5, 1, 5, '正确', 0, 1, '2026-02-23 13:31:29'),(10, 2, 6, 1, 6, '正确', 1, 1, '2026-02-23 13:32:59'),(11, 2, 4, 1, 4, 'ABCD', 1, 1, '2026-02-23 13:33:09'),(12, 2, 5, 1, 5, '错误', 1, 1, '2026-02-23 13:33:37'),(13, 2, 6, 1, 6, '正确', 1, 1, '2026-02-23 13:34:40'),(14, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 16:26:41'),(15, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 16:26:48'),(16, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 16:27:18'),(17, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 16:27:57'),(18, 2, 31, 4, 1, '正确', 1, 1, '2026-02-23 19:09:31'),(19, 1, 32, 4, 1, '正确', 1, 1, '2026-02-23 19:30:24')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `exercise_system`.`question_type` WRITE;
DELETE FROM `exercise_system`.`question_type`;
INSERT INTO `exercise_system`.`question_type` (`id`,`type_name`,`sort`,`create_time`) VALUES (1, '单选题', 1, '2026-02-23 11:24:39'),(2, '多选题', 2, '2026-02-23 11:24:39'),(3, '判断题', 3, '2026-02-23 11:24:39'),(4, '简答题', 4, '2026-02-23 11:24:39')
;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `exercise_system`.`sys_user` WRITE;
DELETE FROM `exercise_system`.`sys_user`;
INSERT INTO `exercise_system`.`sys_user` (`id`,`username`,`password`,`nickname`,`role`,`email`,`phone`,`create_time`,`update_time`) VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员', 'admin', NULL, NULL, '2026-02-23 11:24:39', '2026-02-23 14:46:25'),(2, 'test', 'e10adc3949ba59abbe56e057f20f883e', '测试用户', 'user', '3295586320@qq.com', '17332009477', '2026-02-23 11:24:39', '2026-02-23 18:26:26')
;
UNLOCK TABLES;
COMMIT;
