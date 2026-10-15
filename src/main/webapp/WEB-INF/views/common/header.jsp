<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.jobify.service.SecurityService" %>
<%@ page import="com.jobify.model.User" %>
<%
    User currentUser = SecurityService.getCurrentUser(request);
    request.setAttribute("currentUser", currentUser);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Jobify - Snatch Your Dream Job'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<!-- Main Navigation Bar -->
<header class="navbar">
    <div class="container nav-container">
        <!-- Brand Logo (44px, Quirky font, Tilted -5deg) -->
        <a href="${pageContext.request.contextPath}/home" class="brand-logo" id="nav-brand-logo">
            JOBIFY
        </a>

        <!-- Mobile Menu Toggle Button -->
        <button type="button" class="nav-mobile-toggle" id="nav-mobile-toggle" aria-label="Toggle Navigation">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="3" y1="12" x2="21" y2="12"></line>
                <line x1="3" y1="6" x2="21" y2="6"></line>
                <line x1="3" y1="18" x2="21" y2="18"></line>
            </svg>
        </button>

        <!-- Center Navigation Links -->
        <ul class="nav-links" id="nav-links-menu">
            <li>
                <a href="${pageContext.request.contextPath}/home" 
                   class="nav-link ${pageContext.request.requestURI.endsWith('/home') or pageContext.request.requestURI.endsWith('/index.jsp') or pageContext.request.requestURI.endsWith('/') ? 'active' : ''}"
                   id="nav-link-home">Home</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/companies" 
                   class="nav-link ${pageContext.request.requestURI.contains('/company') ? 'active' : ''}"
                   id="nav-link-company">Company</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/jobs" 
                   class="nav-link ${pageContext.request.requestURI.contains('/jobs') or pageContext.request.requestURI.contains('/job-detail') ? 'active' : ''}"
                   id="nav-link-jobs">Job listing</a>
            </li>
        </ul>

        <!-- Right User Actions -->
        <div class="nav-actions">
            <c:choose>
                <c:when test="${not empty currentUser}">
                    <c:choose>
                        <c:when test="${currentUser.jobSeeker}">
                            <a href="${pageContext.request.contextPath}/seeker/dashboard" class="btn btn-secondary btn-sm" id="nav-dashboard-link">
                                Seeker Dashboard
                            </a>
                        </c:when>
                        <c:when test="${currentUser.employer}">
                            <a href="${pageContext.request.contextPath}/employer/dashboard" class="btn btn-secondary btn-sm" id="nav-dashboard-link">
                                Employer Hub
                            </a>
                            <a href="${pageContext.request.contextPath}/employer/jobs/create" class="btn btn-primary btn-sm" id="nav-post-job-btn">
                                + Post Job
                            </a>
                        </c:when>
                        <c:when test="${currentUser.admin}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-dark btn-sm" id="nav-dashboard-link">
                                Admin Portal
                            </a>
                        </c:when>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/logout" class="nav-auth-link" id="nav-logout-btn" title="Sign out">
                        Sign Out
                    </a>
                </c:when>
                <c:otherwise>
                    <!-- Exact matching design: "Sign in / Employers" -->
                    <a href="${pageContext.request.contextPath}/login" class="nav-auth-link" id="nav-login-link">
                        Sign in
                    </a>
                    <span class="nav-divider">/</span>
                    <a href="${pageContext.request.contextPath}/register?role=EMPLOYER" class="nav-auth-link" id="nav-employer-link">
                        Employers
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- Flash Alerts / Messages Notification Area -->
<jsp:include page="/WEB-INF/views/common/messages.jsp" />
