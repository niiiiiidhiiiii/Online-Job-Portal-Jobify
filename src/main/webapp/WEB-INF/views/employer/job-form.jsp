<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${isEdit ? 'Edit Job Opening' : 'Post New Job'} - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="container dashboard-layout">
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
        <div class="sidebar-profile">
            <div class="sidebar-avatar">
                ${not empty currentUser.displayName ? currentUser.displayName.substring(0, 1).toUpperCase() : 'E'}
            </div>
            <div class="sidebar-name"><c:out value="${currentUser.displayName}" /></div>
            <div class="sidebar-role">Verified Organization</div>
        </div>

        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/employer/dashboard" class="sidebar-menu-link">
                    &#128202; Hiring Dashboard
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/employer/jobs" class="sidebar-menu-link ${not isEdit ? '' : 'active'}">
                    &#128188; Manage Job Listings
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/employer/jobs/create" class="sidebar-menu-link ${isEdit ? '' : 'active'}">
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

    <!-- Job Form -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">${isEdit ? 'Edit Job Listing' : 'Post a New Job Opening'}</h1>
                <p class="section-subtitle">
                    ${isEdit ? 'Update position specifications and applicant criteria' : 'Create an attractive listing to attract the best talent on Jobify'}
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-secondary btn-sm">
                &larr; Back to Listings
            </a>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/employer/jobs/${isEdit ? 'edit' : 'create'}" method="POST" class="job-form">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${job.id}">
                </c:if>

                <div class="form-group">
                    <label for="title" class="form-label">Job Title *</label>
                    <input type="text" 
                           id="title" 
                           name="title" 
                           class="form-control" 
                           placeholder="e.g. Senior Java Backend Engineer" 
                           value="<c:out value='${job.title}'/>" 
                           required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="category" class="form-label">Category / Industry *</label>
                        <select id="category" name="category" class="form-control" required>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" ${job.category == cat ? 'selected' : ''}><c:out value="${cat}"/></option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="jobType" class="form-label">Job Type *</label>
                        <select id="jobType" name="jobType" class="form-control" required>
                            <option value="Full-Time" ${job.jobType == 'Full-Time' ? 'selected' : ''}>Full-Time</option>
                            <option value="Part-Time" ${job.jobType == 'Part-Time' ? 'selected' : ''}>Part-Time</option>
                            <option value="Remote" ${job.jobType == 'Remote' ? 'selected' : ''}>Remote</option>
                            <option value="Internship" ${job.jobType == 'Internship' ? 'selected' : ''}>Internship</option>
                            <option value="Contract" ${job.jobType == 'Contract' ? 'selected' : ''}>Contract</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="location" class="form-label">Location (City, Country / Remote) *</label>
                        <input type="text" 
                               id="location" 
                               name="location" 
                               class="form-control" 
                               placeholder="e.g. New York, NY or Remote" 
                               value="<c:out value='${job.location}'/>" 
                               required>
                    </div>

                    <div class="form-group">
                        <label for="vacancies" class="form-label">Number of Vacancies</label>
                        <input type="number" 
                               id="vacancies" 
                               name="vacancies" 
                               class="form-control" 
                               min="1" 
                               value="${job.vacancies > 0 ? job.vacancies : 1}">
                    </div>

                    <div class="form-group">
                        <label for="deadline" class="form-label">Application Deadline</label>
                        <input type="date" 
                               id="deadline" 
                               name="deadline" 
                               class="form-control" 
                               value="${not empty job.deadline ? job.deadline : ''}">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="salaryMin" class="form-label">Minimum Salary ($ / year)</label>
                        <input type="number" 
                               id="salaryMin" 
                               name="salaryMin" 
                               class="form-control" 
                               placeholder="e.g. 70000" 
                               value="${job.salaryMin > 0 ? job.salaryMin : ''}">
                    </div>

                    <div class="form-group">
                        <label for="salaryMax" class="form-label">Maximum Salary ($ / year)</label>
                        <input type="number" 
                               id="salaryMax" 
                               name="salaryMax" 
                               class="form-control" 
                               placeholder="e.g. 95000" 
                               value="${job.salaryMax > 0 ? job.salaryMax : ''}">
                    </div>
                </div>

                <div class="form-group">
                    <label for="skillsRequired" class="form-label">Required Skills (Comma-Separated for Matching) *</label>
                    <input type="text" 
                           id="skillsRequired" 
                           name="skillsRequired" 
                           class="form-control" 
                           placeholder="Java, MySQL, Jakarta Servlets, Spring Boot, REST API" 
                           value="<c:out value='${job.skillsRequired}'/>" 
                           required>
                    <div class="form-hint">These skills are used to calculate candidate compatibility matches on Jobify.</div>
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">Full Job Description *</label>
                    <textarea id="description" 
                              name="description" 
                              class="form-control" 
                              rows="5" 
                              placeholder="Detail the daily responsibilities, team structure, and projects..." 
                              required><c:out value="${job.description}"/></textarea>
                </div>

                <div class="form-group">
                    <label for="requirements" class="form-label">Candidate Qualifications &amp; Requirements *</label>
                    <textarea id="requirements" 
                              name="requirements" 
                              class="form-control" 
                              rows="4" 
                              placeholder="Education, years of experience, technical background, and personal qualities required..." 
                              required><c:out value="${job.requirements}"/></textarea>
                </div>

                <div class="form-group">
                    <label for="status" class="form-label">Listing Status</label>
                    <select id="status" name="status" class="form-control" style="max-width: 260px;">
                        <option value="ACTIVE" ${job.status == 'ACTIVE' ? 'selected' : ''}>Active (Accepting Applications)</option>
                        <option value="CLOSED" ${job.status == 'CLOSED' ? 'selected' : ''}>Closed / Archived</option>
                    </select>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-secondary">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary btn-lg" id="btn-submit-job">
                        ${isEdit ? 'Update Job Listing' : 'Publish Job Opening'} &rarr;
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
