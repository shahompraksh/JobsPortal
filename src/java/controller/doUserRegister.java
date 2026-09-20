package controller;

import DAO.DaoUser;
import util.PasswordUtil;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class doUserRegister extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name     = trim(request.getParameter("name"));
        String email    = trim(request.getParameter("email"));
        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");
        String phone    = trim(request.getParameter("phone"));
        String confirm  = request.getParameter("confirmPassword");

        // ── Basic validation ────────────────────────────────────────────
        if (name.isBlank() || email.isBlank() || username.isBlank()
                || password == null || password.isBlank()) {
            redirect(response, request, "register.jsp?error=All+required+fields+must+be+filled");
            return;
        }
        if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            redirect(response, request, "register.jsp?error=Invalid+email+address+format");
            return;
        }
        if (confirm != null && !password.equals(confirm)) {
            redirect(response, request, "register.jsp?error=Passwords+do+not+match");
            return;
        }
        if (password.length() < 6) {
            redirect(response, request, "register.jsp?error=Password+must+be+at+least+6+characters");
            return;
        }

        // ── Check duplicates ────────────────────────────────────────────
        if (DaoUser.getUserByEmail(email) != null) {
            redirect(response, request, "register.jsp?error=Email+already+registered.+Please+sign+in.");
            return;
        }
        if (DaoUser.getUserByUsername(username) != null) {
            redirect(response, request, "register.jsp?error=Username+already+taken.+Please+choose+another.");
            return;
        }

        // ── Hash password and register ──────────────────────────────────
        String hashed = PasswordUtil.hashPassword(password);
        User u = new User();
        u.setName(name);
        u.setEmail(email);
        u.setUsername(username);
        u.setPassword(hashed);
        u.setPhone(phone);

        int status = DaoUser.registerUser(u);
        if (status <= 0) {
            redirect(response, request, "register.jsp?error=Registration+failed.+Please+try+again.");
            return;
        }

        // ── Fetch newly created user ────────────────────────────────────
        User newUser = DaoUser.getUserByEmail(email);
        if (newUser == null) {
            redirect(response, request, "register.jsp?error=Account+created+but+lookup+failed.+Contact+support.");
            return;
        }

        // ── Verify newly registered user in DB ────────
        DaoUser.setUserVerified(newUser.getId());

        // Do not auto-login; redirect candidate to candidate login page
        String encodedUser = java.net.URLEncoder.encode(newUser.getUsername(), java.nio.charset.StandardCharsets.UTF_8);
        redirect(response, request, "login.jsp?registered=true&user=" + encodedUser);
    }

    private static String trim(String s) { return s == null ? "" : s.trim(); }

    private static void redirect(HttpServletResponse r, HttpServletRequest req, String path) throws IOException {
        String fullPath = req.getContextPath() + "/" + (path.startsWith("/") ? path.substring(1) : path);
        r.sendRedirect(fullPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        redirect(response, request, "register.jsp");
    }
}
