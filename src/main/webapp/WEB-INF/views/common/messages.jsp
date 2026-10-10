<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.jobify.service.SecurityService" %>
<%
    String flashMsg = (String) session.getAttribute(SecurityService.FLASH_MSG);
    String flashType = (String) session.getAttribute(SecurityService.FLASH_TYPE);
    if (flashMsg != null) {
        request.setAttribute("flashMsg", flashMsg);
        request.setAttribute("flashType", flashType != null ? flashType : "info");
        session.removeAttribute(SecurityService.FLASH_MSG);
        session.removeAttribute(SecurityService.FLASH_TYPE);
    }
%>

<div class="container" style="margin-top: 1rem;">
    <!-- Session Flash Message -->
    <c:if test="${not empty flashMsg}">
        <div class="alert alert-${flashType == 'danger' or flashType == 'error' ? 'danger' : (flashType == 'warning' ? 'warning' : 'success')}">
            <span><c:out value="${flashMsg}" /></span>
            <button type="button" class="alert-close" aria-label="Close">&times;</button>
        </div>
    </c:if>

    <!-- Request Scoped Error Message -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <span><c:out value="${error}" /></span>
            <button type="button" class="alert-close" aria-label="Close">&times;</button>
        </div>
    </c:if>

    <!-- Request Scoped Success Message -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">
            <span><c:out value="${success}" /></span>
            <button type="button" class="alert-close" aria-label="Close">&times;</button>
        </div>
    </c:if>
</div>
