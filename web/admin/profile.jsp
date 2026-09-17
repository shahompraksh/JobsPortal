<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, dbHelper.MyConnect, model.Admin, DAO.DaoAdmin" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Admin admin = DaoAdmin.getAdminByUsername(adminUser);
    if (admin == null) {
        admin = new Admin();
        admin.setUsername(adminUser);
        admin.setName("Administrator");
        admin.setAddress("Kathmandu");
    }

    // Handle Profile Update
    String updateAction = request.getParameter("updateProfile");
    if ("true".equalsIgnoreCase(updateAction) && "POST".equalsIgnoreCase(request.getMethod())) {
        String newName = request.getParameter("name");
        String newAddr = request.getParameter("address");

        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement("UPDATE admin SET name = ?, address = ? WHERE username = ?")) {
            ps.setString(1, newName);
            ps.setString(2, newAddr);
            ps.setString(3, adminUser);
            ps.executeUpdate();
            response.sendRedirect("profile.jsp?msg=Admin+profile+updated+successfully.");
            return;
        } catch(Exception e) {
            response.sendRedirect("profile.jsp?error=Failed+to+update+profile.");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Elevate Workforce Admin</title>
    
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
                    <h2 class="fw-bold mb-1">Administrator Profile</h2>
                    <p class="text-muted mb-0 small">Account details, organizational authorization, and identity settings.</p>
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

                <div class="row g-4">
                    <!-- Left: Identity Badge Card -->
                    <div class="col-lg-4">
                        <div class="adm-card text-center p-4 h-100">
                            <div class="admin-avatar mx-auto mb-3 shadow" style="width: 80px; height: 80px; font-size: 2.2rem;">
                                <%= adminUser.substring(0, 1).toUpperCase() %>
                            </div>
                            <h4 class="fw-bold mb-1"><%= admin.getName() %></h4>
                            <p class="text-muted small mb-3">@<%= adminUser %></p>
                            
                            <div class="mb-4">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-2">
                                    <i class="bi bi-shield-fill-check me-1"></i> Super Administrator
                                </span>
                            </div>

                            <hr class="text-slate-200 my-4">

                            <div class="text-start small">
                                <div class="d-flex justify-content-between py-2 border-bottom">
                                    <span class="text-muted">Account Status:</span>
                                    <strong class="text-success"><i class="bi bi-circle-fill small me-1"></i> Active</strong>
                                </div>
                                <div class="d-flex justify-content-between py-2 border-bottom">
                                    <span class="text-muted">Access Level:</span>
                                    <strong>Full Root Privileges</strong>
                                </div>
                                <div class="d-flex justify-content-between py-2 border-bottom">
                                    <span class="text-muted">Assigned Base:</span>
                                    <strong><%= admin.getAddress() != null ? admin.getAddress() : "Kathmandu" %></strong>
                                </div>
                                <div class="d-flex justify-content-between py-2">
                                    <span class="text-muted">Security Encryption:</span>
                                    <strong>SHA-Verified</strong>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Edit Profile Form -->
                    <div class="col-lg-8">
                        <div class="adm-card p-4 p-md-5 h-100">
                            <h5 class="fw-bold mb-4"><i class="bi bi-person-lines-fill text-primary me-2"></i>Edit Admin Identity Information</h5>

                            <form method="post" action="profile.jsp?updateProfile=true">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold">Admin Display Name <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-person"></i></span>
                                            <input type="text" name="name" class="form-control" value="<%= admin.getName() %>" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold">Username</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-at"></i></span>
                                            <input type="text" class="form-control bg-light" value="<%= adminUser %>" readonly>
                                        </div>
                                        <small class="text-muted">System login handle.</small>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label small fw-bold">Operational Base / Address</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-geo-alt"></i></span>
                                            <input type="text" name="address" class="form-control" value="<%= admin.getAddress() != null ? admin.getAddress() : "" %>" placeholder="e.g. Kathmandu, Nepal">
                                        </div>
                                    </div>

                                    <div class="col-12 mt-4 d-flex justify-content-end gap-2">
                                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold shadow-sm">
                                            <i class="bi bi-cloud-check-fill me-1"></i> Save Profile Details
                                        </button>
                                    </div>
                                </div>
                            </form>

                            <hr class="my-5 text-slate-200">

                            <!-- Password Redirect Prompt -->
                            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 p-3 bg-light rounded-4">
                                <div>
                                    <h6 class="fw-bold mb-1">Need to update your admin password?</h6>
                                    <small class="text-muted">Password credentials can be updated under System Settings.</small>
                                </div>
                                <a href="settings.jsp" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                    Change Password
                                </a>
                            </div>
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
