<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Footer Section -->
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <a href="${pageContext.request.contextPath}/home" class="brand-logo" style="font-size: 34px;">
                    JOBIFY
                </a>
                <p>
                    A modern, warm, and intuitive job platform connecting ambitious talent with visionary companies across high-growth industries.
                </p>
            </div>

            <div class="footer-col">
                <h4>For Job Seekers</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/jobs">Explore All Jobs</a></li>
                    <li><a href="${pageContext.request.contextPath}/companies">Featured Companies</a></li>
                    <li><a href="${pageContext.request.contextPath}/register?role=JOB_SEEKER">Create Seeker Profile</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Candidate Sign In</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>For Employers</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/register?role=EMPLOYER">Register Organization</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Employer Sign In</a></li>
                    <li><a href="${pageContext.request.contextPath}/employer/jobs/create">Post a Job Opening</a></li>
                    <li><a href="${pageContext.request.contextPath}/employer/applications">Manage Applicants</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Platform &amp; Growth</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/jobs?jobType=Remote">Remote Opportunities</a></li>
                    <li><a href="${pageContext.request.contextPath}/jobs?jobType=Internship">Internship Programs</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#how-it-works">How Jobify Works</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#industries">Trending Industries</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 Jobify Inc. All rights reserved.</p>
            <p>Designed Diva Codez.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
