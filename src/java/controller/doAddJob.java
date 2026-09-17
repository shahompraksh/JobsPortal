package controller;

import DAO.DaoJobs;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import model.Job;

public class doAddJob extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String title = request.getParameter("title");
        String company = request.getParameter("company");
        String location = request.getParameter("location");
        String salaryStr = request.getParameter("salary");
        String description = request.getParameter("description");
        String type = request.getParameter("type");

        double salary = 0;
        try {
            if (salaryStr != null && !salaryStr.isBlank()) salary = Double.parseDouble(salaryStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/addnewjob.jsp?error=invalidSalary");
            return;
        }

        // Create Job object
        Job j = new Job();
        j.setTitle(title);
        j.setCompany(company);
        j.setLocation(location);
        j.setSalary(salary);
        j.setDescription(description);
        j.setType(type);

        // Save to database
        int result = DaoJobs.addJob(j);

        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/admin/viewalljobs.jsp?msg=Job+added+successfully!");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/addnewjob.jsp?error=Failed+to+add+job");
        }
    }
}
