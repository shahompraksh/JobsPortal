<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session != null) {
        session.removeAttribute("un");
        session.removeAttribute("username");
        session.invalidate();
    }
    response.sendRedirect("login.jsp?msg=You+have+been+successfully+logged+out.");
%>
