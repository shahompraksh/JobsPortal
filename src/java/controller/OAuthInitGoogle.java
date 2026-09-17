package controller;

import util.OAuthConfig;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** Initiates Google OAuth 2.0 flow. Maps to /auth/google */
public class OAuthInitGoogle extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!OAuthConfig.isGoogleConfigured()) {
            if (OAuthConfig.isMockOAuthAllowed()) {
                OAuthConfig.handleMockLogin(req, res, "google", "Google Candidate", "google.candidate@elevate.local");
                return;
            }
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Google+login+is+not+configured+yet.");
            return;
        }
        String state = OAuthConfig.generateState();
        req.getSession(true).setAttribute("oauth_state", state);
        res.sendRedirect(OAuthConfig.buildGoogleAuthUrl(state));
    }
}
