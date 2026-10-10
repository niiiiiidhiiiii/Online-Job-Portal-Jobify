<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign In - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container container-narrow" style="padding: 4rem 1.5rem 5rem;">
    <div class="form-card">
        <div style="text-align: center; margin-bottom: 2rem;">
            <h1 style="font-family: var(--font-heading); font-size: 2rem; color: var(--color-espresso); font-weight: 800;">
                Welcome Back to Jobify
            </h1>
            <p style="color: var(--color-text-muted); font-size: 0.95rem; margin-top: 0.35rem;">
                Sign in to manage your career journey or hiring pipeline
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/login" method="POST" id="login-form">
            <div class="form-group">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       class="form-control" 
                       placeholder="name@example.com" 
                       value="<c:out value='${email}' />" 
                       required 
                       autofocus>
            </div>

            <div class="form-group">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.45rem;">
                    <label for="password" class="form-label" style="margin-bottom: 0;">Password</label>
                    <span style="font-size: 0.8rem; color: var(--color-text-muted);">Protected by BCrypt</span>
                </div>
                <input type="password" 
                       id="password" 
                       name="password" 
                       class="form-control" 
                       placeholder="Enter your account password" 
                       required>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg" id="btn-login-submit" style="margin-top: 1rem;">
                Sign In to Account &rarr;
            </button>
        </form>

        <!-- Quick 1-Click Demo Fill for Evaluators / Viva -->
        <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px dashed var(--color-border); text-align: center;">
            <p style="font-size: 0.82rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: var(--color-cocoa); margin-bottom: 0.75rem;">
                Quick Demo Accounts (College Evaluation)
            </p>
            <div style="display: flex; gap: 0.5rem; justify-content: center; flex-wrap: wrap;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCredentials('admin@jobify.com', 'Admin@123')">
                    &#128081; Admin
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCredentials('techcorp@jobify.com', 'Employer@123')">
                    &#127970; Employer (TechCorp)
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCredentials('alice@jobify.com', 'Seeker@123')">
                    &#128188; Seeker (Alice)
                </button>
            </div>
        </div>

        <div style="text-align: center; margin-top: 1.8rem; font-size: 0.92rem; color: var(--color-text-muted);">
            Don't have an account yet? 
            <a href="${pageContext.request.contextPath}/register" style="font-weight: 700; color: var(--color-cocoa);">
                Create one now
            </a>
        </div>
    </div>
</main>

<script>
    function fillCredentials(email, pwd) {
        document.getElementById('email').value = email;
        document.getElementById('password').value = pwd;
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
