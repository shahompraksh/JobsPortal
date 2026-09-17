package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

/**
 * Sends OTP and system emails via SMTP.
 * Credentials are loaded via AppConfig (.env, System.getenv, System.getProperty).
 */
public final class EmailUtil {

    private EmailUtil() {}

    /** Result container holding detailed status and error category. */
    public static class EmailResult {
        private final boolean success;
        private final String category; // SUCCESS, CONFIG_MISSING, AUTH_FAILED, CONNECTION_FAILED, INVALID_RECIPIENT, PROVIDER_ERROR
        private final String message;

        public EmailResult(boolean success, String category, String message) {
            this.success = success;
            this.category = category;
            this.message = message;
        }

        public boolean isSuccess() { return success; }
        public String getCategory() { return category; }
        public String getMessage() { return message; }

        @Override
        public String toString() {
            return "EmailResult{success=" + success + ", category='" + category + "', message='" + message + "'}";
        }
    }

    /**
     * Sends the 6-digit OTP email.
     * Returns an EmailResult indicating real provider acceptance or failure reason.
     */
    public static EmailResult sendOtpEmail(String toEmail, String recipientName, String otp) {
        if (toEmail == null || toEmail.isBlank() || !toEmail.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return new EmailResult(false, "INVALID_RECIPIENT", "Invalid recipient email address.");
        }

        String host = AppConfig.getSmtpHost();
        String port = AppConfig.getSmtpPort();
        String user = AppConfig.getSmtpUser();
        String pass = AppConfig.getSmtpPassword();
        String from = AppConfig.getSmtpFrom();

        if (user.isBlank() || pass.isBlank()) {
            System.err.println("[EmailUtil] SMTP credentials missing (SMTP_USER or SMTP_PASSWORD empty). Cannot send OTP to: " + maskEmail(toEmail));
            return new EmailResult(false, "CONFIG_MISSING", "SMTP service is not configured. Please set SMTP_USER and SMTP_PASSWORD in .env.");
        }

        System.out.println("[EmailUtil] Initiating OTP email to " + maskEmail(toEmail) + " via " + host + ":" + port);

        Properties props = new Properties();
        props.put("mail.smtp.auth", String.valueOf(AppConfig.isSmtpAuth()));
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.connectiontimeout", "10000"); // 10s
        props.put("mail.smtp.timeout", "10000");           // 10s
        props.put("mail.smtp.writetimeout", "10000");      // 10s

        if ("465".equals(port)) {
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        } else if (AppConfig.isSmtpStartTls()) {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        }

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from, "Elevate Workforce Solutions"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("Verify Your Elevate Account");
            msg.setContent(buildHtml(recipientName, otp), "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("[EmailUtil] OTP email accepted by SMTP server for: " + maskEmail(toEmail));
            return new EmailResult(true, "SUCCESS", "Verification email sent successfully.");

        } catch (AuthenticationFailedException e) {
            System.err.println("[EmailUtil] SMTP Authentication Failed for user " + maskEmail(user) + ": " + e.getMessage());
            return new EmailResult(false, "AUTH_FAILED", "SMTP Authentication failed. For Gmail, please verify you are using a 16-character Google App Password (not your regular password).");

        } catch (MessagingException e) {
            String errMsg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[EmailUtil] SMTP MessagingException: " + errMsg);

            if (errMsg.toLowerCase().contains("timeout") || errMsg.toLowerCase().contains("timed out")) {
                return new EmailResult(false, "CONNECTION_FAILED", "Connection to SMTP server timed out (" + host + ":" + port + ").");
            }
            if (errMsg.toLowerCase().contains("unknown smtp host") || errMsg.toLowerCase().contains("connectexception")) {
                return new EmailResult(false, "CONNECTION_FAILED", "Could not connect to SMTP host: " + host);
            }
            return new EmailResult(false, "PROVIDER_ERROR", "Email provider error: " + errMsg);

        } catch (Exception e) {
            System.err.println("[EmailUtil] Unexpected error sending email: " + e.getMessage());
            return new EmailResult(false, "PROVIDER_ERROR", "Unexpected error: " + e.getMessage());
        }
    }

    /** Sends a diagnostic test email to verify SMTP delivery independently of user registration. */
    public static EmailResult sendTestEmail(String toEmail) {
        if (toEmail == null || toEmail.isBlank() || !toEmail.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return new EmailResult(false, "INVALID_RECIPIENT", "Invalid recipient email address.");
        }

        String host = AppConfig.getSmtpHost();
        String port = AppConfig.getSmtpPort();
        String user = AppConfig.getSmtpUser();
        String pass = AppConfig.getSmtpPassword();
        String from = AppConfig.getSmtpFrom();

        if (user.isBlank() || pass.isBlank()) {
            return new EmailResult(false, "CONFIG_MISSING", "SMTP credentials missing. Please set SMTP_USER and SMTP_PASSWORD in .env.");
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        if ("465".equals(port)) {
            props.put("mail.smtp.ssl.enable", "true");
        } else {
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        }

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from, "Elevate Workforce Solutions"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject("SMTP Test Email");
            msg.setContent(
                "<!DOCTYPE html><html><body style=\"font-family:Arial,sans-serif;padding:30px;background:#f8fafc;\">"
                + "<div style=\"max-width:500px;margin:0 auto;background:#fff;padding:24px;border-radius:12px;border:1px solid #e2e8f0;\">"
                + "<h2 style=\"color:#0066cc;margin-top:0;\">Elevate SMTP Test Successful ✅</h2>"
                + "<p>This email confirms that your SMTP delivery configuration is working properly!</p>"
                + "<ul style=\"color:#475569;font-size:14px;line-height:1.8;\">"
                + "<li><strong>SMTP Host:</strong> " + host + "</li>"
                + "<li><strong>SMTP Port:</strong> " + port + "</li>"
                + "<li><strong>Sender:</strong> " + from + "</li>"
                + "<li><strong>Recipient:</strong> " + toEmail + "</li>"
                + "</ul>"
                + "<p style=\"color:#16a34a;font-weight:bold;margin-bottom:0;\">Your application is ready to deliver real 6-digit OTP verification codes to Gmail and other inboxes.</p>"
                + "</div></body></html>",
                "text/html; charset=UTF-8"
            );

            Transport.send(msg);
            System.out.println("[EmailUtil] Test email successfully accepted by SMTP server for: " + maskEmail(toEmail));
            return new EmailResult(true, "SUCCESS", "Test email accepted by " + host + ":" + port + " for " + toEmail);

        } catch (AuthenticationFailedException e) {
            System.err.println("[EmailUtil] SMTP Auth Failed during test: " + e.getMessage());
            return new EmailResult(false, "AUTH_FAILED", "SMTP Authentication failed. For Gmail, make sure 2-Step Verification is enabled and use a 16-character App Password (https://myaccount.google.com/apppasswords).");

        } catch (MessagingException e) {
            String errMsg = e.getMessage() != null ? e.getMessage() : "";
            System.err.println("[EmailUtil] SMTP Test MessagingException: " + errMsg);
            return new EmailResult(false, "PROVIDER_ERROR", "Mail provider rejected: " + errMsg);

        } catch (Exception e) {
            System.err.println("[EmailUtil] Unexpected error in test email: " + e.getMessage());
            return new EmailResult(false, "PROVIDER_ERROR", "Unexpected error: " + e.getMessage());
        }
    }

    private static String buildHtml(String name, String otp) {
        String displayName = (name != null && !name.isBlank()) ? name : "Candidate";
        StringBuilder digits = new StringBuilder();
        for (char c : otp.toCharArray()) {
            digits.append("<span style=\"display:inline-block;width:44px;height:52px;")
                  .append("line-height:52px;text-align:center;font-size:26px;font-weight:800;")
                  .append("color:#1d4ed8;background:#eff6ff;border:2px solid #bfdbfe;")
                  .append("border-radius:10px;margin:0 4px;\">").append(c).append("</span>");
        }
        return "<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"></head>"
            + "<body style=\"margin:0;padding:0;background:#f1f5f9;font-family:Inter,Arial,sans-serif;\">"
            + "<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"background:#f1f5f9;\"><tr><td align=\"center\" style=\"padding:40px 16px;\">"
            + "<table width=\"100%\" style=\"max-width:560px;background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);border:1px solid #e2e8f0;\">"
            + "<tr><td style=\"background:linear-gradient(135deg,#1d4ed8,#4f46e5);padding:32px 36px;text-align:center;\">"
            + "<h1 style=\"color:#ffffff;font-size:24px;font-weight:800;margin:0;letter-spacing:-0.5px;\">Elevate Workforce</h1>"
            + "<p style=\"color:rgba(255,255,255,0.85);margin:6px 0 0;font-size:13px;\">Career Platform</p>"
            + "</td></tr>"
            + "<tr><td style=\"padding:36px;\">"
            + "<p style=\"font-size:16px;color:#1e293b;margin:0 0 10px;\">Hello <strong>" + displayName + "</strong>,</p>"
            + "<p style=\"font-size:15px;color:#475569;margin:0 0 24px;line-height:1.6;\">Thank you for creating your account.<br>Your verification code is:</p>"
            + "<div style=\"text-align:center;margin-bottom:28px;\">" + digits + "</div>"
            + "<p style=\"font-size:14px;color:#64748b;margin:0 0 16px;line-height:1.6;\">This code expires in <strong>10 minutes</strong> and can only be used once.</p>"
            + "<p style=\"font-size:13px;color:#94a3b8;margin:0 0 28px;\">If you did not create this account, you can ignore this email.</p>"
            + "<p style=\"font-size:14px;color:#334155;margin:0;font-weight:600;\">Regards,<br><span style=\"color:#1d4ed8;\">Elevate Team</span></p>"
            + "</td></tr>"
            + "<tr><td style=\"background:#f8fafc;padding:16px 36px;text-align:center;border-top:1px solid #f1f5f9;\">"
            + "<p style=\"font-size:12px;color:#94a3b8;margin:0;\">© 2026 Elevate Workforce Solutions. All rights reserved.</p>"
            + "</td></tr>"
            + "</table></td></tr></table></body></html>";
    }

    /** Sanitizes email address for safe logging without exposing full identity in production logs. */
    private static String maskEmail(String email) {
        if (email == null || !email.contains("@")) return "invalid-email";
        int at = email.indexOf('@');
        String name = email.substring(0, at);
        String domain = email.substring(at);
        if (name.length() <= 2) return name + "***" + domain;
        return name.substring(0, 2) + "***" + domain;
    }
}
