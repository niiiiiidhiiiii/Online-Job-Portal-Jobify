package com.jobify.controller;

import com.jobify.dao.ProfileDAO;
import com.jobify.dao.StatsDAO;
import com.jobify.dao.UserDAO;
import com.jobify.model.EmployerProfile;
import com.jobify.model.JobSeekerProfile;
import com.jobify.model.Role;
import com.jobify.model.User;
import com.jobify.service.SecurityService;
import com.jobify.util.PasswordUtil;
import com.jobify.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controller for User Authentication: Login, Registration, and Logout.
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ProfileDAO profileDAO = new ProfileDAO();
    private final StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            handleLogout(request, response);
            return;
        }

        // If user already logged in, redirect to their role dashboard
        User loggedUser = SecurityService.getCurrentUser(request);
        if (loggedUser != null) {
            redirectToDashboard(response, request.getContextPath(), loggedUser.getRole());
            return;
        }

        if ("/login".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        } else if ("/register".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        } else if ("/logout".equals(path)) {
            handleLogout(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (!ValidationUtil.isValidEmail(email) || !ValidationUtil.isNotEmpty(password)) {
            request.setAttribute("error", "Please provide a valid email address and password.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email);

        if (user == null || !PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        if (!user.isActive()) {
            request.setAttribute("error", "Your account has been deactivated. Please contact support.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Set session
        SecurityService.loginUser(request, user);
        statsDAO.logActivity(user.getId(), "USER_LOGIN", "User logged in: " + user.getEmail() + " (" + user.getRole() + ")");

        SecurityService.setSuccessMessage(request, "Welcome back, " + user.getDisplayName() + "!");
        redirectToDashboard(response, request.getContextPath(), user.getRole());
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleStr = request.getParameter("role");
        String name = request.getParameter("name"); // Full name for seeker, or company name for employer

        // Validation
        if (!ValidationUtil.isValidEmail(email)) {
            forwardRegisterError(request, response, "Please provide a valid email address.", email, name, roleStr);
            return;
        }

        if (!ValidationUtil.isValidPassword(password)) {
            forwardRegisterError(request, response, "Password must be at least 6 characters long.", email, name, roleStr);
            return;
        }

        if (confirmPassword == null || !confirmPassword.equals(password)) {
            forwardRegisterError(request, response, "Passwords do not match.", email, name, roleStr);
            return;
        }

        if (!ValidationUtil.isNotEmpty(name)) {
            forwardRegisterError(request, response, "Name/Company Name is required.", email, name, roleStr);
            return;
        }

        Role role = Role.fromString(roleStr);
        if (role == null || role == Role.ADMIN) {
            role = Role.JOB_SEEKER; // Default to Job Seeker for standard public registration
        }

        // Check if email already exists
        if (userDAO.isEmailTaken(email, 0)) {
            forwardRegisterError(request, response, "An account with this email already exists. Please sign in.", email, name, roleStr);
            return;
        }

        // Hash password with BCrypt
        String hash = PasswordUtil.hashPassword(password);

        User newUser = new User();
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPasswordHash(hash);
        newUser.setRole(role);
        newUser.setActive(true);

        int userId = userDAO.register(newUser);
        if (userId <= 0) {
            forwardRegisterError(request, response, "Registration failed due to a server error. Please try again.", email, name, roleStr);
            return;
        }

        // Create initial corresponding profile
        if (role == Role.JOB_SEEKER) {
            JobSeekerProfile sp = new JobSeekerProfile();
            sp.setUserId(userId);
            sp.setFullName(name.trim());
            profileDAO.saveOrUpdateSeekerProfile(sp);
        } else if (role == Role.EMPLOYER) {
            EmployerProfile ep = new EmployerProfile();
            ep.setUserId(userId);
            ep.setCompanyName(name.trim());
            profileDAO.saveOrUpdateEmployerProfile(ep);
        }

        statsDAO.logActivity(userId, "USER_REGISTERED", "New " + role.getDisplayName() + " registered: " + email);

        // Auto-login the newly created user
        User createdUser = userDAO.findById(userId);
        SecurityService.loginUser(request, createdUser != null ? createdUser : newUser);

        SecurityService.setSuccessMessage(request, "Account created successfully! Welcome to Jobify.");
        redirectToDashboard(response, request.getContextPath(), role);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = SecurityService.getCurrentUser(request);
        if (user != null) {
            statsDAO.logActivity(user.getId(), "USER_LOGOUT", "User logged out: " + user.getEmail());
        }
        SecurityService.logoutUser(request);
        SecurityService.setSuccessMessage(request, "You have been logged out successfully.");
        response.sendRedirect(request.getContextPath() + "/login");
    }

    private void forwardRegisterError(HttpServletRequest request, HttpServletResponse response,
                                      String error, String email, String name, String role)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.setAttribute("email", email);
        request.setAttribute("name", name);
        request.setAttribute("role", role);
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    private void redirectToDashboard(HttpServletResponse response, String contextPath, Role role) throws IOException {
        if (role == Role.JOB_SEEKER) {
            response.sendRedirect(contextPath + "/seeker/dashboard");
        } else if (role == Role.EMPLOYER) {
            response.sendRedirect(contextPath + "/employer/dashboard");
        } else if (role == Role.ADMIN) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else {
            response.sendRedirect(contextPath + "/home");
        }
    }
}
