package com.cybersec.dao;

import com.cybersec.model.SystemUpdateAlert;
import com.cybersec.utility.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * SystemUpdateAlertDAO - CRUD operations for system_update_alerts table.
 */
public class SystemUpdateAlertDAO {

    // ----------------------------------------------------------------
    // INSERT
    // ----------------------------------------------------------------
    public boolean addAlert(SystemUpdateAlert alert) {
        String sql = "INSERT INTO system_update_alerts (update_type, message) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, alert.getUpdateType());
            ps.setString(2, alert.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[SystemUpdateAlertDAO] addAlert error: " + e.getMessage());
            return false;
        } finally {
            close(null, ps, conn);
        }
    }

    // ----------------------------------------------------------------
    // SELECT ALL (sorted by update_id ASC)
    // ----------------------------------------------------------------
    public List<SystemUpdateAlert> getAllAlerts() {
        return getAlerts("SELECT * FROM system_update_alerts ORDER BY update_id ASC", null);
    }

    // ----------------------------------------------------------------
    // SELECT FAILED ONLY
    // ----------------------------------------------------------------
    public List<SystemUpdateAlert> getFailedAlerts() {
        return getAlerts(
            "SELECT * FROM system_update_alerts WHERE update_type = ? ORDER BY update_id ASC",
            "FAILED"
        );
    }

    // ----------------------------------------------------------------
    // DELETE BY ID
    // ----------------------------------------------------------------
    public boolean deleteAlert(int updateId) {
        String sql = "DELETE FROM system_update_alerts WHERE update_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, updateId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[SystemUpdateAlertDAO] deleteAlert error: " + e.getMessage());
            return false;
        } finally {
            close(null, ps, conn);
        }
    }

    // ----------------------------------------------------------------
    // COUNT ALL / FAILED / PENDING
    // ----------------------------------------------------------------
    public int countAll() {
        return count("SELECT COUNT(*) FROM system_update_alerts");
    }

    public int countFailed() {
        return count("SELECT COUNT(*) FROM system_update_alerts WHERE update_type = 'FAILED'");
    }

    public int countPending() {
        return count("SELECT COUNT(*) FROM system_update_alerts WHERE update_type = 'PENDING'");
    }

    // ----------------------------------------------------------------
    // Private helpers
    // ----------------------------------------------------------------
    private List<SystemUpdateAlert> getAlerts(String sql, String typeFilter) {
        List<SystemUpdateAlert> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            if (typeFilter != null) ps.setString(1, typeFilter);
            rs   = ps.executeQuery();
            while (rs.next()) {
                SystemUpdateAlert alert = new SystemUpdateAlert(
                    rs.getInt("update_id"),
                    rs.getString("update_type"),
                    rs.getString("message")
                );
                list.add(alert);
            }
        } catch (SQLException e) {
            System.err.println("[SystemUpdateAlertDAO] getAlerts error: " + e.getMessage());
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
            System.err.println("[SystemUpdateAlertDAO] count error: " + e.getMessage());
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
