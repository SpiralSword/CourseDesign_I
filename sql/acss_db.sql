CREATE DATABASE IF NOT EXISTS acss_db CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    nickname VARCHAR(64) NOT NULL,
    email VARCHAR(128),
    avatar VARCHAR(255),
    role VARCHAR(8) NOT NULL DEFAULT '0',
    points INT NOT NULL DEFAULT 100,
    status INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS resource (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(128) NOT NULL,
    course_name VARCHAR(64) NOT NULL,
    category VARCHAR(64) NOT NULL,
    description TEXT,
    file_path VARCHAR(255) NOT NULL,
    file_size VARCHAR(32),
    points INT NOT NULL DEFAULT 0,
    uploader_id INT NOT NULL,
    download_count INT NOT NULL DEFAULT 0,
    likes INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS comment (
    id INT PRIMARY KEY AUTO_INCREMENT,
    resource_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ai_chat_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    question TEXT NOT NULL,
    content TEXT NOT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS post (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(128) NOT NULL,
    course_name VARCHAR(64) NOT NULL,
    content TEXT NOT NULL,
    user_id INT NOT NULL,
    like_count INT NOT NULL DEFAULT 0,
    reply_count INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS post_reply (
    id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS post_like (
    id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_post_like (post_id, user_id)
);

CREATE TABLE IF NOT EXISTS check_in_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    UNIQUE KEY uk_user_date (user_id, check_in_date)
);

INSERT INTO `user` (`username`, `password`, `nickname`, `role`, `points`, `status`)
VALUES ('admin', MD5('123456'), '管理员', '1', 100, 0);