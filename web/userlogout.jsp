

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
    session.invalidate();  // destroy session
    response.sendRedirect("index.jsp");
%>
