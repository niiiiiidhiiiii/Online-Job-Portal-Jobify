package com.jobify.dao;

import com.jobify.config.DBConnection;
import com.jobify.model.ActivityLog;
import com.jobify.model.DashboardStats;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for platform metrics, statistics, and audit activity logs.
 */
public class StatsDAO {

    private static final Logger LOGGER = Logger.getLogger(StatsDAO.class.getName());

    /**
     * Gathers platform-wide statistics for the Administrator Dashboard.
     */
    public DashboardStats getAdminStats() {
        DashboardStats stats = new DashboardStats();

        String sqlUsers = "SELECT " +
                "COUNT(*) AS total, " +
                "SUM(CASE WHEN role = 'JOB_SEEKER' THEN 1 ELSE 0 END) AS seekers, " +
                "SUM(CASE WHEN role = 'EMPLOYER' THEN 1 ELSE 0 END) AS employers, " +
                "SUM(CASE WHEN role = 'ADMIN' THEN 1 ELSE 0 END) AS admins " +
                "FROM users";

        String sqlJobs = "SELECT " +
                "COUNT(*) AS total, " +
                "SUM(CASE WHEN status = 'ACTIVE' AND approval_status = 'APPROVED' THEN 1 ELSE 0 END) AS active, " +
                "SUM(CASE WHEN approval_status = 'PENDING' THEN 1 ELSE 0 END) AS pending " +
                "FROM jobs";

        String sqlApps = "SELECT COUNT(*) AS total FROM applications";

        try (Connection conn = DBConnection.getConnection()) {
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sqlUsers)) {
                if (rs.next()) {
                    stats.setTotalUsers(rs.getInt("total"));
                    stats.setTotalJobSeekers(rs.getInt("seekers"));
                    stats.setTotalEmployers(rs.getInt("employers"));
                    stats.setTotalAdmins(rs.getInt("admins"));
                }
            }

            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sqlJobs)) {
                if (rs.next()) {
                    stats.setTotalJobs(rs.getInt("total"));
                    stats.setActiveJobs(rs.getInt("active"));
                    stats.setPendingApprovalJobs(rs.getInt("pending"));
                }
            }

            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sqlApps)) {
                if (rs.next()) {
                    stats.setTotalApplications(rs.getInt("total"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error aggregating admin statistics", e);
        }

        return stats;
    }

    /**
     * Gathers employer-specific statistics.
     */
    public DashboardStats getEmployerStats(int employerId) {
        DashboardStats stats = new DashboardStats();

        String sqlJobs = "SELECT " +
                "COUNT(*) AS total, " +
                "SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) AS active, " +
                "SUM(CASE WHEN status = 'CLOSED' THEN 1 ELSE 0 END) AS closed " +
                "FROM jobs WHERE employer_id = ?";

        String sqlApps = "SELECT " +
                "COUNT(a.id) AS total, " +
                "SUM(CASE WHEN a.status = 'PENDING' THEN 1 ELSE 0 END) AS pending, " +
                "SUM(CASE WHEN a.status = 'SHORTLISTED' THEN 1 ELSE 0 END) AS shortlisted, " +
                "SUM(CASE WHEN a.status = 'ACCEPTED' THEN 1 ELSE 0 END) AS accepted, " +
                "SUM(CASE WHEN a.status = 'REJECTED' THEN 1 ELSE 0 END) AS rejected " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "WHERE j.employer_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(sqlJobs)) {
                stmt.setInt(1, employerId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        stats.setEmployerTotalJobs(rs.getInt("total"));
                        stats.setEmployerActiveJobs(rs.getInt("active"));
                        stats.setEmployerClosedJobs(rs.getInt("closed"));
                    }
                }
            }

            try (PreparedStatement stmt = conn.prepareStatement(sqlApps)) {
                stmt.setInt(1, employerId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        stats.setEmployerTotalApplications(rs.getInt("total"));
                        stats.setEmployerPendingApplications(rs.getInt("pending"));
                        stats.setEmployerShortlistedApplications(rs.getInt("shortlisted"));
                        stats.setEmployerAcceptedApplications(rs.getInt("accepted"));
                        stats.setEmployerRejectedApplications(rs.getInt("rejected"));
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error aggregating employer stats for ID: " + employerId, e);
        }

        return stats;
    }

    /**
     * Gathers seeker-specific application statistics.
     */
    public DashboardStats getSeekerStats(int seekerId) {
        DashboardStats stats = new DashboardStats();

        String sqlApps = "SELECT " +
                "COUNT(*) AS total, " +
                "SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) AS pending, " +
                "SUM(CASE WHEN status = 'SHORTLISTED' THEN 1 ELSE 0 END) AS shortlisted, " +
                "SUM(CASE WHEN status = 'ACCEPTED' THEN 1 ELSE 0 END) AS accepted, " +
                "SUM(CASE WHEN status = 'REJECTED' THEN 1 ELSE 0 END) AS rejected " +
                "FROM applications WHERE seeker_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlApps)) {

            stmt.setInt(1, seekerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.setSeekerTotalApplications(rs.getInt("total"));
                    stats.setSeekerPendingApplications(rs.getInt("pending"));
                    stats.setSeekerShortlistedApplications(rs.getInt("shortlisted"));
                    stats.setSeekerAcceptedApplications(rs.getInt("accepted"));
                    stats.setSeekerRejectedApplications(rs.getInt("rejected"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error aggregating seeker stats for ID: " + seekerId, e);
        }

        return stats;
    }

    /**
     * Logs an activity in the database for admin auditing.
     */
    public void logActivity(Integer userId, String action, String details) {
        String sql = "INSERT INTO activity_logs (user_id, action, details) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (userId != null && userId > 0) {
                stmt.setInt(1, userId);
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            stmt.setString(2, action);
            stmt.setString(3, details);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to log activity: " + action, e);
        }
    }

    /**
     * Retrieves recent platform activities for Admin dashboard.
     */
    public List<ActivityLog> getRecentActivities(int limit) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT al.*, u.email AS user_email " +
                "FROM activity_logs al " +
                "LEFT JOIN users u ON al.user_id = u.id " +
                "ORDER BY al.created_at DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit > 0 ? limit : 10);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ActivityLog log = new ActivityLog();
                    log.setId(rs.getInt("id"));
                    int uid = rs.getInt("user_id");
                    if (!rs.wasNull()) {
                        log.setUserId(uid);
                    }
                    log.setUserEmail(rs.getString("user_email"));
                    log.setAction(rs.getString("action"));
                    log.setDetails(rs.getString("details"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching recent activities", e);
        }
        return list;
    }
}
