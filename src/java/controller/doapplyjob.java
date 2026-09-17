package controller;

import DAO.DaoApplication;
import model.Application;
import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class doapplyjob extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Object userIdAttribute = request.getSession(false) == null ? null : request.getSession(false).getAttribute("userId");
        if (!(userIdAttribute instanceof Integer)) {
            response.sendRedirect("login.jsp?msg=Please+login+first.");
            return;
        }
        int userId = (Integer) userIdAttribute;
        int jobId;
        try {
            jobId = Integer.parseInt(request.getParameter("jobId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("findajob.jsp?msg=Invalid+job.");
            return;
        }

        Application app = new Application();
        app.setUserID(userId);
        app.setJobID(jobId);
        app.setStatus("Pending");

        int status = DaoApplication.addApplication(app);

        if (status > 0) {
            response.sendRedirect("applications.jsp?msg=Application submitted successfully!");
        } else {
            response.sendRedirect("findajob.jsp?msg=Application+could+not+be+submitted.+You+may+already+have+applied.");
        }
    }
}
