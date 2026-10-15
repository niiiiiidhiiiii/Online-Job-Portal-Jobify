<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Employer Dashboard - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container dashboard-layout">
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
        <div class="sidebar-profile">
            <div class="sidebar-avatar">
                ${not empty profile.companyName ? profile.companyName.substring(0, 1).toUpperCase() : 'E'}
            </div>
            <div class="sidebar-name"><c:out value="${not empty profile.companyName ? profile.companyName : currentUser.displayName}" /></div>
            <div class="sidebar-role">Verified Organization</div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/employer/dashboard" class="sidebar-menu-link active">
                    &#128202; Hiring Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/employer/jobs" class="sidebar-menu-link">
                    &#128188; Manage Job Listings
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/employer/jobs/create" class="sidebar-menu-link">
                    &#10133; Post New Opening
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/employer/applications" class="sidebar-menu-link">
                    &#128101; Review Applicants
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/employer/profile" class="sidebar-menu-link">
                    &#127970; Company Profile
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">Employer Hiring Hub</h1>
                <p class="section-subtitle">Manage open listings, evaluate incoming candidates, and build your team</p>
            </div>
            <a href="${pageContext.request.contextPath}/employer/jobs/create" class="btn btn-primary btn-sm">
                + Create New Opening
            </a>
        </div>

        <!-- Hiring Metrics Widgets -->
        <div class="stats-cards-grid">
            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Total Listings</h4>
                    <div class="stat-number">${stats.employerTotalJobs}</div>
                </div>
                <div class="stat-icon">&#128188;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Active Openings</h4>
                    <div class="stat-number">${stats.employerActiveJobs}</div>
                </div>
                <div class="stat-icon" style="color: #1E6B35;">&#128994;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Candidates Applied</h4>
                    <div class="stat-number">${stats.employerTotalApplications}</div>
                </div>
                <div class="stat-icon" style="color: var(--color-primary-brown);">&#128101;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Shortlisted</h4>
                    <div class="stat-number">${stats.employerShortlistedApplications}</div>
                </div>
                <div class="stat-icon" style="color: #25634D;">&#9733;</div>
            </div>
        </div>

        <!-- Quick Action Shortcuts -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1.25rem; margin-bottom: 2.75rem;">
            <a href="${pageContext.request.contextPath}/employer/jobs/create" class="form-card" style="padding: 1.4rem; display: flex; align-items: center; gap: 1rem; text-decoration: none; border-radius: 14px;">
                <div class="stat-icon" style="background-color: var(--color-sand); font-size: 1.35rem;">&#10133;</div>
                <div>
                    <div style="font-weight: 700; color: var(--color-dark-brown);">Post a Job</div>
                    <div style="font-size: 0.82rem; color: var(--color-text-muted);">Reach targeted talent</div>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/employer/applications" class="form-card" style="padding: 1.4rem; display: flex; align-items: center; gap: 1rem; text-decoration: none; border-radius: 14px;">
                <div class="stat-icon" style="background-color: var(--color-sand); font-size: 1.35rem;">&#128100;</div>
                <div>
                    <div style="font-weight: 700; color: var(--color-dark-brown);">Review Candidates</div>
                    <div style="font-size: 0.82rem; color: var(--color-text-muted);">${stats.employerPendingApplications} pending evaluation</div>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/employer/profile" class="form-card" style="padding: 1.4rem; display: flex; align-items: center; gap: 1rem; text-decoration: none; border-radius: 14px;">
                <div class="stat-icon" style="background-color: var(--color-sand); font-size: 1.35rem;">&#127970;</div>
                <div>
                    <div style="font-weight: 700; color: var(--color-dark-brown);">Brand Profile</div>
                    <div style="font-size: 0.82rem; color: var(--color-text-muted);">Update public presence</div>
                </div>
            </a>
        </div>

        <!-- Recent Applicants Table -->
        <div>
            <div class="section-header" style="margin-bottom: 1.25rem;">
                <h2 style="font-family: var(--font-heading); font-size: 1.4rem; color: var(--color-dark-brown); font-weight: 700;">
                    Recent Applicants
                </h2>
                <a href="${pageContext.request.contextPath}/employer/applications" class="btn btn-secondary btn-sm">
                    View All Candidates
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty recentApplicants}">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Candidate</th>
                                    <th>Position</th>
                                    <th>Applied On</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="app" items="${recentApplicants}">
                                    <tr>
                                        <td>
                                            <div style="font-weight: 700; color: var(--color-dark-brown);">
                                                <c:out value="${not empty app.seekerName ? app.seekerName : app.seekerEmail}" />
                                            </div>
                                            <div style="font-size: 0.82rem; color: var(--color-text-muted);"><c:out value="${app.seekerEmail}" /></div>
                                        </td>
                                        <td><c:out value="${app.jobTitle}" /></td>
                                        <td>${app.appliedAt.toString().substring(0, 10)}</td>
                                        <td>
                                            <span class="badge ${app.badgeClass}"><c:out value="${app.status}" /></span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/employer/applications?jobId=${app.jobId}" class="btn btn-outline btn-sm">
                                                Evaluate &rarr;
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" style="padding: 2.75rem 1.5rem;">
                        <div class="empty-state-icon">&#128101;</div>
                        <h3 class="empty-state-title">No applications received yet</h3>
                        <p class="empty-state-text">Once candidates discover your listings, their profiles will appear here for review.</p>
                        <a href="${pageContext.request.contextPath}/employer/jobs/create" class="btn btn-primary btn-sm">Post New Job</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
