package controller;
import util.OAuthConfig;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class OAuthInitFacebook extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (!OAuthConfig.isFacebookConfigured()) {
            if (OAuthConfig.isMockOAuthAllowed()) {
                OAuthConfig.handleMockLogin(req, res, "facebook", "Facebook Candidate", "facebook.candidate@elevate.local");
                return;
            }
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Facebook+login+is+not+configured+yet.");
            return;
        }
        String state = OAuthConfig.generateState();
        req.getSession(true).setAttribute("oauth_state_fb", state);
        res.sendRedirect(OAuthConfig.buildFacebookAuthUrl(state));
    }
}
