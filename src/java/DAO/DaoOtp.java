package DAO;

import java.sql.*;
import dbHelper.MyConnect;
import model.OtpRecord;

/** Data Access Object for OTP verification and rate-limiting tables. */
public class DaoOtp {

    private static final int OTP_EXPIRE_MINUTES = 10;
    private static final int MAX_RESEND_PER_WINDOW = 3;
    private static final int RESEND_WINDOW_MINUTES  = 10;

    // ── Save a new OTP (invalidates any existing unused OTP for this user) ──
    public static void saveOtp(int userId, String otpHash) {
        try (Connection conn = MyConnect.connectDatab()) {
            // Invalidate old
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE verification_otps SET used=1 WHERE user_id=? AND used=0")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            // Insert new
            Timestamp exp = new Timestamp(System.currentTimeMillis() + OTP_EXPIRE_MINUTES * 60_000L);
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO verification_otps (user_id, otp_hash, expires_at) VALUES (?,?,?)")) {
                ps.setInt(1, userId);
                ps.setString(2, otpHash);
                ps.setTimestamp(3, exp);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ── Get the latest active (non-used) OTP for a user ──
    public static OtpRecord getActiveOtp(int userId) {
        String sql = "SELECT * FROM verification_otps WHERE user_id=? AND used=0 ORDER BY id DESC LIMIT 1";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                OtpRecord r = new OtpRecord();
                r.setId(rs.getInt("id"));
                r.setUserId(rs.getInt("user_id"));
                r.setOtpHash(rs.getString("otp_hash"));
                r.setExpiresAt(rs.getTimestamp("expires_at"));
                r.setAttempts(rs.getInt("attempts"));
                r.setUsed(rs.getBoolean("used"));
                return r;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // ── Increment attempt counter; returns true if still under limit ──
    public static boolean incrementAttempts(int otpId) {
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE verification_otps SET attempts = attempts + 1 WHERE id=?")) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
        // Re-read attempts
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT attempts FROM verification_otps WHERE id=?")) {
            ps.setInt(1, otpId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("attempts") < util.OtpUtil.getMaxAttempts();
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ── Mark OTP as used ──
    public static void markOtpUsed(int otpId) {
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE verification_otps SET used=1 WHERE id=?")) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ── Check if email is rate-limited for resend ──
    public static boolean isResendRateLimited(String email) {
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT attempt_count, window_start FROM otp_rate_limits WHERE email=?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("attempt_count");
                Timestamp windowStart = rs.getTimestamp("window_start");
                long elapsed = System.currentTimeMillis() - windowStart.getTime();
                long windowMs = RESEND_WINDOW_MINUTES * 60_000L;
                if (elapsed > windowMs) return false; // window expired — not limited
                return count >= MAX_RESEND_PER_WINDOW;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // ── Record a resend attempt (insert or update) ──
    public static void recordResendAttempt(String email) {
        try (Connection conn = MyConnect.connectDatab()) {
            // Check if window expired first
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT window_start FROM otp_rate_limits WHERE email=?")) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    Timestamp ws = rs.getTimestamp("window_start");
                    long elapsed = System.currentTimeMillis() - ws.getTime();
                    if (elapsed > RESEND_WINDOW_MINUTES * 60_000L) {
                        // Reset window
                        try (PreparedStatement upd = conn.prepareStatement(
                                "UPDATE otp_rate_limits SET attempt_count=1, window_start=NOW() WHERE email=?")) {
                            upd.setString(1, email);
                            upd.executeUpdate();
                        }
                        return;
                    }
                    // Increment
                    try (PreparedStatement upd = conn.prepareStatement(
                            "UPDATE otp_rate_limits SET attempt_count=attempt_count+1 WHERE email=?")) {
                        upd.setString(1, email);
                        upd.executeUpdate();
                    }
                    return;
                }
            }
            // Insert first record
            try (PreparedStatement ins = conn.prepareStatement(
                    "INSERT INTO otp_rate_limits (email, attempt_count) VALUES (?,1)")) {
                ins.setString(1, email);
                ins.executeUpdate();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
}
