-- 数据库更新脚本 - 添加用户角色和习题册创建者
USE exercise_system;

-- 添加用户角色字段（如果列不存在）
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'exercise_system' AND TABLE_NAME = 'sys_user' AND COLUMN_NAME = 'role');
SET @sql := IF(@exist = 0, 'ALTER TABLE sys_user ADD COLUMN role VARCHAR(20) DEFAULT ''user'' COMMENT ''角色：user-普通用户，admin-管理员'' AFTER nickname', 'SELECT ''role column already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'exercise_system' AND TABLE_NAME = 'sys_user' AND COLUMN_NAME = 'avatar');
SET @sql := IF(@exist = 0, 'ALTER TABLE sys_user ADD COLUMN avatar VARCHAR(200) DEFAULT NULL COMMENT ''头像URL'' AFTER role', 'SELECT ''avatar column already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'exercise_system' AND TABLE_NAME = 'sys_user' AND COLUMN_NAME = 'email');
SET @sql := IF(@exist = 0, 'ALTER TABLE sys_user ADD COLUMN email VARCHAR(100) DEFAULT NULL COMMENT ''邮箱'' AFTER avatar', 'SELECT ''email column already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'exercise_system' AND TABLE_NAME = 'sys_user' AND COLUMN_NAME = 'phone');
SET @sql := IF(@exist = 0, 'ALTER TABLE sys_user ADD COLUMN phone VARCHAR(20) DEFAULT NULL COMMENT ''手机号'' AFTER email', 'SELECT ''phone column already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加习题册创建者字段
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'exercise_system' AND TABLE_NAME = 'exercise_book' AND COLUMN_NAME = 'creator_id');
SET @sql := IF(@exist = 0, 'ALTER TABLE exercise_book ADD COLUMN creator_id BIGINT DEFAULT NULL COMMENT ''创建者ID'' AFTER status', 'SELECT ''creator_id column already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'exercise_system' AND TABLE_NAME = 'exercise_book' AND COLUMN_NAME = 'is_public');
SET @sql := IF(@exist = 0, 'ALTER TABLE exercise_book ADD COLUMN is_public TINYINT DEFAULT 1 COMMENT ''是否公开：1-公开，0-私有'' AFTER creator_id', 'SELECT ''is_public column already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 更新现有用户角色
UPDATE sys_user SET role = 'admin' WHERE username = 'admin';
UPDATE sys_user SET role = 'user' WHERE username = 'test';

-- 更新现有习题册创建者
UPDATE exercise_book SET creator_id = 1 WHERE id IN (1, 2, 3);

SELECT '=== 数据库更新完成 ===' as info;
