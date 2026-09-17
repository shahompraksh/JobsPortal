<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, dbHelper.MyConnect, DAO.DaoMessage"%>
<%
    String username = (String) session.getAttribute("un");
    if (username == null) {
        username = (String) session.getAttribute("username");
    }
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Database Metrics Aggregation
    int totalJobs = 0;
    int totalUsers = 0;
    int totalApplications = 0;
    double totalPayroll = 0;
    int pendingApps = 0;
    int hiredApps = 0;
    int shortlistedApps = 0;
    int unreadMessages = 0;

    try (Connection conn = MyConnect.connectDatab()) {
        // Jobs count & sum salary
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*), COALESCE(SUM(salary), 0) FROM jobs")) {
            if (rs.next()) {
                totalJobs = rs.getInt(1);
                totalPayroll = rs.getDouble(2);
            }
        }
        // Users count
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM user")) {
            if (rs.next()) totalUsers = rs.getInt(1);
        }
        // Applications count
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM applications")) {
            if (rs.next()) totalApplications = rs.getInt(1);
        }
        // Status counts
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT status, COUNT(*) FROM applications GROUP BY status")) {
            while (rs.next()) {
                String stName = rs.getString(1);
                int count = rs.getInt(2);
                if ("Pending".equalsIgnoreCase(stName)) pendingApps = count;
                else if ("Hired".equalsIgnoreCase(stName)) hiredApps = count;
                else if ("Shortlisted".equalsIgnoreCase(stName)) shortlistedApps = count;
            }
        }
        unreadMessages = DaoMessage.getUnreadCount();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Executive Dashboard - Elevate Workforce Admin</title>
    
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
        <!-- Reusable Sidebar -->
        <jsp:include page="admin-sidebar.jsp" />

        <!-- Main Wrapper -->
        <div class="admin-main">
            <!-- Reusable Topbar -->
            <jsp:include page="admin-topbar.jsp" />

            <!-- Content Area -->
            <main class="admin-content">
                <!-- Page Title -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="fw-bold mb-1">Executive Dashboard</h2>
                        <p class="text-muted mb-0 small">Real-time recruitment metrics, candidate pipeline, and portal operations.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <a href="addnewjob.jsp" class="btn btn-primary rounded-pill px-3 py-2 fw-semibold btn-sm shadow-sm">
                            <i class="bi bi-plus-circle-fill me-1"></i> Post New Job
                        </a>
                        <a href="reports.jsp" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold btn-sm">
                            <i class="bi bi-download me-1"></i> Export Data
                        </a>
                    </div>
                </div>

                <!-- Alert Messages -->
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

                <!-- KPI Metric Cards -->
                <div class="row g-4 mb-4">
                    <!-- Total Jobs -->
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-widget">
                            <div class="stat-widget-icon stat-icon-primary">
                                <i class="bi bi-briefcase-fill"></i>
                            </div>
                            <div>
                                <div class="stat-widget-val"><%= totalJobs %></div>
                                <p class="stat-widget-label">Active Job Postings</p>
                                <span class="stat-trend trend-up"><i class="bi bi-arrow-up-right"></i> Live on Portal</span>
                            </div>
                        </div>
                    </div>

                    <!-- Total Candidates -->
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-widget">
                            <div class="stat-widget-icon stat-icon-accent">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <div>
                                <div class="stat-widget-val"><%= totalUsers %></div>
                                <p class="stat-widget-label">Registered Candidates</p>
                                <span class="stat-trend trend-up"><i class="bi bi-check-circle"></i> Verified Seekers</span>
                            </div>
                        </div>
                    </div>

                    <!-- Total Applications -->
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-widget">
                            <div class="stat-widget-icon stat-icon-success">
                                <i class="bi bi-file-earmark-check-fill"></i>
                            </div>
                            <div>
                                <div class="stat-widget-val"><%= totalApplications %></div>
                                <p class="stat-widget-label">Total Applications</p>
                                <span class="stat-trend trend-up"><i class="bi bi-graph-up-arrow"></i> Submissions</span>
                            </div>
                        </div>
                    </div>

                    <!-- Estimated Payroll Volume -->
                    <div class="col-xl-3 col-md-6">
                        <div class="stat-widget">
                            <div class="stat-widget-icon stat-icon-warning">
                                <i class="bi bi-cash-stack"></i>
                            </div>
                            <div>
                                <div class="stat-widget-val" style="font-size: 1.45rem;">
                                    NPR <%= String.format("%,.0f", totalPayroll) %>
                                </div>
                                <p class="stat-widget-label">Monthly Payroll Volume</p>
                                <span class="stat-trend text-muted"><i class="bi bi-calculator"></i> Active Listings</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Secondary Metric Row -->
                <div class="row g-4 mb-4">
                    <div class="col-md-3 col-6">
                        <div class="adm-card p-3 d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted small fw-semibold">Pending Review</span>
                                <h4 class="fw-bold mb-0 text-warning"><%= pendingApps %></h4>
                            </div>
                            <span class="badge bg-warning-subtle text-warning-emphasis p-2 rounded-circle"><i class="bi bi-clock-history fs-5"></i></span>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div class="adm-card p-3 d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted small fw-semibold">Shortlisted</span>
                                <h4 class="fw-bold mb-0 text-info"><%= shortlistedApps %></h4>
                            </div>
                            <span class="badge bg-info-subtle text-info p-2 rounded-circle"><i class="bi bi-star-fill fs-5"></i></span>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div class="adm-card p-3 d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted small fw-semibold">Hired / Placed</span>
                                <h4 class="fw-bold mb-0 text-success"><%= hiredApps %></h4>
                            </div>
                            <span class="badge bg-success-subtle text-success p-2 rounded-circle"><i class="bi bi-award-fill fs-5"></i></span>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div class="adm-card p-3 d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted small fw-semibold">Inquiries</span>
                                <h4 class="fw-bold mb-0 text-danger"><%= unreadMessages %> Unread</h4>
                            </div>
                            <span class="badge bg-danger-subtle text-danger p-2 rounded-circle"><i class="bi bi-envelope-fill fs-5"></i></span>
                        </div>
                    </div>
                </div>

                <!-- Admin Running Partner Companies Ticker -->
                <jsp:include page="admin-running-ticker.jsp" />

                <!-- Recent Applications Table -->
                <div class="adm-card mb-4">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <div>
                            <h5 class="fw-bold mb-0">Recent Candidate Applications</h5>
                            <small class="text-muted">Direct candidate submissions awaiting employer evaluation</small>
                        </div>
                        <a href="viewapplications.jsp" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                            View All Applications <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="table-modern">
                            <thead>
                                <tr>
                                    <th>Applicant Name</th>
                                    <th>Applied Position</th>
                                    <th>Company</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th class="text-end">Quick Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    boolean hasRecentApps = false;
                                    try (Connection conn = MyConnect.connectDatab();
                                         Statement st = conn.createStatement();
                                         ResultSet rs = st.executeQuery(
                                            "SELECT a.id, a.applied_date, a.status, u.name AS applicant_name, u.email AS applicant_email, j.title AS job_title, j.company AS job_company " +
                                            "FROM applications a " +
                                            "JOIN user u ON a.user_id = u.id " +
                                            "JOIN jobs j ON a.job_id = j.id " +
                                            "ORDER BY a.applied_date DESC LIMIT 5")) {
                                        while (rs.next()) {
                                            hasRecentApps = true;
                                            int appId = rs.getInt("id");
                                            String aName = rs.getString("applicant_name");
                                            String aEmail = rs.getString("applicant_email");
                                            String jTitle = rs.getString("job_title");
                                            String jComp = rs.getString("job_company");
                                            String aDate = rs.getString("applied_date");
                                            String status = rs.getString("status");
                                            
                                            String badgeClass = "badge-pending";
                                            if ("Shortlisted".equalsIgnoreCase(status)) badgeClass = "badge-shortlisted";
                                            else if ("Hired".equalsIgnoreCase(status)) badgeClass = "badge-hired";
                                            else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "badge-rejected";
                                %>
                                <tr>
                                    <td>
                                        <div class="fw-bold"><%= aName %></div>
                                        <small class="text-muted"><%= aEmail %></small>
                                    </td>
                                    <td><strong><%= jTitle %></strong></td>
                                    <td><%= jComp %></td>
                                    <td><small class="text-muted"><%= aDate %></small></td>
                                    <td>
                                        <span class="badge-status <%= badgeClass %>"><%= status %></span>
                                    </td>
                                    <td class="text-end">
                                        <div class="dropdown d-inline-block">
                                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle rounded-pill px-3" type="button" data-bs-toggle="dropdown">
                                                Update
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-3">
                                                <li>
                                                    <form action="../doUpdateApplicationStatus" method="post">
                                                        <input type="hidden" name="id" value="<%= appId %>">
                                                        <input type="hidden" name="status" value="Shortlisted">
                                                        <button type="submit" class="dropdown-item small text-info"><i class="bi bi-star me-2"></i> Shortlist</button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form action="../doUpdateApplicationStatus" method="post">
                                                        <input type="hidden" name="id" value="<%= appId %>">
                                                        <input type="hidden" name="status" value="Hired">
                                                        <button type="submit" class="dropdown-item small text-success"><i class="bi bi-check-lg me-2"></i> Hire</button>
                                                    </form>
                                                </li>
                                                <li>
                                                    <form action="../doUpdateApplicationStatus" method="post">
                                                        <input type="hidden" name="id" value="<%= appId %>">
                                                        <input type="hidden" name="status" value="Rejected">
                                                        <button type="submit" class="dropdown-item small text-danger"><i class="bi bi-x-lg me-2"></i> Reject</button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <%      }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    }
                                    if (!hasRecentApps) {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">No applications submitted yet.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Recent Jobs Overview -->
                <div class="adm-card">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <div>
                            <h5 class="fw-bold mb-0">Active Job Postings</h5>
                            <small class="text-muted">Live listings currently discoverable by candidates</small>
                        </div>
                        <a href="viewalljobs.jsp" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                            Manage All <%= totalJobs %> Jobs <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="table-modern">
                            <thead>
                                <tr>
                                    <th>Job Title</th>
                                    <th>Company</th>
                                    <th>Location</th>
                                    <th>Monthly Salary</th>
                                    <th>Type</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try (Connection conn = MyConnect.connectDatab();
                                         Statement st = conn.createStatement();
                                         ResultSet rs = st.executeQuery("SELECT id, title, company, location, salary, type FROM jobs ORDER BY id DESC LIMIT 5")) {
                                        while (rs.next()) {
                                            int jId = rs.getInt("id");
                                %>
                                <tr>
                                    <td><strong><%= rs.getString("title") %></strong></td>
                                    <td><%= rs.getString("company") %></td>
                                    <td><i class="bi bi-geo-alt me-1 text-muted"></i><%= rs.getString("location") %></td>
                                    <td><strong class="text-slate-900">NPR <%= String.format("%,.0f", rs.getDouble("salary")) %></strong></td>
                                    <td><span class="badge bg-primary-subtle text-primary border rounded-pill px-2 py-1 small"><%= rs.getString("type") %></span></td>
                                    <td class="text-end">
                                        <a href="updatejob.jsp?id=<%= jId %>" class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1">Edit</a>
                                        <a href="../findajob.jsp" target="_blank" class="btn btn-sm btn-outline-secondary rounded-pill px-2" title="Preview on public site"><i class="bi bi-eye"></i></a>
                                    </td>
                                </tr>
                                <%      }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
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