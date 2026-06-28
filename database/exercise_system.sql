/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 90400 (9.4.0)
 Source Host           : localhost:3306
 Source Schema         : exercise_system

 Target Server Type    : MySQL
 Target Server Version : 90400 (9.4.0)
 File Encoding         : 65001

 Date: 31/05/2026 15:01:30
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for book_purchase
-- ----------------------------
DROP TABLE IF EXISTS `book_purchase`;
CREATE TABLE `book_purchase`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `book_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `purchase_time` datetime NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_book_user`(`book_id` ASC, `user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_purchase
-- ----------------------------

-- ----------------------------
-- Table structure for collection
-- ----------------------------
DROP TABLE IF EXISTS `collection`;
CREATE TABLE `collection`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_question`(`user_id` ASC, `question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of collection
-- ----------------------------
INSERT INTO `collection` VALUES (2, 1, 9, '2026-02-23 13:11:04');

-- ----------------------------
-- Table structure for exam_detail
-- ----------------------------
DROP TABLE IF EXISTS `exam_detail`;
CREATE TABLE `exam_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `exam_id` bigint NOT NULL COMMENT '考试记录ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `user_answer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户答案',
  `is_correct` tinyint NULL DEFAULT 0 COMMENT '是否正确',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_detail
-- ----------------------------

-- ----------------------------
-- Table structure for exam_question
-- ----------------------------
DROP TABLE IF EXISTS `exam_question`;
CREATE TABLE `exam_question`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `exam_id` bigint NOT NULL COMMENT '考试ID',
  `question_id` bigint NOT NULL COMMENT '题目ID',
  `question_seq` int NULL DEFAULT NULL COMMENT '试卷内题目序号',
  `user_answer` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户答案',
  `is_correct` tinyint NULL DEFAULT 0 COMMENT '是否正确：1-正确，0-错误',
  `is_answered` tinyint NULL DEFAULT 0 COMMENT '是否作答：0-未作答，1-已作答',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `ai_score` int NULL DEFAULT NULL COMMENT 'AI评分（0-100）',
  `ai_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'AI评分详情',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_exam_id`(`exam_id` ASC) USING BTREE,
  INDEX `idx_question_id`(`question_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 224 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试题目关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_question
-- ----------------------------
INSERT INTO `exam_question` VALUES (211, 22, 5, 1, '正确', 0, 1, '2026-03-03 23:47:27', NULL, NULL);
INSERT INTO `exam_question` VALUES (212, 22, 8, 2, 'B', 0, 1, '2026-03-03 23:47:27', NULL, NULL);
INSERT INTO `exam_question` VALUES (213, 22, 2, 3, 'C', 1, 1, '2026-03-03 23:47:27', NULL, NULL);
INSERT INTO `exam_question` VALUES (214, 23, 5, 1, '正确', 0, 1, '2026-03-03 23:48:26', NULL, NULL);
INSERT INTO `exam_question` VALUES (215, 23, 7, 2, '', 0, 1, '2026-03-03 23:48:26', NULL, NULL);
INSERT INTO `exam_question` VALUES (216, 24, 10, 1, '错误', 1, 1, '2026-03-04 16:41:14', NULL, NULL);
INSERT INTO `exam_question` VALUES (219, 26, 47, 1, '节省ipv4地址，保证安全', 0, 1, '2026-03-04 23:24:06', NULL, NULL);
INSERT INTO `exam_question` VALUES (220, 26, 44, 2, 'B', 0, 1, '2026-03-04 23:24:06', NULL, NULL);
INSERT INTO `exam_question` VALUES (221, 26, 46, 3, 'IP数据报', 1, 1, '2026-03-04 23:24:06', NULL, NULL);
INSERT INTO `exam_question` VALUES (222, 26, 41, 4, 'B', 1, 1, '2026-03-04 23:24:06', NULL, NULL);
INSERT INTO `exam_question` VALUES (223, 27, 47, 1, '节省ip', 0, 1, '2026-03-04 23:46:28', 20, '得分：20分\n\n评价：\n1. 答案完整度分析  \n   用户答案仅回答了\"节省ip\"这一部分，未涉及NAT的核心功能（如共享公网IP、转换表记录、内外网数据报处理）和作用的其他关键点（如网络通信复杂度），完整度严重不足。\n\n2. 关键要点覆盖情况  \n   仅覆盖了答题要点中的\"减少IP地址消耗\"（对应节省ip），但未涉及其他四个核心要点：共享公网IP、转换表记录、内外网数据报处理、网络通信复杂度。完全偏离了题目要求的\"简述作用及工作原理\"的完整结构。\n\n3. 改进建议  \n   需要系统性地回答题目要求的全部要点：  \n   - 首先明确NAT的核心作用（共享公网IP、减少IP消耗）  \n   - 详细说明工作原理（转换表记录、内外网数据报处理）  \n   - 补充说明其带来的额外影响（增加通信复杂度）  \n   建议参考正确答案的表述结构，分点阐述作用与原理，确保覆盖所有考核要点。');

-- ----------------------------
-- Table structure for exam_record
-- ----------------------------
DROP TABLE IF EXISTS `exam_record`;
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
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '考试记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_record
-- ----------------------------
INSERT INTO `exam_record` VALUES (22, 2, 1, '考试_Java基础练习题_2026/3/3 23:47:27', 3, '2026-03-03 23:47:27', '2026-03-03 23:47:27', 1, 1, 33.33, '2026-03-03 23:47:27');
INSERT INTO `exam_record` VALUES (23, 1, 1, '考试_Java基础练习题_2026/3/3 23:48:25', 2, '2026-03-03 23:48:26', '2026-03-03 23:48:26', 1, 0, 0.00, '2026-03-03 23:48:26');
INSERT INTO `exam_record` VALUES (24, 2, 1, '考试_Java基础练习题_2026/3/4 16:41:14', 1, '2026-03-04 16:41:14', '2026-03-04 16:41:14', 1, 1, 100.00, '2026-03-04 16:41:14');
INSERT INTO `exam_record` VALUES (26, 2, 4, '考试_软考中级习题册_2026/3/4 23:23:11', 4, '2026-03-04 23:23:12', '2026-03-04 23:23:12', 1, 2, 27.50, '2026-03-04 23:23:11');
INSERT INTO `exam_record` VALUES (27, 2, 4, '考试_软考中级习题册_2026/3/4 23:46:28', 1, '2026-03-04 23:46:29', '2026-03-04 23:46:55', 1, 0, 20.00, '2026-03-04 23:46:28');

-- ----------------------------
-- Table structure for exercise_book
-- ----------------------------
DROP TABLE IF EXISTS `exercise_book`;
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
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '习题册表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exercise_book
-- ----------------------------
INSERT INTO `exercise_book` VALUES (1, 'Java基础练习题', 'Java语言基础知识练习，包含变量、数据类型、运算符等', 1, '2026-02-23 11:24:39', 1, 1, 1, NULL, 0.00, '计算机');
INSERT INTO `exercise_book` VALUES (2, '数据库原理习题', '数据库SQL语句练习，包含查询、增删改等操作', 1, '2026-02-23 11:24:39', 1, 1, 1, NULL, 0.00, '计算机');
INSERT INTO `exercise_book` VALUES (3, '数据结构与算法', '常见数据结构和算法练习题', 1, '2026-02-23 11:24:39', 1, 1, 1, NULL, 0.00, '计算机');
INSERT INTO `exercise_book` VALUES (4, '软考中级习题册', '想要报考中级软考的同学请刷题\n', NULL, '2026-02-23 14:48:04', 1, 2, 1, NULL, 0.01, '计算机');

-- ----------------------------
-- Table structure for notification
-- ----------------------------
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '消息内容',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'system' COMMENT '消息类型：system-系统消息，exam-考试消息',
  `related_id` bigint NULL DEFAULT NULL COMMENT '关联ID（如考试记录ID）',
  `is_read` tinyint NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_is_read`(`is_read` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notification
-- ----------------------------
INSERT INTO `notification` VALUES (1, 2, '考试判卷完成', '您的考试【考试_软考中级习题册_2026/3/4 23:46:28】已完成判卷，得分：-80.00分', 'exam', 27, 1, '2026-03-04 23:46:55');

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
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
  `attachment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '题目附件URL',
  `attachment_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '题目附件名称',
  `ai_scoring` tinyint NULL DEFAULT 0 COMMENT '是否启用AI评分：0-否，1-是',
  `key_points` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '答题要点（用于AI评分）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '题目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES (1, 1, 1, 'Java中哪个关键字用于定义类？', NULL, '[\"A. class\", \"B. struct\", \"C. define\", \"D. type\"]', 'A', 'Java使用class关键字来定义类，这是Java面向对象编程的基础。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (2, 1, 1, 'Java中int类型占用多少字节？', NULL, '[\"A. 1字节\", \"B. 2字节\", \"C. 4字节\", \"D. 8字节\"]', 'C', 'Java中int类型固定占用4个字节（32位），这是Java跨平台特性的体现。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (3, 1, 1, '以下哪个不是Java的基本数据类型？', NULL, '[\"A. int\", \"B. String\", \"C. boolean\", \"D. double\"]', 'B', 'String是引用类型，不是基本数据类型。Java有8种基本数据类型：byte、short、int、long、float、double、char、boolean。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (4, 1, 2, 'Java中面向对象的特性包括哪些？', NULL, '[\"A. 封装\", \"B. 继承\", \"C. 多态\", \"D. 以上都是\"]', 'ABCD', '面向对象的三大特性是封装、继承、多态，这是OOP编程的核心概念。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (5, 1, 3, 'Java是一种解释型语言。', NULL, '[]', '错误', 'Java是半编译半解释型语言。Java源代码先编译成字节码，然后由JVM解释执行或JIT编译执行。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (6, 1, 3, 'Java程序必须包含main方法才能运行。', NULL, '[]', '正确', 'main方法是Java程序的入口点，格式为public static void main(String[] args)。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (7, 1, 4, '请简述Java中==和equals的区别。', NULL, '[]', '==比较的是引用（内存地址），equals比较的是内容。对于基本数据类型，==比较值；对于引用类型，==比较内存地址。equals方法默认比较内存地址，但很多类（如String）重写了equals方法来比较内容。', '==是运算符，equals是方法。==比较基本类型时比较值，比较引用类型时比较内存地址。equals默认比较内存地址，但String等类重写了该方法比较内容。', 3, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (8, 1, 1, 'Java中用于输出内容到控制台的方法是？', NULL, '[\"A. System.out.println()\", \"B. Console.write()\", \"C. print()\", \"D. output()\"]', 'A', 'Java使用System.out.println()方法输出内容到控制台。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (9, 1, 2, 'Java中的访问修饰符有哪些？', NULL, '[\"A. public\", \"B. private\", \"C. protected\", \"D. default\"]', 'ABCD', 'Java有四种访问修饰符：public（公共）、private（私有）、protected（受保护）、default（默认，不写修饰符）。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (10, 1, 3, 'Java支持多重继承。', NULL, '[]', '错误', 'Java不支持类的多重继承，但可以实现多个接口。这样设计是为了避免菱形继承问题。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (11, 2, 1, 'SQL中用于查询数据的关键字是？', NULL, '[\"A. SELECT\", \"B. INSERT\", \"C. UPDATE\", \"D. DELETE\"]', 'A', 'SELECT语句用于从数据库中查询数据，是最常用的SQL语句之一。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (12, 2, 1, 'SQL中用于删除表数据的命令是？', NULL, '[\"A. DROP\", \"B. DELETE\", \"C. TRUNCATE\", \"D. REMOVE\"]', 'B', 'DELETE用于删除表中的数据，DROP用于删除整个表结构，TRUNCATE用于删除表中所有数据但保留表结构。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (13, 2, 2, '以下哪些是SQL的聚合函数？', NULL, '[\"A. COUNT\", \"B. SUM\", \"C. AVG\", \"D. MAX\"]', 'ABCD', 'SQL聚合函数包括COUNT（计数）、SUM（求和）、AVG（平均值）、MAX（最大值）、MIN（最小值）等。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (14, 2, 3, '主键可以包含NULL值。', NULL, '[]', '错误', '主键（PRIMARY KEY）不能包含NULL值，且必须唯一。这是主键的基本约束条件。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (15, 2, 3, '外键用于建立表与表之间的关联关系。', NULL, '[]', '正确', '外键（FOREIGN KEY）用于建立和加强两个表之间的链接，保证数据的一致性和完整性。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (16, 2, 4, '请简述SQL中WHERE和HAVING的区别。', NULL, '[]', 'WHERE在分组前过滤数据，不能使用聚合函数；HAVING在分组后过滤数据，可以使用聚合函数。WHERE作用于行，HAVING作用于组。', 'WHERE和HAVING都是过滤条件，但WHERE在GROUP BY之前执行，不能使用聚合函数；HAVING在GROUP BY之后执行，可以使用聚合函数进行过滤。', 3, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (17, 2, 1, '数据库事务的ACID特性中，I代表什么？', NULL, '[\"A. 原子性\", \"B. 一致性\", \"C. 隔离性\", \"D. 持久性\"]', 'C', 'ACID中：A-原子性(Atomicity)、C-一致性(Consistency)、I-隔离性(Isolation)、D-持久性(Durability)。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (18, 2, 2, '以下哪些是数据库的隔离级别？', NULL, '[\"A. 读未提交\", \"B. 读已提交\", \"C. 可重复读\", \"D. 串行化\"]', 'ABCD', '数据库四种隔离级别：读未提交(Read Uncommitted)、读已提交(Read Committed)、可重复读(Repeatable Read)、串行化(Serializable)。', 3, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (19, 2, 1, 'SQL中用于排序的关键字是？', NULL, '[\"A. ORDER BY\", \"B. GROUP BY\", \"C. SORT BY\", \"D. ARRANGE\"]', 'A', 'ORDER BY用于对查询结果进行排序，可配合ASC（升序）或DESC（降序）使用。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (20, 2, 3, 'UNION和UNION ALL的结果是相同的。', NULL, '[]', '错误', 'UNION会去除重复记录，UNION ALL保留所有记录包括重复的。UNION ALL性能更好。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (21, 3, 1, '栈的特点是？', NULL, '[\"A. 先进先出\", \"B. 先进后出\", \"C. 随机访问\", \"D. 双向访问\"]', 'B', '栈是一种后进先出（LIFO）的数据结构，最后入栈的元素最先出栈。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (22, 3, 1, '队列的特点是？', NULL, '[\"A. 先进先出\", \"B. 先进后出\", \"C. 随机访问\", \"D. 单向访问\"]', 'A', '队列是一种先进先出（FIFO）的数据结构，先入队的元素先出队。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (23, 3, 2, '以下哪些是常见的排序算法？', NULL, '[\"A. 冒泡排序\", \"B. 快速排序\", \"C. 归并排序\", \"D. 二分查找\"]', 'ABC', '冒泡排序、快速排序、归并排序都是排序算法，二分查找是查找算法不是排序算法。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (24, 3, 3, '二分查找要求数据必须有序。', NULL, '[]', '正确', '二分查找算法要求数据必须是有序的，每次比较中间元素，将搜索范围缩小一半。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (25, 3, 3, '链表支持随机访问。', NULL, '[]', '错误', '链表不支持随机访问，要访问第n个元素必须从头节点开始遍历n次。数组才支持随机访问。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (26, 3, 4, '请简述数组和链表的区别。', NULL, '[]', '数组：连续内存，支持随机访问，插入删除效率低。链表：非连续内存，不支持随机访问，插入删除效率高。', '数组在内存中连续存储，支持O(1)随机访问，但插入删除需要O(n)时间。链表通过指针连接，插入删除只需O(1)，但访问需要O(n)遍历。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (27, 3, 1, '快速排序的平均时间复杂度是？', NULL, '[\"A. O(n)\", \"B. O(nlogn)\", \"C. O(n²)\", \"D. O(logn)\"]', 'B', '快速排序平均时间复杂度为O(nlogn)，最坏情况（已排序数组）为O(n²)。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (28, 3, 2, '以下哪些是树形结构？', NULL, '[\"A. 二叉树\", \"B. B树\", \"C. 堆\", \"D. 哈希表\"]', 'ABC', '二叉树、B树、堆都是树形结构，哈希表是基于数组的数据结构。', 2, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (29, 3, 1, '哈希表查找的平均时间复杂度是？', NULL, '[\"A. O(1)\", \"B. O(n)\", \"C. O(logn)\", \"D. O(nlogn)\"]', 'A', '哈希表通过哈希函数直接定位元素位置，平均查找时间复杂度为O(1)。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (30, 3, 3, '递归算法必须有终止条件。', NULL, '[]', '正确', '递归算法必须有终止条件（基准情况），否则会无限递归导致栈溢出。', 1, '2026-02-23 11:24:39', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (41, 4, 1, '在10BASE-5以太网中，若使用中继器连接多个网段，以下哪种说法正确？', '', '[\"A.可以串联5个中继器，形成6个网段\",\"B. 5段中只能有3个连接主机，其余段必须连接中继器\",\"C.中继器可以隔离广播域，但无法隔离冲突域\",\"D.半双工模式下，中继器能提升网络传输效率\"]', 'B', '根据5-4-3规程，10BASE-5以太网最多串联4个中继器，形成5段，其中仅允许3段连接主机，其余2段必须通过中、继器连接。选项B正确描述了这一规则，而其他选项均存在技术错误。', NULL, '2026-03-04 22:21:14', '', '', '', 0, NULL);
INSERT INTO `question` VALUES (44, 4, 1, '以太网帧的数据字段最小长度是？', NULL, '[\"A. 46字节\",\"B. 64字节\",\"C. 18字节\",\"D. 1500字节\"]', 'A', '根据以太网帧结构，数据字段的最小长度为46字节，以确保帧的有效传输。整个帧最短64字节包含目的地址（6字节）、源地址（6字节）、类型（2字节）、CRC（4字节）和数据字段（46字节）的总和。', 1, '2026-03-04 22:41:57', NULL, NULL, NULL, 0, NULL);
INSERT INTO `question` VALUES (46, 4, 4, '网络层的基本数据单位是什么？', NULL, '[]', '数据报', '根据材料，网络层的基本数据单位为IP数据报。', 1, '2026-03-04 23:16:30', NULL, NULL, NULL, 1, '数据报');
INSERT INTO `question` VALUES (47, 4, 4, '简述NAT的作用及其工作原理', NULL, NULL, 'NAT（网络地址转换）的作用是通过将内网私有地址转换为公网地址，实现多个主机共享一个公有IP访问互联网，从而减缓IP地址消耗。其工作原理包括：1. 内网数据报发出时，NAT服务器将其私有源地址替换为公网地址，并记录转换关系到转换表；2. 外部响应数据报返回时，NAT根据转换表将目的公网地址还原为对应的私有地址，再转发至内网主机。', '解析：NAT的核心作用是解决IPv4地址不足问题，通过地址转换实现内网设备访问公网。转换表是关键组件，用于跟踪和还原地址映射。双向转换过程体现了NAT对内外网通信的处理机制，同时因地址转换增加了路由和安全性管理的复杂度。', 1, '2026-03-04 23:21:59', NULL, NULL, NULL, 1, '实现多个主机共享公网IP；减少IP地址消耗；通过转换表记录地址映射；处理内外网数据报的地址转换；增加网络通信复杂度');

-- ----------------------------
-- Table structure for question_record
-- ----------------------------
DROP TABLE IF EXISTS `question_record`;
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
  `answer_attachment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '答案附件URL',
  `answer_attachment_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '答案附件名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '做题记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question_record
-- ----------------------------
INSERT INTO `question_record` VALUES (6, 1, 9, 1, 9, 'D', 0, 1, '2026-02-23 13:11:05', NULL, NULL);
INSERT INTO `question_record` VALUES (7, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 13:27:42', NULL, NULL);
INSERT INTO `question_record` VALUES (8, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 13:27:50', NULL, NULL);
INSERT INTO `question_record` VALUES (14, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 16:26:41', NULL, NULL);
INSERT INTO `question_record` VALUES (15, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 16:26:48', NULL, NULL);
INSERT INTO `question_record` VALUES (16, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 16:27:18', NULL, NULL);
INSERT INTO `question_record` VALUES (17, 1, 2, 1, 2, 'C', 1, 1, '2026-02-23 16:27:57', NULL, NULL);
INSERT INTO `question_record` VALUES (19, 1, 32, 4, 1, '正确', 1, 1, '2026-02-23 19:30:24', NULL, NULL);
INSERT INTO `question_record` VALUES (21, 2, 10, 1, 10, '错误', 1, 1, '2026-03-04 19:34:55', '', '');
INSERT INTO `question_record` VALUES (22, 2, 1, 1, 1, 'A', 1, 1, '2026-03-04 19:42:05', '', '');
INSERT INTO `question_record` VALUES (23, 2, 7, 1, 7, '不会', 0, 1, '2026-03-04 19:43:00', '', '');
INSERT INTO `question_record` VALUES (24, 2, 6, 1, 6, '正确', 1, 1, '2026-03-04 19:56:54', '', '');
INSERT INTO `question_record` VALUES (25, 2, 2, 1, 2, 'C', 1, 1, '2026-03-04 20:40:03', '', '');
INSERT INTO `question_record` VALUES (26, 2, 5, 1, 5, '错误', 1, 1, '2026-03-04 21:59:35', '', '');
INSERT INTO `question_record` VALUES (27, 1, 1, 1, 1, 'A', 1, 1, '2026-03-04 22:00:17', '', '');

-- ----------------------------
-- Table structure for question_type
-- ----------------------------
DROP TABLE IF EXISTS `question_type`;
CREATE TABLE `question_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题型名称：单选/多选/判断/简答',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '题型分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question_type
-- ----------------------------
INSERT INTO `question_type` VALUES (1, '单选题', 1, '2026-02-23 11:24:39');
INSERT INTO `question_type` VALUES (2, '多选题', 2, '2026-02-23 11:24:39');
INSERT INTO `question_type` VALUES (3, '判断题', 3, '2026-02-23 11:24:39');
INSERT INTO `question_type` VALUES (4, '简答题', 4, '2026-02-23 11:24:39');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'user' COMMENT '角色：user-普通用户，admin-管理员',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `balance` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '余额',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 'admin', NULL, NULL, '2026-02-23 11:24:39', '2026-03-04 23:01:44', 1000.00);
INSERT INTO `sys_user` VALUES (2, 'test', 'e10adc3949ba59abbe56e057f20f883e', 'user', '3295586320@qq.com', '17332009477', '2026-02-23 11:24:39', '2026-03-05 16:43:11', 0.00);
INSERT INTO `sys_user` VALUES (3, 'wy234', 'fcea920f7412b5da7be0cf42b8c93759', 'user', '189825078@qq.com', NULL, '2026-03-03 18:08:06', '2026-03-03 18:22:40', 0.00);

-- ----------------------------
-- Table structure for wallet_transaction
-- ----------------------------
DROP TABLE IF EXISTS `wallet_transaction`;
CREATE TABLE `wallet_transaction`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `wallet_id` bigint NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `balance_after` decimal(10, 2) NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `related_id` bigint NULL DEFAULT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wallet_transaction
-- ----------------------------
INSERT INTO `wallet_transaction` VALUES (2, 1, 'recharge', 200.00, 200.00, '充值', NULL, '2026-03-03 21:00:18');
INSERT INTO `wallet_transaction` VALUES (4, 1, 'recharge', 200.00, 399.99, '充值', NULL, '2026-03-04 18:20:25');
INSERT INTO `wallet_transaction` VALUES (5, 1, 'recharge', 200.00, 599.99, '充值', NULL, '2026-03-04 18:20:27');
INSERT INTO `wallet_transaction` VALUES (6, 1, 'recharge', 200.00, 799.99, '充值', NULL, '2026-03-04 18:20:30');
INSERT INTO `wallet_transaction` VALUES (7, 1, 'recharge', 200.00, 999.99, '充值', NULL, '2026-03-04 18:20:32');

SET FOREIGN_KEY_CHECKS = 1;
