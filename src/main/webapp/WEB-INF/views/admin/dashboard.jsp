<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Administrator Dashboard - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container dashboard-layout">
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
        <div class="sidebar-profile">
            <div class="sidebar-avatar">
                A
            </div>
            <div class="sidebar-name"><c:out value="${currentUser.displayName}" /></div>
            <div class="sidebar-role">Platform Administrator</div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-menu-link active">
                    &#128202; Admin Overview
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-menu-link">
                    &#128101; User Management
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/jobs" class="sidebar-menu-link">
                    &#128188; Job Moderation
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/applications" class="sidebar-menu-link">
                    &#128221; Platform Applications
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">Administrator Console</h1>
                <p class="section-subtitle">Portal health, account moderation, and job verification overview</p>
            </div>
            <span class="badge badge-accepted" style="font-size: 0.85rem; padding: 0.4rem 0.9rem;">
                &#9679; System Online
            </span>
        </div>

        <!-- Metric Cards -->
        <div class="stats-cards-grid">
            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Total Users</h4>
                    <div class="stat-number">${stats.totalUsers}</div>
                </div>
                <div class="stat-icon" style="color: var(--color-mid-brown);">&#128101;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Job Seekers</h4>
                    <div class="stat-number">${stats.totalJobSeekers}</div>
                </div>
                <div class="stat-icon" style="color: var(--color-primary-brown);">&#128188;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Employers</h4>
                    <div class="stat-number">${stats.totalEmployers}</div>
                </div>
                <div class="stat-icon" style="color: var(--color-dusty-rose);">&#127970;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Active Jobs</h4>
                    <div class="stat-number">${stats.activeJobs}</div>
                </div>
                <div class="stat-icon" style="color: #2E7D32;">&#128994;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Pending Review</h4>
                    <div class="stat-number" style="color: var(--color-dusty-rose);">${stats.pendingApprovalJobs}</div>
                </div>
                <div class="stat-icon" style="color: var(--color-dusty-rose);">&#9888;</div>
            </div>

            <div class="stat-card">
                <div class="stat-card-info">
                    <h4>Applications</h4>
                    <div class="stat-number">${stats.totalApplications}</div>
                </div>
                <div class="stat-icon" style="color: var(--color-dark-brown);">&#128221;</div>
            </div>
        </div>

        <!-- Pending Approval Queue -->
        <div class="form-card" style="padding: 1.75rem; border-radius: 16px; margin-bottom: 2.25rem;">
            <div class="section-header" style="margin-bottom: 1.25rem;">
                <div>
                    <h2 style="font-family: var(--font-heading); font-size: 1.35rem; color: var(--color-dark-brown); font-weight: 700;">
                        Job Moderation Queue
                    </h2>
                    <p style="font-size: 0.88rem; color: var(--color-text-muted);">
                        Review employer job submissions awaiting public release
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/jobs" class="btn btn-secondary btn-sm">
                    View All Platform Jobs
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty pendingJobs}">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Job Title</th>
                                    <th>Employer</th>
                                    <th>Category &amp; Location</th>
                                    <th>Posted Date</th>
                                    <th>Moderation Decision</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pj" items="${pendingJobs}">
                                    <tr>
                                        <td>
                                            <div style="font-weight: 700; color: var(--color-dark-brown);"><c:out value="${pj.title}" /></div>
                                            <div style="font-size: 0.8rem; color: var(--color-text-muted);">${pj.formattedSalary}</div>
                                        </td>
                                        <td><c:out value="${pj.companyName}" /></td>
                                        <td><c:out value="${pj.category}" /> &bull; <c:out value="${pj.location}" /></td>
                                        <td>${pj.createdAt.toString().substring(0, 10)}</td>
                                        <td>
                                            <div style="display: flex; gap: 0.5rem;">
                                                <form action="${pageContext.request.contextPath}/admin/jobs/approve" method="POST" style="display: inline;">
                                                    <input type="hidden" name="jobId" value="${pj.id}">
                                                    <input type="hidden" name="approvalStatus" value="APPROVED">
                                                    <button type="submit" class="btn btn-primary btn-sm" style="background-color: #2E7D32; border-color: #2E7D32; padding: 0.35rem 0.85rem;">
                                                        &#10004; Approve
                                                    </button>
                                                </form>

                                                <form action="${pageContext.request.contextPath}/admin/jobs/approve" method="POST" style="display: inline;">
                                                    <input type="hidden" name="jobId" value="${pj.id}">
                                                    <input type="hidden" name="approvalStatus" value="REJECTED">
                                                    <button type="submit" class="btn btn-secondary btn-sm" style="color: #991B1B; padding: 0.35rem 0.85rem;">
                                                        &#10006; Reject
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" style="padding: 2.25rem 1rem;">
                        <div style="font-size: 1.8rem; color: #2E7D32; margin-bottom: 0.5rem;">&#10004;</div>
                        <h4 style="font-weight: 700; color: var(--color-dark-brown);">Approval Queue Clear</h4>
                        <p style="font-size: 0.88rem; color: var(--color-text-muted);">
                            All employer job postings have been reviewed and approved.
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Recent Audit Log Entries -->
        <div class="form-card" style="padding: 1.75rem; border-radius: 16px;">
            <div class="section-header" style="margin-bottom: 1.25rem;">
                <h2 style="font-family: var(--font-heading); font-size: 1.35rem; color: var(--color-dark-brown); font-weight: 700;">
                    System Audit Activity Log
                </h2>
            </div>

            <div class="table-responsive">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Timestamp</th>
                            <th>Action</th>
                            <th>User Reference</th>
                            <th>Event Details</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${recentActivities}">
                            <tr>
                                <td style="white-space: nowrap; font-size: 0.82rem; color: var(--color-text-muted);">
                                    ${log.createdAt.toString().substring(0, 19)}
                                </td>
                                <td>
                                    <span class="meta-pill" style="font-family: monospace; font-size: 0.75rem; background-color: var(--color-sand); color: var(--color-dark-brown);">
                                        <c:out value="${log.action}" />
                                    </span>
                                </td>
                                <td>
                                    <c:out value="${not empty log.userEmail ? log.userEmail : 'SYSTEM'}" />
                                </td>
                                <td style="font-size: 0.88rem; color: var(--color-text-dark);">
                                    <c:out value="${log.details}" />
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
