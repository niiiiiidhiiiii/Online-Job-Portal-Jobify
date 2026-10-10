package com.jobify.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC Connection Manager for Jobify.
 * Provides thread-safe connections to MySQL/MariaDB database.
 */
public final class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    static {
        try {
            Class.forName(DBConfig.getDriver());
            LOGGER.info("JDBC Driver successfully registered: " + DBConfig.getDriver());
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Failed to load JDBC driver: " + DBConfig.getDriver(), e);
            throw new RuntimeException("JDBC Driver not found: " + DBConfig.getDriver(), e);
        }
    }

    private DBConnection() {
        // Prevent instantiation
    }

    /**
     * Obtains a new JDBC Connection to the configured database.
     *
     * @return active java.sql.Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(
                    DBConfig.getUrl(),
                    DBConfig.getUsername(),
                    DBConfig.getPassword()
            );
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to establish JDBC Connection to database: " + e.getMessage(), e);
            throw e;
        }
    }

    /**
     * Checks if the database is reachable.
     *
     * @return true if connection succeeds, false otherwise
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            LOGGER.warning("Database connectivity test failed: " + e.getMessage());
            return false;
        }
    }

    /**
     * Safely rolls back a transaction.
     *
     * @param conn Connection to rollback
     */
    public static void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error during transaction rollback: " + e.getMessage(), e);
            }
        }
    }
}
