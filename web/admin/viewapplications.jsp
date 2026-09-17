<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Application, DAO.DaoApplication" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String statusFilter = request.getParameter("statusFilter") != null ? request.getParameter("statusFilter").trim() : "";
    String jobFilterStr = request.getParameter("jobFilter");
    int jobFilterId = (jobFilterStr != null && !jobFilterStr.isEmpty()) ? Integer.parseInt(jobFilterStr) : 0;

    List<Application> allApplications = DaoApplication.getAllApplications();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Job Applications - Elevate Workforce Admin</title>
    
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
                        <h2 class="fw-bold mb-1">Candidate Applications Pipeline</h2>
                        <p class="text-muted mb-0 small">Review incoming job applications, preview candidate resumes, and update recruitment statuses.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <button onclick="exportTableToCSV('appsTable', 'elevate_applications.csv')" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold btn-sm">
                            <i class="bi bi-download me-1"></i> Export Applications CSV
                        </button>
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

                <!-- Status Filter Pills & Search -->
                <div class="adm-card mb-4 p-3">
                    <div class="row g-3 align-items-center justify-content-between">
                        <div class="col-lg-6 col-md-12">
                            <div class="d-flex flex-wrap gap-2">
                                <a href="viewapplications.jsp" class="btn btn-sm rounded-pill px-3 <%= statusFilter.isEmpty() ? "btn-primary" : "btn-outline-secondary" %>">
                                    All (<%= allApplications.size() %>)
                                </a>
                                <a href="viewapplications.jsp?statusFilter=Pending" class="btn btn-sm rounded-pill px-3 <%= "Pending".equalsIgnoreCase(statusFilter) ? "btn-warning" : "btn-outline-secondary" %>">
                                    Pending
                                </a>
                                <a href="viewapplications.jsp?statusFilter=Shortlisted" class="btn btn-sm rounded-pill px-3 <%= "Shortlisted".equalsIgnoreCase(statusFilter) ? "btn-info" : "btn-outline-secondary" %>">
                                    Shortlisted
                                </a>
                                <a href="viewapplications.jsp?statusFilter=Hired" class="btn btn-sm rounded-pill px-3 <%= "Hired".equalsIgnoreCase(statusFilter) ? "btn-success" : "btn-outline-secondary" %>">
                                    Hired
                                </a>
                                <a href="viewapplications.jsp?statusFilter=Rejected" class="btn btn-sm rounded-pill px-3 <%= "Rejected".equalsIgnoreCase(statusFilter) ? "btn-danger" : "btn-outline-secondary" %>">
                                    Rejected
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-5 col-md-12">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                                <input type="text" id="appSearchInput" class="form-control border-start-0" placeholder="Type to search applicants or roles...">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Applications Table -->
                <div class="table-modern-wrapper">
                    <div class="table-responsive">
                        <table id="appsTable" class="table-modern">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Applicant Details</th>
                                    <th>Job Applied For</th>
                                    <th>Company</th>
                                    <th>Applied Date</th>
                                    <th>Resume</th>
                                    <th>Status</th>
                                    <th class="text-end no-export">Change Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    boolean hasApps = false;
                                    for (Application app : allApplications) {
                                        // Apply filter
                                        if (!statusFilter.isEmpty() && !statusFilter.equalsIgnoreCase(app.getStatus())) {
                                            continue;
                                        }
                                        if (jobFilterId > 0 && app.getJobID() != jobFilterId) {
                                            continue;
                                        }

                                        hasApps = true;
                                        int appId = app.getId();
                                        String aName = app.getApplicantName() != null ? app.getApplicantName() : "User #" + app.getUserID();
                                        String aEmail = app.getApplicantEmail() != null ? app.getApplicantEmail() : "N/A";
                                        String aPhone = app.getApplicantPhone() != null ? app.getApplicantPhone() : "";
                                        String aResume = app.getApplicantResume();
                                        String jTitle = app.getJobtitle() != null ? app.getJobtitle() : "Job #" + app.getJobID();
                                        String jComp = app.getCompany() != null ? app.getCompany() : "Company";
                                        String aDate = app.getApplieddate() != null ? app.getApplieddate() : "";
                                        String status = app.getStatus() != null ? app.getStatus() : "Pending";

                                        String badgeClass = "badge-pending";
                                        if ("Shortlisted".equalsIgnoreCase(status)) badgeClass = "badge-shortlisted";
                                        else if ("Hired".equalsIgnoreCase(status)) badgeClass = "badge-hired";
                                        else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "badge-rejected";
                                %>
                                <tr>
                                    <td class="fw-bold text-muted">#<%= appId %></td>
                                    <td>
                                        <div class="fw-bold"><%= aName %></div>
                                        <small class="text-muted d-block"><a href="mailto:<%= aEmail %>" class="text-decoration-none"><%= aEmail %></a></small>
                                        <% if (!aPhone.isEmpty()) { %>
                                            <small class="text-slate-500"><i class="bi bi-telephone me-1"></i><%= aPhone %></small>
                                        <% } %>
                                    </td>
                                    <td>
                                        <strong class="text-slate-900"><%= jTitle %></strong>
                                    </td>
                                    <td>
                                        <i class="bi bi-building me-1 text-muted"></i><%= jComp %>
                                    </td>
                                    <td>
                                        <small class="text-muted"><%= aDate %></small>
                                    </td>
                                    <td>
                                        <% if (aResume != null && !aResume.isEmpty()) { %>
                                            <a href="../<%= aResume %>" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill px-2 py-1 small" title="Preview Resume Document">
                                                <i class="bi bi-file-earmark-pdf me-1"></i> View CV
                                            </a>
                                        <% } else { %>
                                            <span class="text-muted small">None</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge-status <%= badgeClass %>"><%= status %></span>
                                    </td>
                                    <td class="text-end no-export">
                                        <div class="dropdown d-inline-block">
                                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle rounded-pill px-3" type="button" data-bs-toggle="dropdown">
                                                Update
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-3">
                                                <li>
                                                    <form action="../doUpdateApplicationStatus" method="post">
                                                        <input type="hidden" name="id" value="<%= appId %>">
                                                        <input type="hidden" name="status" value="Pending">
                                                        <button type="submit" class="dropdown-item small text-warning"><i class="bi bi-clock me-2"></i> Set Pending</button>
                                                    </form>
                                                </li>
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
                                                        <button type="submit" class="dropdown-item small text-success"><i class="bi bi-check-lg me-2"></i> Hire Candidate</button>
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
                                    if (!hasApps) {
                                %>
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">No applications found matching the selected filter.</td>
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
    <script>
        setupTableSearch('appSearchInput', 'appsTable');
    </script>
</body>
</html>
