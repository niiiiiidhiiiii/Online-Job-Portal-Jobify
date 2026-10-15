<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Featured Companies - Jobify" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<main class="container" style="padding: 3.5rem 1.75rem 6rem;">
    <div class="section-header">
        <div>
            <h1 class="section-title">Partner Companies</h1>
            <p class="section-subtitle">Discover visionary organizations and forward-thinking teams hiring on Jobify</p>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty companies}">
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 1.75rem;">
                <c:forEach var="c" items="${companies}">
                    <div class="job-card">
                        <div>
                            <div class="job-card-header">
                                <div class="job-company-avatar" style="width: 56px; height: 56px; font-size: 1.5rem; border-radius: 14px;">
                                    ${c.companyName.substring(0, 1).toUpperCase()}
                                </div>
                                <div class="job-header-info">
                                    <h3 class="job-title">
                                        <a href="${pageContext.request.contextPath}/company-details?id=${c.userId}">
                                            <c:out value="${c.companyName}" />
                                        </a>
                                    </h3>
                                    <div class="job-company"><c:out value="${not empty c.industry ? c.industry : 'Technology & Services'}" /></div>
                                </div>
                            </div>

                            <div class="job-meta-pills">
                                <span class="meta-pill">&#128205; <c:out value="${not empty c.location ? c.location : 'Remote'}" /></span>
                                <span class="meta-pill">&#128101; <c:out value="${not empty c.companySize ? c.companySize : '10-50'} team members" /></span>
                            </div>

                            <p class="job-desc-snippet">
                                <c:out value="${not empty c.description ? c.description : 'Innovative company offering modern career paths and growth opportunities.'}" />
                            </p>
                        </div>

                        <div class="job-card-footer">
                            <span class="badge badge-active">${c.activeJobCount} Active Job(s)</span>
                            <a href="${pageContext.request.contextPath}/company-details?id=${c.userId}" class="btn btn-secondary btn-sm">
                                View Openings &rarr;
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">&#127970;</div>
                <h3 class="empty-state-title">No companies listed yet</h3>
                <p class="empty-state-text">Employers will appear here as they register and build their public company profiles.</p>
                <a href="${pageContext.request.contextPath}/register?role=EMPLOYER" class="btn btn-primary">Register Organization</a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
