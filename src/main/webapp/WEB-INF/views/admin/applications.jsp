<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="All Platform Applications - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container dashboard-layout">
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
        <div class="sidebar-profile">
            <div class="sidebar-avatar" style="background-color: var(--color-espresso); color: #FFFFFF;">
                A
            </div>
            <div class="sidebar-name"><c:out value="${currentUser.displayName}" /></div>
            <div class="sidebar-role">Platform Administrator</div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-menu-link">
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
                <a href="${pageContext.request.contextPath}/admin/applications" class="sidebar-menu-link active">
                    &#128221; Platform Applications
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">All Platform Applications</h1>
                <p class="section-subtitle">Real-time audit log of all candidate submissions and hiring progression</p>
            </div>
            <span class="badge badge-match" style="font-size: 0.85rem;">
                ${stats.totalApplications} Submissions Recorded
            </span>
        </div>

        <c:choose>
            <c:when test="${not empty applications}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>App ID</th>
                                <th>Candidate</th>
                                <th>Applied Role</th>
                                <th>Employer</th>
                                <th>Submission Date</th>
                                <th>Current Status</th>
                                <th>Employer Feedback</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${applications}">
                                <tr>
                                    <td>#${app.id}</td>
                                    <td>
                                        <div style="font-weight: 700; color: var(--color-espresso);">
                                            <c:out value="${not empty app.seekerName ? app.seekerName : app.seekerEmail}" />
                                        </div>
                                        <div style="font-size: 0.8rem; color: var(--color-text-muted);"><c:out value="${app.seekerEmail}" /></div>
                                    </td>
                                    <td>
                                        <div style="font-weight: 600;">
                                            <a href="${pageContext.request.contextPath}/job-details?id=${app.jobId}">
                                                <c:out value="${app.jobTitle}" />
                                            </a>
                                        </div>
                                    </td>
                                    <td><c:out value="${app.companyName}" /></td>
                                    <td style="font-size: 0.82rem; color: var(--color-text-muted);">
                                        ${app.appliedAt.toString().substring(0, 10)}
                                    </td>
                                    <td>
                                        <span class="badge ${app.badgeClass}"><c:out value="${app.status}" /></span>
                                    </td>
                                    <td style="max-width: 250px; font-size: 0.85rem;">
                                        <c:out value="${not empty app.employerNotes ? app.employerNotes : 'No feedback entered yet'}" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">&#128221;</div>
                    <h3 class="empty-state-title">No applications recorded yet</h3>
                    <p class="empty-state-text">As job seekers submit resumes, all platform records will appear here.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
