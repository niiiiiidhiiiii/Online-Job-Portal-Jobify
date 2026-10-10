package com.jobify.model;

/**
 * Enumeration of user roles within Jobify.
 */
public enum Role {
    JOB_SEEKER("Job Seeker"),
    EMPLOYER("Employer"),
    ADMIN("Administrator");

    private final String displayName;

    Role(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public static Role fromString(String roleStr) {
        if (roleStr == null) return null;
        try {
            return Role.valueOf(roleStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
