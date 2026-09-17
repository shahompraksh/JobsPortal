package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ContactController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");
        String contactMethod = request.getParameter("contactMethod");

        DAO.DaoMessage.addMessage(name, email, phone, message, contactMethod);
        System.out.println("Contact inquiry saved from: " + name + " (" + email + ", " + phone + ") - Method: " + contactMethod + " - Message: " + message);

        response.sendRedirect("contact.jsp?msg=Thank+you+for+your+message!+We+will+get+back+to+you+soon.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("contact.jsp");
    }
}
