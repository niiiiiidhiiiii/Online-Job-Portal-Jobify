<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Job Moderation - Jobify" />
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
                <a href="${pageContext.request.contextPath}/admin/jobs" class="sidebar-menu-link active">
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
                <h1 class="section-title">Job Listing Moderation</h1>
                <p class="section-subtitle">Approve, reject, or audit all employer listings across Jobify</p>
            </div>
            <span class="badge badge-match" style="font-size: 0.85rem; padding: 0.4rem 0.9rem;">
                Moderation Center
            </span>
        </div>

        <!-- Filter Toolbar -->
        <div class="form-card" style="padding: 1.5rem; border-radius: 16px; margin-bottom: 2rem;">
            <form action="${pageContext.request.contextPath}/admin/jobs" method="GET" class="filter-bar" style="grid-template-columns: 1fr 1fr auto; margin-bottom: 0;">
                <div>
                    <label class="form-label" style="font-size: 0.82rem; font-weight: 600;">Approval State</label>
                    <select name="approval" class="form-control">
                        <option value="ALL">All Approvals</option>
                        <option value="PENDING" ${selectedApproval == 'PENDING' ? 'selected' : ''}>Pending Review</option>
                        <option value="APPROVED" ${selectedApproval == 'APPROVED' ? 'selected' : ''}>Approved Listings</option>
                        <option value="REJECTED" ${selectedApproval == 'REJECTED' ? 'selected' : ''}>Rejected Listings</option>
                    </select>
                </div>

                <div>
                    <label class="form-label" style="font-size: 0.82rem; font-weight: 600;">Listing Status</label>
                    <select name="status" class="form-control">
                        <option value="ALL">All Statuses</option>
                        <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Active Listings</option>
                        <option value="CLOSED" ${selectedStatus == 'CLOSED' ? 'selected' : ''}>Closed / Archived</option>
                    </select>
                </div>

                <div style="display: flex; gap: 0.5rem; align-self: flex-end;">
                    <button type="submit" class="btn btn-primary" style="padding: 0.65rem 1.25rem;">Filter</button>
                    <a href="${pageContext.request.contextPath}/admin/jobs" class="btn btn-secondary" style="padding: 0.65rem 1.1rem;">Clear</a>
                </div>
            </form>
        </div>

        <!-- Jobs Moderation Table -->
        <c:choose>
            <c:when test="${not empty jobs}">
                <div class="form-card" style="padding: 1.75rem; border-radius: 16px;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Job ID &amp; Title</th>
                                    <th>Employer</th>
                                    <th>Category &amp; Type</th>
                                    <th>Posted Date</th>
                                    <th>Approval</th>
                                    <th>Status</th>
                                    <th>Moderation Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="j" items="${jobs}">
                                    <tr>
                                        <td>
                                            <div style="font-weight: 700; color: var(--color-dark-brown);">
                                                <a href="${pageContext.request.contextPath}/job-details?id=${j.id}" style="color: var(--color-dark-brown); text-decoration: none;">
                                                    <c:out value="${j.title}" />
                                                </a>
                                            </div>
                                            <div style="font-size: 0.8rem; color: var(--color-text-muted);">
                                                #${j.id} &bull; <c:out value="${j.location}" /> &bull; ${j.formattedSalary}
                                            </div>
                                        </td>
                                        <td><c:out value="${j.companyName}" /></td>
                                        <td>
                                            <span class="meta-pill"><c:out value="${j.category}" /></span>
                                            <span class="meta-pill"><c:out value="${j.jobType}" /></span>
                                        </td>
                                        <td style="font-size: 0.82rem; color: var(--color-text-muted);">
                                            ${j.createdAt.toString().substring(0, 10)}
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
                                            <div style="display: flex; gap: 0.4rem; align-items: center;">
                                                <c:if test="${j.approvalStatus != 'APPROVED'}">
                                                    <form action="${pageContext.request.contextPath}/admin/jobs/approve" method="POST" style="display: inline;">
                                                        <input type="hidden" name="jobId" value="${j.id}">
                                                        <input type="hidden" name="approvalStatus" value="APPROVED">
                                                        <button type="submit" class="btn btn-primary btn-sm" style="background-color: #2E7D32; border-color: #2E7D32; padding: 0.35rem 0.65rem;" title="Approve listing">
                                                            &#10004;
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <c:if test="${j.approvalStatus != 'REJECTED'}">
                                                    <form action="${pageContext.request.contextPath}/admin/jobs/approve" method="POST" style="display: inline;">
                                                        <input type="hidden" name="jobId" value="${j.id}">
                                                        <input type="hidden" name="approvalStatus" value="REJECTED">
                                                        <button type="submit" class="btn btn-secondary btn-sm" style="color: #991B1B; padding: 0.35rem 0.65rem;" title="Reject listing">
                                                            &#10006;
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <a href="${pageContext.request.contextPath}/job-details?id=${j.id}" class="btn btn-outline btn-sm" style="padding: 0.35rem 0.75rem;" title="Preview public page">
                                                    Preview
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state" style="padding: 3rem 1.5rem;">
                    <div class="empty-state-icon">&#128188;</div>
                    <h3 class="empty-state-title">No jobs match your filter</h3>
                    <p class="empty-state-text">Adjust the approval or status filters above to view more listings.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
