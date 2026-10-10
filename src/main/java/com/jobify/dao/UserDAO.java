package com.jobify.dao;

import com.jobify.config.DBConnection;
import com.jobify.model.Role;
import com.jobify.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for User management and authentication.
 */
public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    /**
     * Registers a new user.
     *
     * @param user User object containing email, passwordHash, and role
     * @return Generated user ID if successful, or -1 on failure
     */
    public int register(User user) {
        String sql = "INSERT INTO users (email, password_hash, role, is_active) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, user.getEmail().trim().toLowerCase());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getRole().name());
            stmt.setBoolean(4, user.isActive());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        user.setId(id);
                        return id;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error registering user: " + user.getEmail(), e);
        }
        return -1;
    }

    /**
     * Finds a user by email address.
     *
     * @param email User email
     * @return User object or null if not found
     */
    public User findByEmail(String email) {
        if (email == null) return null;
        String sql = "SELECT u.id, u.email, u.password_hash, u.role, u.is_active, u.created_at, u.updated_at, " +
                "COALESCE(sp.full_name, ep.company_name, u.email) AS display_name " +
                "FROM users u " +
                "LEFT JOIN seeker_profiles sp ON u.id = sp.user_id " +
                "LEFT JOIN employer_profiles ep ON u.id = ep.user_id " +
                "WHERE LOWER(u.email) = LOWER(?) LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by email: " + email, e);
        }
        return null;
    }

    /**
     * Finds a user by primary key ID.
     */
    public User findById(int id) {
        String sql = "SELECT u.id, u.email, u.password_hash, u.role, u.is_active, u.created_at, u.updated_at, " +
                "COALESCE(sp.full_name, ep.company_name, u.email) AS display_name " +
                "FROM users u " +
                "LEFT JOIN seeker_profiles sp ON u.id = sp.user_id " +
                "LEFT JOIN employer_profiles ep ON u.id = ep.user_id " +
                "WHERE u.id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user by ID: " + id, e);
        }
        return null;
    }

    /**
     * Checks if an email is already registered, optionally excluding a user ID (for profile edits).
     */
    public boolean isEmailTaken(String email, int excludeUserId) {
        String sql = "SELECT id FROM users WHERE LOWER(email) = LOWER(?) AND id != ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email.trim().toLowerCase());
            stmt.setInt(2, excludeUserId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking email uniqueness: " + email, e);
        }
        return false;
    }

    /**
     * Lists users for Admin with optional role filter and search term.
     */
    public List<User> findAll(String roleFilter, String search) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT u.id, u.email, u.password_hash, u.role, u.is_active, u.created_at, u.updated_at, " +
                        "COALESCE(sp.full_name, ep.company_name, u.email) AS display_name " +
                        "FROM users u " +
                        "LEFT JOIN seeker_profiles sp ON u.id = sp.user_id " +
                        "LEFT JOIN employer_profiles ep ON u.id = ep.user_id " +
                        "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (roleFilter != null && !roleFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleFilter)) {
            sql.append("AND u.role = ? ");
            params.add(roleFilter.trim().toUpperCase());
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(u.email) LIKE ? OR LOWER(sp.full_name) LIKE ? OR LOWER(ep.company_name) LIKE ?) ");
            String pattern = "%" + search.trim().toLowerCase() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }

        sql.append("ORDER BY u.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUser(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error listing users", e);
        }
        return list;
    }

    /**
     * Updates user active status (for Admin toggle).
     */
    public boolean updateStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, isActive);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating status for user ID: " + userId, e);
        }
        return false;
    }

    /**
     * Deletes a user account.
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting user ID: " + userId, e);
        }
        return false;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(Role.fromString(rs.getString("role")));
        u.setActive(rs.getBoolean("is_active"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        u.setDisplayName(rs.getString("display_name"));
        return u;
    }
}
