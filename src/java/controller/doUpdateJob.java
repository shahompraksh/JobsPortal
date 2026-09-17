package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Job;
import DAO.DaoJobs;

public class doUpdateJob extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String company = request.getParameter("company");
        String location = request.getParameter("location");
        String salaryStr = request.getParameter("salary");
        String description = request.getParameter("description");
        String type = request.getParameter("type");

        try {
            int id = Integer.parseInt(idStr);
            double salary = 0;
            if (salaryStr != null && !salaryStr.isBlank()) {
                try {
                    salary = Double.parseDouble(salaryStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            Job j = new Job();
            j.setId(id);
            j.setTitle(title);
            j.setCompany(company);
            j.setLocation(location);
            j.setSalary(salary);
            j.setDescription(description);
            j.setType(type);

            int result = DaoJobs.updateJob(j);
            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/viewalljobs.jsp?msg=Job+updated+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/viewalljobs.jsp?error=Update+failed.+Job+not+found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/viewalljobs.jsp?error=" + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Error updating job", "UTF-8"));
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
