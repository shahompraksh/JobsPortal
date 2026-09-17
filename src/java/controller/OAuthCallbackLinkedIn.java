package controller;

import DAO.DaoUser;
import model.User;
import util.OAuthConfig;
import org.json.JSONObject;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class OAuthCallbackLinkedIn extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (req.getParameter("error") != null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=LinkedIn+sign-in+was+cancelled.");
            return;
        }
        HttpSession session = req.getSession(false);
        String saved    = session != null ? (String) session.getAttribute("oauth_state_li") : null;
        String returned = req.getParameter("state");
        if (saved == null || !saved.equals(returned)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+OAuth+state.");
            return;
        }
        session.removeAttribute("oauth_state_li");

        String code = req.getParameter("code");
        if (code == null) { res.sendRedirect(req.getContextPath() + "/login.jsp?error=No+code+from+LinkedIn."); return; }

        try {
            // Exchange code for access token
            String body = "grant_type=authorization_code"
                + "&code="          + encode(code)
                + "&redirect_uri="  + encode(OAuthConfig.linkedInRedirectUri())
                + "&client_id="     + encode(OAuthConfig.getLinkedInClientId())
                + "&client_secret=" + encode(OAuthConfig.getLinkedInClientSecret());

            JSONObject tokenResp = postForm("https://www.linkedin.com/oauth/v2/accessToken", body);
            if (tokenResp == null || !tokenResp.has("access_token")) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=LinkedIn+token+exchange+failed."); return;
            }
            String accessToken = tokenResp.getString("access_token");

            // Fetch user info using OpenID Connect userinfo endpoint
            JSONObject info = getJsonWithBearer("https://api.linkedin.com/v2/userinfo", accessToken);
            if (info == null) { res.sendRedirect(req.getContextPath() + "/login.jsp?error=LinkedIn+user+info+failed."); return; }

            String providerUserId = info.optString("sub");
            String email          = info.optString("email");
            String name           = info.optString("name");
            String picture        = info.optString("picture");

            User user = DaoUser.createOrLinkOAuthUser(email, name, "linkedin", providerUserId, picture);
            if (user == null) { res.sendRedirect(req.getContextPath() + "/login.jsp?error=Account+creation+failed."); return; }

            HttpSession s = req.getSession(true);
            s.setAttribute("username",  user.getUsername());
            s.setAttribute("userId",    user.getId());
            s.setAttribute("userEmail", user.getEmail());
            s.setAttribute("userName",  user.getName());
            s.setMaxInactiveInterval(3600);
            res.sendRedirect(req.getContextPath() + "/index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=LinkedIn+sign-in+failed.");
        }
    }

    private JSONObject postForm(String urlStr, String body) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setConnectTimeout(10_000); conn.setReadTimeout(10_000);
        try (OutputStream os = conn.getOutputStream()) { os.write(body.getBytes(StandardCharsets.UTF_8)); }
        if (conn.getResponseCode() != 200) return null;
        return new JSONObject(new String(conn.getInputStream().readAllBytes(), StandardCharsets.UTF_8));
    }

    private JSONObject getJsonWithBearer(String urlStr, String token) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
        conn.setRequestProperty("Authorization", "Bearer " + token);
        conn.setConnectTimeout(10_000); conn.setReadTimeout(10_000);
        if (conn.getResponseCode() != 200) return null;
        return new JSONObject(new String(conn.getInputStream().readAllBytes(), StandardCharsets.UTF_8));
    }
    private String encode(String v) { return URLEncoder.encode(v, StandardCharsets.UTF_8); }
}
