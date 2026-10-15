<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Create Account - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container container-narrow" style="padding: 4.5rem 1.5rem 6rem;">
    <div class="form-card">
        <div style="text-align: center; margin-bottom: 2.25rem;">
            <h1 style="font-family: var(--font-heading); font-size: 2.2rem; color: var(--color-dark-brown); font-weight: 700;">
                Join Jobify Today
            </h1>
            <p style="color: var(--color-text-muted); font-size: 0.98rem; margin-top: 0.35rem;">
                Select your account role to begin your experience
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/register" method="POST" id="register-form">
            <!-- Role Selection Radio Cards -->
            <div class="form-group">
                <label class="form-label">I am joining as:</label>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <label id="role-card-seeker" 
                           style="border: 2px solid ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'var(--color-border)' : 'var(--color-dark-brown)'}; 
                                  background-color: ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'var(--color-cream-soft)' : 'var(--color-sand)'}; 
                                  border-radius: 14px; padding: 1.15rem; cursor: pointer; display: flex; align-items: center; gap: 0.85rem; transition: all 0.2s ease;">
                        <input type="radio" 
                               name="role" 
                               value="JOB_SEEKER" 
                               ${param.role != 'EMPLOYER' and role != 'EMPLOYER' ? 'checked' : ''} 
                               onchange="updateRoleLabels('JOB_SEEKER')">
                        <div>
                            <div style="font-weight: 700; color: var(--color-dark-brown); font-size: 1.05rem;">Job Seeker</div>
                            <div style="font-size: 0.82rem; color: var(--color-text-muted);">Looking for jobs &amp; internships</div>
                        </div>
                    </label>

                    <label id="role-card-employer"
                           style="border: 2px solid ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'var(--color-dark-brown)' : 'var(--color-border)'}; 
                                  background-color: ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'var(--color-sand)' : 'var(--color-cream-soft)'}; 
                                  border-radius: 14px; padding: 1.15rem; cursor: pointer; display: flex; align-items: center; gap: 0.85rem; transition: all 0.2s ease;">
                        <input type="radio" 
                               name="role" 
                               value="EMPLOYER" 
                               ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'checked' : ''} 
                               onchange="updateRoleLabels('EMPLOYER')">
                        <div>
                            <div style="font-weight: 700; color: var(--color-dark-brown); font-size: 1.05rem;">Employer</div>
                            <div style="font-size: 0.82rem; color: var(--color-text-muted);">Posting roles &amp; hiring talent</div>
                        </div>
                    </label>
                </div>
            </div>

            <div class="form-group">
                <label for="name" class="form-label" id="name-label">
                    ${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'Company Name' : 'Full Name'} *
                </label>
                <input type="text" 
                       id="name" 
                       name="name" 
                       class="form-control" 
                       placeholder="${param.role == 'EMPLOYER' or role == 'EMPLOYER' ? 'e.g. Acme Innovations LLC' : 'e.g. Jane Doe'}" 
                       value="<c:out value='${name}' />" 
                       required>
            </div>

            <div class="form-group">
                <label for="email" class="form-label">Email Address *</label>
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
                    <label for="password" class="form-label">Password *</label>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-control" 
                           placeholder="At least 6 characters" 
                           minlength="6" 
                           required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password *</label>
                    <input type="password" 
                           id="confirmPassword" 
                           name="confirmPassword" 
                           class="form-control" 
                           placeholder="Repeat password" 
                           minlength="6" 
                           required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg" id="btn-register-submit" style="margin-top: 1.5rem;">
                Create Account &rarr;
            </button>
        </form>

        <div style="text-align: center; margin-top: 2rem; font-size: 0.94rem; color: var(--color-text-muted);">
            Already have an account? 
            <a href="${pageContext.request.contextPath}/login" style="font-weight: 700; color: var(--color-dark-brown);">
                Sign in here &rarr;
            </a>
        </div>
    </div>
</main>

<script>
    function updateRoleLabels(selected) {
        const label = document.getElementById('name-label');
        const input = document.getElementById('name');
        const seekerCard = document.getElementById('role-card-seeker');
        const employerCard = document.getElementById('role-card-employer');

        if (selected === 'EMPLOYER') {
            label.innerText = 'Company Name *';
            input.placeholder = 'e.g. Acme Innovations LLC';
            if (seekerCard && employerCard) {
                seekerCard.style.borderColor = 'var(--color-border)';
                seekerCard.style.backgroundColor = 'var(--color-cream-soft)';
                employerCard.style.borderColor = 'var(--color-dark-brown)';
                employerCard.style.backgroundColor = 'var(--color-sand)';
            }
        } else {
            label.innerText = 'Full Name *';
            input.placeholder = 'e.g. Jane Doe';
            if (seekerCard && employerCard) {
                seekerCard.style.borderColor = 'var(--color-dark-brown)';
                seekerCard.style.backgroundColor = 'var(--color-sand)';
                employerCard.style.borderColor = 'var(--color-border)';
                employerCard.style.backgroundColor = 'var(--color-cream-soft)';
            }
        }
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
