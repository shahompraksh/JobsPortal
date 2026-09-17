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

/** Handles Facebook OAuth callback. Maps to /auth/facebook/callback */
public class OAuthCallbackFacebook extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (req.getParameter("error") != null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Facebook+sign-in+was+cancelled.");
            return;
        }

        // State CSRF check
        HttpSession session = req.getSession(false);
        String saved  = session != null ? (String) session.getAttribute("oauth_state_fb") : null;
        String returned = req.getParameter("state");
        if (saved == null || !saved.equals(returned)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+OAuth+state.");
            return;
        }
        session.removeAttribute("oauth_state_fb");

        String code = req.getParameter("code");
        if (code == null) { res.sendRedirect(req.getContextPath() + "/login.jsp?error=No+code+from+Facebook."); return; }

        try {
            // Exchange code for access token
            String tokenUrl = "https://graph.facebook.com/v18.0/oauth/access_token"
                + "?client_id="     + encode(OAuthConfig.getFacebookAppId())
                + "&client_secret=" + encode(OAuthConfig.getFacebookAppSecret())
                + "&redirect_uri="  + encode(OAuthConfig.facebookRedirectUri())
                + "&code="          + encode(code);

            JSONObject tokenResp = getJson(tokenUrl);
            if (tokenResp == null || !tokenResp.has("access_token")) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=Facebook+token+exchange+failed.");
                return;
            }
            String accessToken = tokenResp.getString("access_token");

            // Fetch user info
            String infoUrl = "https://graph.facebook.com/me?fields=id,name,email,picture&access_token=" + encode(accessToken);
            JSONObject info = getJson(infoUrl);
            if (info == null) { res.sendRedirect(req.getContextPath() + "/login.jsp?error=Facebook+user+info+failed."); return; }

            String providerUserId = info.optString("id");
            String email          = info.optString("email");
            String name           = info.optString("name");
            String picture        = info.optJSONObject("picture") != null
                    ? info.getJSONObject("picture").optJSONObject("data") != null
                        ? info.getJSONObject("picture").getJSONObject("data").optString("url") : "" : "";

            User user = DaoUser.createOrLinkOAuthUser(email, name, "facebook", providerUserId, picture);
            if (user == null) { res.sendRedirect(req.getContextPath() + "/login.jsp?error=Account+creation+failed."); return; }

            HttpSession s = req.getSession(true);
            s.setAttribute("username", user.getUsername());
            s.setAttribute("userId",   user.getId());
            s.setAttribute("userEmail", user.getEmail());
            s.setAttribute("userName",  user.getName());
            s.setMaxInactiveInterval(3600);
            res.sendRedirect(req.getContextPath() + "/index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Facebook+sign-in+failed.");
        }
    }

    private JSONObject getJson(String url) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setConnectTimeout(10_000); conn.setReadTimeout(10_000);
        if (conn.getResponseCode() != 200) return null;
        return new JSONObject(new String(conn.getInputStream().readAllBytes(), StandardCharsets.UTF_8));
    }
    private String encode(String v) { return URLEncoder.encode(v, StandardCharsets.UTF_8); }
}
