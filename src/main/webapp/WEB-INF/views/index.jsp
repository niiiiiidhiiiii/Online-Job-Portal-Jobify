<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Jobify - Snatch Your Dream Job" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Hero Section (Faithfully matching user's reference mockup) -->
<section class="hero-section">
    <div class="container">
        <!-- Exact headline from mockup -->
        <h1 class="hero-headline">
            SNATCH YOUR DREAM JOB<br>
            WITH JOBIFY
        </h1>

        <!-- Search Bar (Pill shape container with white search button) -->
        <div class="hero-search-wrapper">
            <form action="${pageContext.request.contextPath}/jobs" method="GET" class="hero-search-pill" id="hero-search-form">
                <input type="text" 
                       name="keyword" 
                       class="hero-search-input" 
                       id="hero-search-keyword"
                       placeholder="Job title or keyword" 
                       value="<c:out value='${param.keyword}'/>"
                       aria-label="Job title or keyword">

                <button type="submit" class="hero-search-button" id="hero-search-submit-btn">
                    Search job
                </button>
            </form>

            <div class="hero-popular-tags">
                <span>Popular:</span>
                <a href="${pageContext.request.contextPath}/jobs?keyword=Java" class="hero-tag">Java</a>
                <a href="${pageContext.request.contextPath}/jobs?jobType=Remote" class="hero-tag">Remote</a>
                <a href="${pageContext.request.contextPath}/jobs?keyword=UI%2FUX" class="hero-tag">UI/UX Design</a>
                <a href="${pageContext.request.contextPath}/jobs?jobType=Full-Time" class="hero-tag">Full-Time</a>
                <a href="${pageContext.request.contextPath}/jobs?keyword=MySQL" class="hero-tag">MySQL</a>
                <a href="${pageContext.request.contextPath}/jobs?jobType=Internship" class="hero-tag">Internships</a>
            </div>
        </div>
    </div>
</section>

<!-- Deep Brown Statistics Banner -->
<section class="hero-bottom-band">
    <div class="container">
        <div class="stats-grid-band">
            <div class="stat-item-band">
                <h3>${stats.activeJobs > 0 ? stats.activeJobs : '12+'}</h3>
                <p>Active Job Openings</p>
            </div>
            <div class="stat-item-band">
                <h3>${stats.totalEmployers > 0 ? stats.totalEmployers : '8+'}</h3>
                <p>Verified Companies</p>
            </div>
            <div class="stat-item-band">
                <h3>${stats.totalJobSeekers > 0 ? stats.totalJobSeekers : '25+'}</h3>
                <p>Active Job Seekers</p>
            </div>
            <div class="stat-item-band">
                <h3>${stats.totalApplications > 0 ? stats.totalApplications : '40+'}</h3>
                <p>Applications Processed</p>
            </div>
        </div>
    </div>
</section>

<!-- Explore by Category Section -->
<section class="container" style="padding: 4rem 1.5rem 2rem;">
    <div class="section-header">
        <div>
            <h2 class="section-title">Explore by Industry</h2>
            <p class="section-subtitle">Find high-growth roles in trending sectors</p>
        </div>
        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline btn-sm">View All Jobs &rarr;</a>
    </div>

    <div class="category-grid">
        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/jobs?category=${cat}" class="category-card">
                <div class="category-icon">&#128188;</div>
                <div class="category-name"><c:out value="${cat}" /></div>
                <div class="category-desc">Explore verified listings</div>
            </a>
        </c:forEach>
    </div>
</section>

<!-- Featured Job Opportunities Section -->
<section class="container" style="padding: 2.5rem 1.5rem 4.5rem;">
    <div class="section-header">
        <div>
            <h2 class="section-title">Featured Opportunities</h2>
            <p class="section-subtitle">Hand-picked openings from forward-thinking employers</p>
        </div>
        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary btn-sm">Browse All Openings</a>
    </div>

    <c:choose>
        <c:when test="${not empty featuredJobs}">
            <div class="jobs-grid">
                <c:forEach var="job" items="${featuredJobs}">
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
                <h3 class="empty-state-title">No job openings yet</h3>
                <p class="empty-state-text">Be the first employer to post a role or check back shortly!</p>
                <a href="${pageContext.request.contextPath}/employer/jobs/create" class="btn btn-primary">Post a Job</a>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<!-- College Viva Technical Highlights Section -->
<section style="background-color: var(--color-card-bg-warm); border-top: 1px solid var(--color-border); padding: 3.5rem 0;" id="architecture">
    <div class="container">
        <div class="section-header" style="text-align: center; justify-content: center;">
            <div>
                <h2 class="section-title">Architecture &amp; Design Overview</h2>
                <p class="section-subtitle">Full-Stack Java Enterprise Architecture adhering to academic &amp; industry best practices</p>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1.5rem; margin-top: 1.5rem;">
            <div class="form-card" style="padding: 1.5rem;">
                <h3 style="font-family: var(--font-heading); color: var(--color-espresso); margin-bottom: 0.5rem;">
                    &#9881; MVC Architecture
                </h3>
                <p style="font-size: 0.88rem; color: var(--color-text-muted);">
                    Strict separation of concerns: POJO Models in <code>com.jobify.model</code>, real JDBC DAOs in <code>com.jobify.dao</code>, Jakarta Servlets controllers, and responsive JSP views with JSTL.
                </p>
            </div>

            <div class="form-card" style="padding: 1.5rem;">
                <h3 style="font-family: var(--font-heading); color: var(--color-espresso); margin-bottom: 0.5rem;">
                    &#128274; Security &amp; BCrypt
                </h3>
                <p style="font-size: 0.88rem; color: var(--color-text-muted);">
                    Passwords safely hashed via BCrypt with cryptographic salt. Role-based <code>AuthFilter</code> guards Seekers, Employers, and Admins. PreparedStatements prevent SQL injection.
                </p>
            </div>

            <div class="form-card" style="padding: 1.5rem;">
                <h3 style="font-family: var(--font-heading); color: var(--color-espresso); margin-bottom: 0.5rem;">
                    &#129302; Skill Matching Engine
                </h3>
                <p style="font-size: 0.88rem; color: var(--color-text-muted);">
                    <code>RecommendationService</code> normalizes applicant skills and job requirements with alias resolution, computing personalized compatibility percentages for every seeker.
                </p>
            </div>

            <div class="form-card" style="padding: 1.5rem;">
                <h3 style="font-family: var(--font-heading); color: var(--color-espresso); margin-bottom: 0.5rem;">
                    &#128190; Normalized Relational DB
                </h3>
                <p style="font-size: 0.88rem; color: var(--color-text-muted);">
                    Normalized 3NF MySQL/MariaDB schema with Foreign Keys, Cascading constraints, Indexes, and Unique constraints preventing duplicate applications.
                </p>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
