package controller;

import DAO.DaoUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig
public class doUserProfile extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        Part filePart = request.getPart("resume");
        String fileName = "";
        String baseDir = request.getServletContext().getRealPath("");
        File uploadDir = new File(baseDir, "uploads");
        if (!uploadDir.exists()) uploadDir.mkdirs();

        if (filePart != null && filePart.getSize() > 0) {
            fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isBlank()) {
                File destination = new File(uploadDir, fileName);
                filePart.write(destination.getAbsolutePath());
            }
        }

        User u = new User();
        u.setId(id);
        u.setName(name);
        u.setEmail(email);
        u.setUsername(username);
        u.setPassword(password);
        u.setPhone(phone);
        if (!fileName.isEmpty()) {
            u.setResume("uploads/" + fileName);
        } else {
            // Keep existing resume if not uploaded
            User existing = DaoUser.getUserByUsername(username);
            u.setResume(existing.getResume());
        }

        int status = DaoUser.updateUser(u);

        if (status > 0) {
            response.sendRedirect("profile.jsp?msg=Profile updated successfully!");
        } else {
            response.sendRedirect("profile.jsp?msg=Update failed. Try again.");
        }
    }
}
