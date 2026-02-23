-- 详细检查数据库中的数据
USE exercise_system;

-- 检查习题册
SELECT '=== 习题册 ===' as info;
SELECT * FROM exercise_book;

-- 检查题目
SELECT '=== 题目 ===' as info;
SELECT id, book_id, type_id, content FROM question;

-- 检查每个习题册的题目数量
SELECT '=== 每个习题册的题目数量 ===' as info;
SELECT 
    b.id as book_id,
    b.book_name,
    (SELECT COUNT(*) FROM question WHERE book_id = b.id) as total_count
FROM exercise_book b
ORDER BY b.id;

-- 测试 selectDetailById 查询（模拟后端查询）
SELECT '=== 测试 selectDetailById 查询 (book_id=1, user_id=1) ===' as info;
SELECT b.*,
       (SELECT COUNT(*) FROM question WHERE book_id = b.id) as total_count,
       (SELECT COUNT(DISTINCT question_id) FROM question_record WHERE book_id = b.id AND user_id = 1) as done_count,
       (SELECT COUNT(*) FROM question_record WHERE book_id = b.id AND user_id = 1 AND is_correct = 1) as correct_count
FROM exercise_book b
WHERE b.id = 1;

-- 测试 selectDetailById 查询（模拟后端查询，book_id=2）
SELECT '=== 测试 selectDetailById 查询 (book_id=2, user_id=1) ===' as info;
SELECT b.*,
       (SELECT COUNT(*) FROM question WHERE book_id = b.id) as total_count,
       (SELECT COUNT(DISTINCT question_id) FROM question_record WHERE book_id = b.id AND user_id = 1) as done_count,
       (SELECT COUNT(*) FROM question_record WHERE book_id = b.id AND user_id = 1 AND is_correct = 1) as correct_count
FROM exercise_book b
WHERE b.id = 2;

-- 测试 selectDetailById 查询（模拟后端查询，book_id=3）
SELECT '=== 测试 selectDetailById 查询 (book_id=3, user_id=1) ===' as info;
SELECT b.*,
       (SELECT COUNT(*) FROM question WHERE book_id = b.id) as total_count,
       (SELECT COUNT(DISTINCT question_id) FROM question_record WHERE book_id = b.id AND user_id = 1) as done_count,
       (SELECT COUNT(*) FROM question_record WHERE book_id = b.id AND user_id = 1 AND is_correct = 1) as correct_count
FROM exercise_book b
WHERE b.id = 3;
