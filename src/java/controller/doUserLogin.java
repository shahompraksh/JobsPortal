package controller;

import DAO.DaoUser;
import model.User;
import util.PasswordUtil;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class doUserLogin extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");

        if (username.isBlank() || password == null || password.isBlank()) {
            forward(request, response, "Please enter your username and password.");
            return;
        }

        // ── Look up user by username (or email) ───────────────────────
        User user = DaoUser.getUserByUsername(username);
        if (user == null && username.contains("@")) {
            user = DaoUser.getUserByEmail(username);
        }

        if (user == null) {
            forward(request, response, "Invalid username or password.");
            return;
        }

        // ── Cannot login with password if OAuth-only account ─────────
        if ("OAUTH_NO_PASSWORD".equals(user.getPassword())) {
            forward(request, response, "This account uses social sign-in. Please sign in with Google, Facebook, LinkedIn, or Apple.");
            return;
        }

        // ── Verify password (PBKDF2 or legacy plain-text migration) ───
        boolean valid = PasswordUtil.checkPassword(password, user.getPassword());
        if (!valid) {
            forward(request, response, "Invalid username or password.");
            return;
        }

        // ── Auto-migrate plain-text password to PBKDF2 hash ───────────
        if (PasswordUtil.isLegacyPlainText(user.getPassword())) {
            String newHash = PasswordUtil.hashPassword(password);
            user.setPassword(newHash);
            DaoUser.updateUser(user);
            System.out.println("[Login] Migrated plain-text password to PBKDF2 for user: " + user.getUsername());
        }

        // ── Success — create session ───────────────────────────────────
        HttpSession session = request.getSession(true);
        session.setAttribute("username",  user.getUsername());
        session.setAttribute("userId",    user.getId());
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("userName",  user.getName());
        session.setMaxInactiveInterval(60 * 60); // 1 hour

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    private static String trim(String s) { return s == null ? "" : s.trim(); }

    private static void forward(HttpServletRequest req, HttpServletResponse res, String msg)
            throws ServletException, IOException {
        req.setAttribute("errorMessage", msg);
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
