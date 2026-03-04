-- 为考试题目表添加AI评分字段
ALTER TABLE exam_question ADD COLUMN ai_score INT DEFAULT NULL COMMENT 'AI评分（0-100）';
ALTER TABLE exam_question ADD COLUMN ai_comment TEXT DEFAULT NULL COMMENT 'AI评分详情';

-- 创建消息通知表
CREATE TABLE IF NOT EXISTS notification (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    title VARCHAR(100) NOT NULL COMMENT '消息标题',
    content TEXT COMMENT '消息内容',
    type VARCHAR(20) DEFAULT 'system' COMMENT '消息类型：system-系统消息，exam-考试消息',
    related_id BIGINT DEFAULT NULL COMMENT '关联ID（如考试记录ID）',
    is_read TINYINT DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息通知表';
