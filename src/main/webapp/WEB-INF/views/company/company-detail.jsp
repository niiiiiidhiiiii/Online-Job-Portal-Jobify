<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${company.companyName} - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 3.5rem 1.5rem 5rem;">
    <!-- Company Profile Header Card -->
    <div class="form-card" style="margin-bottom: 2.5rem;">
        <div style="display: flex; align-items: center; gap: 1.5rem; flex-wrap: wrap;">
            <div class="job-company-avatar" style="width: 72px; height: 72px; font-size: 1.8rem; border-radius: 18px;">
                ${company.companyName.substring(0, 1).toUpperCase()}
            </div>
            <div style="flex: 1;">
                <h1 style="font-family: var(--font-heading); font-size: 2rem; font-weight: 800; color: var(--color-espresso);">
                    <c:out value="${company.companyName}" />
                </h1>
                <div style="font-size: 1rem; color: var(--color-text-muted); margin-top: 0.25rem;">
                    &#128188; <c:out value="${not empty company.industry ? company.industry : 'General Industry'}" /> &bull; 
                    &#128205; <c:out value="${not empty company.location ? company.location : 'Remote'}" /> &bull; 
                    &#128101; <c:out value="${not empty company.companySize ? company.companySize : '10-50'} team members" />
                </div>
            </div>

            <c:if test="${not empty company.website}">
                <a href="<c:out value='${company.website}'/>" target="_blank" rel="noopener noreferrer" class="btn btn-outline btn-sm">
                    Visit Official Website &#8599;
                </a>
            </c:if>
        </div>

        <c:if test="${not empty company.description}">
            <div style="margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--color-border); font-size: 0.95rem; line-height: 1.7; color: var(--color-text-main);">
                <p><c:out value="${company.description}" /></p>
            </div>
        </c:if>
    </div>

    <!-- Active Jobs Posted by this Company -->
    <div class="section-header">
        <div>
            <h2 class="section-title">Open Positions at <c:out value="${company.companyName}"/></h2>
            <p class="section-subtitle">Join their team and advance your career</p>
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
                <p class="empty-state-text">This company currently has no active listings. Check back later!</p>
                <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">Browse All Jobs</a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
