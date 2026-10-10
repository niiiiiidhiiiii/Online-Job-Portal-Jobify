package com.jobify.dao;

import com.jobify.config.DBConnection;
import com.jobify.model.Application;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for job applications.
 */
public class ApplicationDAO {

    private static final Logger LOGGER = Logger.getLogger(ApplicationDAO.class.getName());

    /**
     * Submits a new job application.
     * Prevents duplicate applications via UNIQUE constraint and pre-check.
     *
     * @return generated application ID if successful, -1 if duplicate or failed
     */
    public int apply(Application app) {
        if (hasApplied(app.getJobId(), app.getSeekerId())) {
            LOGGER.warning("Duplicate application blocked: seeker " + app.getSeekerId() + " for job " + app.getJobId());
            return -1;
        }

        String sql = "INSERT INTO applications (job_id, seeker_id, cover_letter, resume_summary, status, employer_notes) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, app.getJobId());
            stmt.setInt(2, app.getSeekerId());
            stmt.setString(3, app.getCoverLetter());
            stmt.setString(4, app.getResumeSummary());
            stmt.setString(5, app.getStatus() != null ? app.getStatus() : "PENDING");
            stmt.setString(6, app.getEmployerNotes());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        app.setId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating job application", e);
        }
        return -1;
    }

    /**
     * Checks if a seeker has already applied for a specific job.
     */
    public boolean hasApplied(int jobId, int seekerId) {
        String sql = "SELECT id FROM applications WHERE job_id = ? AND seeker_id = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, jobId);
            stmt.setInt(2, seekerId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking existing application", e);
        }
        return false;
    }

    /**
     * Retrieves all applications submitted by a specific job seeker.
     */
    public List<Application> getBySeekerId(int seekerId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, j.title AS job_title, j.category AS job_category, j.job_type, " +
                "j.location AS job_location, ep.company_name " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "LEFT JOIN employer_profiles ep ON j.employer_id = ep.user_id " +
                "WHERE a.seeker_id = ? " +
                "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, seekerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Application app = mapApplication(rs);
                    app.setJobTitle(rs.getString("job_title"));
                    app.setJobCategory(rs.getString("job_category"));
                    app.setJobType(rs.getString("job_type"));
                    app.setJobLocation(rs.getString("job_location"));
                    app.setCompanyName(rs.getString("company_name"));
                    list.add(app);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching seeker applications for seeker ID: " + seekerId, e);
        }
        return list;
    }

    /**
     * Retrieves applications for jobs owned by a specific employer.
     * Optionally filtered by a specific job ID.
     */
    public List<Application> getByEmployerId(int employerId, Integer jobIdFilter) {
        List<Application> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT a.*, j.title AS job_title, j.category AS job_category, j.job_type, " +
                        "j.location AS job_location, ep.company_name, " +
                        "u.email AS seeker_email, sp.full_name AS seeker_name, sp.phone AS seeker_phone, " +
                        "sp.headline AS seeker_headline, sp.location AS seeker_location, " +
                        "sp.skills AS seeker_skills, sp.education AS seeker_education, " +
                        "sp.experience AS seeker_experience, sp.resume_url AS seeker_resume_url " +
                        "FROM applications a " +
                        "JOIN jobs j ON a.job_id = j.id " +
                        "LEFT JOIN employer_profiles ep ON j.employer_id = ep.user_id " +
                        "JOIN users u ON a.seeker_id = u.id " +
                        "LEFT JOIN seeker_profiles sp ON a.seeker_id = sp.user_id " +
                        "WHERE j.employer_id = ? "
        );

        if (jobIdFilter != null && jobIdFilter > 0) {
            sql.append("AND a.job_id = ? ");
        }

        sql.append("ORDER BY a.applied_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setInt(1, employerId);
            if (jobIdFilter != null && jobIdFilter > 0) {
                stmt.setInt(2, jobIdFilter);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Application app = mapApplication(rs);
                    app.setJobTitle(rs.getString("job_title"));
                    app.setJobCategory(rs.getString("job_category"));
                    app.setJobType(rs.getString("job_type"));
                    app.setJobLocation(rs.getString("job_location"));
                    app.setCompanyName(rs.getString("company_name"));

                    app.setSeekerEmail(rs.getString("seeker_email"));
                    app.setSeekerName(rs.getString("seeker_name"));
                    app.setSeekerPhone(rs.getString("seeker_phone"));
                    app.setSeekerHeadline(rs.getString("seeker_headline"));
                    app.setSeekerLocation(rs.getString("seeker_location"));
                    app.setSeekerSkills(rs.getString("seeker_skills"));
                    app.setSeekerEducation(rs.getString("seeker_education"));
                    app.setSeekerExperience(rs.getString("seeker_experience"));
                    app.setSeekerResumeUrl(rs.getString("seeker_resume_url"));

                    list.add(app);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching employer applications for employer ID: " + employerId, e);
        }
        return list;
    }

    /**
     * Updates an application status (Pending, Shortlisted, Rejected, Accepted).
     * Validates that the job belongs to the current employer.
     */
    public boolean updateStatus(int applicationId, int employerId, String newStatus, String notes) {
        String sql = "UPDATE applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "SET a.status = ?, a.employer_notes = COALESCE(?, a.employer_notes) " +
                "WHERE a.id = ? AND j.employer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus.toUpperCase());
            stmt.setString(2, notes);
            stmt.setInt(3, applicationId);
            stmt.setInt(4, employerId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating status for application ID: " + applicationId, e);
        }
        return false;
    }

    /**
     * Admin view: lists all applications across the platform.
     */
    public List<Application> getAllForAdmin() {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, j.title AS job_title, j.category AS job_category, j.job_type, " +
                "j.location AS job_location, ep.company_name, " +
                "u.email AS seeker_email, sp.full_name AS seeker_name, sp.phone AS seeker_phone, " +
                "sp.headline AS seeker_headline, sp.location AS seeker_location, " +
                "sp.skills AS seeker_skills, sp.education AS seeker_education, " +
                "sp.experience AS seeker_experience, sp.resume_url AS seeker_resume_url " +
                "FROM applications a " +
                "JOIN jobs j ON a.job_id = j.id " +
                "LEFT JOIN employer_profiles ep ON j.employer_id = ep.user_id " +
                "JOIN users u ON a.seeker_id = u.id " +
                "LEFT JOIN seeker_profiles sp ON a.seeker_id = sp.user_id " +
                "ORDER BY a.applied_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Application app = mapApplication(rs);
                app.setJobTitle(rs.getString("job_title"));
                app.setJobCategory(rs.getString("job_category"));
                app.setJobType(rs.getString("job_type"));
                app.setJobLocation(rs.getString("job_location"));
                app.setCompanyName(rs.getString("company_name"));

                app.setSeekerEmail(rs.getString("seeker_email"));
                app.setSeekerName(rs.getString("seeker_name"));
                app.setSeekerPhone(rs.getString("seeker_phone"));
                app.setSeekerHeadline(rs.getString("seeker_headline"));
                app.setSeekerLocation(rs.getString("seeker_location"));
                app.setSeekerSkills(rs.getString("seeker_skills"));
                app.setSeekerEducation(rs.getString("seeker_education"));
                app.setSeekerExperience(rs.getString("seeker_experience"));
                app.setSeekerResumeUrl(rs.getString("seeker_resume_url"));

                list.add(app);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error listing all applications for admin", e);
        }
        return list;
    }

    private Application mapApplication(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setId(rs.getInt("id"));
        a.setJobId(rs.getInt("job_id"));
        a.setSeekerId(rs.getInt("seeker_id"));
        a.setCoverLetter(rs.getString("cover_letter"));
        a.setResumeSummary(rs.getString("resume_summary"));
        a.setStatus(rs.getString("status"));
        a.setEmployerNotes(rs.getString("employer_notes"));
        a.setAppliedAt(rs.getTimestamp("applied_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));
        return a;
    }
}
