-- 完整的数据库初始化脚本
-- 如果数据库不存在则创建
CREATE DATABASE IF NOT EXISTS exercise_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE exercise_system;

-- 删除所有表（按依赖关系）
DROP TABLE IF EXISTS exam_question;
DROP TABLE IF EXISTS exam_record;
DROP TABLE IF EXISTS question_record;
DROP TABLE IF EXISTS question_collection;
DROP TABLE IF EXISTS question;
DROP TABLE IF EXISTS exercise_book;
DROP TABLE IF EXISTS question_type;
DROP TABLE IF EXISTS sys_user;

-- 创建用户表
CREATE TABLE sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    nickname VARCHAR(50) COMMENT '昵称',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 创建题型表
CREATE TABLE question_type (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    type_name VARCHAR(20) NOT NULL COMMENT '题型名称',
    type_code VARCHAR(10) NOT NULL COMMENT '题型代码',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题型表';

-- 创建习题册表
CREATE TABLE exercise_book (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    book_name VARCHAR(100) NOT NULL COMMENT '习题册名称',
    book_desc VARCHAR(500) COMMENT '习题册描述',
    type_id BIGINT COMMENT '题型分类ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    status TINYINT DEFAULT 1 COMMENT '状态：1-启用，0-禁用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='习题册表';

-- 创建题目表
CREATE TABLE question (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    book_id BIGINT NOT NULL COMMENT '习题册ID',
    type_id BIGINT NOT NULL COMMENT '题型ID：1-单选，2-多选，3-判断，4-简答',
    content TEXT NOT NULL COMMENT '题干内容',
    options TEXT COMMENT '选项，JSON格式存储，如["A.xxx","B.xxx","C.xxx","D.xxx"]',
    answer VARCHAR(500) NOT NULL COMMENT '答案',
    analysis TEXT COMMENT '解析',
    difficulty TINYINT DEFAULT 1 COMMENT '难度：1-易，2-中，3-难',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='题目表';

-- 创建做题记录表
CREATE TABLE question_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    question_id BIGINT NOT NULL COMMENT '题目ID',
    book_id BIGINT NOT NULL COMMENT '习题册ID',
    question_seq INT COMMENT '题目在当前习题册中的序号',
    answer VARCHAR(500) COMMENT '用户作答',
    is_correct TINYINT DEFAULT 0 COMMENT '是否正确：1-正确，0-错误',
    is_answered TINYINT DEFAULT 0 COMMENT '是否已答：0-未答，1-已答',
    do_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '作答时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='做题记录表';

-- 创建收藏表
CREATE TABLE question_collection (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    question_id BIGINT NOT NULL COMMENT '题目ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    UNIQUE KEY uk_user_question (user_id, question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

-- 创建考试记录表
CREATE TABLE exam_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    book_id BIGINT NOT NULL COMMENT '习题册ID',
    exam_name VARCHAR(100) COMMENT '考试名称',
    total_count INT COMMENT '题目总数',
    correct_count INT DEFAULT 0 COMMENT '正确数量',
    score DECIMAL(5,2) DEFAULT 0.00 COMMENT '得分',
    start_time DATETIME COMMENT '考试开始时间',
    end_time DATETIME COMMENT '考试结束时间',
    status TINYINT DEFAULT 0 COMMENT '状态：0-未完成，1-已完成',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试记录表';

-- 创建考试题目关联表
CREATE TABLE exam_question (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    exam_id BIGINT NOT NULL COMMENT '考试ID',
    question_id BIGINT NOT NULL COMMENT '题目ID',
    question_seq INT COMMENT '试卷内题目序号',
    user_answer VARCHAR(500) COMMENT '用户答案',
    is_correct TINYINT DEFAULT 0 COMMENT '是否正确：1-正确，0-错误',
    is_answered TINYINT DEFAULT 0 COMMENT '是否作答：0-未作答，1-已作答',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_exam_id (exam_id),
    INDEX idx_question_id (question_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试题目关联表';

-- 初始化题型数据
INSERT INTO question_type (type_name, type_code) VALUES 
('单选题', '1'),
('多选题', '2'),
('判断题', '3'),
('简答题', '4');

-- 初始化用户数据（密码为123456的MD5加密）
INSERT INTO sys_user (username, password, nickname) VALUES 
('admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员'),
('test', 'e10adc3949ba59abbe56e057f20f883e', '测试用户');

-- 初始化习题册数据
INSERT INTO exercise_book (book_name, book_desc, type_id, status) VALUES 
('Java基础练习题', 'Java语言基础知识练习，包含变量、数据类型、运算符等', 1, 1),
('数据库原理习题', '数据库SQL语句练习，包含查询、增删改等操作', 1, 1),
('数据结构与算法', '常见数据结构和算法练习题', 1, 1);

-- 插入 Java基础练习题 的题目数据
INSERT INTO question (book_id, type_id, content, options, answer, analysis, difficulty) VALUES 
(1, 1, 'Java中哪个关键字用于定义类？', '["A. class", "B. struct", "C. define", "D. type"]', 'A', 'Java使用class关键字来定义类，这是Java面向对象编程的基础。', 1),
(1, 1, 'Java中int类型占用多少字节？', '["A. 1字节", "B. 2字节", "C. 4字节", "D. 8字节"]', 'C', 'Java中int类型固定占用4个字节（32位），这是Java跨平台特性的体现。', 1),
(1, 1, '以下哪个不是Java的基本数据类型？', '["A. int", "B. String", "C. boolean", "D. double"]', 'B', 'String是引用类型，不是基本数据类型。Java有8种基本数据类型：byte、short、int、long、float、double、char、boolean。', 1),
(1, 2, 'Java中面向对象的特性包括哪些？', '["A. 封装", "B. 继承", "C. 多态", "D. 以上都是"]', 'ABCD', '面向对象的三大特性是封装、继承、多态，这是OOP编程的核心概念。', 2),
(1, 3, 'Java是一种解释型语言。', '[]', '错误', 'Java是半编译半解释型语言。Java源代码先编译成字节码，然后由JVM解释执行或JIT编译执行。', 2),
(1, 3, 'Java程序必须包含main方法才能运行。', '[]', '正确', 'main方法是Java程序的入口点，格式为public static void main(String[] args)。', 1),
(1, 4, '请简述Java中==和equals的区别。', '[]', '==比较的是引用（内存地址），equals比较的是内容。对于基本数据类型，==比较值；对于引用类型，==比较内存地址。equals方法默认比较内存地址，但很多类（如String）重写了equals方法来比较内容。', '==是运算符，equals是方法。==比较基本类型时比较值，比较引用类型时比较内存地址。equals默认比较内存地址，但String等类重写了该方法比较内容。', 3),
(1, 1, 'Java中用于输出内容到控制台的方法是？', '["A. System.out.println()", "B. Console.write()", "C. print()", "D. output()"]', 'A', 'Java使用System.out.println()方法输出内容到控制台。', 1),
(1, 2, 'Java中的访问修饰符有哪些？', '["A. public", "B. private", "C. protected", "D. default"]', 'ABCD', 'Java有四种访问修饰符：public（公共）、private（私有）、protected（受保护）、default（默认，不写修饰符）。', 2),
(1, 3, 'Java支持多重继承。', '[]', '错误', 'Java不支持类的多重继承，但可以实现多个接口。这样设计是为了避免菱形继承问题。', 2);

-- 插入 数据库原理习题 的题目数据
INSERT INTO question (book_id, type_id, content, options, answer, analysis, difficulty) VALUES 
(2, 1, 'SQL中用于查询数据的关键字是？', '["A. SELECT", "B. INSERT", "C. UPDATE", "D. DELETE"]', 'A', 'SELECT语句用于从数据库中查询数据，是最常用的SQL语句之一。', 1),
(2, 1, 'SQL中用于删除表数据的命令是？', '["A. DROP", "B. DELETE", "C. TRUNCATE", "D. REMOVE"]', 'B', 'DELETE用于删除表中的数据，DROP用于删除整个表结构，TRUNCATE用于删除表中所有数据但保留表结构。', 2),
(2, 2, '以下哪些是SQL的聚合函数？', '["A. COUNT", "B. SUM", "C. AVG", "D. MAX"]', 'ABCD', 'SQL聚合函数包括COUNT（计数）、SUM（求和）、AVG（平均值）、MAX（最大值）、MIN（最小值）等。', 1),
(2, 3, '主键可以包含NULL值。', '[]', '错误', '主键（PRIMARY KEY）不能包含NULL值，且必须唯一。这是主键的基本约束条件。', 1),
(2, 3, '外键用于建立表与表之间的关联关系。', '[]', '正确', '外键（FOREIGN KEY）用于建立和加强两个表之间的链接，保证数据的一致性和完整性。', 1),
(2, 4, '请简述SQL中WHERE和HAVING的区别。', '[]', 'WHERE在分组前过滤数据，不能使用聚合函数；HAVING在分组后过滤数据，可以使用聚合函数。WHERE作用于行，HAVING作用于组。', 'WHERE和HAVING都是过滤条件，但WHERE在GROUP BY之前执行，不能使用聚合函数；HAVING在GROUP BY之后执行，可以使用聚合函数进行过滤。', 3),
(2, 1, '数据库事务的ACID特性中，I代表什么？', '["A. 原子性", "B. 一致性", "C. 隔离性", "D. 持久性"]', 'C', 'ACID中：A-原子性(Atomicity)、C-一致性(Consistency)、I-隔离性(Isolation)、D-持久性(Durability)。', 2),
(2, 2, '以下哪些是数据库的隔离级别？', '["A. 读未提交", "B. 读已提交", "C. 可重复读", "D. 串行化"]', 'ABCD', '数据库四种隔离级别：读未提交(Read Uncommitted)、读已提交(Read Committed)、可重复读(Repeatable Read)、串行化(Serializable)。', 3),
(2, 1, 'SQL中用于排序的关键字是？', '["A. ORDER BY", "B. GROUP BY", "C. SORT BY", "D. ARRANGE"]', 'A', 'ORDER BY用于对查询结果进行排序，可配合ASC（升序）或DESC（降序）使用。', 1),
(2, 3, 'UNION和UNION ALL的结果是相同的。', '[]', '错误', 'UNION会去除重复记录，UNION ALL保留所有记录包括重复的。UNION ALL性能更好。', 2);

-- 插入 数据结构与算法 的题目数据
INSERT INTO question (book_id, type_id, content, options, answer, analysis, difficulty) VALUES 
(3, 1, '栈的特点是？', '["A. 先进先出", "B. 先进后出", "C. 随机访问", "D. 双向访问"]', 'B', '栈是一种后进先出（LIFO）的数据结构，最后入栈的元素最先出栈。', 1),
(3, 1, '队列的特点是？', '["A. 先进先出", "B. 先进后出", "C. 随机访问", "D. 单向访问"]', 'A', '队列是一种先进先出（FIFO）的数据结构，先入队的元素先出队。', 1),
(3, 2, '以下哪些是常见的排序算法？', '["A. 冒泡排序", "B. 快速排序", "C. 归并排序", "D. 二分查找"]', 'ABC', '冒泡排序、快速排序、归并排序都是排序算法，二分查找是查找算法不是排序算法。', 1),
(3, 3, '二分查找要求数据必须有序。', '[]', '正确', '二分查找算法要求数据必须是有序的，每次比较中间元素，将搜索范围缩小一半。', 1),
(3, 3, '链表支持随机访问。', '[]', '错误', '链表不支持随机访问，要访问第n个元素必须从头节点开始遍历n次。数组才支持随机访问。', 2),
(3, 4, '请简述数组和链表的区别。', '[]', '数组：连续内存，支持随机访问，插入删除效率低。链表：非连续内存，不支持随机访问，插入删除效率高。', '数组在内存中连续存储，支持O(1)随机访问，但插入删除需要O(n)时间。链表通过指针连接，插入删除只需O(1)，但访问需要O(n)遍历。', 2),
(3, 1, '快速排序的平均时间复杂度是？', '["A. O(n)", "B. O(nlogn)", "C. O(n²)", "D. O(logn)"]', 'B', '快速排序平均时间复杂度为O(nlogn)，最坏情况（已排序数组）为O(n²)。', 2),
(3, 2, '以下哪些是树形结构？', '["A. 二叉树", "B. B树", "C. 堆", "D. 哈希表"]', 'ABC', '二叉树、B树、堆都是树形结构，哈希表是基于数组的数据结构。', 2),
(3, 1, '哈希表查找的平均时间复杂度是？', '["A. O(1)", "B. O(n)", "C. O(logn)", "D. O(nlogn)"]', 'A', '哈希表通过哈希函数直接定位元素位置，平均查找时间复杂度为O(1)。', 1),
(3, 3, '递归算法必须有终止条件。', '[]', '正确', '递归算法必须有终止条件（基准情况），否则会无限递归导致栈溢出。', 1);

-- 验证插入结果
SELECT '=== 数据库初始化完成 ===' as info;
SELECT 
    b.id as book_id,
    b.book_name,
    COUNT(q.id) as question_count
FROM exercise_book b
LEFT JOIN question q ON b.id = q.book_id
GROUP BY b.id, b.book_name
ORDER BY b.id;
