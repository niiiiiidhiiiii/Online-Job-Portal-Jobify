<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="404 - Page Not Found - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 5rem 1.5rem; text-align: center;">
    <div class="empty-state" style="max-width: 600px; margin: 0 auto; padding: 4rem 2rem;">
        <div class="empty-state-icon" style="background-color: var(--color-cream); color: var(--color-cocoa);">&#128269;</div>
        <h1 class="empty-state-title" style="font-size: 2rem;">404 - Page Not Found</h1>
        <p class="empty-state-text">
            The page or job listing you were looking for could not be found or may have been moved.
        </p>
        <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 1.5rem;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Return Home</a>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-secondary">Explore Jobs</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
