package com.jobify.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Loads database configuration from classpath properties file (db.properties)
 * or system environment variables (DB_URL, DB_USERNAME, DB_PASSWORD).
 * Follows the 12-factor configuration pattern.
 */
public final class DBConfig {

    private static final Logger LOGGER = Logger.getLogger(DBConfig.class.getName());
    private static final Properties PROPERTIES = new Properties();

    private static final String DEFAULT_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/jobify_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";

    static {
        loadProperties();
    }

    private DBConfig() {
        // Prevent instantiation
    }

    private static void loadProperties() {
        try (InputStream input = DBConfig.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                PROPERTIES.load(input);
                LOGGER.info("Successfully loaded database configuration from db.properties");
            } else {
                LOGGER.warning("db.properties not found on classpath. Falling back to environment variables or defaults.");
            }
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Error reading db.properties file: " + e.getMessage(), e);
        }
    }

    public static String getDriver() {
        String envDriver = System.getenv("DB_DRIVER");
        if (envDriver != null && !envDriver.trim().isEmpty()) {
            return envDriver.trim();
        }
        return PROPERTIES.getProperty("db.driver", DEFAULT_DRIVER).trim();
    }

    public static String getUrl() {
        String envUrl = System.getenv("DB_URL");
        if (envUrl != null && !envUrl.trim().isEmpty()) {
            return envUrl.trim();
        }
        return PROPERTIES.getProperty("db.url", DEFAULT_URL).trim();
    }

    public static String getUsername() {
        String envUser = System.getenv("DB_USERNAME");
        if (envUser != null && !envUser.trim().isEmpty()) {
            return envUser.trim();
        }
        return PROPERTIES.getProperty("db.username", DEFAULT_USER).trim();
    }

    public static String getPassword() {
        String envPassword = System.getenv("DB_PASSWORD");
        if (envPassword != null) {
            return envPassword.trim();
        }
        return PROPERTIES.getProperty("db.password", DEFAULT_PASSWORD).trim();
    }
}
