package com.jobify.dao;

import com.jobify.config.DBConnection;
import com.jobify.model.EmployerProfile;
import com.jobify.model.JobSeekerProfile;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Job Seeker and Employer profiles.
 */
public class ProfileDAO {

    private static final Logger LOGGER = Logger.getLogger(ProfileDAO.class.getName());

    // --------------------------------------------------------------------
    // Job Seeker Profile Operations
    // --------------------------------------------------------------------

    public JobSeekerProfile getSeekerProfile(int userId) {
        String sql = "SELECT sp.*, u.email " +
                "FROM seeker_profiles sp " +
                "JOIN users u ON sp.user_id = u.id " +
                "WHERE sp.user_id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapSeekerProfile(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching seeker profile for user ID: " + userId, e);
        }
        return null;
    }

    public boolean saveOrUpdateSeekerProfile(JobSeekerProfile p) {
        String checkSql = "SELECT id FROM seeker_profiles WHERE user_id = ? LIMIT 1";
        String insertSql = "INSERT INTO seeker_profiles " +
                "(user_id, full_name, phone, headline, location, bio, skills, education, experience, resume_url, resume_summary) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String updateSql = "UPDATE seeker_profiles SET " +
                "full_name = ?, phone = ?, headline = ?, location = ?, bio = ?, skills = ?, " +
                "education = ?, experience = ?, resume_url = ?, resume_summary = ? " +
                "WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            boolean exists = false;
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, p.getUserId());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    exists = rs.next();
                }
            }

            if (exists) {
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setString(1, p.getFullName());
                    updateStmt.setString(2, p.getPhone());
                    updateStmt.setString(3, p.getHeadline());
                    updateStmt.setString(4, p.getLocation());
                    updateStmt.setString(5, p.getBio());
                    updateStmt.setString(6, p.getSkills());
                    updateStmt.setString(7, p.getEducation());
                    updateStmt.setString(8, p.getExperience());
                    updateStmt.setString(9, p.getResumeUrl());
                    updateStmt.setString(10, p.getResumeSummary());
                    updateStmt.setInt(11, p.getUserId());
                    return updateStmt.executeUpdate() > 0;
                }
            } else {
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    insertStmt.setInt(1, p.getUserId());
                    insertStmt.setString(2, p.getFullName());
                    insertStmt.setString(3, p.getPhone());
                    insertStmt.setString(4, p.getHeadline());
                    insertStmt.setString(5, p.getLocation());
                    insertStmt.setString(6, p.getBio());
                    insertStmt.setString(7, p.getSkills());
                    insertStmt.setString(8, p.getEducation());
                    insertStmt.setString(9, p.getExperience());
                    insertStmt.setString(10, p.getResumeUrl());
                    insertStmt.setString(11, p.getResumeSummary());
                    return insertStmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving seeker profile for user ID: " + p.getUserId(), e);
        }
        return false;
    }

    // --------------------------------------------------------------------
    // Employer Profile Operations
    // --------------------------------------------------------------------

    public EmployerProfile getEmployerProfile(int userId) {
        String sql = "SELECT ep.*, u.email, " +
                "(SELECT COUNT(*) FROM jobs j WHERE j.employer_id = ep.user_id AND j.status = 'ACTIVE' AND j.approval_status = 'APPROVED') AS active_jobs " +
                "FROM employer_profiles ep " +
                "JOIN users u ON ep.user_id = u.id " +
                "WHERE ep.user_id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapEmployerProfile(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching employer profile for user ID: " + userId, e);
        }
        return null;
    }

    public boolean saveOrUpdateEmployerProfile(EmployerProfile p) {
        String checkSql = "SELECT id FROM employer_profiles WHERE user_id = ? LIMIT 1";
        String insertSql = "INSERT INTO employer_profiles " +
                "(user_id, company_name, contact_person, phone, website, location, industry, company_size, description, logo_url) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String updateSql = "UPDATE employer_profiles SET " +
                "company_name = ?, contact_person = ?, phone = ?, website = ?, location = ?, " +
                "industry = ?, company_size = ?, description = ?, logo_url = ? " +
                "WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            boolean exists = false;
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, p.getUserId());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    exists = rs.next();
                }
            }

            if (exists) {
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setString(1, p.getCompanyName());
                    updateStmt.setString(2, p.getContactPerson());
                    updateStmt.setString(3, p.getPhone());
                    updateStmt.setString(4, p.getWebsite());
                    updateStmt.setString(5, p.getLocation());
                    updateStmt.setString(6, p.getIndustry());
                    updateStmt.setString(7, p.getCompanySize());
                    updateStmt.setString(8, p.getDescription());
                    updateStmt.setString(9, p.getLogoUrl());
                    updateStmt.setInt(10, p.getUserId());
                    return updateStmt.executeUpdate() > 0;
                }
            } else {
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    insertStmt.setInt(1, p.getUserId());
                    insertStmt.setString(2, p.getCompanyName());
                    insertStmt.setString(3, p.getContactPerson());
                    insertStmt.setString(4, p.getPhone());
                    insertStmt.setString(5, p.getWebsite());
                    insertStmt.setString(6, p.getLocation());
                    insertStmt.setString(7, p.getIndustry());
                    insertStmt.setString(8, p.getCompanySize());
                    insertStmt.setString(9, p.getDescription());
                    insertStmt.setString(10, p.getLogoUrl());
                    return insertStmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving employer profile for user ID: " + p.getUserId(), e);
        }
        return false;
    }

    public List<EmployerProfile> getAllEmployers() {
        List<EmployerProfile> list = new ArrayList<>();
        String sql = "SELECT ep.*, u.email, " +
                "(SELECT COUNT(*) FROM jobs j WHERE j.employer_id = ep.user_id AND j.status = 'ACTIVE' AND j.approval_status = 'APPROVED') AS active_jobs " +
                "FROM employer_profiles ep " +
                "JOIN users u ON ep.user_id = u.id " +
                "WHERE u.is_active = TRUE " +
                "ORDER BY ep.company_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapEmployerProfile(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error listing employers", e);
        }
        return list;
    }

    private JobSeekerProfile mapSeekerProfile(ResultSet rs) throws SQLException {
        JobSeekerProfile p = new JobSeekerProfile();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getInt("user_id"));
        p.setFullName(rs.getString("full_name"));
        p.setPhone(rs.getString("phone"));
        p.setHeadline(rs.getString("headline"));
        p.setLocation(rs.getString("location"));
        p.setBio(rs.getString("bio"));
        p.setSkills(rs.getString("skills"));
        p.setEducation(rs.getString("education"));
        p.setExperience(rs.getString("experience"));
        p.setResumeUrl(rs.getString("resume_url"));
        p.setResumeSummary(rs.getString("resume_summary"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        p.setEmail(rs.getString("email"));
        return p;
    }

    private EmployerProfile mapEmployerProfile(ResultSet rs) throws SQLException {
        EmployerProfile p = new EmployerProfile();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getInt("user_id"));
        p.setCompanyName(rs.getString("company_name"));
        p.setContactPerson(rs.getString("contact_person"));
        p.setPhone(rs.getString("phone"));
        p.setWebsite(rs.getString("website"));
        p.setLocation(rs.getString("location"));
        p.setIndustry(rs.getString("industry"));
        p.setCompanySize(rs.getString("company_size"));
        p.setDescription(rs.getString("description"));
        p.setLogoUrl(rs.getString("logo_url"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        p.setEmail(rs.getString("email"));
        try {
            p.setActiveJobCount(rs.getInt("active_jobs"));
        } catch (SQLException ignored) {
        }
        return p;
    }
}
