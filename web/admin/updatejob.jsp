<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, dbHelper.MyConnect" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String jobId = request.getParameter("id");
    if (jobId == null || jobId.isBlank()) {
        response.sendRedirect("viewalljobs.jsp?msg=Please+select+a+job+to+update.");
        return;
    }

    String title = "", company = "", location = "", description = "", type = "";
    double salary = 0;

    try (Connection conn = MyConnect.connectDatab();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM jobs WHERE id = ?")) {
        ps.setInt(1, Integer.parseInt(jobId));
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                title = rs.getString("title");
                company = rs.getString("company");
                location = rs.getString("location");
                salary = rs.getDouble("salary");
                description = rs.getString("description");
                type = rs.getString("type");
            } else {
                response.sendRedirect("viewalljobs.jsp?error=JobNotFound");
                return;
            }
        }
    } catch (Exception e) {
        response.sendRedirect("viewalljobs.jsp?error=" + java.net.URLEncoder.encode("Error loading job: " + e.getMessage(), "UTF-8"));
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Job #<%= jobId %> - Elevate Workforce Admin</title>
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Modern Admin Stylesheet -->
    <link rel="stylesheet" href="admin-modern.css">
</head>
<body>
    <div class="admin-wrapper">
        <jsp:include page="admin-sidebar.jsp" />

        <div class="admin-main">
            <jsp:include page="admin-topbar.jsp" />

            <main class="admin-content">
                <div class="mb-4">
                    <a href="viewalljobs.jsp" class="text-muted small text-decoration-none">
                        <i class="bi bi-arrow-left me-1"></i> Back to All Jobs
                    </a>
                    <h2 class="fw-bold mt-2 mb-1">Edit Job Listing #<%= jobId %></h2>
                    <p class="text-muted small">Update vacancy details, compensation benchmarks, and job specifications.</p>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-10">
                        <div class="adm-card p-4 p-md-5">
                            <form action="../doUpdateJob" method="post">
                                <input type="hidden" name="id" value="<%= jobId %>">

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="title" class="form-label small fw-bold">Job Title <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-briefcase"></i></span>
                                            <input type="text" id="title" name="title" class="form-control" value="<%= title %>" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="company" class="form-label small fw-bold">Hiring Company <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-building"></i></span>
                                            <input type="text" id="company" name="company" class="form-control" value="<%= company %>" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="location" class="form-label small fw-bold">Location <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-geo-alt"></i></span>
                                            <input type="text" id="location" name="location" class="form-control" value="<%= location %>" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="salary" class="form-label small fw-bold">Monthly Salary (NPR)</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted">NPR</span>
                                            <input type="number" id="salary" name="salary" class="form-control" value="<%= (long)salary %>">
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="type" class="form-label small fw-bold">Employment Type <span class="text-danger">*</span></label>
                                        <select id="type" name="type" class="form-select" required>
                                            <option value="Full-time" <%= "Full-time".equalsIgnoreCase(type) ? "selected" : "" %>>Full-time</option>
                                            <option value="Part-time" <%= "Part-time".equalsIgnoreCase(type) ? "selected" : "" %>>Part-time</option>
                                            <option value="Internship" <%= "Internship".equalsIgnoreCase(type) ? "selected" : "" %>>Internship</option>
                                            <option value="Remote" <%= "Remote".equalsIgnoreCase(type) ? "selected" : "" %>>Remote</option>
                                        </select>
                                    </div>

                                    <div class="col-12">
                                        <label for="description" class="form-label small fw-bold">Job Description & Requirements <span class="text-danger">*</span></label>
                                        <textarea id="description" name="description" rows="6" class="form-control" required><%= description %></textarea>
                                    </div>

                                    <div class="col-12 mt-4 d-flex justify-content-end gap-2">
                                        <a href="viewalljobs.jsp" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
                                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold shadow-sm">
                                            <i class="bi bi-cloud-arrow-up-fill me-1"></i> Save Changes
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="admin-modern.js"></script>
</body>
</html>