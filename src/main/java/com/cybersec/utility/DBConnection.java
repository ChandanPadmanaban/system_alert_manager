package com.cybersec.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection - JDBC utility class for MySQL connection management.
 * Uses the Singleton pattern for the connection factory.
 */
public class DBConnection {

    private static final String DRIVER   = "org.h2.Driver";
    private static final String URL      = "jdbc:h2:mem:cyber_monitoring_system;MODE=MySQL;DB_CLOSE_DELAY=-1;INIT=RUNSCRIPT FROM 'cyber_monitoring_system.sql'";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "";

    // Private constructor to prevent instantiation
    private DBConnection() {}

    /**
     * Returns a new JDBC Connection to the cyber_monitoring_system database.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("H2 JDBC Driver not found. Add h2-*.jar to WEB-INF/lib.", e);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /**
     * Safely closes a connection (null-safe).
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Error closing connection: " + e.getMessage());
            }
        }
    }
}
