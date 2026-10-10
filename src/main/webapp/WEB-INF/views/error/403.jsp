<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="403 - Access Denied - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 5rem 1.5rem; text-align: center;">
    <div class="empty-state" style="max-width: 600px; margin: 0 auto; padding: 4rem 2rem;">
        <div class="empty-state-icon" style="background-color: #FEE2E2; color: #DC2626;">&#128274;</div>
        <h1 class="empty-state-title" style="font-size: 2rem;">403 - Access Denied</h1>
        <p class="empty-state-text">
            You do not have the required permissions or role privileges to view this section of Jobify.
        </p>
        <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 1.5rem;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Return Home</a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Switch Account</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
