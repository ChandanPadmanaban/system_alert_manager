-- ============================================================
-- Cyber Security Monitoring System - Database Script
-- Database: cyber_monitoring_system
-- ============================================================

-- CREATE DATABASE IF NOT EXISTS cyber_monitoring_system
--     CHARACTER SET utf8mb4
--     COLLATE utf8mb4_unicode_ci;

-- USE cyber_monitoring_system;

-- ============================================================
-- Table: users
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    full_name   VARCHAR(100) DEFAULT 'Admin User',
    role        VARCHAR(20)  DEFAULT 'admin',
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

MERGE INTO users (username, password, full_name, role) KEY (username) VALUES ('admin', 'admin123', 'System Administrator', 'admin');

-- ============================================================
-- Table: data_access_logs
-- ============================================================
CREATE TABLE IF NOT EXISTS data_access_logs (
    access_id   INT AUTO_INCREMENT PRIMARY KEY,
    access_type VARCHAR(50)  NOT NULL,
    message     TEXT         NOT NULL,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Only insert seed data if the table is empty
INSERT INTO data_access_logs (access_type, message)
SELECT 'AUTHORIZED', 'User admin accessed /dashboard at 10:00 AM' WHERE NOT EXISTS (SELECT 1 FROM data_access_logs);
INSERT INTO data_access_logs (access_type, message)
SELECT 'UNAUTHORIZED', 'Unknown IP 192.168.1.99 attempted access to /admin panel' WHERE (SELECT COUNT(*) FROM data_access_logs) = 1;
INSERT INTO data_access_logs (access_type, message)
SELECT 'AUTHORIZED',   'User john accessed /reports module' WHERE (SELECT COUNT(*) FROM data_access_logs) = 2;
INSERT INTO data_access_logs (access_type, message)
SELECT 'UNAUTHORIZED', 'Brute-force attempt detected from 203.0.113.5' WHERE (SELECT COUNT(*) FROM data_access_logs) = 3;
INSERT INTO data_access_logs (access_type, message)
SELECT 'AUTHORIZED',   'User alice downloaded audit_report.pdf' WHERE (SELECT COUNT(*) FROM data_access_logs) = 4;
INSERT INTO data_access_logs (access_type, message)
SELECT 'UNAUTHORIZED', 'SQL injection attempt blocked on login endpoint' WHERE (SELECT COUNT(*) FROM data_access_logs) = 5;
INSERT INTO data_access_logs (access_type, message)
SELECT 'AUTHORIZED',   'User bob accessed file_integrity module' WHERE (SELECT COUNT(*) FROM data_access_logs) = 6;
INSERT INTO data_access_logs (access_type, message)
SELECT 'UNAUTHORIZED', 'Port scan detected from external IP 198.51.100.42' WHERE (SELECT COUNT(*) FROM data_access_logs) = 7;

-- ============================================================
-- Table: system_update_alerts
-- ============================================================
CREATE TABLE IF NOT EXISTS system_update_alerts (
    update_id   INT AUTO_INCREMENT PRIMARY KEY,
    update_type VARCHAR(50)  NOT NULL,
    message     TEXT         NOT NULL,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Seed data
INSERT INTO system_update_alerts (update_type, message)
SELECT 'SUCCESS', 'Kernel patch v5.15.0 applied successfully' WHERE NOT EXISTS (SELECT 1 FROM system_update_alerts);
INSERT INTO system_update_alerts (update_type, message)
SELECT 'FAILED',  'Antivirus definitions update failed — network timeout' WHERE (SELECT COUNT(*) FROM system_update_alerts) = 1;
INSERT INTO system_update_alerts (update_type, message)
SELECT 'PENDING', 'Critical security patch CVE-2024-1234 awaiting approval' WHERE (SELECT COUNT(*) FROM system_update_alerts) = 2;
INSERT INTO system_update_alerts (update_type, message)
SELECT 'SUCCESS', 'Firewall rules updated and applied' WHERE (SELECT COUNT(*) FROM system_update_alerts) = 3;
INSERT INTO system_update_alerts (update_type, message)
SELECT 'FAILED',  'SSL certificate renewal failed — expired credentials' WHERE (SELECT COUNT(*) FROM system_update_alerts) = 4;
INSERT INTO system_update_alerts (update_type, message)
SELECT 'SUCCESS', 'OS security baseline applied to all nodes' WHERE (SELECT COUNT(*) FROM system_update_alerts) = 5;
INSERT INTO system_update_alerts (update_type, message)
SELECT 'PENDING', 'Zero-day vulnerability patch pending review' WHERE (SELECT COUNT(*) FROM system_update_alerts) = 6;
INSERT INTO system_update_alerts (update_type, message)
SELECT 'FAILED',  'Backup job failed — insufficient disk space' WHERE (SELECT COUNT(*) FROM system_update_alerts) = 7;

-- ============================================================
-- Table: file_integrity_alerts
-- ============================================================
CREATE TABLE IF NOT EXISTS file_integrity_alerts (
    alert_id    INT AUTO_INCREMENT PRIMARY KEY,
    alert_type  VARCHAR(50)  NOT NULL,
    description TEXT         NOT NULL,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Seed data
INSERT INTO file_integrity_alerts (alert_type, description)
SELECT 'MODIFIED',  '/etc/passwd modified — unexpected hash change detected' WHERE NOT EXISTS (SELECT 1 FROM file_integrity_alerts);
INSERT INTO file_integrity_alerts (alert_type, description)
SELECT 'DELETED',   '/var/log/auth.log deleted — possible log tampering' WHERE (SELECT COUNT(*) FROM file_integrity_alerts) = 1;
INSERT INTO file_integrity_alerts (alert_type, description)
SELECT 'MODIFIED',  '/etc/sudoers file changed without authorized request' WHERE (SELECT COUNT(*) FROM file_integrity_alerts) = 2;
INSERT INTO file_integrity_alerts (alert_type, description)
SELECT 'CREATED',   'Suspicious file /tmp/.hidden_shell created' WHERE (SELECT COUNT(*) FROM file_integrity_alerts) = 3;
INSERT INTO file_integrity_alerts (alert_type, description)
SELECT 'MODIFIED',  'Web root index.php checksum mismatch — possible defacement' WHERE (SELECT COUNT(*) FROM file_integrity_alerts) = 4;
INSERT INTO file_integrity_alerts (alert_type, description)
SELECT 'DELETED',   'Backup file removed from /secure/backups/' WHERE (SELECT COUNT(*) FROM file_integrity_alerts) = 5;
INSERT INTO file_integrity_alerts (alert_type, description)
SELECT 'CREATED',   'Unknown binary dropped in /usr/local/bin/' WHERE (SELECT COUNT(*) FROM file_integrity_alerts) = 6;
INSERT INTO file_integrity_alerts (alert_type, description)
SELECT 'MODIFIED',  'SSH authorized_keys modified on production server' WHERE (SELECT COUNT(*) FROM file_integrity_alerts) = 7;

-- ============================================================
-- END OF SCRIPT
-- ============================================================
