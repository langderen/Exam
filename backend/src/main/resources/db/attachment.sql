-- 为题目表添加附件字段
ALTER TABLE question ADD COLUMN attachment VARCHAR(500) DEFAULT NULL COMMENT '题目附件URL';
ALTER TABLE question ADD COLUMN attachment_name VARCHAR(255) DEFAULT NULL COMMENT '题目附件名称';

-- 为答题记录表添加答案附件字段
ALTER TABLE question_record ADD COLUMN answer_attachment VARCHAR(500) DEFAULT NULL COMMENT '答案附件URL';
ALTER TABLE question_record ADD COLUMN answer_attachment_name VARCHAR(255) DEFAULT NULL COMMENT '答案附件名称';

-- 为题目表添加AI评分字段
ALTER TABLE question ADD COLUMN ai_scoring TINYINT DEFAULT 0 COMMENT '是否启用AI评分：0-否，1-是';
ALTER TABLE question ADD COLUMN key_points TEXT DEFAULT NULL COMMENT '答题要点（用于AI评分）';
