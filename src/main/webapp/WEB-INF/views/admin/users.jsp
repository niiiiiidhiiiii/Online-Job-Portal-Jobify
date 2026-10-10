<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="User Management - Jobify" />
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
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-menu-link active">
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
                <h1 class="section-title">User Account Controls</h1>
                <p class="section-subtitle">Manage registered candidates, employers, and administrator accounts</p>
            </div>
        </div>

        <!-- Filter & Search Toolbar -->
        <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="filter-bar" style="grid-template-columns: 1fr 200px auto;">
            <div>
                <label class="form-label" style="font-size: 0.8rem;">Search Users</label>
                <input type="text" 
                       name="search" 
                       class="form-control" 
                       placeholder="Email, candidate name, or company name" 
                       value="<c:out value='${search}'/>">
            </div>

            <div>
                <label class="form-label" style="font-size: 0.8rem;">Role Filter</label>
                <select name="role" class="form-control">
                    <option value="ALL">All Roles (${stats.totalUsers})</option>
                    <option value="JOB_SEEKER" ${selectedRole == 'JOB_SEEKER' ? 'selected' : ''}>Job Seekers (${stats.totalJobSeekers})</option>
                    <option value="EMPLOYER" ${selectedRole == 'EMPLOYER' ? 'selected' : ''}>Employers (${stats.totalEmployers})</option>
                    <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Admins (${stats.totalAdmins})</option>
                </select>
            </div>

            <div style="display: flex; gap: 0.5rem; align-self: flex-end;">
                <button type="submit" class="btn btn-primary">Filter</button>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Clear</a>
            </div>
        </form>

        <!-- User Accounts Table -->
        <c:choose>
            <c:when test="${not empty users}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Email / Account</th>
                                <th>Name / Company</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Registered</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>#${u.id}</td>
                                    <td style="font-weight: 600;"><c:out value="${u.email}" /></td>
                                    <td><c:out value="${u.displayName}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.admin}">
                                                <span class="badge" style="background-color: var(--color-espresso); color: #FFFFFF;">Admin</span>
                                            </c:when>
                                            <c:when test="${u.employer}">
                                                <span class="badge" style="background-color: #FEF3C7; color: #92400E;">Employer</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge" style="background-color: #DBEAFE; color: #1E40AF;">Job Seeker</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge ${u.active ? 'badge-active' : 'badge-rejected'}">
                                            ${u.active ? 'Active' : 'Suspended'}
                                        </span>
                                    </td>
                                    <td style="font-size: 0.82rem; color: var(--color-text-muted);">
                                        ${u.createdAt.toString().substring(0, 10)}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.id == currentUser.id}">
                                                <span style="font-size: 0.8rem; color: var(--color-text-light); font-style: italic;">
                                                    Current User
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <div style="display: flex; gap: 0.4rem; align-items: center;">
                                                    <!-- Toggle Status -->
                                                    <form action="${pageContext.request.contextPath}/admin/users/status" method="POST" style="display: inline;">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <input type="hidden" name="active" value="${!u.active}">
                                                        <button type="submit" class="btn btn-secondary btn-sm" title="${u.active ? 'Deactivate account' : 'Reactivate account'}">
                                                            ${u.active ? 'Deactivate' : 'Activate'}
                                                        </button>
                                                    </form>

                                                    <!-- Delete User -->
                                                    <form action="${pageContext.request.contextPath}/admin/users/delete" method="POST" style="display: inline;" onsubmit="return confirm('Permanently delete user ${u.email}? This action cannot be undone.');">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <button type="submit" class="btn btn-outline btn-sm" style="color: #991B1B; border-color: #FECACA;" title="Delete user account">
                                                            &times;
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">&#128101;</div>
                    <h3 class="empty-state-title">No users found</h3>
                    <p class="empty-state-text">No accounts matched the search criteria.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
