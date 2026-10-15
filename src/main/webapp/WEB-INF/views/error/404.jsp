<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="404 - Page Not Found - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 5rem 1.5rem; text-align: center; min-height: 60vh; display: flex; align-items: center; justify-content: center;">
    <div class="empty-state" style="max-width: 580px; width: 100%; margin: 0 auto; padding: 3.5rem 2.5rem; background: #FFFFFF; border: 1px solid var(--color-sand); border-radius: 20px; box-shadow: var(--shadow-sm);">
        <div class="empty-state-icon" style="background-color: var(--color-sand); color: var(--color-primary-brown); font-size: 2.2rem; width: 72px; height: 72px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1.25rem;">&#128269;</div>
        <h1 class="empty-state-title" style="font-size: 2rem; color: var(--color-dark-brown); margin-bottom: 0.75rem;">Page Not Found</h1>
        <p class="empty-state-text" style="color: var(--color-mid-brown); font-size: 0.98rem; line-height: 1.6; margin-bottom: 2rem;">
            The page or job listing you were looking for could not be found or may have been relocated.
        </p>
        <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary" style="padding: 0.75rem 1.75rem;">Return Home</a>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-secondary" style="padding: 0.75rem 1.75rem;">Explore Jobs</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
