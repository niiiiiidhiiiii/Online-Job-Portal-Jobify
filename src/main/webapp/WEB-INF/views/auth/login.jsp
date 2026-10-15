<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign In - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container container-narrow" style="padding: 4.5rem 1.5rem 6rem;">
    <div class="form-card">
        <div style="text-align: center; margin-bottom: 2.25rem;">
            <h1 style="font-family: var(--font-heading); font-size: 2.2rem; color: var(--color-dark-brown); font-weight: 700;">
                Welcome Back to Jobify
            </h1>
            <p style="color: var(--color-text-muted); font-size: 0.98rem; margin-top: 0.35rem;">
                Sign in to manage your career opportunities or recruitment pipeline
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
                </div>
                <input type="password" 
                       id="password" 
                       name="password" 
                       class="form-control" 
                       placeholder="Enter your account password" 
                       required>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg" id="btn-login-submit" style="margin-top: 1.5rem;">
                Sign In to Account &rarr;
            </button>
        </form>

        <!-- Convenient Demo Shortcuts (Professional & Subtle) -->
        <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px dashed var(--color-border); text-align: center;">
            <p style="font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; color: var(--color-mid-brown); margin-bottom: 0.75rem;">
                Quick Demo Access
            </p>
            <div style="display: flex; gap: 0.5rem; justify-content: center; flex-wrap: wrap;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCredentials('alice@jobify.com', 'Seeker@123')">
                    Candidate Demo
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCredentials('techcorp@jobify.com', 'Employer@123')">
                    Employer Demo
                </button>
                <button type="button" class="btn btn-secondary btn-sm" onclick="fillCredentials('admin@jobify.com', 'Admin@123')">
                    Admin Demo
                </button>
            </div>
        </div>

        <div style="text-align: center; margin-top: 2rem; font-size: 0.94rem; color: var(--color-text-muted);">
            Don't have an account yet? 
            <a href="${pageContext.request.contextPath}/register" style="font-weight: 700; color: var(--color-dark-brown);">
                Create one now &rarr;
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
