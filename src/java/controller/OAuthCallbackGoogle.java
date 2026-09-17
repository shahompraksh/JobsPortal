package controller;

import DAO.DaoUser;
import model.User;
import util.OAuthConfig;
import org.json.JSONObject;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** Handles Google OAuth 2.0 callback. Maps to /auth/google/callback */
public class OAuthCallbackGoogle extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String error = req.getParameter("error");
        if (error != null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Google+sign-in+was+cancelled.");
            return;
        }

        // ── CSRF state check ──────────────────────────────────────────
        HttpSession session = req.getSession(false);
        String savedState  = session != null ? (String) session.getAttribute("oauth_state") : null;
        String returnState = req.getParameter("state");
        if (savedState == null || !savedState.equals(returnState)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+OAuth+state.+Please+try+again.");
            return;
        }
        session.removeAttribute("oauth_state");

        String code = req.getParameter("code");
        if (code == null || code.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=No+authorization+code+received.");
            return;
        }

        try {
            // ── Exchange code for tokens ──────────────────────────────
            JSONObject tokens = exchangeCode(code);
            if (tokens == null || !tokens.has("id_token")) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=Google+token+exchange+failed.");
                return;
            }

            // ── Decode ID token payload (no verification in dev; verify in prod) ──
            String idToken    = tokens.getString("id_token");
            JSONObject payload = decodeJwtPayload(idToken);
            if (payload == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+ID+token+from+Google.");
                return;
            }

            String providerUserId = payload.optString("sub");
            String email          = payload.optString("email");
            String name           = payload.optString("name");
            String picture        = payload.optString("picture");

            if (providerUserId.isBlank()) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=Could+not+retrieve+Google+user+ID.");
                return;
            }

            // ── Find or create/link user ──────────────────────────────
            User user = DaoUser.createOrLinkOAuthUser(email, name, "google", providerUserId, picture);
            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=Failed+to+create+or+find+account.+Please+try+again.");
                return;
            }

            // ── Set session ───────────────────────────────────────────
            HttpSession s = req.getSession(true);
            s.setAttribute("username",  user.getUsername());
            s.setAttribute("userId",    user.getId());
            s.setAttribute("userEmail", user.getEmail());
            s.setAttribute("userName",  user.getName());
            s.setMaxInactiveInterval(60 * 60);

            res.sendRedirect(req.getContextPath() + "/index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Google+sign-in+failed.+Please+try+again.");
        }
    }

    /** Exchange authorization code for access + ID tokens. */
    private JSONObject exchangeCode(String code) throws Exception {
        String body = "client_id="     + encode(OAuthConfig.getGoogleClientId())
                    + "&client_secret=" + encode(OAuthConfig.getGoogleClientSecret())
                    + "&redirect_uri="  + encode(OAuthConfig.googleRedirectUri())
                    + "&grant_type=authorization_code"
                    + "&code="          + encode(code);

        URL url = new URL("https://oauth2.googleapis.com/token");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setConnectTimeout(10_000);
        conn.setReadTimeout(10_000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.getBytes(StandardCharsets.UTF_8));
        }

        if (conn.getResponseCode() != 200) {
            String errBody = new String(conn.getErrorStream().readAllBytes(), StandardCharsets.UTF_8);
            System.err.println("[Google OAuth] Token exchange error: " + errBody);
            return null;
        }
        String response = new String(conn.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        return new JSONObject(response);
    }

    /** Base64url-decode the JWT payload segment. */
    private JSONObject decodeJwtPayload(String idToken) {
        try {
            String[] parts = idToken.split("\\.");
            if (parts.length < 2) return null;
            byte[] payloadBytes = Base64.getUrlDecoder().decode(
                    parts[1].replaceAll("=+$", "") // strip padding
            );
            return new JSONObject(new String(payloadBytes, StandardCharsets.UTF_8));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private String encode(String v) { return URLEncoder.encode(v, StandardCharsets.UTF_8); }
}
