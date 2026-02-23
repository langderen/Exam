-- 检查数据库连接和数据
USE exercise_system;

-- 检查习题册
SELECT '=== 习题册 ===' as info;
SELECT id, book_name FROM exercise_book;

-- 检查题目
SELECT '=== 题目 ===' as info;
SELECT COUNT(*) as question_count FROM question;

-- 检查每个习题册的题目数量
SELECT '=== 每个习题册的题目数量 ===' as info;
SELECT 
    b.id as book_id,
    b.book_name,
    COUNT(q.id) as question_count
FROM exercise_book b
LEFT JOIN question q ON b.id = q.book_id
GROUP BY b.id, b.book_name
ORDER BY b.id;

-- 测试跳转到第1题
SELECT '=== 测试跳转到第1题 (book_id=1, offset=0) ===' as info;
SELECT q.*, qt.type_name, eb.book_name
FROM question q
LEFT JOIN question_type qt ON q.type_id = qt.id
LEFT JOIN exercise_book eb ON q.book_id = eb.id
WHERE q.book_id = 1
ORDER BY q.id ASC
LIMIT 0, 1;

-- 测试跳转到第2题
SELECT '=== 测试跳转到第2题 (book_id=1, offset=1) ===' as info;
SELECT q.*, qt.type_name, eb.book_name
FROM question q
LEFT JOIN question_type qt ON q.type_id = qt.id
LEFT JOIN exercise_book eb ON q.book_id = eb.id
WHERE q.book_id = 1
ORDER BY q.id ASC
LIMIT 1, 1;
