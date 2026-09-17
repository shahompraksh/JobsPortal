package controller;

import DAO.DaoUser;
import model.User;
import org.json.JSONObject;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Apple uses form_post response mode — Apple POSTs to this endpoint.
 * Maps to /auth/apple/callback
 */
public class OAuthCallbackApple extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String error = req.getParameter("error");
        if (error != null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Apple+sign-in+was+cancelled.");
            return;
        }

        HttpSession session = req.getSession(false);
        String saved    = session != null ? (String) session.getAttribute("oauth_state_apple") : null;
        String returned = req.getParameter("state");
        if (saved == null || !saved.equals(returned)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+Apple+OAuth+state.");
            return;
        }
        session.removeAttribute("oauth_state_apple");

        String idToken = req.getParameter("id_token");
        if (idToken == null || idToken.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=No+identity+token+from+Apple.");
            return;
        }

        try {
            // Decode Apple ID token payload (in production: verify signature with Apple's public keys)
            JSONObject payload = decodeJwtPayload(idToken);
            if (payload == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+Apple+identity+token.");
                return;
            }

            String providerUserId = payload.optString("sub");
            String email          = payload.optString("email"); // may be private relay

            // Apple provides name only on FIRST login via the "user" form field
            String name = null;
            String userJson = req.getParameter("user");
            if (userJson != null && !userJson.isBlank()) {
                try {
                    JSONObject userObj = new JSONObject(userJson);
                    JSONObject nameObj = userObj.optJSONObject("name");
                    if (nameObj != null) {
                        String first = nameObj.optString("firstName", "");
                        String last  = nameObj.optString("lastName", "");
                        name = (first + " " + last).trim();
                    }
                } catch (Exception ignored) {}
            }

            User user = DaoUser.createOrLinkOAuthUser(email, name, "apple", providerUserId, null);
            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=Apple+account+creation+failed.");
                return;
            }

            HttpSession s = req.getSession(true);
            s.setAttribute("username",  user.getUsername());
            s.setAttribute("userId",    user.getId());
            s.setAttribute("userEmail", user.getEmail());
            s.setAttribute("userName",  user.getName());
            s.setMaxInactiveInterval(3600);
            res.sendRedirect(req.getContextPath() + "/index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Apple+sign-in+failed.");
        }
    }

    // Apple also redirects GET on error
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/login.jsp?error=Apple+sign-in+failed+or+was+cancelled.");
    }

    private JSONObject decodeJwtPayload(String token) {
        try {
            String[] parts = token.split("\\.");
            if (parts.length < 2) return null;
            byte[] bytes = Base64.getUrlDecoder().decode(parts[1].replaceAll("=+$", ""));
            return new JSONObject(new String(bytes, StandardCharsets.UTF_8));
        } catch (Exception e) { return null; }
    }
}
