package controller;

import DAO.DaoApplication;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class doUpdateApplicationStatus extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        boolean isAdmin = session != null && (session.getAttribute("un") != null || session.getAttribute("username") != null);

        if (!isAdmin) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("status");

        try {
            int applicationId = Integer.parseInt(idStr);
            if (newStatus == null || newStatus.isBlank()) {
                newStatus = "Pending";
            }

            int result = DaoApplication.updateStatus(applicationId, newStatus);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/viewapplications.jsp?msg=Application+status+updated+to+" + java.net.URLEncoder.encode(newStatus, "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/viewapplications.jsp?error=Failed+to+update+application+status.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/viewapplications.jsp?error=Invalid+request.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/viewapplications.jsp");
    }
}
