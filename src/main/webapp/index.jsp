<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Forward directly to HomeServlet so database-driven featured jobs & stats load
    request.getRequestDispatcher("/home").forward(request, response);
%>
