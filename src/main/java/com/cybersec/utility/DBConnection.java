package com.cybersec.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection - JDBC utility class for MySQL connection management.
 * Uses the Singleton pattern for the connection factory.
 */
public class DBConnection {

    private static final String H2_DRIVER   = "org.h2.Driver";
    private static final String H2_URL      = "jdbc:h2:./cyber_monitoring_system;MODE=MySQL;INIT=RUNSCRIPT FROM 'cyber_monitoring_system.sql'";
    
    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";

    // Private constructor to prevent instantiation
    private DBConnection() {}

    /**
     * Returns a new JDBC Connection to the cyber_monitoring_system database.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        String dbUrl = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        String dbPass = System.getenv("DB_PASS");

        try {
            if (dbUrl != null && !dbUrl.trim().isEmpty()) {
                // Use External MySQL Database
                Class.forName(MYSQL_DRIVER);
                return DriverManager.getConnection(dbUrl, dbUser, dbPass == null ? "" : dbPass);
            } else {
                // Use Local Embedded H2 Database
                Class.forName(H2_DRIVER);
                return DriverManager.getConnection(H2_URL, "sa", "");
            }
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found.", e);
        }
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
