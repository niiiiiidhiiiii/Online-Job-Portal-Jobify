<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile & Resume - Jobify" />
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
                    &#128202; Dashboard Overview
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/profile" class="sidebar-menu-link active">
                    &#128100; My Profile &amp; Resume
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/applications" class="sidebar-menu-link">
                    &#128221; Track Applications
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/seeker/recommendations" class="sidebar-menu-link">
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

    <!-- Profile Edit Form -->
    <main class="dashboard-content">
        <div class="section-header">
            <div>
                <h1 class="section-title">My Candidate Profile</h1>
                <p class="section-subtitle">Keep your skills and resume details current for employers and smart match recommendations</p>
            </div>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/seeker/profile" method="POST">
                <!-- Basic Contact Info -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName" class="form-label">Full Name *</label>
                        <input type="text" 
                               id="fullName" 
                               name="fullName" 
                               class="form-control" 
                               value="<c:out value='${profile.fullName}'/>" 
                               required>
                    </div>

                    <div class="form-group">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="text" 
                               id="phone" 
                               name="phone" 
                               class="form-control" 
                               placeholder="+1 (555) 000-0000" 
                               value="<c:out value='${profile.phone}'/>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="headline" class="form-label">Professional Headline</label>
                        <input type="text" 
                               id="headline" 
                               name="headline" 
                               class="form-control" 
                               placeholder="e.g. Full-Stack Developer | Java, MySQL & React" 
                               value="<c:out value='${profile.headline}'/>">
                    </div>

                    <div class="form-group">
                        <label for="location" class="form-label">Location (City, Country / Remote)</label>
                        <input type="text" 
                               id="location" 
                               name="location" 
                               class="form-control" 
                               placeholder="e.g. San Francisco, CA or Remote" 
                               value="<c:out value='${profile.location}'/>">
                    </div>
                </div>

                <!-- Skills for Matching Engine -->
                <div class="form-group">
                    <label for="skills" class="form-label">Skills &amp; Technologies (Used for Job Recommendations) *</label>
                    <input type="text" 
                           id="skills" 
                           name="skills" 
                           class="form-control" 
                           placeholder="Java, Spring Boot, MySQL, Jakarta Servlets, HTML, CSS, JavaScript, Git" 
                           value="<c:out value='${profile.skills}'/>" 
                           required>
                    <div class="form-hint">Separate individual skills with commas. Our recommendation engine uses these to match you with top jobs.</div>
                </div>

                <div class="form-group">
                    <label for="bio" class="form-label">Professional Summary / Bio</label>
                    <textarea id="bio" 
                              name="bio" 
                              class="form-control" 
                              rows="3" 
                              placeholder="A brief overview of your background, career interests, and passions..."><c:out value="${profile.bio}"/></textarea>
                </div>

                <!-- Education & Experience -->
                <div class="form-group">
                    <label for="education" class="form-label">Education History</label>
                    <textarea id="education" 
                              name="education" 
                              class="form-control" 
                              rows="2" 
                              placeholder="e.g. B.S. in Computer Science, University Name (2021 - 2025)"><c:out value="${profile.education}"/></textarea>
                </div>

                <div class="form-group">
                    <label for="experience" class="form-label">Work &amp; Internship Experience</label>
                    <textarea id="experience" 
                              name="experience" 
                              class="form-control" 
                              rows="3" 
                              placeholder="e.g. Software Engineer at Company (2 years). Built REST APIs and scalable database layers."><c:out value="${profile.experience}"/></textarea>
                </div>

                <!-- Resume URL and Resume Highlights -->
                <div class="form-group">
                    <label for="resumeUrl" class="form-label">Online Portfolio / Resume Link (GitHub / LinkedIn / Drive)</label>
                    <input type="url" 
                           id="resumeUrl" 
                           name="resumeUrl" 
                           class="form-control" 
                           placeholder="https://github.com/yourhandle or https://linkedin.com/in/yourprofile" 
                           value="<c:out value='${profile.resumeUrl}'/>">
                </div>

                <div class="form-group">
                    <label for="resumeSummary" class="form-label">Default Resume Summary (Auto-attached to Applications)</label>
                    <textarea id="resumeSummary" 
                              name="resumeSummary" 
                              class="form-control" 
                              rows="3" 
                              placeholder="Core highlights from your CV that will be submitted with each job application..."><c:out value="${profile.resumeSummary}"/></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary btn-lg" id="btn-save-profile">
                        Save Profile Changes &rarr;
                    </button>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
