package com.jobify.service;

import com.jobify.model.Role;
import com.jobify.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Service for managing user session state, authentication tokens, and flash notifications.
 */
public final class SecurityService {

    public static final String SESSION_USER = "LOGGED_IN_USER";
    public static final String FLASH_TYPE = "FLASH_TYPE";
    public static final String FLASH_MSG = "FLASH_MESSAGE";

    private SecurityService() {
        // Prevent instantiation
    }

    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object u = session.getAttribute(SESSION_USER);
            if (u instanceof User) {
                return (User) u;
            }
        }
        return null;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    public static boolean hasRole(HttpServletRequest request, Role role) {
        User u = getCurrentUser(request);
        return u != null && u.getRole() == role;
    }

    public static void loginUser(HttpServletRequest request, User user) {
        // Invalidate old session to prevent session fixation attacks
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute(SESSION_USER, user);
    }

    public static void logoutUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    public static void setFlashMessage(HttpServletRequest request, String type, String message) {
        HttpSession session = request.getSession(true);
        session.setAttribute(FLASH_TYPE, type);
        session.setAttribute(FLASH_MSG, message);
    }

    public static void setSuccessMessage(HttpServletRequest request, String message) {
        setFlashMessage(request, "success", message);
    }

    public static void setErrorMessage(HttpServletRequest request, String message) {
        setFlashMessage(request, "danger", message);
    }

    public static void setWarningMessage(HttpServletRequest request, String message) {
        setFlashMessage(request, "warning", message);
    }
}
