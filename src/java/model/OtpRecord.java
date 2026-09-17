package model;

import java.sql.Timestamp;

/** Represents one row in verification_otps table. */
public class OtpRecord {
    private int id;
    private int userId;
    private String otpHash;
    private Timestamp expiresAt;
    private int attempts;
    private boolean used;

    public int getId()             { return id; }
    public void setId(int id)      { this.id = id; }
    public int getUserId()                 { return userId; }
    public void setUserId(int userId)      { this.userId = userId; }
    public String getOtpHash()             { return otpHash; }
    public void setOtpHash(String otpHash) { this.otpHash = otpHash; }
    public Timestamp getExpiresAt()                { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt)  { this.expiresAt = expiresAt; }
    public int getAttempts()               { return attempts; }
    public void setAttempts(int attempts)  { this.attempts = attempts; }
    public boolean isUsed()               { return used; }
    public void setUsed(boolean used)     { this.used = used; }

    public boolean isExpired() {
        return expiresAt == null || expiresAt.before(new java.util.Date());
    }
}
