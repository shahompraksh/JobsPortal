package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import dbHelper.MyConnect;
import model.Admin;

public class DaoAdmin {

    // Update admin record
    public static int doSave(Admin a) {
        int status = 0;
        String sql = "UPDATE admin SET name=?, address=?, username=?, password=? WHERE id=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, a.getName());
            pst.setString(2, a.getAddress());
            pst.setString(3, a.getUsername());
            pst.setString(4, a.getPassword());
            pst.setInt(5, a.getId());

            status = pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static int doUpdat(Admin a) {
        return doSave(a);
    }

    public static int doDel(Admin a) {
        int status = 0;
        String sql = "DELETE FROM admin WHERE id=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, a.getId());
            status = pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static int doLogin(Admin a) {
        int status = 0;
        String sql = "SELECT * FROM admin WHERE username=? AND password=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, a.getUsername());
            pst.setString(2, a.getPassword());

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    status = 1;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static Admin getAdminByUsername(String username) {
        Admin a = null;
        String sql = "SELECT * FROM admin WHERE username=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, username);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    a = new Admin();
                    a.setId(rs.getInt("id"));
                    a.setName(rs.getString("name"));
                    a.setAddress(rs.getString("address"));
                    a.setUsername(rs.getString("username"));
                    a.setPassword(rs.getString("password"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return a;
    }
}
