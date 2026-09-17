<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Email OTP has been removed; all accounts are verified automatically.
    Object loggedInUser = session.getAttribute("username");
    if (loggedInUser != null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp?msg=Account+verification+is+automatic.+Please+sign+in.");
    }
%>
