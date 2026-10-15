<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${job.title} at ${job.companyName} - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 3.5rem 1.75rem 6rem;">
    <!-- Breadcrumb Trail -->
    <div style="font-size: 0.9rem; color: var(--color-text-muted); margin-bottom: 2rem;">
        <a href="${pageContext.request.contextPath}/home">Home</a> &rsaquo;
        <a href="${pageContext.request.contextPath}/jobs">Jobs</a> &rsaquo;
        <span style="color: var(--color-dark-brown); font-weight: 700;"><c:out value="${job.title}"/></span>
    </div>

    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2.25rem;">
        <!-- Left Main Job Content -->
        <div>
            <div class="form-card" style="margin-bottom: 2rem;">
                <div style="display: flex; align-items: flex-start; justify-content: space-between; gap: 1.25rem; flex-wrap: wrap;">
                    <div style="display: flex; gap: 1.25rem; align-items: center;">
                        <div class="job-company-avatar" style="width: 64px; height: 64px; font-size: 1.6rem; border-radius: 16px;">
                            ${job.companyName.substring(0, 1).toUpperCase()}
                        </div>
                        <div>
                            <h1 style="font-family: var(--font-heading); font-size: 2rem; font-weight: 700; color: var(--color-dark-brown); line-height: 1.2;">
                                <c:out value="${job.title}" />
                            </h1>
                            <div style="font-size: 1.05rem; font-weight: 600; color: var(--color-mid-brown); margin-top: 0.25rem;">
                                <a href="${pageContext.request.contextPath}/company-details?id=${job.employerId}">
                                    <c:out value="${job.companyName}" /> &rarr;
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Match Score Badge (Dusty Rose Accent) -->
                    <c:if test="${matchScore > 0}">
                        <div style="background-color: var(--color-dusty-rose-light); border: 1px solid var(--color-dusty-rose-border); border-radius: 14px; padding: 0.65rem 1.15rem; text-align: center;">
                            <div style="font-size: 0.74rem; text-transform: uppercase; font-weight: 700; color: var(--color-dusty-rose); letter-spacing: 0.5px;">Profile Skill Match</div>
                            <div style="font-size: 1.4rem; font-weight: 800; color: var(--color-dusty-rose);">${matchScore}%</div>
                        </div>
                    </c:if>
                </div>

                <div class="job-meta-pills" style="margin-top: 1.5rem; margin-bottom: 1.5rem;">
                    <span class="meta-pill" style="padding: 0.35rem 0.85rem; font-size: 0.88rem;">&#128205; <c:out value="${job.location}" /></span>
                    <span class="meta-pill" style="padding: 0.35rem 0.85rem; font-size: 0.88rem;">&#9200; <c:out value="${job.jobType}" /></span>
                    <span class="meta-pill" style="padding: 0.35rem 0.85rem; font-size: 0.88rem;">&#128193; <c:out value="${job.category}" /></span>
                    <span class="meta-pill" style="padding: 0.35rem 0.85rem; font-size: 0.88rem;">&#128101; <c:out value="${job.vacancies}" /> Opening(s)</span>
                </div>

                <!-- Compensation & Quick Action Strip -->
                <div style="display: flex; align-items: center; justify-content: space-between; padding: 1.4rem; background-color: var(--color-card-bg-warm); border-radius: 14px; margin-bottom: 2.25rem; flex-wrap: wrap; gap: 1rem; border: 1px solid var(--color-border-subtle);">
                    <div>
                        <div style="font-size: 0.8rem; text-transform: uppercase; font-weight: 700; color: var(--color-text-muted); letter-spacing: 0.5px;">Target Compensation</div>
                        <div style="font-family: var(--font-editorial); font-size: 1.5rem; font-weight: 800; color: var(--color-dark-brown); margin-top: 0.15rem;">${job.formattedSalary}</div>
                    </div>

                    <div>
                        <c:choose>
                            <c:when test="${empty currentUser}">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg" id="btn-login-to-apply">
                                    Sign In to Apply
                                </a>
                            </c:when>
                            <c:when test="${currentUser.jobSeeker}">
                                <c:choose>
                                    <c:when test="${hasApplied}">
                                        <button class="btn btn-secondary btn-lg" disabled style="cursor: not-allowed; opacity: 0.85;">
                                            &#10004; Already Applied
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-primary btn-lg" onclick="openModal('applyModal')" id="btn-open-apply-modal">
                                            Apply for this Job &rarr;
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-pending" style="font-size: 0.9rem; padding: 0.6rem 1rem;">
                                    Browsing in ${currentUser.role.displayName} View
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Job Description -->
                <div style="margin-bottom: 2.25rem;">
                    <h3 style="font-family: var(--font-heading); font-size: 1.35rem; font-weight: 700; color: var(--color-dark-brown); margin-bottom: 0.85rem;">
                        Position Overview
                    </h3>
                    <p style="white-space: pre-line; color: var(--color-text-main); font-size: 0.98rem; line-height: 1.75;">
                        <c:out value="${job.description}" />
                    </p>
                </div>

                <!-- Requirements -->
                <div style="margin-bottom: 2.25rem;">
                    <h3 style="font-family: var(--font-heading); font-size: 1.35rem; font-weight: 700; color: var(--color-dark-brown); margin-bottom: 0.85rem;">
                        Candidate Requirements
                    </h3>
                    <p style="white-space: pre-line; color: var(--color-text-main); font-size: 0.98rem; line-height: 1.75;">
                        <c:out value="${job.requirements}" />
                    </p>
                </div>

                <!-- Required Skills -->
                <div>
                    <h3 style="font-family: var(--font-heading); font-size: 1.35rem; font-weight: 700; color: var(--color-dark-brown); margin-bottom: 0.85rem;">
                        Required Skills &amp; Qualifications
                    </h3>
                    <div class="job-skills-list">
                        <c:forEach var="skill" items="${job.skillList}">
                            <span class="skill-tag" style="padding: 0.4rem 0.9rem; font-size: 0.88rem;">
                                <c:out value="${skill}" />
                            </span>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Sidebar Info -->
        <div>
            <!-- Company Card -->
            <div class="form-card" style="margin-bottom: 1.5rem;">
                <h3 style="font-family: var(--font-heading); font-size: 1.25rem; font-weight: 700; color: var(--color-dark-brown); margin-bottom: 1rem;">
                    About the Employer
                </h3>
                <div style="font-size: 1.15rem; font-weight: 700; color: var(--color-dark-brown); margin-bottom: 0.35rem;">
                    <c:out value="${job.companyName}" />
                </div>
                <div style="font-size: 0.9rem; color: var(--color-text-muted); margin-bottom: 1.25rem;">
                    &#128205; <c:out value="${not empty job.companyLocation ? job.companyLocation : 'Remote / Hybrid'}" />
                </div>

                <c:if test="${not empty job.companyWebsite}">
                    <div style="margin-bottom: 0.85rem;">
                        <a href="<c:out value='${job.companyWebsite}'/>" target="_blank" rel="noopener noreferrer" class="btn btn-outline btn-sm btn-block">
                            Visit Official Website &#8599;
                        </a>
                    </div>
                </c:if>

                <a href="${pageContext.request.contextPath}/company-details?id=${job.employerId}" class="btn btn-secondary btn-sm btn-block">
                    View All Openings at <c:out value="${job.companyName}" />
                </a>
            </div>

            <!-- Job Meta Summary -->
            <div class="form-card">
                <h4 style="font-family: var(--font-heading); font-size: 1.1rem; font-weight: 700; color: var(--color-dark-brown); margin-bottom: 1rem;">
                    Opportunity Snapshot
                </h4>
                <div style="display: flex; flex-direction: column; gap: 0.85rem; font-size: 0.92rem;">
                    <div style="display: flex; justify-content: space-between;">
                        <span style="color: var(--color-text-muted);">Application Deadline:</span>
                        <span style="font-weight: 600;">${not empty job.deadline ? job.deadline : 'Open until filled'}</span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span style="color: var(--color-text-muted);">Job Ref ID:</span>
                        <span style="font-weight: 600;">#${job.id}</span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span style="color: var(--color-text-muted);">Posting Status:</span>
                        <span class="badge ${job.active ? 'badge-active' : 'badge-closed'}">${job.status}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Job Application Modal (Job Seekers) -->
<c:if test="${not empty currentUser and currentUser.jobSeeker and not hasApplied}">
    <div class="modal-overlay" id="applyModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Apply for ${job.title}</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('applyModal')">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/seeker/apply" method="POST">
                <div class="modal-body">
                    <input type="hidden" name="jobId" value="${job.id}">

                    <div style="padding: 1.1rem; background-color: var(--color-card-bg-warm); border-radius: 12px; margin-bottom: 1.5rem; border: 1px solid var(--color-border-subtle);">
                        <div style="font-weight: 700; color: var(--color-dark-brown); font-size: 1.05rem;">${currentUser.displayName}</div>
                        <div style="font-size: 0.88rem; color: var(--color-text-muted);">${currentUser.email}</div>
                    </div>

                    <div class="form-group">
                        <label for="coverLetter" class="form-label">Cover Letter / Note to Employer *</label>
                        <textarea id="coverLetter" 
                                  name="coverLetter" 
                                  class="form-control" 
                                  rows="4" 
                                  placeholder="Introduce yourself and explain why you're a great fit for this position..." 
                                  required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="resumeSummary" class="form-label">Resume Highlights / Key Experience</label>
                        <textarea id="resumeSummary" 
                                  name="resumeSummary" 
                                  class="form-control" 
                                  rows="3" 
                                  placeholder="Brief summary of skills, education, or link to online resume/portfolio..."><c:out value="${not empty seekerProfile ? seekerProfile.resumeSummary : ''}"/></textarea>
                        <div class="form-hint">Pre-filled from your seeker profile. You can customize before submitting.</div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('applyModal')">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="btn-submit-application">
                        Confirm &amp; Submit Application &rarr;
                    </button>
                </div>
            </form>
        </div>
    </div>
</c:if>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
