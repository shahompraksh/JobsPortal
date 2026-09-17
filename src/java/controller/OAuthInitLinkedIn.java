package controller;
import util.OAuthConfig;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class OAuthInitLinkedIn extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (!OAuthConfig.isLinkedInConfigured()) {
            if (OAuthConfig.isMockOAuthAllowed()) {
                OAuthConfig.handleMockLogin(req, res, "linkedin", "LinkedIn Candidate", "linkedin.candidate@elevate.local");
                return;
            }
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=LinkedIn+login+is+not+configured+yet.");
            return;
        }
        String state = OAuthConfig.generateState();
        req.getSession(true).setAttribute("oauth_state_li", state);
        res.sendRedirect(OAuthConfig.buildLinkedInAuthUrl(state));
    }
}
