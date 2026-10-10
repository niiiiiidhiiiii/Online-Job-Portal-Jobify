<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Job Seeker Dashboard - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container dashboard-layout">
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
        <div class="sidebar-profile">
            <div class="sidebar-avatar">
                ${not empty profile.fullName ? profile.fullName.substring(0, 1).toUpperCase() : 'U'}
            </div>
            <div class="sidebar-name"><c:out value="${not empty profile.fullName ? profile.fullName : currentUser.displayName}" /></div>
            <div class="sidebar-role">${not empty profile.headline ? profile.headline : 'Job Seeker'}</div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/seeker/dashboard" class="sidebar-menu-link active">
                    &#128202; Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/profile" class="sidebar-menu-link">
                    &#128100; My Profile &amp; Resume
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/applications" class="sidebar-menu-link">
                    &#128221; Track Applications
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/recommendations" class="sidebar-menu-link">
                    &#128161; Job Recommendations
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/jobs" class="sidebar-menu-link">
                    &#128269; Search All Jobs
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Dashboard Content -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">Seeker Dashboard</h1>
                <p class="section-subtitle">Track your application pipeline and discover matching roles</p>
            </div>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary btn-sm">Find New Jobs &rarr;</a>
        </div>

        <!-- Metrics Overview Cards -->
        <div class="stats-cards-grid">
            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Submitted</h4>
                    <div class="stat-number">${stats.seekerTotalApplications}</div>
                </div>
                <div class="stat-icon">&#128221;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>In Review</h4>
                    <div class="stat-number">${stats.seekerPendingApplications}</div>
                </div>
                <div class="stat-icon" style="color: #D97706;">&#9200;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Shortlisted</h4>
                    <div class="stat-number">${stats.seekerShortlistedApplications}</div>
                </div>
                <div class="stat-icon" style="color: #0D9488;">&#9733;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Offers Accepted</h4>
                    <div class="stat-number">${stats.seekerAcceptedApplications}</div>
                </div>
                <div class="stat-icon" style="color: #166534;">&#127881;</div>
            </div>
        </div>

        <!-- Skill-Based Recommendations Widget -->
        <div style="margin-bottom: 2.5rem;">
            <div class="section-header" style="margin-bottom: 1rem;">
                <div>
                    <h2 style="font-family: var(--font-heading); font-size: 1.35rem; color: var(--color-espresso); font-weight: 700;">
                        Recommended for Your Skills
                    </h2>
                    <p style="font-size: 0.88rem; color: var(--color-text-muted);">
                        Calculated by analyzing your profile skills: 
                        <strong><c:out value="${not empty profile.skills ? profile.skills : 'No skills set yet'}"/></strong>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/seeker/recommendations" class="btn btn-outline btn-sm">
                    View All Matches &rarr;
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty recommendations}">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1rem;">
                        <c:forEach var="rec" items="${recommendations}">
                            <div class="job-card" style="padding: 1.25rem;">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem;">
                                    <h4 style="font-family: var(--font-heading); font-size: 1.05rem; font-weight: 700;">
                                        <a href="${pageContext.request.contextPath}/job-details?id=${rec.id}">
                                            <c:out value="${rec.title}" />
                                        </a>
                                    </h4>
                                    <span class="badge badge-match">${rec.matchScore}% Match</span>
                                </div>
                                <div style="font-size: 0.88rem; color: var(--color-text-muted); margin-bottom: 0.75rem;">
                                    <c:out value="${rec.companyName}" /> &bull; <c:out value="${rec.location}" />
                                </div>
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: auto; padding-top: 0.75rem; border-top: 1px solid var(--color-border-subtle);">
                                    <span style="font-weight: 700; font-size: 0.92rem;">${rec.formattedSalary}</span>
                                    <a href="${pageContext.request.contextPath}/job-details?id=${rec.id}" class="btn btn-secondary btn-sm">
                                        View &rarr;
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" style="padding: 2rem 1rem;">
                        <p style="font-size: 0.9rem; color: var(--color-text-muted); margin-bottom: 1rem;">
                            Add your skills (e.g. Java, MySQL, React) to your profile to get automated matching recommendations!
                        </p>
                        <a href="${pageContext.request.contextPath}/seeker/profile" class="btn btn-primary btn-sm">
                            Update Skills Profile
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Recent Applications Table -->
        <div>
            <div class="section-header" style="margin-bottom: 1rem;">
                <h2 style="font-family: var(--font-heading); font-size: 1.35rem; color: var(--color-espresso); font-weight: 700;">
                    Recent Applications
                </h2>
                <a href="${pageContext.request.contextPath}/seeker/applications" class="btn btn-secondary btn-sm">
                    View All History
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty recentApplications}">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Role Title</th>
                                    <th>Company</th>
                                    <th>Applied On</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="app" items="${recentApplications}">
                                    <tr>
                                        <td style="font-weight: 600;">
                                            <a href="${pageContext.request.contextPath}/job-details?id=${app.jobId}">
                                                <c:out value="${app.jobTitle}" />
                                            </a>
                                        </td>
                                        <td><c:out value="${app.companyName}" /></td>
                                        <td>${app.appliedAt.toString().substring(0, 10)}</td>
                                        <td>
                                            <span class="badge ${app.badgeClass}"><c:out value="${app.status}" /></span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/job-details?id=${app.jobId}" class="btn btn-outline btn-sm">
                                                Job Info
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" style="padding: 2.5rem 1rem;">
                        <div class="empty-state-icon">&#128221;</div>
                        <h3 class="empty-state-title">No applications submitted yet</h3>
                        <p class="empty-state-text">Explore open job listings and submit your first application today!</p>
                        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary btn-sm">Browse Jobs Now</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
