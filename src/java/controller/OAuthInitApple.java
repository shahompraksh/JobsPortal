package controller;
import util.OAuthConfig;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class OAuthInitApple extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if (!OAuthConfig.isAppleConfigured()) {
            if (OAuthConfig.isMockOAuthAllowed()) {
                OAuthConfig.handleMockLogin(req, res, "apple", "Apple Candidate", "apple.candidate@elevate.local");
                return;
            }
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Apple+sign-in+is+not+configured+yet.");
            return;
        }
        String state = OAuthConfig.generateState();
        req.getSession(true).setAttribute("oauth_state_apple", state);
        res.sendRedirect(OAuthConfig.buildAppleAuthUrl(state));
    }
}
