package DAO;

import dbHelper.MyConnect;
import model.Application;
import java.sql.*;
import java.util.*;

public class DaoApplication {

    // Fetch applications for a specific job seeker
    public static List<Application> getApplicationsByUser(int userId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, j.title AS jobtitle, j.company AS company " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "WHERE a.user_id = ? ORDER BY a.applied_date DESC";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Application app = new Application();
                    app.setId(rs.getInt("id"));
                    app.setUserID(rs.getInt("user_id"));
                    app.setJobID(rs.getInt("job_id"));
                    app.setJobtitle(rs.getString("jobtitle"));
                    app.setCompany(rs.getString("company"));
                    app.setApplieddate(rs.getString("applied_date"));
                    app.setStatus(rs.getString("status"));
                    list.add(app);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Fetch all applications for Admin view with applicant and job details
    public static List<Application> getAllApplications() {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.id, a.user_id, a.job_id, a.applied_date, a.status, " +
                     "u.name AS applicant_name, u.email AS applicant_email, u.phone AS applicant_phone, u.resume AS applicant_resume, " +
                     "j.title AS job_title, j.company AS job_company " +
                     "FROM applications a " +
                     "JOIN user u ON a.user_id = u.id " +
                     "JOIN jobs j ON a.job_id = j.id " +
                     "ORDER BY a.applied_date DESC";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Application app = new Application();
                app.setId(rs.getInt("id"));
                app.setUserID(rs.getInt("user_id"));
                app.setJobID(rs.getInt("job_id"));
                app.setApplieddate(rs.getString("applied_date"));
                app.setStatus(rs.getString("status"));
                app.setApplicantName(rs.getString("applicant_name"));
                app.setApplicantEmail(rs.getString("applicant_email"));
                app.setApplicantPhone(rs.getString("applicant_phone"));
                app.setApplicantResume(rs.getString("applicant_resume"));
                app.setJobtitle(rs.getString("job_title"));
                app.setCompany(rs.getString("job_company"));
                list.add(app);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Submit new application
    public static int addApplication(Application app) {
        int status = 0;
        String sql = "INSERT INTO applications (user_id, job_id, applied_date, status) VALUES (?, ?, NOW(), ?)";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, app.getUserID());
            ps.setInt(2, app.getJobID());
            ps.setString(3, app.getStatus());

            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Admin updates application status (e.g. Hired, Shortlisted, Rejected)
    public static int updateStatus(int applicationId, String newStatus) {
        int status = 0;
        String sql = "UPDATE applications SET status = ? WHERE id = ?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, applicationId);
            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Candidate withdraws pending application
    public static boolean withdrawPendingApplication(int applicationId, int userId) {
        String sql = "DELETE FROM applications WHERE id=? AND user_id=? AND status='Pending'";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
