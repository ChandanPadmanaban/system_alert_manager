package com.cybersec.dao;

import com.cybersec.model.FileIntegrityAlert;
import com.cybersec.utility.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FileIntegrityAlertDAO - CRUD operations for file_integrity_alerts table.
 */
public class FileIntegrityAlertDAO {

    // ----------------------------------------------------------------
    // INSERT
    // ----------------------------------------------------------------
    public boolean addAlert(FileIntegrityAlert alert) {
        String sql = "INSERT INTO file_integrity_alerts (alert_type, description) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, alert.getAlertType());
            ps.setString(2, alert.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[FileIntegrityAlertDAO] addAlert error: " + e.getMessage());
            return false;
        } finally {
            close(null, ps, conn);
        }
    }

    // ----------------------------------------------------------------
    // SELECT ALL (sorted by alert_id ASC)
    // ----------------------------------------------------------------
    public List<FileIntegrityAlert> getAllAlerts() {
        return getAlerts("SELECT * FROM file_integrity_alerts ORDER BY alert_id ASC", null);
    }

    // ----------------------------------------------------------------
    // SELECT MODIFIED ONLY
    // ----------------------------------------------------------------
    public List<FileIntegrityAlert> getModifiedAlerts() {
        return getAlerts(
            "SELECT * FROM file_integrity_alerts WHERE alert_type = ? ORDER BY alert_id ASC",
            "MODIFIED"
        );
    }

    // ----------------------------------------------------------------
    // DELETE BY ID
    // ----------------------------------------------------------------
    public boolean deleteAlert(int alertId) {
        String sql = "DELETE FROM file_integrity_alerts WHERE alert_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, alertId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[FileIntegrityAlertDAO] deleteAlert error: " + e.getMessage());
            return false;
        } finally {
            close(null, ps, conn);
        }
    }

    // ----------------------------------------------------------------
    // COUNT ALL / MODIFIED
    // ----------------------------------------------------------------
    public int countAll() {
        return count("SELECT COUNT(*) FROM file_integrity_alerts");
    }

    public int countModified() {
        return count("SELECT COUNT(*) FROM file_integrity_alerts WHERE alert_type = 'MODIFIED'");
    }

    // ----------------------------------------------------------------
    // Private helpers
    // ----------------------------------------------------------------
    private List<FileIntegrityAlert> getAlerts(String sql, String typeFilter) {
        List<FileIntegrityAlert> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            if (typeFilter != null) ps.setString(1, typeFilter);
            rs   = ps.executeQuery();
            while (rs.next()) {
                FileIntegrityAlert alert = new FileIntegrityAlert(
                    rs.getInt("alert_id"),
                    rs.getString("alert_type"),
                    rs.getString("description")
                );
                list.add(alert);
            }
        } catch (SQLException e) {
            System.err.println("[FileIntegrityAlertDAO] getAlerts error: " + e.getMessage());
        } finally {
            close(rs, ps, conn);
        }
        return list;
    }

    private int count(String sql) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            rs   = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[FileIntegrityAlertDAO] count error: " + e.getMessage());
        } finally {
            close(rs, ps, conn);
        }
        return 0;
    }

    private void close(ResultSet rs, PreparedStatement ps, Connection conn) {
        try { if (rs != null) rs.close();   } catch (SQLException ignored) {}
        try { if (ps != null) ps.close();   } catch (SQLException ignored) {}
        DBConnection.closeConnection(conn);
    }
}
