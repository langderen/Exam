-- 检查并修复题目数据
USE exercise_system;

-- 检查习题册
SELECT '习题册数量：', COUNT(*) FROM exercise_book;

-- 检查题目
SELECT '题目数量：', COUNT(*) FROM question;

-- 检查每个习题册的题目数
SELECT 
    b.id as book_id,
    b.book_name,
    COUNT(q.id) as question_count
FROM exercise_book b
LEFT JOIN question q ON b.id = q.book_id
GROUP BY b.id, b.book_name
ORDER BY b.id;

-- 如果题目数为0，重新插入题目数据
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
(1, 3, 'Java支持多重继承。', '[]', '错误', 'Java不支持类的多重继承，但可以实现多个接口。这样设计是为了避免菱形继承问题。', 2)
ON DUPLICATE KEY UPDATE id=id;

-- 验证插入结果
SELECT 
    b.id as book_id,
    b.book_name,
    COUNT(q.id) as question_count
FROM exercise_book b
LEFT JOIN question q ON b.id = q.book_id
GROUP BY b.id, b.book_name
ORDER BY b.id;
