<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Footer Section -->
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <h3>JOBIFY</h3>
                <p>
                    A modern, warm, and intuitive web-based online job portal connecting ambitious talent with visionary companies.
                </p>
            </div>

            <div class="footer-col">
                <h4>For Job Seekers</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/jobs">Explore Jobs</a></li>
                    <li><a href="${pageContext.request.contextPath}/companies">Featured Companies</a></li>
                    <li><a href="${pageContext.request.contextPath}/register?role=JOB_SEEKER">Create Seeker Profile</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Seeker Sign In</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>For Employers</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/register?role=EMPLOYER">Register Company</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Employer Sign In</a></li>
                    <li><a href="${pageContext.request.contextPath}/employer/jobs/create">Post a Job Opening</a></li>
                    <li><a href="${pageContext.request.contextPath}/employer/applications">Manage Applicants</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>College Viva Demo</h4>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/login">Admin Login (admin@jobify.com)</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Employer Login (techcorp@jobify.com)</a></li>
                    <li><a href="${pageContext.request.contextPath}/login">Seeker Login (alice@jobify.com)</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#architecture">MVC & Schema Overview</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 Jobify Portal. College Project: Jakarta EE, Servlets, JSP, JDBC, MySQL.</p>
            <p>Designed with Cozy Warm Cream, Beige &amp; Cocoa Brown Aesthetics.</p>
        </div>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
