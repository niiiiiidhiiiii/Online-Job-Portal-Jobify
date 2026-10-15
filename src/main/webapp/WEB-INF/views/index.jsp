<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Jobify - Snatch Your Dream Job" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<!-- Hero Section (Matching exact visual design from reference) -->
<section class="hero-section">
    <!-- Left Decorative Botanical Vine Artwork -->
    <div class="hero-botanical-art" aria-hidden="true">
        <svg viewBox="0 0 140 500" fill="none" xmlns="http://www.w3.org/2000/svg" style="width: 100%; height: 100%;">
            <!-- Vertical flowing vine stem -->
            <path d="M40 0 C45 60 25 120 40 180 C55 240 20 300 35 360 C50 420 30 460 38 500" stroke="#7F5B45" stroke-width="2.5" stroke-linecap="round"/>
            
            <!-- Leaves along the vine -->
            <path d="M41 45 C55 35 62 48 42 55" fill="#EBD9C3" stroke="#7F5B45" stroke-width="1.5"/>
            <path d="M36 115 C20 105 15 120 35 125" fill="#EBD9C3" stroke="#7F5B45" stroke-width="1.5"/>
            <path d="M43 210 C60 200 65 218 43 222" fill="#EBD9C3" stroke="#7F5B45" stroke-width="1.5"/>
            <path d="M30 290 C12 280 10 300 30 302" fill="#EBD9C3" stroke="#7F5B45" stroke-width="1.5"/>
            <path d="M38 395 C55 385 60 405 38 410" fill="#EBD9C3" stroke="#7F5B45" stroke-width="1.5"/>

            <!-- Flower 1: Top White Flower -->
            <g transform="translate(40, 80)">
                <circle cx="-12" cy="0" r="8" fill="#FFFFFF"/>
                <circle cx="12" cy="0" r="8" fill="#FFFFFF"/>
                <circle cx="0" cy="-12" r="8" fill="#FFFFFF"/>
                <circle cx="0" cy="12" r="8" fill="#FFFFFF"/>
                <circle cx="-8" cy="-8" r="8" fill="#FFFFFF"/>
                <circle cx="8" cy="-8" r="8" fill="#FFFFFF"/>
                <circle cx="-8" cy="8" r="8" fill="#FFFFFF"/>
                <circle cx="8" cy="8" r="8" fill="#FFFFFF"/>
                <circle cx="0" cy="0" r="5" fill="#EBD9C3"/>
            </g>

            <!-- Flower 2: Dusty Rose Flower -->
            <g transform="translate(32, 160)">
                <circle cx="-10" cy="0" r="6.5" fill="#B8715F"/>
                <circle cx="10" cy="0" r="6.5" fill="#B8715F"/>
                <circle cx="0" cy="-10" r="6.5" fill="#B8715F"/>
                <circle cx="0" cy="10" r="6.5" fill="#B8715F"/>
                <circle cx="-7" cy="-7" r="6.5" fill="#B8715F"/>
                <circle cx="7" cy="-7" r="6.5" fill="#B8715F"/>
                <circle cx="-7" cy="7" r="6.5" fill="#B8715F"/>
                <circle cx="7" cy="7" r="6.5" fill="#B8715F"/>
                <circle cx="0" cy="0" r="4.5" fill="#5B3C2B"/>
            </g>

            <!-- Flower 3: Middle White Flower -->
            <g transform="translate(38, 260)">
                <circle cx="-14" cy="0" r="9" fill="#FFFFFF"/>
                <circle cx="14" cy="0" r="9" fill="#FFFFFF"/>
                <circle cx="0" cy="-14" r="9" fill="#FFFFFF"/>
                <circle cx="0" cy="14" r="9" fill="#FFFFFF"/>
                <circle cx="-10" cy="-10" r="9" fill="#FFFFFF"/>
                <circle cx="10" cy="-10" r="9" fill="#FFFFFF"/>
                <circle cx="-10" cy="10" r="9" fill="#FFFFFF"/>
                <circle cx="10" cy="10" r="9" fill="#FFFFFF"/>
                <circle cx="0" cy="0" r="6" fill="#EBD9C3"/>
            </g>

            <!-- Flower 4: Dusty Rose Flower Lower -->
            <g transform="translate(32, 350)">
                <circle cx="-9" cy="0" r="6" fill="#B8715F"/>
                <circle cx="9" cy="0" r="6" fill="#B8715F"/>
                <circle cx="0" cy="-9" r="6" fill="#B8715F"/>
                <circle cx="0" cy="9" r="6" fill="#B8715F"/>
                <circle cx="-6" cy="-6" r="6" fill="#B8715F"/>
                <circle cx="6" cy="-6" r="6" fill="#B8715F"/>
                <circle cx="-6" cy="6" r="6" fill="#B8715F"/>
                <circle cx="6" cy="6" r="6" fill="#B8715F"/>
                <circle cx="0" cy="0" r="4" fill="#5B3C2B"/>
            </g>
        </svg>
    </div>

    <div class="container">
        <div class="hero-grid">
            <!-- Left Column (55%): Headline, Pill Search Bar & Popular Tags -->
            <div class="hero-content">
                <h1 class="hero-headline">
                    Snatch your dream<br>job with Jobify
                </h1>

                <!-- Search Pill Form -->
                <div class="hero-search-wrapper">
                    <form action="${pageContext.request.contextPath}/jobs" method="GET" class="hero-search-pill" id="hero-search-form">
                        <div class="hero-search-field">
                            <input type="text" 
                                   name="keyword" 
                                   class="hero-search-input" 
                                   id="hero-search-keyword"
                                   placeholder="Job title or keyword" 
                                   value="<c:out value='${param.keyword}'/>"
                                   aria-label="Job title or keyword">
                        </div>

                        <div class="hero-search-divider"></div>

                        <div class="hero-search-field">
                            <input type="text" 
                                   name="location" 
                                   class="hero-search-input" 
                                   id="hero-search-location"
                                   placeholder="City or remote" 
                                   value="<c:out value='${param.location}'/>"
                                   aria-label="City or remote">
                        </div>

                        <button type="submit" class="hero-search-button" id="hero-search-submit-btn">
                            Search job
                        </button>
                    </form>

                    <!-- Popular Search Chips -->
                    <div class="hero-popular-tags">
                        <span class="hero-popular-label">Popular:</span>
                        <a href="${pageContext.request.contextPath}/jobs?keyword=Java" class="hero-tag">Java</a>
                        <a href="${pageContext.request.contextPath}/jobs?jobType=Remote" class="hero-tag">Remote</a>
                        <a href="${pageContext.request.contextPath}/jobs?keyword=UI%2FUX" class="hero-tag">UI/UX Design</a>
                        <a href="${pageContext.request.contextPath}/jobs?jobType=Full-Time" class="hero-tag">Full-Time</a>
                        <a href="${pageContext.request.contextPath}/jobs?keyword=MySQL" class="hero-tag">MySQL</a>
                        <a href="${pageContext.request.contextPath}/jobs?jobType=Internship" class="hero-tag">Internships</a>
                    </div>
                </div>
            </div>

            <!-- Right Column (45%): Floating Match Cards Visual Area -->
            <div class="hero-visual-area" aria-hidden="true">
                <div class="hero-cards-cluster">
                    <!-- Card 1: Top Left (tilted) -->
                    <div class="floating-job-card card-slot-1">
                        <div class="card-top-row">
                            <div class="card-avatar-box">N</div>
                            <span class="card-match-label">92% match</span>
                        </div>
                        <div class="card-job-title">Junior Java Developer</div>
                        <div class="card-company-sub">Northwind Labs &bull; Delhi</div>
                        <span class="card-tag-pill">Full-Time</span>
                    </div>

                    <!-- Card 2: Top Right (tilted) -->
                    <div class="floating-job-card card-slot-2">
                        <div class="card-top-row">
                            <div class="card-avatar-box" style="background-color: #5B3C2B;">B</div>
                            <span class="card-match-label">87% match</span>
                        </div>
                        <div class="card-job-title">UI/UX Design Intern</div>
                        <div class="card-company-sub">Bloom Studio &bull; Remote</div>
                        <span class="card-tag-pill">Internship</span>
                    </div>

                    <!-- Card 3: Bottom Left (tilted) -->
                    <div class="floating-job-card card-slot-3">
                        <div class="card-top-row">
                            <div class="card-avatar-box" style="background-color: #382315;">K</div>
                            <span class="card-match-label">81% match</span>
                        </div>
                        <div class="card-job-title">MySQL Data Analyst</div>
                        <div class="card-company-sub">Kite Analytics &bull; Noida</div>
                        <span class="card-tag-pill">Hybrid</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Stats Band (Directly below hero with cream background) -->
<section class="stats-banner">
    <div class="container">
        <div class="stats-grid-band">
            <div class="stat-item-band">
                <h3>${stats.activeJobs > 0 ? stats.activeJobs : '12+'}</h3>
                <p>Active job openings</p>
            </div>
            <div class="stat-item-band">
                <h3>${stats.totalEmployers > 0 ? stats.totalEmployers : '2'}</h3>
                <p>Verified companies</p>
            </div>
            <div class="stat-item-band">
                <h3>${stats.totalJobSeekers > 0 ? stats.totalJobSeekers : '3'}</h3>
                <p>Active job seekers</p>
            </div>
            <div class="stat-item-band">
                <h3>${stats.totalApplications > 0 ? stats.totalApplications : '40+'}</h3>
                <p>Applications processed</p>
            </div>
        </div>
    </div>
</section>

<!-- Explore by Industry Section (3-Column Layout) -->
<section class="container" style="padding: 4.5rem 1.75rem 2.5rem;" id="industries">
    <div class="section-header">
        <div>
            <h2 class="section-title">Explore by Industry</h2>
            <p class="section-subtitle">Discover high-growth openings categorized across leading domains</p>
        </div>
        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline btn-sm">Browse All Openings &rarr;</a>
    </div>

    <div class="category-grid">
        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/jobs?category=${cat}" class="category-card">
                <div class="category-icon-box">&#128188;</div>
                <div class="category-name"><c:out value="${cat}" /></div>
                <div class="category-desc">Explore verified full-time, remote, and internship roles.</div>
                <div class="category-link-cta">View open listings &rarr;</div>
            </a>
        </c:forEach>
    </div>
</section>

<!-- "How Jobify Works" Section -->
<section class="workflow-section" id="how-it-works">
    <div class="container">
        <div class="section-header" style="text-align: center; justify-content: center; margin-bottom: 3rem;">
            <div>
                <h2 class="section-title">How Jobify Works</h2>
                <p class="section-subtitle">A seamless journey connecting ambitious candidates with world-class employers</p>
            </div>
        </div>

        <div class="workflow-grid">
            <div class="workflow-card">
                <div class="workflow-step-num">01</div>
                <div class="workflow-icon-wrap">&#128100;</div>
                <h3>Create Your Profile</h3>
                <p>Register as a job seeker or employer in seconds. Add your background, skills, and portfolio highlights to stand out.</p>
            </div>

            <div class="workflow-card">
                <div class="workflow-step-num">02</div>
                <div class="workflow-icon-wrap">&#128161;</div>
                <h3>Smart Skill Matching</h3>
                <p>Our recommendation engine compares your profile skills directly with job requirements, highlighting compatibility percentages.</p>
            </div>

            <div class="workflow-card">
                <div class="workflow-step-num">03</div>
                <div class="workflow-icon-wrap">&#128640;</div>
                <h3>Apply &amp; Get Hired</h3>
                <p>Submit targeted applications with customized cover letters, track review status live, and communicate directly with hiring teams.</p>
            </div>
        </div>
    </div>
</section>

<!-- Featured Job Opportunities Section -->
<section class="container" style="padding: 4.5rem 1.75rem;">
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
                <p class="empty-state-text">Be the first employer to post a role or check back shortly as companies list openings!</p>
                <a href="${pageContext.request.contextPath}/employer/jobs/create" class="btn btn-primary">Post a Job Opening</a>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<!-- Closing Call-To-Action Banner -->
<section class="cta-banner-section">
    <div class="container">
        <div class="cta-box">
            <h2>Ready to Take the Next Step?</h2>
            <p>Join thousands of professionals and forward-thinking companies building their future on Jobify.</p>
            <div class="cta-actions">
                <a href="${pageContext.request.contextPath}/register?role=JOB_SEEKER" class="btn btn-primary btn-lg">
                    Find Your Next Role &rarr;
                </a>
                <a href="${pageContext.request.contextPath}/register?role=EMPLOYER" class="btn btn-outline btn-lg" style="background-color: var(--color-sand);">
                    Post Open Positions
                </a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
