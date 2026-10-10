package com.jobify.dao;

import com.jobify.config.DBConnection;
import com.jobify.model.Job;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Job Listings.
 */
public class JobDAO {

    private static final Logger LOGGER = Logger.getLogger(JobDAO.class.getName());

    /**
     * Creates a new job posting.
     */
    public int create(Job job) {
        String sql = "INSERT INTO jobs " +
                "(employer_id, title, category, job_type, location, salary_min, salary_max, description, requirements, skills_required, vacancies, deadline, status, approval_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, job.getEmployerId());
            stmt.setString(2, job.getTitle());
            stmt.setString(3, job.getCategory());
            stmt.setString(4, job.getJobType());
            stmt.setString(5, job.getLocation());
            stmt.setBigDecimal(6, job.getSalaryMin());
            stmt.setBigDecimal(7, job.getSalaryMax());
            stmt.setString(8, job.getDescription());
            stmt.setString(9, job.getRequirements());
            stmt.setString(10, job.getSkillsRequired());
            stmt.setInt(11, job.getVacancies());
            stmt.setDate(12, job.getDeadline());
            stmt.setString(13, job.getStatus() != null ? job.getStatus() : "ACTIVE");
            stmt.setString(14, job.getApprovalStatus() != null ? job.getApprovalStatus() : "APPROVED");

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        job.setId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating job listing: " + job.getTitle(), e);
        }
        return -1;
    }

    /**
     * Updates an existing job posting. Strictly enforces employer ownership.
     */
    public boolean update(Job job, int employerId) {
        String sql = "UPDATE jobs SET " +
                "title = ?, category = ?, job_type = ?, location = ?, salary_min = ?, salary_max = ?, " +
                "description = ?, requirements = ?, skills_required = ?, vacancies = ?, deadline = ?, status = ? " +
                "WHERE id = ? AND employer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, job.getTitle());
            stmt.setString(2, job.getCategory());
            stmt.setString(3, job.getJobType());
            stmt.setString(4, job.getLocation());
            stmt.setBigDecimal(5, job.getSalaryMin());
            stmt.setBigDecimal(6, job.getSalaryMax());
            stmt.setString(7, job.getDescription());
            stmt.setString(8, job.getRequirements());
            stmt.setString(9, job.getSkillsRequired());
            stmt.setInt(10, job.getVacancies());
            stmt.setDate(11, job.getDeadline());
            stmt.setString(12, job.getStatus());
            stmt.setInt(13, job.getId());
            stmt.setInt(14, employerId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating job ID: " + job.getId(), e);
        }
        return false;
    }

    /**
     * Toggles job status (ACTIVE / CLOSED). Enforces employer ownership.
     */
    public boolean updateJobStatus(int jobId, int employerId, String status) {
        String sql = "UPDATE jobs SET status = ? WHERE id = ? AND employer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status.toUpperCase());
            stmt.setInt(2, jobId);
            stmt.setInt(3, employerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating status for job ID: " + jobId, e);
        }
        return false;
    }

    /**
     * Deletes a job posting. Enforces employer ownership.
     */
    public boolean delete(int jobId, int employerId) {
        String sql = "DELETE FROM jobs WHERE id = ? AND employer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, jobId);
            stmt.setInt(2, employerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting job ID: " + jobId, e);
        }
        return false;
    }

    /**
     * Retrieves a job by ID along with company details.
     */
    public Job getById(int jobId) {
        String sql = "SELECT j.*, ep.company_name, ep.website AS company_website, " +
                "ep.location AS company_location, ep.logo_url AS company_logo, " +
                "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) AS app_count " +
                "FROM jobs j " +
                "LEFT JOIN employer_profiles ep ON j.employer_id = ep.user_id " +
                "WHERE j.id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, jobId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapJob(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching job ID: " + jobId, e);
        }
        return null;
    }

    /**
     * Searches and filters active, approved jobs.
     */
    public List<Job> getAllActive(String keyword, String location, String category, String jobType, Double minSalary, int offset, int limit) {
        List<Job> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT j.*, ep.company_name, ep.website AS company_website, " +
                        "ep.location AS company_location, ep.logo_url AS company_logo, " +
                        "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) AS app_count " +
                        "FROM jobs j " +
                        "LEFT JOIN employer_profiles ep ON j.employer_id = ep.user_id " +
                        "WHERE j.status = 'ACTIVE' AND j.approval_status = 'APPROVED' "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(j.title) LIKE ? OR LOWER(j.description) LIKE ? OR LOWER(j.skills_required) LIKE ? OR LOWER(ep.company_name) LIKE ?) ");
            String term = "%" + keyword.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND (LOWER(j.location) LIKE ? OR LOWER(ep.location) LIKE ?) ");
            String locTerm = "%" + location.trim().toLowerCase() + "%";
            params.add(locTerm);
            params.add(locTerm);
        }

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append("AND LOWER(j.category) = LOWER(?) ");
            params.add(category.trim());
        }

        if (jobType != null && !jobType.trim().isEmpty() && !"ALL".equalsIgnoreCase(jobType)) {
            sql.append("AND LOWER(j.job_type) = LOWER(?) ");
            params.add(jobType.trim());
        }

        if (minSalary != null && minSalary > 0) {
            sql.append("AND (j.salary_max >= ? OR j.salary_min >= ?) ");
            params.add(minSalary);
            params.add(minSalary);
        }

        sql.append("ORDER BY j.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit > 0 ? limit : 20);
        params.add(Math.max(offset, 0));

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapJob(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching active jobs", e);
        }
        return list;
    }

    /**
     * Counts active, approved jobs matching the filter.
     */
    public int countActive(String keyword, String location, String category, String jobType, Double minSalary) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM jobs j " +
                        "LEFT JOIN employer_profiles ep ON j.employer_id = ep.user_id " +
                        "WHERE j.status = 'ACTIVE' AND j.approval_status = 'APPROVED' "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(j.title) LIKE ? OR LOWER(j.description) LIKE ? OR LOWER(j.skills_required) LIKE ? OR LOWER(ep.company_name) LIKE ?) ");
            String term = "%" + keyword.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND (LOWER(j.location) LIKE ? OR LOWER(ep.location) LIKE ?) ");
            String locTerm = "%" + location.trim().toLowerCase() + "%";
            params.add(locTerm);
            params.add(locTerm);
        }

        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append("AND LOWER(j.category) = LOWER(?) ");
            params.add(category.trim());
        }

        if (jobType != null && !jobType.trim().isEmpty() && !"ALL".equalsIgnoreCase(jobType)) {
            sql.append("AND LOWER(j.job_type) = LOWER(?) ");
            params.add(jobType.trim());
        }

        if (minSalary != null && minSalary > 0) {
            sql.append("AND (j.salary_max >= ? OR j.salary_min >= ?) ");
            params.add(minSalary);
            params.add(minSalary);
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting active jobs", e);
        }
        return 0;
    }

    /**
     * Lists all jobs posted by a specific employer.
     */
    public List<Job> getByEmployerId(int employerId) {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.*, ep.company_name, ep.website AS company_website, " +
                "ep.location AS company_location, ep.logo_url AS company_logo, " +
                "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) AS app_count " +
                "FROM jobs j " +
                "LEFT JOIN employer_profiles ep ON j.employer_id = ep.user_id " +
                "WHERE j.employer_id = ? " +
                "ORDER BY j.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, employerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapJob(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching jobs for employer ID: " + employerId, e);
        }
        return list;
    }

    /**
     * Admin view: lists all jobs across platform with status filters.
     */
    public List<Job> getAllJobsForAdmin(String statusFilter, String approvalFilter) {
        List<Job> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT j.*, ep.company_name, ep.website AS company_website, " +
                        "ep.location AS company_location, ep.logo_url AS company_logo, " +
                        "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) AS app_count " +
                        "FROM jobs j " +
                        "LEFT JOIN employer_profiles ep ON j.employer_id = ep.user_id " +
                        "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND j.status = ? ");
            params.add(statusFilter.trim().toUpperCase());
        }

        if (approvalFilter != null && !approvalFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(approvalFilter)) {
            sql.append("AND j.approval_status = ? ");
            params.add(approvalFilter.trim().toUpperCase());
        }

        sql.append("ORDER BY j.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapJob(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error listing all jobs for admin", e);
        }
        return list;
    }

    /**
     * Admin action: updates approval status (APPROVED or REJECTED).
     */
    public boolean updateApprovalStatus(int jobId, String approvalStatus) {
        String sql = "UPDATE jobs SET approval_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, approvalStatus.toUpperCase());
            stmt.setInt(2, jobId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating approval status for job ID: " + jobId, e);
        }
        return false;
    }

    /**
     * Retrieves top featured active jobs for landing page.
     */
    public List<Job> getFeaturedJobs(int limit) {
        return getAllActive(null, null, null, null, null, 0, limit > 0 ? limit : 6);
    }

    /**
     * Retrieves distinct categories from database.
     */
    public List<String> getAllCategories() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT name FROM categories ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching categories", e);
        }
        return list;
    }

    private Job mapJob(ResultSet rs) throws SQLException {
        Job j = new Job();
        j.setId(rs.getInt("id"));
        j.setEmployerId(rs.getInt("employer_id"));
        j.setTitle(rs.getString("title"));
        j.setCategory(rs.getString("category"));
        j.setJobType(rs.getString("job_type"));
        j.setLocation(rs.getString("location"));
        j.setSalaryMin(rs.getBigDecimal("salary_min"));
        j.setSalaryMax(rs.getBigDecimal("salary_max"));
        j.setDescription(rs.getString("description"));
        j.setRequirements(rs.getString("requirements"));
        j.setSkillsRequired(rs.getString("skills_required"));
        j.setVacancies(rs.getInt("vacancies"));
        j.setDeadline(rs.getDate("deadline"));
        j.setStatus(rs.getString("status"));
        j.setApprovalStatus(rs.getString("approval_status"));
        j.setCreatedAt(rs.getTimestamp("created_at"));
        j.setUpdatedAt(rs.getTimestamp("updated_at"));

        j.setCompanyName(rs.getString("company_name"));
        j.setCompanyWebsite(rs.getString("company_website"));
        j.setCompanyLocation(rs.getString("company_location"));
        j.setCompanyLogo(rs.getString("company_logo"));
        try {
            j.setApplicationCount(rs.getInt("app_count"));
        } catch (SQLException ignored) {
        }
        return j;
    }
}
