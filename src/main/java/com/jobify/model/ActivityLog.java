package com.jobify.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Activity log entry for admin monitoring and auditing.
 */
public class ActivityLog implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Integer userId;
    private String userEmail;
    private String action;
    private String details;
    private Timestamp createdAt;

    public ActivityLog() {
    }

    public ActivityLog(Integer userId, String action, String details) {
        this.userId = userId;
        this.action = action;
        this.details = details;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
