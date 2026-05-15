package com.cybersec.dao;

import com.cybersec.model.User;
import com.cybersec.utility.DBConnection;

import java.sql.*;

/**
 * UserDAO - Handles authentication queries.
 */
public class UserDAO {

    /**
     * Validate user credentials from the database.
     * Uses PreparedStatement to prevent SQL injection.
     */
    public User authenticate(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps   = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs   = ps.executeQuery();
            if (rs.next()) {
                user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("full_name"),
                    rs.getString("role")
                );
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] authenticate error: " + e.getMessage());
        } finally {
            close(rs, ps, conn);
        }
        return user;
    }

    private void close(ResultSet rs, PreparedStatement ps, Connection conn) {
        try { if (rs   != null) rs.close();   } catch (SQLException ignored) {}
        try { if (ps   != null) ps.close();   } catch (SQLException ignored) {}
        DBConnection.closeConnection(conn);
    }
}
