package com.cybersec.dao;

import com.cybersec.model.DataAccessLog;
import com.cybersec.utility.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DataAccessLogDAO - CRUD operations for data_access_logs table.
 */
public class DataAccessLogDAO {

    // ----------------------------------------------------------------
    // INSERT
    // ----------------------------------------------------------------
    public boolean addLog(DataAccessLog log) {
        String sql = "INSERT INTO data_access_logs (access_type, message) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, log.getAccessType());
            ps.setString(2, log.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[DataAccessLogDAO] addLog error: " + e.getMessage());
            return false;
        } finally {
            close(null, ps, conn);
        }
    }

    // ----------------------------------------------------------------
    // SELECT ALL (sorted by access_id ASC)
    // ----------------------------------------------------------------
    public List<DataAccessLog> getAllLogs() {
        return getLogs("SELECT * FROM data_access_logs ORDER BY access_id ASC", null);
    }

    // ----------------------------------------------------------------
    // SELECT UNAUTHORIZED ONLY
    // ----------------------------------------------------------------
    public List<DataAccessLog> getUnauthorizedLogs() {
        return getLogs(
            "SELECT * FROM data_access_logs WHERE access_type = ? ORDER BY access_id ASC",
            "UNAUTHORIZED"
        );
    }

    // ----------------------------------------------------------------
    // DELETE BY ID
    // ----------------------------------------------------------------
    public boolean deleteLog(int accessId) {
        String sql = "DELETE FROM data_access_logs WHERE access_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setInt(1, accessId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[DataAccessLogDAO] deleteLog error: " + e.getMessage());
            return false;
        } finally {
            close(null, ps, conn);
        }
    }

    // ----------------------------------------------------------------
    // COUNT ALL / UNAUTHORIZED
    // ----------------------------------------------------------------
    public int countAll() {
        return count("SELECT COUNT(*) FROM data_access_logs");
    }

    public int countUnauthorized() {
        return count("SELECT COUNT(*) FROM data_access_logs WHERE access_type = 'UNAUTHORIZED'");
    }

    // ----------------------------------------------------------------
    // Private helpers
    // ----------------------------------------------------------------
    private List<DataAccessLog> getLogs(String sql, String typeFilter) {
        List<DataAccessLog> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            if (typeFilter != null) ps.setString(1, typeFilter);
            rs   = ps.executeQuery();
            while (rs.next()) {
                DataAccessLog log = new DataAccessLog(
                    rs.getInt("access_id"),
                    rs.getString("access_type"),
                    rs.getString("message")
                );
                list.add(log);
            }
        } catch (SQLException e) {
            System.err.println("[DataAccessLogDAO] getLogs error: " + e.getMessage());
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
            System.err.println("[DataAccessLogDAO] count error: " + e.getMessage());
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
