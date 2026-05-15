USE cyber_monitoring_system; 
SELECT * FROM file_integrity_alerts ORDER BY alert_id DESC LIMIT 10; 
SELECT * FROM system_update_alerts ORDER BY update_id DESC LIMIT 10; 
SELECT * FROM data_access_logs ORDER BY access_id DESC LIMIT 10; 
