<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Explore Jobs - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 3rem 1.5rem 5rem;">
    <!-- Page Title -->
    <div class="section-header">
        <div>
            <h1 class="section-title">Explore Job Opportunities</h1>
            <p class="section-subtitle">Showing ${totalJobs} open positions across top categories</p>
        </div>
        <c:if test="${not empty currentUser and currentUser.employer}">
            <a href="${pageContext.request.contextPath}/employer/jobs/create" class="btn btn-primary btn-sm">
                + Post New Opening
            </a>
        </c:if>
    </div>

    <!-- Search & Filter Toolbar -->
    <form action="${pageContext.request.contextPath}/jobs" method="GET" class="filter-bar" id="job-filter-form">
        <div>
            <label class="form-label" style="font-size: 0.8rem;">Keyword</label>
            <input type="text" 
                   name="keyword" 
                   class="form-control" 
                   placeholder="Title, skill, or keyword" 
                   value="<c:out value='${keyword}'/>">
        </div>

        <div>
            <label class="form-label" style="font-size: 0.8rem;">Location</label>
            <input type="text" 
                   name="location" 
                   class="form-control" 
                   placeholder="City, State, or Remote" 
                   value="<c:out value='${location}'/>">
        </div>

        <div>
            <label class="form-label" style="font-size: 0.8rem;">Category</label>
            <select name="category" class="form-control">
                <option value="ALL">All Categories</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat}" ${category == cat ? 'selected' : ''}><c:out value="${cat}"/></option>
                </c:forEach>
            </select>
        </div>

        <div>
            <label class="form-label" style="font-size: 0.8rem;">Job Type</label>
            <select name="jobType" class="form-control">
                <option value="ALL">All Job Types</option>
                <option value="Full-Time" ${jobType == 'Full-Time' ? 'selected' : ''}>Full-Time</option>
                <option value="Part-Time" ${jobType == 'Part-Time' ? 'selected' : ''}>Part-Time</option>
                <option value="Remote" ${jobType == 'Remote' ? 'selected' : ''}>Remote</option>
                <option value="Internship" ${jobType == 'Internship' ? 'selected' : ''}>Internship</option>
                <option value="Contract" ${jobType == 'Contract' ? 'selected' : ''}>Contract</option>
            </select>
        </div>

        <div>
            <label class="form-label" style="font-size: 0.8rem;">Min Salary ($)</label>
            <input type="number" 
                   name="minSalary" 
                   class="form-control" 
                   placeholder="e.g. 50000" 
                   value="<c:out value='${minSalary}'/>">
        </div>

        <div style="display: flex; gap: 0.5rem; align-self: flex-end;">
            <button type="submit" class="btn btn-primary" id="btn-apply-filters">
                Filter
            </button>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-secondary" title="Clear filters">
                Clear
            </a>
        </div>
    </form>

    <!-- Jobs Grid -->
    <c:choose>
        <c:when test="${not empty jobs}">
            <div class="jobs-grid">
                <c:forEach var="job" items="${jobs}">
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
                                <c:if test="${job.matchScore > 0}">
                                    <span class="badge badge-match" title="Skill match based on your profile">
                                        ${job.matchScore}% Match
                                    </span>
                                </c:if>
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

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:forEach var="p" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/jobs?keyword=<c:out value='${keyword}'/>&location=<c:out value='${location}'/>&category=<c:out value='${category}'/>&jobType=<c:out value='${jobType}'/>&minSalary=<c:out value='${minSalary}'/>&page=${p}" 
                           class="page-link ${currentPage == p ? 'active' : ''}">
                            ${p}
                        </a>
                    </c:forEach>
                </div>
            </c:if>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">&#128269;</div>
                <h3 class="empty-state-title">No jobs match your search</h3>
                <p class="empty-state-text">
                    Try adjusting your search criteria, clearing salary or location filters to see more results.
                </p>
                <a href="${pageContext.request.contextPath}/jobs" class="btn btn-secondary">
                    Clear All Filters
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
