package DAO;

import dbHelper.MyConnect;
import model.Job;
import java.sql.*;
import java.util.*;

public class DaoJobs {

    // ✅ Add new job
    public static int addJob(Job j) {
        int status = 0;
        String sql = "INSERT INTO jobs (title, company, location, salary, description, type) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, j.getTitle());
            ps.setString(2, j.getCompany());
            ps.setString(3, j.getLocation());
            ps.setDouble(4, j.getSalary());
            ps.setString(5, j.getDescription());
            ps.setString(6, j.getType());

            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // ✅ Delete job
    public static int deljob(Job j) {
        int status = 0;
        try (Connection conn = MyConnect.connectDatab()) {
            String sql = "DELETE FROM jobs WHERE id=?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, j.getId());
            status = pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // ✅ Fetch jobs with pagination, filters, search and sorting
    public static List<Job> getJobs(int offset, int noOfRecords, String type, String location, double maxSalary, String search, String sortBy) {
        List<Job> jobList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM jobs WHERE 1=1");

        if (type != null && !type.isEmpty()) sql.append(" AND type=?");
        if (location != null && !location.isEmpty()) sql.append(" AND location=?");
        if (maxSalary > 0) sql.append(" AND salary<=?");
        if (search != null && !search.isEmpty()) sql.append(" AND (title LIKE ? OR company LIKE ?)");

        // Sorting
        if (sortBy != null) {
            switch (sortBy) {
                case "Newest":
                    sql.append(" ORDER BY id DESC");
                    break;
                case "Oldest":
                    sql.append(" ORDER BY id ASC");
                    break;
                case "Salary: High to Low":
                    sql.append(" ORDER BY salary DESC");
                    break;
                case "Salary: Low to High":
                    sql.append(" ORDER BY salary ASC");
                    break;
                default:
                    sql.append(" ORDER BY id DESC");
            }
        } else {
            sql.append(" ORDER BY id DESC");
        }

        sql.append(" LIMIT ?, ?");

        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (type != null && !type.isEmpty()) ps.setString(idx++, type);
            if (location != null && !location.isEmpty()) ps.setString(idx++, location);
            if (maxSalary > 0) ps.setDouble(idx++, maxSalary);
            if (search != null && !search.isEmpty()) {
                ps.setString(idx++, "%" + search + "%");
                ps.setString(idx++, "%" + search + "%");
            }

            ps.setInt(idx++, offset);
            ps.setInt(idx, noOfRecords);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Job j = new Job();
                j.setId(rs.getInt("id"));
                j.setTitle(rs.getString("title"));
                j.setCompany(rs.getString("company"));
                j.setLocation(rs.getString("location"));
                j.setSalary(rs.getDouble("salary"));
                j.setDescription(rs.getString("description"));
                j.setType(rs.getString("type"));
                jobList.add(j);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jobList;
    }

    // ✅ Count jobs for pagination with filters
    public static int getJobCount(String type, String location, double maxSalary, String search) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM jobs WHERE 1=1");

        if (type != null && !type.isEmpty()) sql.append(" AND type=?");
        if (location != null && !location.isEmpty()) sql.append(" AND location=?");
        if (maxSalary > 0) sql.append(" AND salary<=?");
        if (search != null && !search.isEmpty()) sql.append(" AND (title LIKE ? OR company LIKE ?)");

        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (type != null && !type.isEmpty()) ps.setString(idx++, type);
            if (location != null && !location.isEmpty()) ps.setString(idx++, location);
            if (maxSalary > 0) ps.setDouble(idx++, maxSalary);
            if (search != null && !search.isEmpty()) {
                ps.setString(idx++, "%" + search + "%");
                ps.setString(idx++, "%" + search + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    // ✅ Fetch all jobs (admin or full listing)
    public static List<Job> getAllJobs() {
        List<Job> jobList = new ArrayList<>();
        String sql = "SELECT * FROM jobs ORDER BY id ASC";

        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Job j = new Job();
                j.setId(rs.getInt("id"));
                j.setTitle(rs.getString("title"));
                j.setCompany(rs.getString("company"));
                j.setLocation(rs.getString("location"));
                j.setSalary(rs.getDouble("salary"));
                j.setDescription(rs.getString("description"));
                j.setType(rs.getString("type"));
                jobList.add(j);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return jobList;
    }
    // Fetch single job by ID
public static Job getJobById(int id) {
    Job job = null;
    String sql = "SELECT * FROM jobs WHERE id = ?";
    try (Connection conn = MyConnect.connectDatab();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            job = new Job();
            job.setId(rs.getInt("id"));
            job.setTitle(rs.getString("title"));
            job.setCompany(rs.getString("company"));
            job.setLocation(rs.getString("location"));
            job.setSalary(rs.getDouble("salary"));
            job.setDescription(rs.getString("description"));
            job.setType(rs.getString("type"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return job;
}

    // ✅ Update existing job
    public static int updateJob(Job j) {
        int status = 0;
        String sql = "UPDATE jobs SET title=?, company=?, location=?, salary=?, description=?, type=? WHERE id=?";
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, j.getTitle());
            ps.setString(2, j.getCompany());
            ps.setString(3, j.getLocation());
            ps.setDouble(4, j.getSalary());
            ps.setString(5, j.getDescription());
            ps.setString(6, j.getType());
            ps.setInt(7, j.getId());

            status = ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

}

