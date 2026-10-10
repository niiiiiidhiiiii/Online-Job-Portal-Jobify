<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Applications - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container dashboard-layout">
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
        <div class="sidebar-profile">
            <div class="sidebar-avatar">
                ${not empty currentUser.displayName ? currentUser.displayName.substring(0, 1).toUpperCase() : 'U'}
            </div>
            <div class="sidebar-name"><c:out value="${currentUser.displayName}" /></div>
            <div class="sidebar-role">Job Seeker</div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/seeker/dashboard" class="sidebar-menu-link">
                    &#128202; Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/profile" class="sidebar-menu-link">
                    &#128100; My Profile &amp; Resume
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/applications" class="sidebar-menu-link active">
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

    <!-- Application Tracking List -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">Application Status Tracker</h1>
                <p class="section-subtitle">Real-time status updates and feedback from hiring teams</p>
            </div>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary btn-sm">
                Apply to More Jobs
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty applications}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Target Position</th>
                                <th>Employer</th>
                                <th>Location &amp; Type</th>
                                <th>Applied Date</th>
                                <th>Status</th>
                                <th>Employer Notes / Feedback</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${applications}">
                                <tr>
                                    <td style="font-weight: 700; color: var(--color-espresso);">
                                        <a href="${pageContext.request.contextPath}/job-details?id=${app.jobId}">
                                            <c:out value="${app.jobTitle}" />
                                        </a>
                                    </td>
                                    <td><c:out value="${app.companyName}" /></td>
                                    <td>
                                        <span style="font-size: 0.85rem; color: var(--color-text-muted);">
                                            <c:out value="${app.jobLocation}" /> &bull; <c:out value="${app.jobType}" />
                                        </span>
                                    </td>
                                    <td>${app.appliedAt.toString().substring(0, 10)}</td>
                                    <td>
                                        <span class="badge ${app.badgeClass}"><c:out value="${app.status}" /></span>
                                    </td>
                                    <td style="max-width: 250px;">
                                        <c:choose>
                                            <c:when test="${not empty app.employerNotes}">
                                                <div style="font-size: 0.85rem; background-color: var(--color-cream); padding: 0.4rem 0.6rem; border-radius: 6px; border-left: 3px solid var(--color-cocoa);">
                                                    <c:out value="${app.employerNotes}" />
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="font-size: 0.82rem; color: var(--color-text-light); font-style: italic;">
                                                    Awaiting review
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/job-details?id=${app.jobId}" class="btn btn-outline btn-sm">
                                            Job Details
                                        </a>
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
                    <h3 class="empty-state-title">No applications found</h3>
                    <p class="empty-state-text">You haven't submitted any applications yet. Explore openings and apply today!</p>
                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">Find Your Next Job</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
