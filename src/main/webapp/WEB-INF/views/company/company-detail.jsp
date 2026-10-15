<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${company.companyName} - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 3.5rem 1.75rem 6rem;">
    <!-- Company Profile Header Card -->
    <div class="form-card" style="margin-bottom: 3rem;">
        <div style="display: flex; align-items: center; gap: 1.5rem; flex-wrap: wrap;">
            <div class="job-company-avatar" style="width: 76px; height: 76px; font-size: 2rem; border-radius: 20px;">
                ${company.companyName.substring(0, 1).toUpperCase()}
            </div>
            <div style="flex: 1; min-width: 240px;">
                <h1 style="font-family: var(--font-heading); font-size: 2.2rem; font-weight: 700; color: var(--color-dark-brown); line-height: 1.2;">
                    <c:out value="${company.companyName}" />
                </h1>
                <div style="font-size: 1rem; color: var(--color-text-muted); margin-top: 0.35rem; display: flex; flex-wrap: wrap; gap: 0.75rem;">
                    <span>&#128188; <c:out value="${not empty company.industry ? company.industry : 'General Industry'}" /></span>
                    <span>&bull;</span>
                    <span>&#128205; <c:out value="${not empty company.location ? company.location : 'Remote'}" /></span>
                    <span>&bull;</span>
                    <span>&#128101; <c:out value="${not empty company.companySize ? company.companySize : '10-50'} team members" /></span>
                </div>
            </div>

            <c:if test="${not empty company.website}">
                <a href="<c:out value='${company.website}'/>" target="_blank" rel="noopener noreferrer" class="btn btn-outline btn-sm">
                    Visit Official Website &#8599;
                </a>
            </c:if>
        </div>

        <c:if test="${not empty company.description}">
            <div style="margin-top: 1.75rem; padding-top: 1.75rem; border-top: 1px solid var(--color-border); font-size: 0.98rem; line-height: 1.75; color: var(--color-text-main);">
                <p><c:out value="${company.description}" /></p>
            </div>
        </c:if>
    </div>

    <!-- Active Jobs Posted by this Company -->
    <div class="section-header">
        <div>
            <h2 class="section-title">Open Positions at <c:out value="${company.companyName}"/></h2>
            <p class="section-subtitle">Join their team and advance your career journey</p>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty companyJobs}">
            <div class="jobs-grid">
                <c:forEach var="job" items="${companyJobs}">
                    <div class="job-card">
                        <div>
                            <div class="job-card-header">
                                <div class="job-header-info">
                                    <h3 class="job-title">
                                        <a href="${pageContext.request.contextPath}/job-details?id=${job.id}">
                                            <c:out value="${job.title}" />
                                        </a>
                                    </h3>
                                    <div class="job-company"><c:out value="${company.companyName}" /></div>
                                </div>
                            </div>

                            <div class="job-meta-pills">
                                <span class="meta-pill">&#128205; <c:out value="${job.location}" /></span>
                                <span class="meta-pill">&#9200; <c:out value="${job.jobType}" /></span>
                                <span class="meta-pill">&#128193; <c:out value="${job.category}" /></span>
                            </div>

                            <p class="job-desc-snippet"><c:out value="${job.description}" /></p>

                            <div class="job-skills-list">
                                <c:forEach var="skill" items="${job.skillList}">
                                    <span class="skill-tag"><c:out value="${skill}" /></span>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="job-card-footer">
                            <span class="job-salary">${job.formattedSalary}</span>
                            <a href="${pageContext.request.contextPath}/job-details?id=${job.id}" class="btn btn-secondary btn-sm">
                                View Details &rarr;
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">&#128269;</div>
                <h3 class="empty-state-title">No current openings</h3>
                <p class="empty-state-text">This company currently has no active listings. Check back later or browse other partner companies!</p>
                <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">Browse All Jobs</a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
