

-- 创建bind库
-- CREATE DATABASE bind DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;


-- 添加bind用户
-- CREATE USER 'bind'@'%' IDENTIFIED BY 'bind';


-- 授权bind用户查询权限
-- GRANT SELECT ON bind.* TO 'bind'@'%';


-- 创建表结构
CREATE TABLE IF NOT EXISTS `records` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `zone` varchar(255) NOT NULL,
    `ttl` int(11) NOT NULL DEFAULT '86400',
    `type` varchar(255) NOT NULL,
    `host` varchar(255) NOT NULL DEFAULT '@',
    `mx_priority` int(11) DEFAULT NULL,
    `data` text,
    `primary_ns` varchar(255) DEFAULT NULL,
    `resp_contact` varchar(255) DEFAULT NULL,
    `serial` bigint(20) DEFAULT NULL,
    `refresh` int(11) DEFAULT NULL,
    `retry` int(11) DEFAULT NULL,
    `expire` int(11) DEFAULT NULL,
    `minimum` int(11) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `type` (`type`),
    KEY `host` (`host`),
    KEY `zone` (`zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 添加Zone和NS
INSERT INTO `records` (`zone`, `ttl`, `type`, `host`, `mx_priority`, `data`, `primary_ns`, `resp_contact`, `serial`, `refresh`, `retry`, `expire`, `minimum`) VALUES
('speech.local', 86400, 'SOA', '@', NULL, NULL, 'ns1.speech.local.', 'speech.local.', 2019072501, 10800, 7200, 604800, 86400),
('speech.local', 86400, 'NS', '@', NULL, 'ns1.speech.local.', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('speech.local', 86400, 'NS', '@', NULL, 'ns2.speech.local.', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


-- 添加A记录
INSERT INTO `records` (`zone`, `ttl`, `type`, `host`, `data`) VALUES
('speech.local', 86400, 'A', 'ns1', '192.168.9.120');


-- 添加CNAME
INSERT INTO `records` (`zone`, `ttl`, `type`, `host`, `data`) VALUES
('speech.local', 86400, 'CNAME', 'ns2', 'ns1.speech.local.');


