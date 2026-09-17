package util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * OAuth 2.0 configuration and URL builder.
 * All credentials come from environment variables — never hardcoded.
 *
 * Required env vars per provider:
 *   Google:   GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, APP_BASE_URL
 *   Facebook: FACEBOOK_APP_ID,  FACEBOOK_APP_SECRET,  APP_BASE_URL
 *   LinkedIn: LINKEDIN_CLIENT_ID, LINKEDIN_CLIENT_SECRET, APP_BASE_URL
 *   Apple:    APPLE_CLIENT_ID,  APPLE_TEAM_ID, APPLE_KEY_ID, APPLE_PRIVATE_KEY, APP_BASE_URL
 */
public final class OAuthConfig {

    private static final SecureRandom RNG = new SecureRandom();

    private OAuthConfig() {}

    // ── Env var helpers ───────────────────────────────────────────────
    public static String getGoogleClientId()     { return setting("GOOGLE_CLIENT_ID", ""); }
    public static String getGoogleClientSecret() { return setting("GOOGLE_CLIENT_SECRET", ""); }
    public static String getFacebookAppId()      { return setting("FACEBOOK_APP_ID", ""); }
    public static String getFacebookAppSecret()  { return setting("FACEBOOK_APP_SECRET", ""); }
    public static String getLinkedInClientId()   { return setting("LINKEDIN_CLIENT_ID", ""); }
    public static String getLinkedInClientSecret(){ return setting("LINKEDIN_CLIENT_SECRET", ""); }
    public static String getAppleClientId()      { return setting("APPLE_CLIENT_ID", ""); }
    public static String getAppleTeamId()        { return setting("APPLE_TEAM_ID", ""); }
    public static String getAppleKeyId()         { return setting("APPLE_KEY_ID", ""); }
    public static String getApplePrivateKey()    { return setting("APPLE_PRIVATE_KEY", ""); }
    public static String getAppBaseUrl()         { return setting("APP_BASE_URL", "http://localhost:8080/JobsPortal"); }

    // ── Configured checks ─────────────────────────────────────────────
    public static boolean isGoogleConfigured()   { return !getGoogleClientId().isBlank() && !getGoogleClientSecret().isBlank(); }
    public static boolean isFacebookConfigured() { return !getFacebookAppId().isBlank()  && !getFacebookAppSecret().isBlank(); }
    public static boolean isLinkedInConfigured() { return !getLinkedInClientId().isBlank() && !getLinkedInClientSecret().isBlank(); }
    public static boolean isAppleConfigured()    { return !getAppleClientId().isBlank() && !getApplePrivateKey().isBlank(); }

    // ── Redirect URIs ─────────────────────────────────────────────────
    public static String googleRedirectUri()   { return getAppBaseUrl() + "/auth/google/callback"; }
    public static String facebookRedirectUri() { return getAppBaseUrl() + "/auth/facebook/callback"; }
    public static String linkedInRedirectUri() { return getAppBaseUrl() + "/auth/linkedin/callback"; }
    public static String appleRedirectUri()    { return getAppBaseUrl() + "/auth/apple/callback"; }

    // ── State token (CSRF protection) ─────────────────────────────────
    public static String generateState() {
        byte[] bytes = new byte[24];
        RNG.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    // ── Google OAuth URL ──────────────────────────────────────────────
    public static String buildGoogleAuthUrl(String state) {
        return "https://accounts.google.com/o/oauth2/v2/auth"
            + "?client_id="     + encode(getGoogleClientId())
            + "&redirect_uri="  + encode(googleRedirectUri())
            + "&response_type=code"
            + "&scope="         + encode("openid email profile")
            + "&state="         + encode(state)
            + "&access_type=offline"
            + "&prompt=select_account";
    }

    // ── Facebook OAuth URL ────────────────────────────────────────────
    public static String buildFacebookAuthUrl(String state) {
        return "https://www.facebook.com/v18.0/dialog/oauth"
            + "?client_id="     + encode(getFacebookAppId())
            + "&redirect_uri="  + encode(facebookRedirectUri())
            + "&scope="         + encode("email,public_profile")
            + "&state="         + encode(state)
            + "&response_type=code";
    }

    // ── LinkedIn OAuth URL ────────────────────────────────────────────
    public static String buildLinkedInAuthUrl(String state) {
        return "https://www.linkedin.com/oauth/v2/authorization"
            + "?client_id="     + encode(getLinkedInClientId())
            + "&redirect_uri="  + encode(linkedInRedirectUri())
            + "&response_type=code"
            + "&scope="         + encode("openid profile email")
            + "&state="         + encode(state);
    }

    // ── Apple OAuth URL ───────────────────────────────────────────────
    public static String buildAppleAuthUrl(String state) {
        return "https://appleid.apple.com/auth/authorize"
            + "?client_id="     + encode(getAppleClientId())
            + "&redirect_uri="  + encode(appleRedirectUri())
            + "&response_type=" + encode("code id_token")
            + "&scope="         + encode("name email")
            + "&response_mode=form_post"
            + "&state="         + encode(state);
    }

    private static String encode(String v) {
        return URLEncoder.encode(v, StandardCharsets.UTF_8);
    }

    public static boolean isMockOAuthAllowed() {
        return Boolean.parseBoolean(setting("ENABLE_MOCK_OAUTH", "true"));
    }

    public static boolean handleMockLogin(jakarta.servlet.http.HttpServletRequest req,
                                          jakarta.servlet.http.HttpServletResponse res,
                                          String provider, String name, String email) throws java.io.IOException {
        model.User user = DAO.DaoUser.createOrLinkOAuthUser(email, name, provider, "mock_" + provider + "_id", "images/candidate-portrait.jpg");
        if (user != null) {
            jakarta.servlet.http.HttpSession s = req.getSession(true);
            s.setAttribute("username",  user.getUsername());
            s.setAttribute("userId",    user.getId());
            s.setAttribute("userEmail", user.getEmail());
            s.setAttribute("userName",  user.getName());
            s.setMaxInactiveInterval(60 * 60);
            String label = "google".equalsIgnoreCase(provider) ? "Google"
                         : "linkedin".equalsIgnoreCase(provider) ? "LinkedIn"
                         : "facebook".equalsIgnoreCase(provider) ? "Facebook"
                         : "apple".equalsIgnoreCase(provider) ? "Apple"
                         : provider;
            res.sendRedirect(req.getContextPath() + "/index.jsp?msg=" + URLEncoder.encode("Signed in successfully with " + label + " (Demo Mode)!", StandardCharsets.UTF_8));
            return true;
        }
        return false;
    }

    private static String setting(String name, String fallback) {
        return AppConfig.get(name, fallback);
    }
}
