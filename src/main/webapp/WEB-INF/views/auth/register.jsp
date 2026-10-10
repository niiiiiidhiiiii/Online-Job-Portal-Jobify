<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Create Account - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container container-narrow" style="padding: 4rem 1.5rem 5rem;">
    <div class="form-card">
        <div style="text-align: center; margin-bottom: 2rem;">
            <h1 style="font-family: var(--font-heading); font-size: 2rem; color: var(--color-espresso); font-weight: 800;">
                Join Jobify Today
            </h1>
            <p style="color: var(--color-text-muted); font-size: 0.95rem; margin-top: 0.35rem;">
                Select your account role to begin your experience
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/register" method="POST" id="register-form">
            <!-- Role Selection Radio Cards -->
            <div class="form-group">
                <label class="form-label">I am joining as:</label>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <label style="border: 2px solid ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'var(--color-border)' : 'var(--color-cocoa)'}; 
                                  background-color: ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'var(--color-card-bg)' : 'var(--color-cream)'}; 
                                  border-radius: 12px; padding: 1rem; cursor: pointer; display: flex; align-items: center; gap: 0.75rem;">
                        <input type="radio" 
                               name="role" 
                               value="JOB_SEEKER" 
                               ${param.role != 'EMPLOYER' and role != 'EMPLOYER' ? 'checked' : ''} 
                               onchange="updateRoleLabels('JOB_SEEKER')">
                        <div>
                            <div style="font-weight: 700; color: var(--color-espresso);">Job Seeker</div>
                            <div style="font-size: 0.8rem; color: var(--color-text-muted);">Looking for jobs &amp; internships</div>
                        </div>
                    </label>

                    <label style="border: 2px solid ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'var(--color-cocoa)' : 'var(--color-border)'}; 
                                  background-color: ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'var(--color-cream)' : 'var(--color-card-bg)'}; 
                                  border-radius: 12px; padding: 1rem; cursor: pointer; display: flex; align-items: center; gap: 0.75rem;">
                        <input type="radio" 
                               name="role" 
                               value="EMPLOYER" 
                               ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'checked' : ''} 
                               onchange="updateRoleLabels('EMPLOYER')">
                        <div>
                            <div style="font-weight: 700; color: var(--color-espresso);">Employer</div>
                            <div style="font-size: 0.8rem; color: var(--color-text-muted);">Posting roles &amp; hiring talent</div>
                        </div>
                    </label>
                </div>
            </div>

            <div class="form-group">
                <label for="name" class="form-label" id="name-label">
                    ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'Company Name' : 'Full Name'}
                </label>
                <input type="text" 
                       id="name" 
                       name="name" 
                       class="form-control" 
                       placeholder="e.g. Jane Doe or Acme Corp" 
                       value="<c:out value='${name}' />" 
                       required>
            </div>

            <div class="form-group">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" 
                       id="email" 
                       name="email" 
                       class="form-control" 
                       placeholder="name@example.com" 
                       value="<c:out value='${email}' />" 
                       required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-control" 
                           placeholder="At least 6 characters" 
                           minlength="6" 
                           required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" 
                           id="confirmPassword" 
                           name="confirmPassword" 
                           class="form-control" 
                           placeholder="Repeat password" 
                           minlength="6" 
                           required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg" id="btn-register-submit" style="margin-top: 1rem;">
                Create Account &rarr;
            </button>
        </form>

        <div style="text-align: center; margin-top: 1.8rem; font-size: 0.92rem; color: var(--color-text-muted);">
            Already have an account? 
            <a href="${pageContext.request.contextPath}/login" style="font-weight: 700; color: var(--color-cocoa);">
                Sign in here
            </a>
        </div>
    </div>
</main>

<script>
    function updateRoleLabels(selected) {
        const label = document.getElementById('name-label');
        const input = document.getElementById('name');
        if (selected === 'EMPLOYER') {
            label.innerText = 'Company Name';
            input.placeholder = 'e.g. Acme Innovations LLC';
        } else {
            label.innerText = 'Full Name';
            input.placeholder = 'e.g. Alice Johnson';
        }
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
