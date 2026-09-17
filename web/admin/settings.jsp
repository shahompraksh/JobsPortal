<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, dbHelper.MyConnect" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle Password Change
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    if (newPassword != null && !newPassword.isBlank() && "POST".equalsIgnoreCase(request.getMethod())) {
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("settings.jsp?error=Passwords+do+not+match.");
            return;
        }
        try (Connection conn = MyConnect.connectDatab();
             PreparedStatement ps = conn.prepareStatement("UPDATE admin SET password = ? WHERE username = ?")) {
            ps.setString(1, newPassword);
            ps.setString(2, adminUser);
            ps.executeUpdate();
            response.sendRedirect("settings.jsp?msg=Admin+password+updated+successfully.");
            return;
        } catch(Exception e) {
            response.sendRedirect("settings.jsp?error=Failed+to+update+password.");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings - Elevate Workforce Admin</title>
    
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
                    <h2 class="fw-bold mb-1">Platform Settings & Configuration</h2>
                    <p class="text-muted mb-0 small">Manage organizational credentials, appearance preferences, and system parameters.</p>
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
                    <!-- Column 1: General & Appearance -->
                    <div class="col-lg-6">
                        <!-- General Settings -->
                        <div class="adm-card mb-4 p-4">
                            <h5 class="fw-bold mb-3"><i class="bi bi-globe text-primary me-2"></i>General Portal Info</h5>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Platform Name</label>
                                <input type="text" class="form-control" value="Elevate Workforce Solutions" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Support Email</label>
                                <input type="email" class="form-control" value="shahomprakash2004@gmail.com" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Contact Helpline</label>
                                <input type="text" class="form-control" value="+977 9761819137" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold">Official WhatsApp Support</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-success-subtle text-success"><i class="bi bi-whatsapp"></i></span>
                                    <input type="text" class="form-control" value="+977 9761819137" readonly>
                                    <a href="https://wa.me/9779761819137?text=Hello%20Elevate%20Workforce,%20I%20have%20an%20inquiry" target="_blank" rel="noopener noreferrer" class="btn btn-outline-success">
                                        Chat Now <i class="bi bi-box-arrow-up-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                            <div>
                                <label class="form-label small fw-bold">Operational Base</label>
                                <input type="text" class="form-control" value="Kathmandu, Bagmati Province, Nepal" readonly>
                            </div>
                        </div>

                        <!-- Appearance Preferences -->
                        <div class="adm-card p-4">
                            <h5 class="fw-bold mb-3"><i class="bi bi-palette text-info me-2"></i>Dashboard Appearance</h5>
                            <p class="text-muted small mb-3">Choose how the admin dashboard interface displays on your device.</p>
                            
                            <div class="d-flex gap-3">
                                <button type="button" onclick="applyTheme('light'); localStorage.setItem('admin-theme', 'light');" class="btn btn-outline-primary rounded-pill px-4 flex-grow-1">
                                    <i class="bi bi-sun-fill me-1 text-warning"></i> Light Mode
                                </button>
                                <button type="button" onclick="applyTheme('dark'); localStorage.setItem('admin-theme', 'dark');" class="btn btn-outline-secondary rounded-pill px-4 flex-grow-1">
                                    <i class="bi bi-moon-stars-fill me-1"></i> Dark Mode
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Column 2: Security & Password -->
                    <div class="col-lg-6">
                        <div class="adm-card p-4 h-100">
                            <h5 class="fw-bold mb-3"><i class="bi bi-shield-lock-fill text-danger me-2"></i>Security & Admin Credentials</h5>
                            <p class="text-muted small mb-4">Update the master administrative password for account <strong><%= adminUser %></strong>.</p>

                            <form method="post" action="settings.jsp">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold">Current Administrator</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-person-fill"></i></span>
                                        <input type="text" class="form-control bg-light" value="<%= adminUser %>" readonly>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-bold">New Admin Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-key-fill"></i></span>
                                        <input type="password" name="newPassword" class="form-control" placeholder="Enter new strong password" required minlength="4">
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label small fw-bold">Confirm New Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-check2-circle"></i></span>
                                        <input type="password" name="confirmPassword" class="form-control" placeholder="Re-type new password" required minlength="4">
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary rounded-pill px-4 py-2 fw-bold w-100 shadow-sm">
                                    <i class="bi bi-shield-check me-1"></i> Update Admin Password
                                </button>
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
