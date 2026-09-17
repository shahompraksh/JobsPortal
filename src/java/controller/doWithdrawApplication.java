package controller;

import DAO.DaoApplication;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class doWithdrawApplication extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Object userId = request.getSession(false) == null ? null : request.getSession(false).getAttribute("userId");
        if (!(userId instanceof Integer)) {
            response.sendRedirect("login.jsp?msg=Please+login+first.");
            return;
        }
        try {
            int applicationId = Integer.parseInt(request.getParameter("id"));
            boolean withdrawn = DaoApplication.withdrawPendingApplication(applicationId, (Integer) userId);
            response.sendRedirect("applications.jsp?msg=" + (withdrawn ? "Application+withdrawn." : "Application+could+not+be+withdrawn."));
        } catch (NumberFormatException e) {
            response.sendRedirect("applications.jsp?msg=Invalid+application.");
        }
    }
}
