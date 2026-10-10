<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="500 - System Notice - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 5rem 1.5rem; text-align: center;">
    <div class="empty-state" style="max-width: 600px; margin: 0 auto; padding: 4rem 2rem;">
        <div class="empty-state-icon" style="background-color: #FEF3C7; color: #D97706;">&#9888;</div>
        <h1 class="empty-state-title" style="font-size: 2rem;">Something Went Wrong</h1>
        <p class="empty-state-text">
            An unexpected error occurred while processing your request. If this is a new setup, ensure your MySQL database is active and schema has been loaded.
        </p>
        <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 1.5rem;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Return to Homepage</a>
            <a href="javascript:history.back()" class="btn btn-secondary">&larr; Go Back</a>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
