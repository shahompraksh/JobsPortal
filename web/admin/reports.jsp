<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, dbHelper.MyConnect" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int jobCount = 0;
    int userCount = 0;
    int appCount = 0;
    double totalPayroll = 0;

    try (Connection conn = MyConnect.connectDatab()) {
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*), COALESCE(SUM(salary), 0) FROM jobs")) {
            if (rs.next()) {
                jobCount = rs.getInt(1);
                totalPayroll = rs.getDouble(2);
            }
        }
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM user")) {
            if (rs.next()) userCount = rs.getInt(1);
        }
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM applications")) {
            if (rs.next()) appCount = rs.getInt(1);
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Data Export - Elevate Workforce Admin</title>
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Modern Admin Stylesheet -->
    <link rel="stylesheet" href="admin-modern.css">

    <style>
        @media print {
            .admin-sidebar, .admin-topbar, .no-print {
                display: none !important;
            }
            .admin-main {
                margin-left: 0 !important;
                width: 100% !important;
            }
        }
    </style>
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
                        <h2 class="fw-bold mb-1">Executive Reports & Data Export</h2>
                        <p class="text-muted mb-0 small">Generate comprehensive recruitment intelligence, audit logs, and downloadable CSV datasets.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2 no-print">
                        <button onclick="window.print()" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold btn-sm">
                            <i class="bi bi-printer-fill me-1"></i> Print / Save PDF
                        </button>
                    </div>
                </div>

                <!-- KPI Metric Snapshot -->
                <div class="row g-4 mb-5">
                    <div class="col-md-3 col-6">
                        <div class="adm-card p-3 text-center">
                            <span class="text-muted small fw-bold text-uppercase">Total Vacancies</span>
                            <h3 class="fw-bold text-primary mt-1 mb-0"><%= jobCount %></h3>
                            <small class="text-muted">Jobs Published</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div class="adm-card p-3 text-center">
                            <span class="text-muted small fw-bold text-uppercase">Registered Talent</span>
                            <h3 class="fw-bold text-accent mt-1 mb-0"><%= userCount %></h3>
                            <small class="text-muted">Candidate Profiles</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div class="adm-card p-3 text-center">
                            <span class="text-muted small fw-bold text-uppercase">Submissions Logged</span>
                            <h3 class="fw-bold text-success mt-1 mb-0"><%= appCount %></h3>
                            <small class="text-muted">Job Applications</small>
                        </div>
                    </div>
                    <div class="col-md-3 col-6">
                        <div class="adm-card p-3 text-center">
                            <span class="text-muted small fw-bold text-uppercase">Monthly Payroll</span>
                            <h3 class="fw-bold text-warning mt-1 mb-0">NPR <%= String.format("%,.0f", totalPayroll) %></h3>
                            <small class="text-muted">Listing Total</small>
                        </div>
                    </div>
                </div>

                <!-- Export Cards Grid -->
                <div class="row g-4 mb-5 no-print">
                    <!-- Export 1: Jobs -->
                    <div class="col-md-6 col-lg-3">
                        <div class="adm-card p-4 text-center h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="stat-widget-icon stat-icon-primary mx-auto mb-3">
                                    <i class="bi bi-briefcase-fill"></i>
                                </div>
                                <h5 class="fw-bold mb-1">Jobs Directory</h5>
                                <p class="text-muted small mb-4">Complete inventory of active vacancies with compensation and location data.</p>
                            </div>
                            <button onclick="exportTableToCSV('exportJobsTable', 'jobs_report.csv')" class="btn btn-primary rounded-pill w-100 btn-sm fw-bold">
                                <i class="bi bi-file-earmark-arrow-down-fill me-1"></i> Download CSV
                            </button>
                        </div>
                    </div>

                    <!-- Export 2: Candidates -->
                    <div class="col-md-6 col-lg-3">
                        <div class="adm-card p-4 text-center h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="stat-widget-icon stat-icon-accent mx-auto mb-3">
                                    <i class="bi bi-people-fill"></i>
                                </div>
                                <h5 class="fw-bold mb-1">Candidates Roster</h5>
                                <p class="text-muted small mb-4">Registered candidates with contact credentials and resume attachment logs.</p>
                            </div>
                            <button onclick="exportTableToCSV('exportUsersTable', 'candidates_report.csv')" class="btn btn-info text-white rounded-pill w-100 btn-sm fw-bold">
                                <i class="bi bi-file-earmark-arrow-down-fill me-1"></i> Download CSV
                            </button>
                        </div>
                    </div>

                    <!-- Export 3: Applications -->
                    <div class="col-md-6 col-lg-3">
                        <div class="adm-card p-4 text-center h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="stat-widget-icon stat-icon-success mx-auto mb-3">
                                    <i class="bi bi-file-earmark-check-fill"></i>
                                </div>
                                <h5 class="fw-bold mb-1">Application Pipeline</h5>
                                <p class="text-muted small mb-4">Audit record of candidate submissions, dates, and evaluation statuses.</p>
                            </div>
                            <button onclick="exportTableToCSV('exportAppsTable', 'applications_report.csv')" class="btn btn-success rounded-pill w-100 btn-sm fw-bold">
                                <i class="bi bi-file-earmark-arrow-down-fill me-1"></i> Download CSV
                            </button>
                        </div>
                    </div>

                    <!-- Export 4: Inquiries -->
                    <div class="col-md-6 col-lg-3">
                        <div class="adm-card p-4 text-center h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="stat-widget-icon stat-icon-warning mx-auto mb-3">
                                    <i class="bi bi-chat-dots-fill"></i>
                                </div>
                                <h5 class="fw-bold mb-1">Contact Inquiries</h5>
                                <p class="text-muted small mb-4">Full archive of communications received via the public portal contact form.</p>
                            </div>
                            <button onclick="exportTableToCSV('exportMsgsTable', 'inquiries_report.csv')" class="btn btn-warning text-white rounded-pill w-100 btn-sm fw-bold">
                                <i class="bi bi-file-earmark-arrow-down-fill me-1"></i> Download CSV
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Hidden / Printable Data Tables for CSV Export -->
                <div class="adm-card p-4">
                    <h5 class="fw-bold mb-3">Applications Summary Table (Export View)</h5>
                    <div class="table-responsive">
                        <table id="exportAppsTable" class="table-modern">
                            <thead>
                                <tr>
                                    <th>App ID</th>
                                    <th>Applicant Name</th>
                                    <th>Applicant Email</th>
                                    <th>Job Title</th>
                                    <th>Company</th>
                                    <th>Applied Date</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try (Connection conn = MyConnect.connectDatab();
                                         Statement st = conn.createStatement();
                                         ResultSet rs = st.executeQuery(
                                            "SELECT a.id, a.applied_date, a.status, u.name as u_name, u.email as u_email, j.title as j_title, j.company as j_comp " +
                                            "FROM applications a JOIN user u ON a.user_id = u.id JOIN jobs j ON a.job_id = j.id ORDER BY a.id DESC")) {
                                        while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getInt("id") %></td>
                                    <td><%= rs.getString("u_name") %></td>
                                    <td><%= rs.getString("u_email") %></td>
                                    <td><%= rs.getString("j_title") %></td>
                                    <td><%= rs.getString("j_comp") %></td>
                                    <td><%= rs.getString("applied_date") %></td>
                                    <td><%= rs.getString("status") %></td>
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

                <!-- Hidden Tables for Direct CSV downloads -->
                <div class="d-none">
                    <!-- Jobs Table -->
                    <table id="exportJobsTable">
                        <thead>
                            <tr><th>ID</th><th>Title</th><th>Company</th><th>Location</th><th>Salary</th><th>Type</th></tr>
                        </thead>
                        <tbody>
                            <%
                                try (Connection conn = MyConnect.connectDatab();
                                     Statement st = conn.createStatement();
                                     ResultSet rs = st.executeQuery("SELECT id, title, company, location, salary, type FROM jobs")) {
                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("title") %></td>
                                <td><%= rs.getString("company") %></td>
                                <td><%= rs.getString("location") %></td>
                                <td><%= rs.getDouble("salary") %></td>
                                <td><%= rs.getString("type") %></td>
                            </tr>
                            <%      }
                                } catch(Exception e) { e.printStackTrace(); }
                            %>
                        </tbody>
                    </table>

                    <!-- Users Table -->
                    <table id="exportUsersTable">
                        <thead>
                            <tr><th>ID</th><th>Name</th><th>Email</th><th>Username</th><th>Phone</th><th>Resume</th></tr>
                        </thead>
                        <tbody>
                            <%
                                try (Connection conn = MyConnect.connectDatab();
                                     Statement st = conn.createStatement();
                                     ResultSet rs = st.executeQuery("SELECT id, name, email, username, phone, resume FROM user")) {
                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("name") %></td>
                                <td><%= rs.getString("email") %></td>
                                <td><%= rs.getString("username") %></td>
                                <td><%= rs.getString("phone") %></td>
                                <td><%= rs.getString("resume") %></td>
                            </tr>
                            <%      }
                                } catch(Exception e) { e.printStackTrace(); }
                            %>
                        </tbody>
                    </table>

                    <!-- Messages Table -->
                    <table id="exportMsgsTable">
                        <thead>
                            <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Message</th><th>Method</th><th>Status</th><th>Date</th></tr>
                        </thead>
                        <tbody>
                            <%
                                try (Connection conn = MyConnect.connectDatab();
                                     Statement st = conn.createStatement();
                                     ResultSet rs = st.executeQuery("SELECT id, name, email, phone, message, contact_method, status, created_at FROM messages")) {
                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("name") %></td>
                                <td><%= rs.getString("email") %></td>
                                <td><%= rs.getString("phone") %></td>
                                <td><%= rs.getString("message") %></td>
                                <td><%= rs.getString("contact_method") %></td>
                                <td><%= rs.getString("status") %></td>
                                <td><%= rs.getString("created_at") %></td>
                            </tr>
                            <%      }
                                } catch(Exception e) { e.printStackTrace(); }
                            %>
                        </tbody>
                    </table>
                </div>

            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="admin-modern.js"></script>
</body>
</html>
