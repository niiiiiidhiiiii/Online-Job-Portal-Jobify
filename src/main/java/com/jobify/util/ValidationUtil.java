package com.jobify.util;

import java.math.BigDecimal;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.regex.Pattern;

/**
 * Validation and sanitization utility for form inputs and request parameters.
 */
public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,63}$"
    );

    private ValidationUtil() {
        // Prevent instantiation
    }

    /**
     * Validates whether an email format is valid.
     */
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Validates password strength (minimum 6 characters).
     */
    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        return password.trim().length() >= 6;
    }

    /**
     * Checks if a string is non-null and not empty.
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    /**
     * Sanitizes input to prevent HTML/XSS injection.
     */
    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim()
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }

    /**
     * Safely parses a BigDecimal or returns defaultValue.
     */
    public static BigDecimal parseBigDecimal(String val, BigDecimal defaultVal) {
        if (val == null || val.trim().isEmpty()) {
            return defaultVal;
        }
        try {
            return new BigDecimal(val.trim().replaceAll("[,\\$]", ""));
        } catch (Exception e) {
            return defaultVal;
        }
    }

    /**
     * Safely parses an integer or returns defaultValue.
     */
    public static int parseInt(String val, int defaultVal) {
        if (val == null || val.trim().isEmpty()) {
            return defaultVal;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return defaultVal;
        }
    }

    /**
     * Safely parses SQL Date (yyyy-MM-dd) or returns null.
     */
    public static Date parseDate(String val) {
        if (val == null || val.trim().isEmpty()) {
            return null;
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            java.util.Date parsed = sdf.parse(val.trim());
            return new Date(parsed.getTime());
        } catch (Exception e) {
            return null;
        }
    }
}
