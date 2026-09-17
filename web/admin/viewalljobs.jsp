<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, dbHelper.MyConnect" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String search = request.getParameter("search") != null ? request.getParameter("search").trim() : "";
    String typeFilter = request.getParameter("type") != null ? request.getParameter("type").trim() : "";
    String locFilter = request.getParameter("location") != null ? request.getParameter("location").trim() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Jobs - Elevate Workforce Admin</title>
    
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
                <!-- Page Title -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="fw-bold mb-1">Jobs & Services Management</h2>
                        <p class="text-muted mb-0 small">Create, modify, and monitor active job postings across Nepal.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <button onclick="exportTableToCSV('jobsTable', 'elevate_jobs.csv')" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold btn-sm">
                            <i class="bi bi-download me-1"></i> Export Jobs CSV
                        </button>
                        <a href="addnewjob.jsp" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold btn-sm shadow-sm">
                            <i class="bi bi-plus-circle-fill me-1"></i> Post New Job
                        </a>
                    </div>
                </div>

                <!-- Messages -->
                <%
                    String msg = request.getParameter("msg");
                    String err = request.getParameter("error");
                    if (msg != null && !msg.isBlank()) {
                %>
                    <div class="alert alert-success alert-dismissible fade show rounded-4 small mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } else if (err != null && !err.isBlank()) { %>
                    <div class="alert alert-danger alert-dismissible fade show rounded-4 small mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> <%= err %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Admin Running Partner Companies Ticker -->
                <jsp:include page="admin-running-ticker.jsp" />

                <!-- Filter Toolbar -->
                <div class="adm-card mb-4 p-3">
                    <form method="get" action="viewalljobs.jsp" class="row g-2 align-items-center">
                        <div class="col-md-5 col-12">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                                <input type="text" name="search" class="form-control border-start-0" placeholder="Search by title, role or company..." value="<%= search %>">
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <select name="type" class="form-select">
                                <option value="">All Employment Types</option>
                                <option value="Full-time" <%= "Full-time".equalsIgnoreCase(typeFilter) ? "selected" : "" %>>Full-time</option>
                                <option value="Part-time" <%= "Part-time".equalsIgnoreCase(typeFilter) ? "selected" : "" %>>Part-time</option>
                                <option value="Remote" <%= "Remote".equalsIgnoreCase(typeFilter) ? "selected" : "" %>>Remote</option>
                                <option value="Internship" <%= "Internship".equalsIgnoreCase(typeFilter) ? "selected" : "" %>>Internship</option>
                            </select>
                        </div>
                        <div class="col-md-2 col-6">
                            <select name="location" class="form-select">
                                <option value="">All Locations</option>
                                <option value="Kathmandu" <%= "Kathmandu".equalsIgnoreCase(locFilter) ? "selected" : "" %>>Kathmandu</option>
                                <option value="Pokhara" <%= "Pokhara".equalsIgnoreCase(locFilter) ? "selected" : "" %>>Pokhara</option>
                                <option value="Lalitpur" <%= "Lalitpur".equalsIgnoreCase(locFilter) ? "selected" : "" %>>Lalitpur</option>
                            </select>
                        </div>
                        <div class="col-md-2 col-12 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100 fw-semibold">Filter</button>
                            <% if (!search.isEmpty() || !typeFilter.isEmpty() || !locFilter.isEmpty()) { %>
                                <a href="viewalljobs.jsp" class="btn btn-outline-secondary" title="Clear Filters"><i class="bi bi-x-lg"></i></a>
                            <% } %>
                        </div>
                    </form>
                </div>

                <!-- Jobs Table -->
                <div class="table-modern-wrapper">
                    <div class="table-responsive">
                        <table id="jobsTable" class="table-modern">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Job Title</th>
                                    <th>Company</th>
                                    <th>Location</th>
                                    <th>Monthly Salary</th>
                                    <th>Type</th>
                                    <th>Applicants</th>
                                    <th class="text-end no-export">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    StringBuilder query = new StringBuilder("SELECT j.*, (SELECT COUNT(*) FROM applications WHERE job_id = j.id) as app_cnt FROM jobs j WHERE 1=1");
                                    if (!search.isEmpty()) query.append(" AND (title LIKE ? OR company LIKE ?)");
                                    if (!typeFilter.isEmpty()) query.append(" AND type = ?");
                                    if (!locFilter.isEmpty()) query.append(" AND location = ?");
                                    query.append(" ORDER BY j.id DESC");

                                    boolean hasJobs = false;
                                    try (Connection conn = MyConnect.connectDatab();
                                         PreparedStatement ps = conn.prepareStatement(query.toString())) {
                                        int pIdx = 1;
                                        if (!search.isEmpty()) {
                                            ps.setString(pIdx++, "%" + search + "%");
                                            ps.setString(pIdx++, "%" + search + "%");
                                        }
                                        if (!typeFilter.isEmpty()) ps.setString(pIdx++, typeFilter);
                                        if (!locFilter.isEmpty()) ps.setString(pIdx++, locFilter);

                                        try (ResultSet rs = ps.executeQuery()) {
                                            while (rs.next()) {
                                                hasJobs = true;
                                                int jId = rs.getInt("id");
                                                String title = rs.getString("title");
                                                String company = rs.getString("company");
                                                String location = rs.getString("location");
                                                double salary = rs.getDouble("salary");
                                                String type = rs.getString("type");
                                                int appCnt = rs.getInt("app_cnt");
                                %>
                                <tr>
                                    <td class="fw-bold text-muted">#<%= jId %></td>
                                    <td>
                                        <div class="fw-bold text-slate-900"><%= title %></div>
                                    </td>
                                    <td>
                                        <i class="bi bi-building me-1 text-muted"></i><%= company %>
                                    </td>
                                    <td>
                                        <i class="bi bi-geo-alt me-1 text-muted"></i><%= location %>
                                    </td>
                                    <td>
                                        <strong>NPR <%= String.format("%,.0f", salary) %></strong>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary-subtle text-primary border rounded-pill px-2 py-1 small">
                                            <%= type %>
                                        </span>
                                    </td>
                                    <td>
                                        <a href="viewapplications.jsp?jobFilter=<%= jId %>" class="badge bg-info-subtle text-info border rounded-pill px-3 py-1 text-decoration-none">
                                            <i class="bi bi-people-fill me-1"></i> <%= appCnt %>
                                        </a>
                                    </td>
                                    <td class="text-end no-export">
                                        <a href="updatejob.jsp?id=<%= jId %>" class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1" title="Edit Details">
                                            <i class="bi bi-pencil me-1"></i> Edit
                                        </a>
                                        <form action="../doDeleteJob" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to permanently delete \'<%= title %>\'?');">
                                            <input type="hidden" name="id" value="<%= jId %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-2" title="Delete Job">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <%          }
                                        }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    }
                                    if (!hasJobs) {
                                %>
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">No job postings matching criteria.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
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