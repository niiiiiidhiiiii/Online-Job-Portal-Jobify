package com.jobify.filter;

import com.jobify.model.Role;
import com.jobify.model.User;
import com.jobify.service.SecurityService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Enforces server-side authentication and role-based authorization.
 * Protects /seeker/*, /employer/*, and /admin/* endpoints.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/seeker/*", "/employer/*", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = path.substring(contextPath.length());

        User currentUser = SecurityService.getCurrentUser(httpRequest);

        // 1. Check Authentication
        if (currentUser == null) {
            SecurityService.setErrorMessage(httpRequest, "Please log in to access this page.");
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // 2. Check Active Status
        if (!currentUser.isActive()) {
            SecurityService.logoutUser(httpRequest);
            SecurityService.setErrorMessage(httpRequest, "Your account has been deactivated. Please contact support.");
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // 3. Check Role-based Authorization
        Role role = currentUser.getRole();

        if (relativePath.startsWith("/seeker/")) {
            if (role != Role.JOB_SEEKER) {
                SecurityService.setErrorMessage(httpRequest, "Access denied. Only Job Seekers can access this section.");
                redirectToUserDashboard(httpResponse, contextPath, role);
                return;
            }
        } else if (relativePath.startsWith("/employer/")) {
            if (role != Role.EMPLOYER) {
                SecurityService.setErrorMessage(httpRequest, "Access denied. Only Employers can access this section.");
                redirectToUserDashboard(httpResponse, contextPath, role);
                return;
            }
        } else if (relativePath.startsWith("/admin/")) {
            if (role != Role.ADMIN) {
                SecurityService.setErrorMessage(httpRequest, "Access denied. Administrator privileges required.");
                redirectToUserDashboard(httpResponse, contextPath, role);
                return;
            }
        }

        // Authorization succeeded
        chain.doFilter(request, response);
    }

    private void redirectToUserDashboard(HttpServletResponse response, String contextPath, Role role) throws IOException {
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
