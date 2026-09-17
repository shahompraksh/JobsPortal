<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Application"%>
<%@page import="DAO.DaoApplication"%>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?msg=Please login first.");
        return;
    }

    Object uidObj = session.getAttribute("userId");
    int userId;
    if (uidObj instanceof Integer) {
        userId = (Integer) uidObj;
    } else {
        model.User u = DAO.DaoUser.getUserByUsername(username);
        if (u == null) {
            response.sendRedirect("login.jsp?msg=Please login first.");
            return;
        }
        userId = u.getId();
        session.setAttribute("userId", userId);
    }
    List<Application> applications = DaoApplication.getApplicationsByUser(userId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My Applications - Elevate Workforce Solutions</title>
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Modern Design System Stylesheet -->
    <link rel="stylesheet" href="modern-style.css">
</head>
<body class="bg-light">

    <jsp:include page="header.jsp" />

    <!-- Page Header -->
    <div class="bg-white border-bottom py-4 mb-4">
        <div class="container d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-2">
            <div>
                <h2 class="fw-bold mb-1 text-slate-900">My Job Applications</h2>
                <p class="text-slate-500 mb-0">Track real-time recruitment statuses and review submission records.</p>
            </div>
            <div>
                <a href="findajob.jsp" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold btn-sm shadow-sm">
                    <i class="bi bi-plus-circle me-1"></i> Apply for More Jobs
                </a>
            </div>
        </div>
    </div>

    <div class="container my-4">
        <% if (applications == null || applications.isEmpty()) { %>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-5">
                <div class="user-avatar-badge mx-auto mb-3" style="width: 64px; height: 64px; font-size: 1.8rem; background: var(--slate-100); color: var(--slate-400);">
                    <i class="bi bi-file-earmark-x"></i>
                </div>
                <h4 class="fw-bold text-slate-800">No Applications Submitted Yet</h4>
                <p class="text-slate-500 max-w-md mx-auto mb-4" style="max-width: 460px;">
                    You haven't submitted any job applications yet. Discover thousands of open roles tailored to your skillset.
                </p>
                <div>
                    <a href="findajob.jsp" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold">
                        Explore Open Jobs Now
                    </a>
                </div>
            </div>
        <% } else { %>
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4 text-slate-600 small text-uppercase fw-bold">#</th>
                                <th class="text-slate-600 small text-uppercase fw-bold">Job Title</th>
                                <th class="text-slate-600 small text-uppercase fw-bold">Hiring Company</th>
                                <th class="text-slate-600 small text-uppercase fw-bold">Date Applied</th>
                                <th class="text-slate-600 small text-uppercase fw-bold">Current Status</th>
                                <th class="pe-4 text-end text-slate-600 small text-uppercase fw-bold">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int i = 1;
                                for (Application app : applications) {
                                    String status = app.getStatus() != null ? app.getStatus() : "Pending";
                                    String badgeClass = "bg-warning-subtle text-warning-emphasis border border-warning-subtle";
                                    if (status.equalsIgnoreCase("Shortlisted")) {
                                        badgeClass = "bg-info-subtle text-info border border-info-subtle";
                                    } else if (status.equalsIgnoreCase("Hired")) {
                                        badgeClass = "bg-success-subtle text-success border border-success-subtle";
                                    } else if (status.equalsIgnoreCase("Rejected")) {
                                        badgeClass = "bg-danger-subtle text-danger border border-danger-subtle";
                                    }
                            %>
                            <tr>
                                <td class="ps-4 fw-bold text-slate-400"><%= i++ %></td>
                                <td>
                                    <div class="fw-bold text-slate-900"><%= app.getJobtitle() %></div>
                                </td>
                                <td>
                                    <span class="text-slate-600"><i class="bi bi-building me-1 text-muted"></i><%= app.getCompany() %></span>
                                </td>
                                <td>
                                    <span class="text-slate-500 small"><i class="bi bi-calendar3 me-1 text-muted"></i><%= app.getApplieddate() %></span>
                                </td>
                                <td>
                                    <span class="badge rounded-pill <%= badgeClass %> px-3 py-1 fw-semibold small">
                                        <%= status %>
                                    </span>
                                </td>
                                <td class="pe-4 text-end">
                                    <% if (status.equalsIgnoreCase("Pending")) { %>
                                        <form method="post" action="doWithdrawApplication" class="d-inline" onsubmit="return confirm('Are you sure you want to withdraw this application?');">
                                            <input type="hidden" name="id" value="<%= app.getId() %>">
                                            <button class="btn btn-sm btn-outline-danger rounded-pill px-3" type="submit">
                                                <i class="bi bi-x-circle me-1"></i> Withdraw
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span class="badge bg-light text-muted border rounded-pill px-3 py-1">
                                            <i class="bi bi-lock-fill me-1"></i> In Review
                                        </span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
