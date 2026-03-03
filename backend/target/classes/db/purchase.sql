-- 为习题册表添加价格字段
ALTER TABLE exercise_book ADD COLUMN price DECIMAL(10,2) DEFAULT 0 COMMENT '价格';

-- 为习题册表添加标签字段
ALTER TABLE exercise_book ADD COLUMN tag VARCHAR(50) DEFAULT NULL COMMENT '标签';

-- 为用户表添加余额字段
ALTER TABLE sys_user ADD COLUMN balance DECIMAL(10,2) DEFAULT 0 COMMENT '余额';

-- 创建购买记录表
CREATE TABLE IF NOT EXISTS book_purchase (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    book_id BIGINT NOT NULL COMMENT '习题册ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    price DECIMAL(10,2) NOT NULL COMMENT '购买时的价格',
    purchase_time DATETIME NOT NULL COMMENT '购买时间',
    UNIQUE KEY uk_book_user (book_id, user_id),
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='习题册购买记录';

-- 创建交易记录表
CREATE TABLE IF NOT EXISTS wallet_transaction (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    wallet_id BIGINT NOT NULL COMMENT '用户ID',
    type VARCHAR(20) NOT NULL COMMENT '类型：recharge充值，purchase消费',
    amount DECIMAL(10,2) NOT NULL COMMENT '金额',
    balance_after DECIMAL(10,2) NOT NULL COMMENT '交易后余额',
    description VARCHAR(255) COMMENT '描述',
    related_id BIGINT COMMENT '关联ID（如习题册ID）',
    create_time DATETIME NOT NULL COMMENT '创建时间',
    INDEX idx_wallet_id (wallet_id),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='钱包交易记录';
