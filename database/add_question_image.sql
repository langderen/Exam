-- 添加题目图片支持
USE exercise_system;

-- 添加题目图片字段
ALTER TABLE question ADD COLUMN IF NOT EXISTS content_image VARCHAR(500) DEFAULT NULL COMMENT '题目图片URL' AFTER content;
ALTER TABLE question ADD COLUMN IF NOT EXISTS options_image VARCHAR(500) DEFAULT NULL COMMENT '选项图片URL' AFTER options;

SELECT '=== 题目图片支持添加完成 ===' as info;
