<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Job Listings - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container dashboard-layout">
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
        <div class="sidebar-profile">
            <div class="sidebar-avatar">
                ${not empty currentUser.displayName ? currentUser.displayName.substring(0, 1).toUpperCase() : 'E'}
            </div>
            <div class="sidebar-name"><c:out value="${currentUser.displayName}" /></div>
            <div class="sidebar-role">Verified Employer</div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/employer/dashboard" class="sidebar-menu-link">
                    &#128202; Hiring Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/employer/jobs" class="sidebar-menu-link active">
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

    <!-- Job Listings Table -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">My Job Postings</h1>
                <p class="section-subtitle">Manage all active and archived job openings for your organization</p>
            </div>
            <a href="${pageContext.request.contextPath}/employer/jobs/create" class="btn btn-primary btn-sm">
                + Post New Opening
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty jobs}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Job Title</th>
                                <th>Category &amp; Type</th>
                                <th>Applicants</th>
                                <th>Approval</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="j" items="${jobs}">
                                <tr>
                                    <td>
                                        <div style="font-weight: 700; color: var(--color-espresso);">
                                            <a href="${pageContext.request.contextPath}/job-details?id=${j.id}">
                                                <c:out value="${j.title}" />
                                            </a>
                                        </div>
                                        <div style="font-size: 0.8rem; color: var(--color-text-muted);">
                                            &#128205; <c:out value="${j.location}" /> &bull; ${j.formattedSalary}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="meta-pill"><c:out value="${j.category}" /></span>
                                        <span class="meta-pill"><c:out value="${j.jobType}" /></span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/employer/applications?jobId=${j.id}" 
                                           class="badge ${j.applicationCount > 0 ? 'badge-shortlisted' : 'badge-closed'}" 
                                           style="text-decoration: none;">
                                            &#128101; ${j.applicationCount} Applicants
                                        </a>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${j.approvalStatus == 'APPROVED'}">
                                                <span class="badge badge-accepted">Approved</span>
                                            </c:when>
                                            <c:when test="${j.approvalStatus == 'PENDING'}">
                                                <span class="badge badge-pending">Pending Review</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-rejected">Rejected</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge ${j.active ? 'badge-active' : 'badge-closed'}">
                                            <c:out value="${j.status}" />
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.4rem; align-items: center; flex-wrap: wrap;">
                                            <a href="${pageContext.request.contextPath}/employer/jobs/edit?id=${j.id}" 
                                               class="btn btn-secondary btn-sm" title="Edit Job">
                                                Edit
                                            </a>

                                            <!-- Toggle Status (Active / Closed) -->
                                            <form action="${pageContext.request.contextPath}/employer/jobs/status" method="POST" style="display: inline;">
                                                <input type="hidden" name="jobId" value="${j.id}">
                                                <input type="hidden" name="status" value="${j.active ? 'CLOSED' : 'ACTIVE'}">
                                                <button type="submit" class="btn btn-outline btn-sm" title="${j.active ? 'Archive/Close listing' : 'Reactivate listing'}">
                                                    ${j.active ? 'Close' : 'Activate'}
                                                </button>
                                            </form>

                                            <!-- Delete Job -->
                                            <form action="${pageContext.request.contextPath}/employer/jobs/delete" method="POST" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this job listing? All associated applications will also be removed.');">
                                                <input type="hidden" name="id" value="${j.id}">
                                                <button type="submit" class="btn btn-secondary btn-sm" style="color: #991B1B;" title="Delete Job">
                                                    &times;
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
                <div class="empty-state">
                    <div class="empty-state-icon">&#128188;</div>
                    <h3 class="empty-state-title">No jobs created yet</h3>
                    <p class="empty-state-text">Start attracting candidates by posting your first job opening.</p>
                    <a href="${pageContext.request.contextPath}/employer/jobs/create" class="btn btn-primary">Post a Job Opening</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
