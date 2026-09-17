package DAO;

import java.sql.*;
import dbHelper.MyConnect;
import model.User;

public class DaoUser {

    // ✅ Register a new user
    public static int registerUser(User u) {
        int status = 0;
        String sql = "INSERT INTO user (name, email, username, password, phone, is_verified) VALUES (?, ?, ?, ?, ?, 1)";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, u.getName());
            pst.setString(2, u.getEmail());
            pst.setString(3, u.getUsername());
            pst.setString(4, u.getPassword());
            pst.setString(5, u.getPhone());

            status = pst.executeUpdate();
            System.out.println("User registered successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // ✅ Update user profile
    // ✅ Update user profile
public static int updateUser(User u) {
    int status = 0;
    String sql = "UPDATE user SET name=?, email=?, username=?, password=?, phone=?, resume=? WHERE id=?";
    try (Connection conn = MyConnect.connectDatab();
         PreparedStatement pst = conn.prepareStatement(sql)) {

        pst.setString(1, u.getName());
        pst.setString(2, u.getEmail());
        pst.setString(3, u.getUsername());
        pst.setString(4, u.getPassword());
        pst.setString(5, u.getPhone());
        pst.setString(6, u.getResume());
        pst.setInt(7, u.getId());

        status = pst.executeUpdate();
        System.out.println("User updated successfully. Rows affected: " + status);

    } catch (Exception e) {
        e.printStackTrace();
    }
    return status;
}

    // ✅ Delete user
    public static int deleteUser(int id) {
        int status = 0;
        String sql = "DELETE FROM user WHERE id=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, id);
            status = pst.executeUpdate();
            System.out.println("User deleted successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // ✅ Login and return User details (instead of boolean)
    public static User doLogin(String username, String password) {
        User u = null;
        String sql = "SELECT * FROM user WHERE username=? AND password=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, username);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setPhone(rs.getString("phone"));
                u.setResume(rs.getString("resume"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }

    // ✅ Fetch user by username
    public static User getUserByUsername(String username) {
        User u = null;
        String sql = "SELECT * FROM user WHERE username=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, username);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setPhone(rs.getString("phone"));
                u.setResume(rs.getString("resume"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }

    // ✅ Fetch all users for Admin
    public static java.util.List<User> getAllUsers() {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM user ORDER BY id DESC";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setPhone(rs.getString("phone"));
                u.setResume(rs.getString("resume"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Fetch user by ID
    public static User getUserById(int id) {
        User u = null;
        String sql = "SELECT * FROM user WHERE id=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setPhone(rs.getString("phone"));
                u.setResume(rs.getString("resume"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }

    // ✅ Count total users
    public static int getUserCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM user";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // ── NEW AUTH METHODS ────────────────────────────────────────────

    /** Fetch user by email address. */
    public static User getUserByEmail(String email) {
        User u = null;
        String sql = "SELECT * FROM user WHERE email=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                u = mapUser(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return u;
    }

    /** Mark a user account as email-verified. */
    public static void setUserVerified(int userId) {
        String sql = "UPDATE user SET is_verified=1 WHERE id=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, userId);
            pst.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    /** Check whether a user has verified their email (auto-authorized). */
    public static boolean isUserVerified(int userId) {
        return true;
    }

    /** Fetch user linked to a specific OAuth provider + provider user ID. */
    public static User getUserByOAuthId(String provider, String providerUserId) {
        String sql = "SELECT u.* FROM user u "
                   + "JOIN oauth_accounts oa ON oa.user_id = u.id "
                   + "WHERE oa.provider=? AND oa.provider_user_id=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, provider);
            pst.setString(2, providerUserId);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /** Link an OAuth account to an existing user. */
    public static void linkOAuthAccount(int userId, String provider, String providerUserId, String email) {
        String sql = "INSERT IGNORE INTO oauth_accounts (user_id, provider, provider_user_id, email) VALUES (?,?,?,?)";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, userId);
            pst.setString(2, provider);
            pst.setString(3, providerUserId);
            pst.setString(4, email);
            pst.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    /**
     * Core OAuth login/register:
     * 1. Look up by OAuth provider ID → return existing linked user
     * 2. Look up by email → link OAuth to existing account → return user
     * 3. Create new user account → link OAuth → return new user
     */
    public static User createOrLinkOAuthUser(String email, String name,
                                              String provider, String providerUserId,
                                              String profileImage) {
        // 1. Already linked?
        User existing = getUserByOAuthId(provider, providerUserId);
        if (existing != null) return existing;

        // 2. Email match?
        User byEmail = (email != null && !email.isBlank()) ? getUserByEmail(email) : null;
        if (byEmail != null) {
            linkOAuthAccount(byEmail.getId(), provider, providerUserId, email);
            setUserVerified(byEmail.getId()); // email confirmed by OAuth provider
            return byEmail;
        }

        // 3. Create new user
        if (email == null || email.isBlank()) email = provider + "_" + providerUserId + "@noemail.invalid";
        String baseUsername = provider;
        if (name != null && !name.isBlank()) {
            String clean = name.toLowerCase().replaceAll("[^a-z0-9]", "");
            if (!clean.isBlank()) {
                baseUsername = clean.substring(0, Math.min(clean.length(), 16));
            }
        }
        String username = makeUniqueUsername(baseUsername);

        String sql = "INSERT INTO user (name, email, username, password, is_verified, profile_image) VALUES (?,?,?,?,1,?)";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            pst.setString(1, name != null ? name : "OAuth User");
            pst.setString(2, email);
            pst.setString(3, username);
            pst.setString(4, "OAUTH_NO_PASSWORD"); // cannot login with password
            pst.setString(5, profileImage);
            pst.executeUpdate();
            ResultSet keys = pst.getGeneratedKeys();
            if (keys.next()) {
                int newId = keys.getInt(1);
                linkOAuthAccount(newId, provider, providerUserId, email);
                return getUserById(newId);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /** Generate a unique username by appending a number if needed. */
    private static String makeUniqueUsername(String base) {
        if (base == null || base.isBlank()) base = "user";
        String candidate = base;
        int suffix = 1;
        while (getUserByUsername(candidate) != null) {
            candidate = base + suffix++;
        }
        return candidate;
    }

    /** Map a ResultSet row to a User object (shared helper). */
    private static User mapUser(ResultSet rs) throws Exception {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setPhone(rs.getString("phone"));
        u.setResume(rs.getString("resume"));
        return u;
    }
}
