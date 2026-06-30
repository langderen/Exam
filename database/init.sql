/*
 Exam 习题册刷题系统 - 数据库初始化脚本
 Database: exercise_system
 Author: langderen
 Create Time: 2026-02-23
 Description: 包含完整的数据库表结构和初始数据
*/

/* 创建数据库（如果不存在） */
CREATE DATABASE IF NOT EXISTS exercise_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

/* 使用数据库 */
USE exercise_system;

/* 关闭外键检查 */
SET FOREIGN_KEY_CHECKS = 0;

-- ==================== 1. 用户表 ====================
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码（MD5加密）',
    `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    `role` VARCHAR(20) DEFAULT 'user' COMMENT '角色：user-普通用户，admin-管理员',
    `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `balance` DECIMAL(10, 2) DEFAULT 0.00 COMMENT '钱包余额',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

-- ==================== 2. 题型分类表 ====================
DROP TABLE IF EXISTS `question_type`;
CREATE TABLE `question_type` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `type_name` VARCHAR(50) NOT NULL COMMENT '题型名称：单选题/多选题/判断题/简答题',
    `sort` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题型分类表';

-- ==================== 3. 习题册表 ====================
DROP TABLE IF EXISTS `exercise_book`;
CREATE TABLE `exercise_book` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `book_name` VARCHAR(100) NOT NULL COMMENT '习题册名称',
    `book_desc` VARCHAR(500) DEFAULT NULL COMMENT '习题册描述',
    `type_id` BIGINT DEFAULT NULL COMMENT '题型分类ID',
    `price` DECIMAL(10, 2) DEFAULT 0.00 COMMENT '价格（0表示免费）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `status` TINYINT DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    `creator_id` BIGINT DEFAULT NULL COMMENT '创建者ID',
    `is_public` TINYINT DEFAULT 1 COMMENT '是否公开：1-公开，0-私有',
    `content_image` VARCHAR(255) DEFAULT NULL COMMENT '封面图片URL',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='习题册表';

-- ==================== 4. 题目表 ====================
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `book_id` BIGINT NOT NULL COMMENT '习题册ID',
    `type_id` BIGINT NOT NULL COMMENT '题型ID：1-单选，2-多选，3-判断，4-简答',
    `content` TEXT NOT NULL COMMENT '题干内容',
    `content_image` VARCHAR(500) DEFAULT NULL COMMENT '题目图片URL',
    `options` TEXT DEFAULT NULL COMMENT '选项，JSON格式存储，如["A.xxx","B.xxx","C.xxx","D.xxx"]',
    `answer` VARCHAR(500) NOT NULL COMMENT '答案',
    `analysis` TEXT DEFAULT NULL COMMENT '解析',
    `difficulty` TINYINT DEFAULT 1 COMMENT '难度：1-易，2-中，3-难',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `options_image` VARCHAR(255) DEFAULT NULL COMMENT '选项图片URL',
    PRIMARY KEY (`id`),
    KEY `idx_book_id` (`book_id`),
    KEY `idx_type_id` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='题目表';

-- ==================== 5. 做题记录表 ====================
DROP TABLE IF EXISTS `question_record`;
CREATE TABLE `question_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `question_id` BIGINT NOT NULL COMMENT '题目ID',
    `book_id` BIGINT NOT NULL COMMENT '习题册ID',
    `question_seq` INT DEFAULT NULL COMMENT '题目在当前习题册中的序号',
    `answer` VARCHAR(500) DEFAULT NULL COMMENT '用户作答',
    `is_correct` TINYINT DEFAULT 0 COMMENT '是否正确：1-正确，0-错误',
    `is_answered` TINYINT DEFAULT 0 COMMENT '是否已答：0-未答，1-已答',
    `do_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '作答时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_question_id` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='做题记录表';

-- ==================== 6. 收藏表 ====================
DROP TABLE IF EXISTS `collection`;
CREATE TABLE `collection` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `question_id` BIGINT NOT NULL COMMENT '题目ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_question` (`user_id`, `question_id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='收藏表';

-- ==================== 7. 考试记录表 ====================
DROP TABLE IF EXISTS `exam_record`;
CREATE TABLE `exam_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `book_id` BIGINT DEFAULT NULL COMMENT '习题册ID',
    `exam_name` VARCHAR(100) DEFAULT NULL COMMENT '考试名称',
    `total_count` INT DEFAULT 0 COMMENT '总题数',
    `start_time` DATETIME DEFAULT NULL COMMENT '考试开始时间',
    `end_time` DATETIME DEFAULT NULL COMMENT '考试结束时间',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-未完成，1-已完成',
    `correct_count` INT DEFAULT 0 COMMENT '正确数',
    `score` DECIMAL(5, 2) DEFAULT 0.00 COMMENT '得分',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='考试记录表';

-- ==================== 8. 考试题目关联表 ====================
DROP TABLE IF EXISTS `exam_question`;
CREATE TABLE `exam_question` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `exam_id` BIGINT NOT NULL COMMENT '考试ID',
    `question_id` BIGINT NOT NULL COMMENT '题目ID',
    `question_seq` INT DEFAULT NULL COMMENT '试卷内题目序号',
    `user_answer` VARCHAR(500) DEFAULT NULL COMMENT '用户答案',
    `is_correct` TINYINT DEFAULT 0 COMMENT '是否正确：1-正确，0-错误',
    `is_answered` TINYINT DEFAULT 0 COMMENT '是否作答：0-未作答，1-已作答',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_exam_id` (`exam_id`),
    KEY `idx_question_id` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='考试题目关联表';

-- ==================== 9. 考试详情表 ====================
DROP TABLE IF EXISTS `exam_detail`;
CREATE TABLE `exam_detail` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `exam_id` BIGINT NOT NULL COMMENT '考试记录ID',
    `question_id` BIGINT NOT NULL COMMENT '题目ID',
    `user_answer` VARCHAR(500) DEFAULT NULL COMMENT '用户答案',
    `is_correct` TINYINT DEFAULT 0 COMMENT '是否正确',
    PRIMARY KEY (`id`),
    KEY `idx_exam_id` (`exam_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='考试详情表';

-- ==================== 10. 钱包交易记录表 ====================
DROP TABLE IF EXISTS `wallet_transaction`;
CREATE TABLE `wallet_transaction` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `wallet_id` BIGINT NOT NULL COMMENT '钱包ID（用户ID）',
    `type` VARCHAR(20) NOT NULL COMMENT '交易类型：recharge-充值，purchase-购买',
    `amount` DECIMAL(10, 2) NOT NULL COMMENT '交易金额（正数充值，负数消费）',
    `balance_after` DECIMAL(10, 2) DEFAULT NULL COMMENT '交易后余额',
    `description` VARCHAR(200) DEFAULT NULL COMMENT '交易描述',
    `related_id` BIGINT DEFAULT NULL COMMENT '关联ID（如购买记录ID）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_wallet_id` (`wallet_id`),
    KEY `idx_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='钱包交易记录表';

-- ==================== 11. 习题册购买记录表 ====================
DROP TABLE IF EXISTS `book_purchase`;
CREATE TABLE `book_purchase` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `book_id` BIGINT NOT NULL COMMENT '习题册ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `price` DECIMAL(10, 2) NOT NULL COMMENT '购买价格',
    `purchase_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '购买时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_book` (`user_id`, `book_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_book_id` (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='习题册购买记录表';

-- ==================== 12. 通知表 ====================
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `title` VARCHAR(100) NOT NULL COMMENT '通知标题',
    `content` TEXT DEFAULT NULL COMMENT '通知内容',
    `type` VARCHAR(20) DEFAULT NULL COMMENT '通知类型：exam-考试，purchase-购买，system-系统',
    `related_id` BIGINT DEFAULT NULL COMMENT '关联ID',
    `is_read` TINYINT DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_is_read` (`is_read`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知表';

-- ==================== 13. 支付订单表 ====================
DROP TABLE IF EXISTS `payment_order`;
CREATE TABLE `payment_order` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `order_no` VARCHAR(64) NOT NULL COMMENT '商户订单号',
    `subject` VARCHAR(200) NOT NULL COMMENT '订单标题',
    `total_amount` DECIMAL(10, 2) NOT NULL COMMENT '支付金额',
    `trade_no` VARCHAR(128) DEFAULT NULL COMMENT '支付宝交易号',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0-待支付，1-已支付，2-已退款，3-已关闭',
    `pay_method` VARCHAR(20) DEFAULT NULL COMMENT '支付方式：alipay-支付宝，wallet-钱包',
    `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_order_no` (`order_no`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_trade_no` (`trade_no`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付订单表';

/* 开启外键检查 */
SET FOREIGN_KEY_CHECKS = 1;

-- ==================== 初始数据 ====================

-- 插入题型数据
INSERT INTO `question_type` (`type_name`, `sort`, `create_time`) VALUES
('单选题', 1, NOW()),
('多选题', 2, NOW()),
('判断题', 3, NOW()),
('简答题', 4, NOW());

-- 插入用户数据（密码均为 123456 的 MD5 值）
INSERT INTO `sys_user` (`username`, `password`, `nickname`, `role`, `email`, `phone`, `balance`, `create_time`) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员', 'admin', NULL, NULL, 100.00, NOW()),
('test', 'e10adc3949ba59abbe56e057f20f883e', '测试用户', 'user', 'test@example.com', '13800138000', 50.00, NOW());

-- 插入习题册数据
INSERT INTO `exercise_book` (`book_name`, `book_desc`, `type_id`, `price`, `create_time`, `status`, `creator_id`, `is_public`) VALUES
('Java基础练习题', 'Java语言基础知识练习，包含变量、数据类型、运算符等', 1, 0.00, NOW(), 1, 1, 1),
('数据库原理习题', '数据库SQL语句练习，包含查询、增删改等操作', 1, 10.00, NOW(), 1, 1, 1),
('数据结构与算法', '常见数据结构和算法练习题', 1, 0.00, NOW(), 1, 1, 1),
('软考中级习题册', '想要报考中级软考的同学请刷题', NULL, 20.00, NOW(), 1, 2, 1);

-- 插入Java基础题目
INSERT INTO `question` (`book_id`, `type_id`, `content`, `options`, `answer`, `analysis`, `difficulty`, `create_time`) VALUES
(1, 1, 'Java中哪个关键字用于定义类？', '["A. class", "B. struct", "C. define", "D. type"]', 'A', 'Java使用class关键字来定义类，这是Java面向对象编程的基础。', 1, NOW()),
(1, 1, 'Java中int类型占用多少字节？', '["A. 1字节", "B. 2字节", "C. 4字节", "D. 8字节"]', 'C', 'Java中int类型固定占用4个字节（32位），这是Java跨平台特性的体现。', 1, NOW()),
(1, 1, '以下哪个不是Java的基本数据类型？', '["A. int", "B. String", "C. boolean", "D. double"]', 'B', 'String是引用类型，不是基本数据类型。Java有8种基本数据类型：byte、short、int、long、float、double、char、boolean。', 1, NOW()),
(1, 2, 'Java中面向对象的特性包括哪些？', '["A. 封装", "B. 继承", "C. 多态", "D. 以上都是"]', 'ABCD', '面向对象的三大特性是封装、继承、多态，这是OOP编程的核心概念。', 2, NOW()),
(1, 3, 'Java是一种解释型语言。', '[]', '错误', 'Java是半编译半解释型语言。Java源代码先编译成字节码，然后由JVM解释执行或JIT编译执行。', 2, NOW()),
(1, 3, 'Java程序必须包含main方法才能运行。', '[]', '正确', 'main方法是Java程序的入口点，格式为public static void main(String[] args)。', 1, NOW()),
(1, 4, '请简述Java中==和equals的区别。', '[]', '==比较的是引用（内存地址），equals比较的是内容。对于基本数据类型，==比较值；对于引用类型，==比较内存地址。equals方法默认比较内存地址，但很多类（如String）重写了equals方法来比较内容。', '==是运算符，equals是方法。==比较基本类型时比较值，比较引用类型时比较内存地址。equals默认比较内存地址，但String等类重写了该方法比较内容。', 3, NOW()),
(1, 1, 'Java中用于输出内容到控制台的方法是？', '["A. System.out.println()", "B. Console.write()", "C. print()", "D. output()"]', 'A', 'Java使用System.out.println()方法输出内容到控制台。', 1, NOW()),
(1, 2, 'Java中的访问修饰符有哪些？', '["A. public", "B. private", "C. protected", "D. default"]', 'ABCD', 'Java有四种访问修饰符：public（公共）、private（私有）、protected（受保护）、default（默认，不写修饰符）。', 2, NOW()),
(1, 3, 'Java支持多重继承。', '[]', '错误', 'Java不支持类的多重继承，但可以实现多个接口。这样设计是为了避免菱形继承问题。', 2, NOW());

-- 插入数据库题目
INSERT INTO `question` (`book_id`, `type_id`, `content`, `options`, `answer`, `analysis`, `difficulty`, `create_time`) VALUES
(2, 1, 'SQL中用于查询数据的关键字是？', '["A. SELECT", "B. INSERT", "C. UPDATE", "D. DELETE"]', 'A', 'SELECT语句用于从数据库中查询数据，是最常用的SQL语句之一。', 1, NOW()),
(2, 1, 'SQL中用于删除表数据的命令是？', '["A. DROP", "B. DELETE", "C. TRUNCATE", "D. REMOVE"]', 'B', 'DELETE用于删除表中的数据，DROP用于删除整个表结构，TRUNCATE用于删除表中所有数据但保留表结构。', 2, NOW()),
(2, 2, '以下哪些是SQL的聚合函数？', '["A. COUNT", "B. SUM", "C. AVG", "D. MAX"]', 'ABCD', 'SQL聚合函数包括COUNT（计数）、SUM（求和）、AVG（平均值）、MAX（最大值）、MIN（最小值）等。', 1, NOW()),
(2, 3, '主键可以包含NULL值。', '[]', '错误', '主键（PRIMARY KEY）不能包含NULL值，且必须唯一。这是主键的基本约束条件。', 1, NOW()),
(2, 3, '外键用于建立表与表之间的关联关系。', '[]', '正确', '外键（FOREIGN KEY）用于建立和加强两个表之间的链接，保证数据的一致性和完整性。', 1, NOW()),
(2, 4, '请简述SQL中WHERE和HAVING的区别。', '[]', 'WHERE在分组前过滤数据，不能使用聚合函数；HAVING在分组后过滤数据，可以使用聚合函数。WHERE作用于行，HAVING作用于组。', 'WHERE和HAVING都是过滤条件，但WHERE在GROUP BY之前执行，不能使用聚合函数；HAVING在GROUP BY之后执行，可以使用聚合函数进行过滤。', 3, NOW()),
(2, 1, '数据库事务的ACID特性中，I代表什么？', '["A. 原子性", "B. 一致性", "C. 隔离性", "D. 持久性"]', 'C', 'ACID中：A-原子性(Atomicity)、C-一致性(Consistency)、I-隔离性(Isolation)、D-持久性(Durability)。', 2, NOW()),
(2, 2, '以下哪些是数据库的隔离级别？', '["A. 读未提交", "B. 读已提交", "C. 可重复读", "D. 串行化"]', 'ABCD', '数据库四种隔离级别：读未提交(Read Uncommitted)、读已提交(Read Committed)、可重复读(Repeatable Read)、串行化(Serializable)。', 3, NOW());

-- 插入数据结构与算法题目
INSERT INTO `question` (`book_id`, `type_id`, `content`, `options`, `answer`, `analysis`, `difficulty`, `create_time`) VALUES
(3, 1, '栈的特点是？', '["A. 先进先出", "B. 先进后出", "C. 随机访问", "D. 双向访问"]', 'B', '栈是一种后进先出（LIFO）的数据结构，最后入栈的元素最先出栈。', 1, NOW()),
(3, 1, '队列的特点是？', '["A. 先进先出", "B. 先进后出", "C. 随机访问", "D. 单向访问"]', 'A', '队列是一种先进先出（FIFO）的数据结构，先入队的元素先出队。', 1, NOW()),
(3, 2, '以下哪些是常见的排序算法？', '["A. 冒泡排序", "B. 快速排序", "C. 归并排序", "D. 二分查找"]', 'ABC', '冒泡排序、快速排序、归并排序都是排序算法，二分查找是查找算法不是排序算法。', 1, NOW()),
(3, 3, '二分查找要求数据必须有序。', '[]', '正确', '二分查找算法要求数据必须是有序的，每次比较中间元素，将搜索范围缩小一半。', 1, NOW()),
(3, 3, '链表支持随机访问。', '[]', '错误', '链表不支持随机访问，要访问第n个元素必须从头节点开始遍历n次。数组才支持随机访问。', 2, NOW()),
(3, 4, '请简述数组和链表的区别。', '[]', '数组：连续内存，支持随机访问，插入删除效率低。链表：非连续内存，不支持随机访问，插入删除效率高。', '数组在内存中连续存储，支持O(1)随机访问，但插入删除需要O(n)时间。链表通过指针连接，插入删除只需O(1)，但访问需要O(n)遍历。', 2, NOW()),
(3, 1, '快速排序的平均时间复杂度是？', '["A. O(n)", "B. O(nlogn)", "C. O(n²)", "D. O(logn)"]', 'B', '快速排序平均时间复杂度为O(nlogn)，最坏情况（已排序数组）为O(n²)。', 2, NOW()),
(3, 1, '哈希表查找的平均时间复杂度是？', '["A. O(1)", "B. O(n)", "C. O(logn)", "D. O(nlogn)"]', 'A', '哈希表通过哈希函数直接定位元素位置，平均查找时间复杂度为O(1)。', 1, NOW()),
(3, 3, '递归算法必须有终止条件。', '[]', '正确', '递归算法必须有终止条件（基准情况），否则会无限递归导致栈溢出。', 1, NOW());

-- 插入软考中级题目
INSERT INTO `question` (`book_id`, `type_id`, `content`, `options`, `answer`, `analysis`, `difficulty`, `create_time`) VALUES
(4, 1, '在软件工程中，需求规格说明书的作用是？', '["A. 描述系统的功能需求", "B. 描述系统的性能需求", "C. 仅供开发人员使用", "D. 仅供测试人员使用"]', 'A', '需求规格说明书（SRS）是软件开发的重要文档，主要描述系统的功能需求。', 2, NOW()),
(4, 3, '软件测试应该尽可能早地开始。', '[]', '正确', '软件测试应该尽早开始，以便尽早发现和修复缺陷，降低修复成本。', 2, NOW()),
(4, 3, '面向对象设计中的封装是指将数据和操作封装在对象中。', '[]', '正确', '封装是面向对象的基本特性之一，将数据和操作封装在对象内部，对外提供接口。', 1, NOW()),
(4, 1, '以下哪个不是软件生命周期模型？', '["A. 瀑布模型", "B. 增量模型", "C. 快速模型", "D. 螺旋模型"]', 'C', '瀑布模型、增量模型、螺旋模型都是常见的软件生命周期模型，快速模型不是标准模型。', 2, NOW()),
(4, 2, '软件维护包括哪些类型？', '["A. 纠错性维护", "B. 适应性维护", "C. 完善性维护", "D. 预防性维护"]', 'ABCD', '软件维护包括纠错性维护（修复错误）、适应性维护（适应环境变化）、完善性维护（改进功能）、预防性维护（预防未来问题）。', 2, NOW()),
(4, 3, 'UML只能用于面向对象软件的建模。', '[]', '错误', 'UML主要用于面向对象建模，但也可以用于其他领域的建模。', 2, NOW()),
(4, 1, 'CMM模型中，"已定义级"是第几级？', '["A. 第二级", "B. 第三级", "C. 第四级", "D. 第五级"]', 'B', 'CMM五级：初始级、已管理级、已定义级、量化管理级、优化级，所以已定义级是第三级。', 3, NOW()),
(4, 2, '以下哪些是白盒测试的方法？', '["A. 语句覆盖", "B. 判定覆盖", "C. 等价类划分", "D. 条件覆盖"]', 'ABD', '语句覆盖、判定覆盖、条件覆盖都是白盒测试方法，等价类划分是黑盒测试方法。', 3, NOW()),
(4, 3, '软件配置管理是对软件交付后的变更进行管理。', '[]', '错误', '软件配置管理贯穿整个软件生命周期，不仅限于交付后，包括开发过程中的所有配置项。', 2, NOW()),
(4, 1, '数据库设计时，第一范式要求？', '["A. 字段不可再分", "B. 非主键字段完全依赖主键", "C. 消除传递依赖", "D. 每个字段都与主键直接相关"]', 'A', '第一范式（1NF）要求字段具有原子性，不可再分。', 1, NOW());

-- 插入测试数据
INSERT INTO `collection` (`user_id`, `question_id`, `create_time`) VALUES
(1, 9, NOW());

INSERT INTO `wallet_transaction` (`wallet_id`, `type`, `amount`, `balance_after`, `description`, `create_time`) VALUES
(1, 'recharge', 100.00, 100.00, '初始充值', NOW()),
(2, 'recharge', 50.00, 50.00, '初始充值', NOW());

-- 输出完成信息
SELECT '数据库初始化完成！' AS 'Status';
