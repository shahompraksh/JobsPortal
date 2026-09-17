package util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Universal configuration manager.
 * Reads configuration with automatic precedence:
 *   1. JVM system properties (System.getProperty)
 *   2. OS environment variables (System.getenv)
 *   3. .env file located in project root, catalina base, or user workspace
 */
public final class AppConfig {

    private static final Map<String, String> ENV_VARS = new HashMap<>();
    private static volatile boolean loaded = false;
    private static File loadedFile = null;
    private static long lastFileModified = 0;
    private static String webAppRoot = null;

    static {
        loadEnvFile();
    }

    private AppConfig() {}

    /** Initialize from ServletContextListener with web application root path. */
    public static synchronized void init(jakarta.servlet.ServletContext ctx) {
        if (ctx != null) {
            webAppRoot = ctx.getRealPath("/");
        }
        reload();
    }

    /** Re-read .env file from disk (useful after user edits credentials without Tomcat restart). */
    public static synchronized void reload() {
        ENV_VARS.clear();
        loaded = false;
        loadedFile = null;
        lastFileModified = 0;
        loadEnvFile();
    }

    private static synchronized void loadEnvFile() {
        if (loadedFile != null && loadedFile.exists()) {
            if (loadedFile.lastModified() == lastFileModified) {
                return;
            }
            ENV_VARS.clear();
        } else if (loaded) {
            return;
        }

        // Potential paths where .env may reside
        String[] candidatePaths = {
            webAppRoot != null ? webAppRoot + "/WEB-INF/.env" : "",
            webAppRoot != null ? webAppRoot + "/.env" : "",
            "/Users/omprakashshah/Desktop/JobsPortal/.env",
            "/Users/omprakashshah/Desktop/JobsPortalAssignment/.env",
            System.getProperty("catalina.base", "") + "/.env",
            ".env",
            "../.env",
            System.getProperty("user.dir", "") + "/.env"
        };

        for (String path : candidatePaths) {
            if (path.isBlank()) continue;
            File f = new File(path);
            if (f.exists() && f.isFile() && f.canRead()) {
                try (BufferedReader reader = new BufferedReader(new FileReader(f, StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        line = line.trim();
                        if (line.isEmpty() || line.startsWith("#")) continue;
                        int idx = line.indexOf('=');
                        if (idx > 0) {
                            String key = line.substring(0, idx).trim();
                            String val = line.substring(idx + 1).trim();
                            if ((val.startsWith("\"") && val.endsWith("\""))
                                    || (val.startsWith("'") && val.endsWith("'"))) {
                                if (val.length() >= 2) {
                                    val = val.substring(1, val.length() - 1);
                                }
                            }
                            ENV_VARS.put(key, val);
                        }
                    }
                    loadedFile = f;
                    lastFileModified = f.lastModified();
                    System.out.println("[AppConfig] Successfully loaded configuration from: " + f.getAbsolutePath());
                    break;
                } catch (Exception e) {
                    System.err.println("[AppConfig] Error reading .env at " + path + ": " + e.getMessage());
                }
            }
        }
        loaded = true;
    }

    /** Generic setting lookup. Checks System props, then System env, then .env map. */
    public static String get(String key, String fallback) {
        loadEnvFile();

        String val = System.getProperty(key);
        if (val != null && !val.isBlank()) return val.trim();

        val = System.getenv(key);
        if (val != null && !val.isBlank()) return val.trim();

        val = ENV_VARS.get(key);
        if (val != null && !val.isBlank()) return val.trim();

        return fallback;
    }

    public static String get(String key) {
        return get(key, "");
    }

    /** Checks multiple alternative aliases for a setting (e.g. SMTP_USER, MAIL_USER, EMAIL_USER). */
    public static String getFirst(String fallback, String... keys) {
        for (String key : keys) {
            String val = get(key, "");
            if (!val.isBlank()) return val;
        }
        return fallback;
    }

    // ── Dedicated SMTP Getters ──────────────────────────────────────
    public static String getSmtpHost() {
        return getFirst("smtp.gmail.com", "SMTP_HOST", "MAIL_HOST", "EMAIL_HOST");
    }

    public static String getSmtpPort() {
        return getFirst("587", "SMTP_PORT", "MAIL_PORT", "EMAIL_PORT");
    }

    public static String getSmtpUser() {
        return getFirst("", "SMTP_USER", "MAIL_USER", "EMAIL_USER", "MAIL_USERNAME");
    }

    public static String getSmtpPassword() {
        return getFirst("", "SMTP_PASSWORD", "MAIL_PASSWORD", "EMAIL_PASSWORD", "MAIL_PASS");
    }

    public static String getSmtpFrom() {
        String user = getSmtpUser();
        return getFirst(user, "SMTP_FROM", "MAIL_FROM", "EMAIL_FROM");
    }

    public static boolean isSmtpAuth() {
        return Boolean.parseBoolean(getFirst("true", "SMTP_AUTH", "MAIL_AUTH"));
    }

    public static boolean isSmtpStartTls() {
        return Boolean.parseBoolean(getFirst("true", "SMTP_STARTTLS", "MAIL_STARTTLS"));
    }

    public static boolean isSmtpConfigured() {
        return !getSmtpUser().isBlank() && !getSmtpPassword().isBlank();
    }

    // ── Application Base URL ─────────────────────────────────────────
    public static String getAppBaseUrl() {
        return getFirst("http://localhost:8080/JobsPortal", "APP_BASE_URL", "BASE_URL");
    }

    // ── Database Getters ─────────────────────────────────────────────
    public static String getDbUrl() {
        // 1. Direct explicit JDBC URL
        String directUrl = getFirst("", "DB_URL", "JDBC_DATABASE_URL");
        if (!directUrl.isBlank()) return directUrl;

        // 2. Cloud connection URI (DATABASE_URL or MYSQL_URL)
        String rawUrl = getFirst("", "DATABASE_URL", "MYSQL_URL");
        if (!rawUrl.isBlank()) {
            if (rawUrl.startsWith("jdbc:")) return rawUrl;
            try {
                java.net.URI uri = new java.net.URI(rawUrl);
                String host = uri.getHost();
                int port = uri.getPort() > 0 ? uri.getPort() : 3306;
                String path = uri.getPath() != null && uri.getPath().length() > 1 ? uri.getPath().substring(1) : "jobsportal";
                return "jdbc:mysql://" + host + ":" + port + "/" + path + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            } catch (Exception ignored) {}
        }

        // 3. Cloud host component variables (Railway / Render / Docker Compose)
        String host = getFirst("", "MYSQLHOST", "DB_HOST", "MYSQL_HOST");
        if (!host.isBlank()) {
            String port = getFirst("3306", "MYSQLPORT", "DB_PORT", "MYSQL_PORT");
            String db   = getFirst("jobsportal", "MYSQLDATABASE", "DB_NAME", "MYSQL_DATABASE");
            return "jdbc:mysql://" + host + ":" + port + "/" + db + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        }

        return "jdbc:mysql://127.0.0.1:3306/jobsportal?useSSL=false&serverTimezone=UTC";
    }

    public static String getDbUser() {
        String rawUrl = getFirst("", "DATABASE_URL", "MYSQL_URL");
        if (!rawUrl.isBlank() && !rawUrl.startsWith("jdbc:")) {
            try {
                java.net.URI uri = new java.net.URI(rawUrl);
                if (uri.getUserInfo() != null) {
                    String[] parts = uri.getUserInfo().split(":", 2);
                    if (!parts[0].isBlank()) return parts[0];
                }
            } catch (Exception ignored) {}
        }
        return getFirst("root", "DB_USER", "MYSQLUSER", "MYSQL_USER");
    }

    public static String getDbPassword() {
        String rawUrl = getFirst("", "DATABASE_URL", "MYSQL_URL");
        if (!rawUrl.isBlank() && !rawUrl.startsWith("jdbc:")) {
            try {
                java.net.URI uri = new java.net.URI(rawUrl);
                if (uri.getUserInfo() != null) {
                    String[] parts = uri.getUserInfo().split(":", 2);
                    if (parts.length > 1) return parts[1];
                }
            } catch (Exception ignored) {}
        }
        return getFirst("Siraha@1234", "DB_PASSWORD", "MYSQLPASSWORD", "MYSQL_PASSWORD");
    }

    // ── OAuth Getters ────────────────────────────────────────────────
    public static String getGoogleClientId()     { return getFirst("", "GOOGLE_CLIENT_ID"); }
    public static String getGoogleClientSecret() { return getFirst("", "GOOGLE_CLIENT_SECRET"); }
    public static String getFacebookAppId()      { return getFirst("", "FACEBOOK_APP_ID"); }
    public static String getFacebookAppSecret()  { return getFirst("", "FACEBOOK_APP_SECRET"); }
    public static String getLinkedInClientId()   { return getFirst("", "LINKEDIN_CLIENT_ID"); }
    public static String getLinkedInClientSecret(){ return getFirst("", "LINKEDIN_CLIENT_SECRET"); }
    public static String getAppleClientId()      { return getFirst("", "APPLE_CLIENT_ID"); }
    public static String getAppleTeamId()        { return getFirst("", "APPLE_TEAM_ID"); }
    public static String getAppleKeyId()         { return getFirst("", "APPLE_KEY_ID"); }
    public static String getApplePrivateKey()    { return getFirst("", "APPLE_PRIVATE_KEY"); }
}
