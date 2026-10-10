<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Review Applicants - Jobify" />
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
                <a href="${pageContext.request.contextPath}/employer/applications" class="sidebar-menu-link active">
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

    <!-- Applicants Review Content -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">Candidate Pipeline</h1>
                <p class="section-subtitle">Review applications, evaluate candidate profiles, and advance hiring stages</p>
            </div>
        </div>

        <!-- Filter by Specific Job -->
        <div class="filter-bar" style="grid-template-columns: 1fr auto; margin-bottom: 1.5rem;">
            <form action="${pageContext.request.contextPath}/employer/applications" method="GET" style="display: flex; gap: 1rem; align-items: center; width: 100%;">
                <div style="flex: 1;">
                    <label class="form-label" style="font-size: 0.8rem;">Filter by Opening</label>
                    <select name="jobId" class="form-control" onchange="this.form.submit()">
                        <option value="">All Job Openings (${stats.employerTotalApplications} Total Candidates)</option>
                        <c:forEach var="mj" items="${myJobs}">
                            <option value="${mj.id}" ${selectedJobId == mj.id ? 'selected' : ''}>
                                <c:out value="${mj.title}" /> (${mj.applicationCount} Applicants)
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <c:if test="${not empty selectedJobId}">
                    <a href="${pageContext.request.contextPath}/employer/applications" class="btn btn-secondary btn-sm" style="align-self: flex-end;">
                        Reset
                    </a>
                </c:if>
            </form>
        </div>

        <c:choose>
            <c:when test="${not empty applicants}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Candidate Name</th>
                                <th>Position</th>
                                <th>Skills &amp; Headline</th>
                                <th>Applied Date</th>
                                <th>Status</th>
                                <th>Evaluation Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${applicants}">
                                <tr>
                                    <td>
                                        <div style="font-weight: 700; color: var(--color-espresso);">
                                            <c:out value="${not empty app.seekerName ? app.seekerName : app.seekerEmail}" />
                                        </div>
                                        <div style="font-size: 0.8rem; color: var(--color-text-muted);"><c:out value="${app.seekerEmail}" /></div>
                                        <c:if test="${not empty app.seekerPhone}">
                                            <div style="font-size: 0.78rem; color: var(--color-text-light);">&#128222; <c:out value="${app.seekerPhone}" /></div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div style="font-weight: 600;"><c:out value="${app.jobTitle}" /></div>
                                        <span class="meta-pill" style="font-size: 0.75rem;"><c:out value="${app.jobType}" /></span>
                                    </td>
                                    <td style="max-width: 260px;">
                                        <c:if test="${not empty app.seekerHeadline}">
                                            <div style="font-size: 0.85rem; font-weight: 600; color: var(--color-espresso); margin-bottom: 0.25rem;">
                                                <c:out value="${app.seekerHeadline}" />
                                            </div>
                                        </c:if>
                                        <div style="font-size: 0.8rem; color: var(--color-text-muted);">
                                            <c:out value="${not empty app.seekerSkills ? app.seekerSkills : 'No skills specified'}" />
                                        </div>
                                    </td>
                                    <td>${app.appliedAt.toString().substring(0, 10)}</td>
                                    <td>
                                        <span class="badge ${app.badgeClass}"><c:out value="${app.status}" /></span>
                                    </td>
                                    <td>
                                        <button type="button" 
                                                class="btn btn-secondary btn-sm" 
                                                onclick="openEvaluateModal('${app.id}', '<c:out value="${not empty app.seekerName ? app.seekerName : app.seekerEmail}"/>', '<c:out value="${app.jobTitle}"/>', '${app.status}', '<c:out value="${app.coverLetter}"/>', '<c:out value="${app.resumeSummary}"/>', '<c:out value="${app.seekerResumeUrl}"/>', '<c:out value="${app.employerNotes}"/>')">
                                            Evaluate &rarr;
                                        </button>
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
                    <h3 class="empty-state-title">No candidates found</h3>
                    <p class="empty-state-text">No job seekers have applied to the selected job opening yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<!-- Candidate Evaluation Modal -->
<div class="modal-overlay" id="evaluateModal">
    <div class="modal-content" style="max-width: 680px;">
        <div class="modal-header">
            <div>
                <h3 class="modal-title" id="evalCandidateName">Candidate Evaluation</h3>
                <div style="font-size: 0.85rem; color: var(--color-text-muted);" id="evalJobTitle"></div>
            </div>
            <button type="button" class="modal-close-btn" onclick="closeModal('evaluateModal')">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/employer/application/status" method="POST">
            <input type="hidden" name="applicationId" id="evalAppId">

            <div class="modal-body">
                <!-- Cover Letter -->
                <div style="margin-bottom: 1.25rem;">
                    <div style="font-size: 0.82rem; text-transform: uppercase; font-weight: 700; color: var(--color-text-muted); margin-bottom: 0.35rem;">
                        Candidate Cover Letter
                    </div>
                    <div id="evalCoverLetter" style="background-color: var(--color-cream); padding: 0.9rem; border-radius: 8px; font-size: 0.9rem; white-space: pre-line; line-height: 1.6; max-height: 160px; overflow-y: auto;"></div>
                </div>

                <!-- Resume Summary -->
                <div style="margin-bottom: 1.25rem;">
                    <div style="font-size: 0.82rem; text-transform: uppercase; font-weight: 700; color: var(--color-text-muted); margin-bottom: 0.35rem;">
                        Resume / Experience Summary
                    </div>
                    <div id="evalResumeSummary" style="background-color: var(--color-cream-light); border: 1px solid var(--color-border); padding: 0.9rem; border-radius: 8px; font-size: 0.9rem; white-space: pre-line; line-height: 1.6; max-height: 140px; overflow-y: auto;"></div>
                </div>

                <!-- Online Resume Link if available -->
                <div id="evalResumeUrlWrapper" style="margin-bottom: 1.25rem; display: none;">
                    <a id="evalResumeUrl" href="#" target="_blank" rel="noopener noreferrer" class="btn btn-outline btn-sm">
                        Open Candidate Online Portfolio / Resume &#8599;
                    </a>
                </div>

                <!-- Update Status & Notes -->
                <div class="form-group" style="padding-top: 1rem; border-top: 1px solid var(--color-border);">
                    <label for="evalStatus" class="form-label">Update Application Stage *</label>
                    <select id="evalStatus" name="status" class="form-control" required>
                        <option value="PENDING">Pending Review</option>
                        <option value="SHORTLISTED">Shortlisted for Interview</option>
                        <option value="ACCEPTED">Offer Accepted / Hired</option>
                        <option value="REJECTED">Application Rejected</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="evalNotes" class="form-label">Feedback Notes / Interview Instructions (Visible to Candidate)</label>
                    <textarea id="evalNotes" name="notes" class="form-control" rows="2" placeholder="e.g. Qualified for round 1. Technical interview scheduled for next Tuesday..."></textarea>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('evaluateModal')">Cancel</button>
                <button type="submit" class="btn btn-primary" id="btn-save-evaluation">
                    Save Status Update &rarr;
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openEvaluateModal(appId, name, jobTitle, currentStatus, coverLetter, resumeSummary, resumeUrl, notes) {
        document.getElementById('evalAppId').value = appId;
        document.getElementById('evalCandidateName').innerText = name;
        document.getElementById('evalJobTitle').innerText = 'Applied for ' + jobTitle;
        document.getElementById('evalCoverLetter').innerText = coverLetter ? coverLetter : 'No cover letter submitted.';
        document.getElementById('evalResumeSummary').innerText = resumeSummary ? resumeSummary : 'No resume summary provided.';
        document.getElementById('evalStatus').value = currentStatus;
        document.getElementById('evalNotes').value = notes ? notes : '';

        const urlWrapper = document.getElementById('evalResumeUrlWrapper');
        const urlLink = document.getElementById('evalResumeUrl');
        if (resumeUrl && resumeUrl.trim() !== '') {
            urlLink.href = resumeUrl;
            urlWrapper.style.display = 'block';
        } else {
            urlWrapper.style.display = 'none';
        }

        openModal('evaluateModal');
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
