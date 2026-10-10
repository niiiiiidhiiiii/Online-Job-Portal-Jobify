<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Personalized Recommendations - Jobify" />
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
                <a href="${pageContext.request.contextPath}/seeker/applications" class="sidebar-menu-link">
                    &#128221; Track Applications
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/recommendations" class="sidebar-menu-link active">
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

    <!-- Recommendations Feed -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">AI Skill-Matched Opportunities</h1>
                <p class="section-subtitle">
                    Automated recommendations calculated by comparing your registered skills against current market demands
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/seeker/profile" class="btn btn-outline btn-sm">
                &#9998; Edit Skills
            </a>
        </div>

        <!-- Seeker Skill Badges Banner -->
        <div style="background-color: var(--color-card-bg); border: 1px solid var(--color-border); border-radius: 14px; padding: 1.25rem; margin-bottom: 2rem;">
            <div style="font-size: 0.82rem; text-transform: uppercase; font-weight: 700; color: var(--color-text-muted); margin-bottom: 0.5rem;">
                Your Current Matched Skills
            </div>
            <div style="display: flex; flex-wrap: wrap; gap: 0.4rem;">
                <c:choose>
                    <c:when test="${not empty profile.skillList}">
                        <c:forEach var="skill" items="${profile.skillList}">
                            <span class="skill-tag" style="background-color: var(--color-cream); color: var(--color-cocoa-dark); padding: 0.35rem 0.75rem; font-size: 0.85rem; border: 1px solid var(--color-border-subtle);">
                                &#10004; <c:out value="${skill}" />
                            </span>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span style="font-size: 0.88rem; color: var(--color-text-muted); font-style: italic;">
                            No skills configured yet. Please update your profile to generate recommendations.
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Recommended Jobs List -->
        <c:choose>
            <c:when test="${not empty recommendations}">
                <div class="jobs-grid">
                    <c:forEach var="job" items="${recommendations}">
                        <div class="job-card">
                            <div>
                                <div class="job-card-header">
                                    <div class="job-company-avatar">
                                        ${job.companyName.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div class="job-header-info">
                                        <h3 class="job-title">
                                            <a href="${pageContext.request.contextPath}/job-details?id=${job.id}">
                                                <c:out value="${job.title}" />
                                            </a>
                                        </h3>
                                        <div class="job-company"><c:out value="${job.companyName}" /></div>
                                    </div>
                                    <span class="badge badge-match" style="font-size: 0.85rem; padding: 0.4rem 0.8rem;">
                                        ${job.matchScore}% Match
                                    </span>
                                </div>

                                <div class="job-meta-pills">
                                    <span class="meta-pill">&#128205; <c:out value="${job.location}" /></span>
                                    <span class="meta-pill">&#9200; <c:out value="${job.jobType}" /></span>
                                    <span class="meta-pill">&#128193; <c:out value="${job.category}" /></span>
                                </div>

                                <p class="job-desc-snippet"><c:out value="${job.description}" /></p>

                                <div style="font-size: 0.8rem; font-weight: 700; color: var(--color-text-muted); margin-bottom: 0.4rem;">
                                    Required by Employer:
                                </div>
                                <div class="job-skills-list">
                                    <c:forEach var="skill" items="${job.skillList}">
                                        <span class="skill-tag"><c:out value="${skill}" /></span>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="job-card-footer">
                                <span class="job-salary">${job.formattedSalary}</span>
                                <a href="${pageContext.request.contextPath}/job-details?id=${job.id}" class="btn btn-primary btn-sm">
                                    View &amp; Apply &rarr;
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">&#128161;</div>
                    <h3 class="empty-state-title">No matching jobs found yet</h3>
                    <p class="empty-state-text">
                        Try adding more skills to your profile (e.g. Java, MySQL, React, CSS) to broaden your recommendation pool.
                    </p>
                    <a href="${pageContext.request.contextPath}/seeker/profile" class="btn btn-primary">
                        Update Candidate Skills
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
