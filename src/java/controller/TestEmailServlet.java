package controller;

import util.AppConfig;
import util.EmailUtil;
import util.EmailUtil.EmailResult;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Diagnostic endpoint for verifying SMTP delivery independently of user registration.
 * Mapped to /api/test-email and /testEmail.
 * Access is restricted to localhost / development or logged-in administrators to prevent public abuse.
 */
public class TestEmailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if (!isAuthorized(req)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access restricted to localhost or authenticated administrators.");
            return;
        }

        res.setContentType("application/json; charset=UTF-8");
        PrintWriter out = res.getWriter();
        JSONObject diag = new JSONObject();

        String host = AppConfig.getSmtpHost();
        String port = AppConfig.getSmtpPort();
        String user = AppConfig.getSmtpUser();
        String pass = AppConfig.getSmtpPassword();
        String from = AppConfig.getSmtpFrom();
        boolean isConfigured = AppConfig.isSmtpConfigured();

        // 1. SMTP configuration check
        boolean configOk = isConfigured && !host.isBlank() && !port.isBlank();
        diag.put("SMTP configuration", configOk ? "OK" : "FAIL (SMTP_USER or SMTP_PASSWORD empty in .env)");

        // 2. SMTP connection check (TCP socket ping)
        boolean connOk = false;
        String connMsg = "FAIL";
        int portInt = 587;
        try { portInt = Integer.parseInt(port); } catch (Exception ignored) {}

        try (java.net.Socket socket = new java.net.Socket()) {
            socket.connect(new java.net.InetSocketAddress(host, portInt), 5000);
            connOk = true;
            connMsg = "OK";
        } catch (Exception e) {
            connMsg = "FAIL (Unable to connect to " + host + ":" + portInt + " - " + e.getMessage() + ")";
        }
        diag.put("SMTP connection", connMsg);

        // 3. SMTP authentication check
        String authMsg = "NOT_CONFIGURED";
        if (configOk && connOk) {
            try {
                java.util.Properties props = new java.util.Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.host", host);
                props.put("mail.smtp.port", port);
                props.put("mail.smtp.connectiontimeout", "5000");
                props.put("mail.smtp.timeout", "5000");
                if (!"465".equals(port)) {
                    props.put("mail.smtp.starttls.enable", "true");
                    props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
                }
                jakarta.mail.Session session = jakarta.mail.Session.getInstance(props);
                try (jakarta.mail.Transport transport = session.getTransport("smtp")) {
                    transport.connect(host, portInt, user, pass);
                    authMsg = "OK";
                }
            } catch (jakarta.mail.AuthenticationFailedException e) {
                authMsg = "FAIL (Invalid credentials or App Password required)";
            } catch (Exception e) {
                authMsg = "FAIL (" + e.getMessage() + ")";
            }
        }
        diag.put("SMTP authentication", authMsg);

        // 4. Overall Email sending status
        if ("OK".equals(authMsg)) {
            diag.put("Email sending", "OK");
        } else if (!configOk) {
            diag.put("Email sending", "NOT_CONFIGURED");
        } else {
            diag.put("Email sending", "FAIL");
        }

        // Safe configuration checks (never exposing the actual password)
        diag.put("SMTP_HOST", !host.isBlank() ? "configured" : "not configured");
        diag.put("SMTP_PORT", !port.isBlank() ? "configured" : "not configured");
        diag.put("SMTP_USER", !user.isBlank() ? "configured" : "not configured");
        diag.put("SMTP_PASSWORD", !pass.isBlank() ? "configured" : "not configured");
        diag.put("SMTP_FROM", !from.isBlank() ? "configured" : "not configured");
        diag.put("usage", "POST to /auth/test-email with parameter 'email' to send an SMTP Test Email.");

        out.print(diag.toString(2));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if (!isAuthorized(req)) {
            res.setStatus(HttpServletResponse.SC_FORBIDDEN);
            res.setContentType("application/json; charset=UTF-8");
            res.getWriter().print("{\"success\":false,\"category\":\"FORBIDDEN\",\"message\":\"Access restricted to localhost or administrators.\"}");
            return;
        }

        // Support both application/x-www-form-urlencoded and application/json
        String targetEmail = req.getParameter("email");
        if (targetEmail == null || targetEmail.isBlank()) {
            try {
                BufferedReader reader = req.getReader();
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) sb.append(line);
                if (sb.length() > 0) {
                    JSONObject json = new JSONObject(sb.toString());
                    targetEmail = json.optString("email", "");
                }
            } catch (Exception ignored) {}
        }

        if (targetEmail == null || targetEmail.isBlank()) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            res.setContentType("application/json; charset=UTF-8");
            res.getWriter().print("{\"success\":false,\"category\":\"INVALID_INPUT\",\"message\":\"Missing 'email' parameter in request.\"}");
            return;
        }

        targetEmail = targetEmail.trim();

        // Trigger test delivery
        EmailResult result = EmailUtil.sendTestEmail(targetEmail);

        res.setContentType("application/json; charset=UTF-8");
        res.setStatus(result.isSuccess() ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_GATEWAY);

        JSONObject resp = new JSONObject();
        resp.put("status", result.isSuccess() ? "SUCCESS" : "ERROR");
        resp.put("success", result.isSuccess());
        resp.put("category", result.getCategory());
        resp.put("message", result.getMessage());
        resp.put("recipient", targetEmail);
        resp.put("smtpHost", AppConfig.getSmtpHost());
        resp.put("smtpPort", AppConfig.getSmtpPort());
        resp.put("smtpFrom", AppConfig.getSmtpFrom());

        res.getWriter().print(resp.toString(2));
    }

    /** Ensure this diagnostic endpoint cannot be abused in open production environments. */
    private boolean isAuthorized(HttpServletRequest req) {
        String remoteAddr = req.getRemoteAddr();
        if ("127.0.0.1".equals(remoteAddr) || "0:0:0:0:0:0:0:1".equals(remoteAddr) || "localhost".equals(remoteAddr)) {
            return true;
        }
        HttpSession session = req.getSession(false);
        return session != null && (session.getAttribute("admin") != null || session.getAttribute("un") != null);
    }
}
