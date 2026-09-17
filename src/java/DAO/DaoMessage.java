package DAO;

import dbHelper.MyConnect;
import java.sql.*;
import java.util.*;

public class DaoMessage {

    // Save a new message/inquiry
    public static int addMessage(String name, String email, String phone, String message, String method) {
        int status = 0;
        String sql = "INSERT INTO messages (name, email, phone, message, contact_method, status, created_at) VALUES (?, ?, ?, ?, ?, 'Unread', NOW())";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone != null ? phone : "");
            ps.setString(4, message);
            ps.setString(5, method != null ? method : "email");
            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Retrieve all messages ordered by latest first
    public static List<Map<String, Object>> getAllMessages() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM messages ORDER BY id DESC";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("name", rs.getString("name"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                map.put("message", rs.getString("message"));
                map.put("contact_method", rs.getString("contact_method"));
                map.put("status", rs.getString("status"));
                map.put("created_at", rs.getString("created_at"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Count of unread messages
    public static int getUnreadCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM messages WHERE status = 'Unread'";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // Mark as read
    public static int markAsRead(int id) {
        int status = 0;
        String sql = "UPDATE messages SET status = 'Read' WHERE id = ?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Mark as unread
    public static int markAsUnread(int id) {
        int status = 0;
        String sql = "UPDATE messages SET status = 'Unread' WHERE id = ?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Delete message
    public static int deleteMessage(int id) {
        int status = 0;
        String sql = "DELETE FROM messages WHERE id = ?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}
