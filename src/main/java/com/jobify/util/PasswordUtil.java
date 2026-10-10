package com.jobify.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for hashing and verifying passwords using BCrypt.
 * Ensures passwords are never stored in plaintext.
 */
public final class PasswordUtil {

    private static final int BCRYPT_WORK_FACTOR = 12;

    private PasswordUtil() {
        // Utility class - prevent instantiation
    }

    /**
     * Hashes a plaintext password using BCrypt with salt.
     *
     * @param plainPassword Plaintext password to hash
     * @return BCrypt hashed password string
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty.");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_WORK_FACTOR));
    }

    /**
     * Verifies a plaintext password against a stored BCrypt hash.
     *
     * @param plainPassword  Plaintext password entered by user
     * @param hashedPassword Stored BCrypt hashed password
     * @return true if password matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Malformed hash
            return false;
        }
    }

    /**
     * CLI utility to generate a BCrypt hash for initial setups (e.g. creating admin accounts).
     */
    public static void main(String[] args) {
        String pwd = (args != null && args.length > 0) ? args[0] : "Admin@123";
        System.out.println("Plaintext: " + pwd);
        System.out.println("BCrypt Hash: " + hashPassword(pwd));
    }
}
