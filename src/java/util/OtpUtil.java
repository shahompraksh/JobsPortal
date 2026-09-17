package util;

import java.security.MessageDigest;
import java.security.SecureRandom;

/** Generates and verifies 6-digit OTPs. OTPs are stored as SHA-256(salt+otp). */
public final class OtpUtil {

    private static final SecureRandom RNG = new SecureRandom();
    private static final int MAX_ATTEMPTS = 5;

    private OtpUtil() {}

    /** Generate a cryptographically secure 6-digit OTP string (e.g. "048291"). */
    public static String generateOtp() {
        int code = RNG.nextInt(900_000) + 100_000; // always 6 digits
        return String.valueOf(code);
    }

    /**
     * Hash an OTP with a fresh random salt.
     * Returns "salt:hash" hex string to store in DB.
     */
    public static String hashOtp(String otp) {
        try {
            byte[] saltBytes = new byte[16];
            RNG.nextBytes(saltBytes);
            String salt = toHex(saltBytes);
            String hash = sha256Hex(salt + otp);
            return salt + ":" + hash;
        } catch (Exception e) {
            throw new RuntimeException("OTP hashing failed", e);
        }
    }

    /**
     * Verify a plain OTP against the stored "salt:hash" value.
     */
    public static boolean verifyOtp(String plain, String stored) {
        if (plain == null || stored == null) return false;
        try {
            String[] parts = stored.split(":", 2);
            if (parts.length != 2) return false;
            String expectedHash = sha256Hex(parts[0] + plain.trim());
            return MessageDigest.isEqual(
                    fromHex(expectedHash), fromHex(parts[1]));
        } catch (Exception e) {
            return false;
        }
    }

    public static int getMaxAttempts() { return MAX_ATTEMPTS; }

    /* ── helpers ── */
    private static String sha256Hex(String input) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        return toHex(md.digest(input.getBytes("UTF-8")));
    }

    private static String toHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    private static byte[] fromHex(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2)
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                                 + Character.digit(hex.charAt(i + 1), 16));
        return data;
    }
}
