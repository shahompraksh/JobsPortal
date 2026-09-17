package util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * BCrypt-compatible password hashing using pure Java.
 * Uses PBKDF2-HMAC-SHA256 with a random 16-byte salt.
 * Format: $pbkdf2$<iterations>$<salt-base64>$<hash-base64>
 */
public final class PasswordUtil {

    private static final int ITERATIONS = 310_000;
    private static final int KEY_LENGTH  = 32; // bytes
    private static final String ALGO     = "PBKDF2WithHmacSHA256";
    private static final String PREFIX   = "$pbkdf2$";

    private PasswordUtil() {}

    /** Hash a plain-text password. Returns the full encoded hash string. */
    public static String hashPassword(String plain) {
        try {
            byte[] salt = new byte[16];
            new SecureRandom().nextBytes(salt);
            byte[] hash = pbkdf2(plain.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
            return PREFIX + ITERATIONS + "$"
                    + Base64.getEncoder().encodeToString(salt) + "$"
                    + Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Password hashing failed", e);
        }
    }

    /** Verify a plain-text password against a stored hash. */
    public static boolean checkPassword(String plain, String stored) {
        if (stored == null) return false;
        try {
            if (stored.startsWith(PREFIX)) {
                String[] parts = stored.split("\\$");
                // parts: [0]="" [1]="pbkdf2" [2]=iterations [3]=salt [4]=hash
                int iters     = Integer.parseInt(parts[2]);
                byte[] salt   = Base64.getDecoder().decode(parts[3]);
                byte[] target = Base64.getDecoder().decode(parts[4]);
                byte[] attempt = pbkdf2(plain.toCharArray(), salt, iters, target.length);
                return MessageDigest.isEqual(target, attempt);
            }
            // Legacy: plain-text comparison (will be auto-migrated)
            return plain.equals(stored);
        } catch (Exception e) {
            return false;
        }
    }

    /** True if stored value looks like a legacy plain-text (not our format). */
    public static boolean isLegacyPlainText(String stored) {
        return stored != null && !stored.startsWith(PREFIX);
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLen)
            throws Exception {
        javax.crypto.spec.PBEKeySpec spec =
                new javax.crypto.spec.PBEKeySpec(password, salt, iterations, keyLen * 8);
        javax.crypto.SecretKeyFactory skf =
                javax.crypto.SecretKeyFactory.getInstance(ALGO);
        return skf.generateSecret(spec).getEncoded();
    }
}
