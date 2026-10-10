package com.jobify.controller;

import com.jobify.dao.ApplicationDAO;
import com.jobify.dao.JobDAO;
import com.jobify.dao.StatsDAO;
import com.jobify.dao.UserDAO;
import com.jobify.model.ActivityLog;
import com.jobify.model.Application;
import com.jobify.model.DashboardStats;
import com.jobify.model.Job;
import com.jobify.model.User;
import com.jobify.service.SecurityService;
import com.jobify.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Administrator operations: Platform Monitoring, User Management,
 * Job Approval, and System Audit Logs.
 */
@WebServlet(name = "AdminServlet", urlPatterns = {
        "/admin/dashboard",
        "/admin/users",
        "/admin/users/status",
        "/admin/users/delete",
        "/admin/jobs",
        "/admin/jobs/approve",
        "/admin/applications"
})
public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final JobDAO jobDAO = new JobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final StatsDAO statsDAO = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/admin/dashboard":
                showDashboard(request, response);
                break;
            case "/admin/users":
                showUsers(request, response);
                break;
            case "/admin/jobs":
                showJobs(request, response);
                break;
            case "/admin/applications":
                showApplications(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        User adminUser = SecurityService.getCurrentUser(request);

        switch (path) {
            case "/admin/users/status":
                handleUserStatus(request, response, adminUser);
                break;
            case "/admin/users/delete":
                handleUserDelete(request, response, adminUser);
                break;
            case "/admin/jobs/approve":
                handleJobApprove(request, response, adminUser);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DashboardStats stats = statsDAO.getAdminStats();
        List<ActivityLog> recentActivities = statsDAO.getRecentActivities(10);
        List<Job> pendingJobs = jobDAO.getAllJobsForAdmin(null, "PENDING");

        request.setAttribute("stats", stats);
        request.setAttribute("recentActivities", recentActivities);
        request.setAttribute("pendingJobs", pendingJobs);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String search = request.getParameter("search");

        List<User> users = userDAO.findAll(role, search);
        DashboardStats stats = statsDAO.getAdminStats();

        request.setAttribute("users", users);
        request.setAttribute("stats", stats);
        request.setAttribute("selectedRole", role);
        request.setAttribute("search", search);

        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void handleUserStatus(HttpServletRequest request, HttpServletResponse response, User adminUser)
            throws IOException {

        int userId = ValidationUtil.parseInt(request.getParameter("userId"), 0);
        boolean active = Boolean.parseBoolean(request.getParameter("active"));

        if (userId == adminUser.getId()) {
            SecurityService.setErrorMessage(request, "You cannot deactivate your own administrator account.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        boolean updated = userDAO.updateStatus(userId, active);
        if (updated) {
            statsDAO.logActivity(adminUser.getId(), "ADMIN_USER_STATUS",
                    "Admin toggled active status to " + active + " for user ID #" + userId);
            SecurityService.setSuccessMessage(request, "User status updated successfully.");
        } else {
            SecurityService.setErrorMessage(request, "Failed to update user status.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleUserDelete(HttpServletRequest request, HttpServletResponse response, User adminUser)
            throws IOException {

        int userId = ValidationUtil.parseInt(request.getParameter("userId"), 0);

        if (userId == adminUser.getId()) {
            SecurityService.setErrorMessage(request, "You cannot delete your own administrator account.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        boolean deleted = userDAO.deleteUser(userId);
        if (deleted) {
            statsDAO.logActivity(adminUser.getId(), "ADMIN_USER_DELETED",
                    "Admin deleted user account ID #" + userId);
            SecurityService.setSuccessMessage(request, "User account deleted successfully.");
        } else {
            SecurityService.setErrorMessage(request, "Failed to delete user account.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void showJobs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String approval = request.getParameter("approval");

        List<Job> jobs = jobDAO.getAllJobsForAdmin(status, approval);
        DashboardStats stats = statsDAO.getAdminStats();

        request.setAttribute("jobs", jobs);
        request.setAttribute("stats", stats);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedApproval", approval);

        request.getRequestDispatcher("/WEB-INF/views/admin/jobs.jsp").forward(request, response);
    }

    private void handleJobApprove(HttpServletRequest request, HttpServletResponse response, User adminUser)
            throws IOException {

        int jobId = ValidationUtil.parseInt(request.getParameter("jobId"), 0);
        String approvalStatus = request.getParameter("approvalStatus");

        if (jobId > 0 && ValidationUtil.isNotEmpty(approvalStatus)) {
            boolean updated = jobDAO.updateApprovalStatus(jobId, approvalStatus);
            if (updated) {
                statsDAO.logActivity(adminUser.getId(), "ADMIN_JOB_APPROVAL",
                        "Admin set job #" + jobId + " approval status to " + approvalStatus);
                SecurityService.setSuccessMessage(request, "Job approval status updated to " + approvalStatus + ".");
            } else {
                SecurityService.setErrorMessage(request, "Could not update job approval status.");
            }
        }

        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/admin/")) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/jobs");
        }
    }

    private void showApplications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Application> applications = applicationDAO.getAllForAdmin();
        DashboardStats stats = statsDAO.getAdminStats();

        request.setAttribute("applications", applications);
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/WEB-INF/views/admin/applications.jsp").forward(request, response);
    }
}
