<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Company Profile - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container dashboard-layout">
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
        <div class="sidebar-profile">
            <div class="sidebar-avatar">
                ${not empty profile.companyName ? profile.companyName.substring(0, 1).toUpperCase() : 'E'}
            </div>
            <div class="sidebar-name"><c:out value="${not empty profile.companyName ? profile.companyName : currentUser.displayName}" /></div>
            <div class="sidebar-role">Verified Employer</div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/employer/dashboard" class="sidebar-menu-link">
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
                <a href="${pageContext.request.contextPath}/employer/profile" class="sidebar-menu-link active">
                    &#127970; Company Profile
                </a>
            </li>
        </ul>
    </aside>

    <!-- Company Profile Form -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">Employer Company Profile</h1>
                <p class="section-subtitle">Showcase your organization culture, values, and company overview to candidates</p>
            </div>
            <a href="${pageContext.request.contextPath}/company-details?id=${currentUser.id}" class="btn btn-outline btn-sm">
                View Public Profile &#8599;
            </a>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/employer/profile" method="POST">
                <div class="form-row">
                    <div class="form-group">
                        <label for="companyName" class="form-label">Company / Organization Name *</label>
                        <input type="text" 
                               id="companyName" 
                               name="companyName" 
                               class="form-control" 
                               value="<c:out value='${profile.companyName}'/>" 
                               required>
                    </div>

                    <div class="form-group">
                        <label for="contactPerson" class="form-label">Hiring Contact Person</label>
                        <input type="text" 
                               id="contactPerson" 
                               name="contactPerson" 
                               class="form-control" 
                               placeholder="e.g. Marcus Vance" 
                               value="<c:out value='${profile.contactPerson}'/>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone" class="form-label">Contact Phone</label>
                        <input type="text" 
                               id="phone" 
                               name="phone" 
                               class="form-control" 
                               placeholder="+1 (555) 000-0000" 
                               value="<c:out value='${profile.phone}'/>">
                    </div>

                    <div class="form-group">
                        <label for="website" class="form-label">Official Website URL</label>
                        <input type="url" 
                               id="website" 
                               name="website" 
                               class="form-control" 
                               placeholder="https://example.com" 
                               value="<c:out value='${profile.website}'/>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="location" class="form-label">Headquarters / Primary Location</label>
                        <input type="text" 
                               id="location" 
                               name="location" 
                               class="form-control" 
                               placeholder="e.g. San Francisco, CA or Remote" 
                               value="<c:out value='${profile.location}'/>">
                    </div>

                    <div class="form-group">
                        <label for="industry" class="form-label">Industry / Sector</label>
                        <input type="text" 
                               id="industry" 
                               name="industry" 
                               class="form-control" 
                               placeholder="e.g. Software & Cloud Services" 
                               value="<c:out value='${profile.industry}'/>">
                    </div>

                    <div class="form-group">
                        <label for="companySize" class="form-label">Company Size</label>
                        <select id="companySize" name="companySize" class="form-control">
                            <option value="1-10" ${profile.companySize == '1-10' ? 'selected' : ''}>1 - 10 employees (Startup)</option>
                            <option value="11-50" ${profile.companySize == '11-50' ? 'selected' : ''}>11 - 50 employees (Growing)</option>
                            <option value="51-200" ${profile.companySize == '51-200' ? 'selected' : ''}>51 - 200 employees (Mid-size)</option>
                            <option value="201-500" ${profile.companySize == '201-500' ? 'selected' : ''}>201 - 500 employees (Scale-up)</option>
                            <option value="500+" ${profile.companySize == '500+' ? 'selected' : ''}>500+ employees (Enterprise)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">About the Company / Mission Statement</label>
                    <textarea id="description" 
                              name="description" 
                              class="form-control" 
                              rows="4" 
                              placeholder="Describe your company culture, technology stack, mission, and why candidates should join..."><c:out value="${profile.description}"/></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary btn-lg" id="btn-save-employer-profile">
                        Save Company Profile &rarr;
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
