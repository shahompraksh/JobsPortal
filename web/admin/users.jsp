<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, dbHelper.MyConnect"%>
<%
    String username = (String) session.getAttribute("un");
    if (username == null) username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Handle user deletion if requested
    String deleteId = request.getParameter("deleteId");
    if (deleteId != null && !deleteId.isBlank()) {
        try {
            int uid = Integer.parseInt(deleteId);
            DAO.DaoUser.deleteUser(uid);
            response.sendRedirect("users.jsp?msg=User+successfully+removed.");
            return;
        } catch(Exception e) {
            response.sendRedirect("users.jsp?error=Failed+to+delete+user.");
            return;
        }
    }

    // Handle user update if requested
    String editId = request.getParameter("editId");
    if (editId != null && !editId.isBlank() && "POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int uid = Integer.parseInt(editId);
            String uName = request.getParameter("name");
            String uEmail = request.getParameter("email");
            String uPhone = request.getParameter("phone");

            try (Connection conn = MyConnect.connectDatab();
                 PreparedStatement ps = conn.prepareStatement("UPDATE user SET name=?, email=?, phone=? WHERE id=?")) {
                ps.setString(1, uName);
                ps.setString(2, uEmail);
                ps.setString(3, uPhone);
                ps.setInt(4, uid);
                ps.executeUpdate();
            }
            response.sendRedirect("users.jsp?msg=Candidate+profile+updated+successfully.");
            return;
        } catch(Exception e) {
            response.sendRedirect("users.jsp?error=Failed+to+update+candidate.");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Users Management - Elevate Workforce Admin</title>
    
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
                        <h2 class="fw-bold mb-1">Candidate User Management</h2>
                        <p class="text-muted mb-0 small">Review, edit, and manage registered job seekers across Nepal.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <button onclick="exportTableToCSV('usersTable', 'elevate_candidates.csv')" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold btn-sm">
                            <i class="bi bi-file-earmark-arrow-down me-1"></i> Export Users CSV
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

                <!-- Search & Filters Toolbar -->
                <div class="adm-card mb-4 p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-6 col-12">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                                <input type="text" id="userSearchInput" class="form-control border-start-0" placeholder="Type to filter candidates by name, username, email, or phone...">
                            </div>
                        </div>
                        <div class="col-md-6 text-md-end text-muted small">
                            <span class="badge bg-primary-subtle text-primary border rounded-pill px-3 py-2">
                                <i class="bi bi-shield-check me-1"></i> Verified Auth System
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="table-modern-wrapper">
                    <div class="table-responsive">
                        <table id="usersTable" class="table-modern">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Candidate Name</th>
                                    <th>Email & Username</th>
                                    <th>Contact Phone</th>
                                    <th>Resume Status</th>
                                    <th>Applications</th>
                                    <th class="text-end no-export">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    boolean hasUsers = false;
                                    try (Connection conn = MyConnect.connectDatab();
                                         Statement st = conn.createStatement();
                                         ResultSet rs = st.executeQuery(
                                            "SELECT u.id, u.name, u.email, u.username, u.phone, u.resume, " +
                                            "(SELECT COUNT(*) FROM applications WHERE user_id = u.id) AS app_count " +
                                            "FROM user u ORDER BY u.id DESC")) {
                                        while (rs.next()) {
                                            hasUsers = true;
                                            int uId = rs.getInt("id");
                                            String name = rs.getString("name");
                                            String email = rs.getString("email");
                                            String uname = rs.getString("username");
                                            String phone = rs.getString("phone");
                                            String resume = rs.getString("resume");
                                            int appCount = rs.getInt("app_count");
                                            String initial = (name != null && !name.isEmpty()) ? name.substring(0, 1).toUpperCase() : "U";
                                %>
                                <tr>
                                    <td class="fw-bold text-muted">#<%= uId %></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <div class="admin-avatar" style="width: 38px; height: 38px; font-size: 0.95rem;">
                                                <%= initial %>
                                            </div>
                                            <div>
                                                <div class="fw-bold"><%= name %></div>
                                                <small class="text-muted"><i class="bi bi-person-badge me-1"></i>Candidate</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div><a href="mailto:<%= email %>" class="text-decoration-none"><%= email %></a></div>
                                        <small class="text-muted">@<%= uname %></small>
                                    </td>
                                    <td>
                                        <span class="text-slate-600"><%= (phone != null && !phone.isEmpty()) ? phone : "Not provided" %></span>
                                    </td>
                                    <td>
                                        <% if (resume != null && !resume.isEmpty()) { %>
                                            <a href="../<%= resume %>" target="_blank" class="badge bg-success-subtle text-success border border-success-subtle rounded-pill text-decoration-none px-3 py-1">
                                                <i class="bi bi-file-earmark-check me-1"></i> Attached
                                            </a>
                                        <% } else { %>
                                            <span class="badge bg-secondary-subtle text-muted rounded-pill px-3 py-1">
                                                <i class="bi bi-file-earmark-x me-1"></i> Missing
                                            </span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary-subtle text-primary border rounded-pill px-3 py-1 fw-bold">
                                            <%= appCount %> applied
                                        </span>
                                    </td>
                                    <td class="text-end no-export">
                                        <!-- Edit Modal Trigger -->
                                        <button class="btn btn-sm btn-outline-primary rounded-pill px-2 me-1" data-bs-toggle="modal" data-bs-target="#editModal<%= uId %>" title="Edit Candidate">
                                            <i class="bi bi-pencil"></i>
                                        </button>

                                        <!-- Delete Confirmation -->
                                        <a href="users.jsp?deleteId=<%= uId %>" class="btn btn-sm btn-outline-danger rounded-pill px-2" onclick="return confirm('Are you sure you want to permanently delete candidate <%= name %>? All associated applications will be removed.');" title="Delete User">
                                            <i class="bi bi-trash"></i>
                                        </a>

                                        <!-- Edit Modal -->
                                        <div class="modal fade" id="editModal<%= uId %>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content text-start">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Edit Candidate Details</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <form method="post" action="users.jsp">
                                                        <input type="hidden" name="editId" value="<%= uId %>">
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label class="form-label small fw-bold">Full Name</label>
                                                                <input type="text" name="name" class="form-control" value="<%= name %>" required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small fw-bold">Email Address</label>
                                                                <input type="email" name="email" class="form-control" value="<%= email %>" required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small fw-bold">Phone Number</label>
                                                                <input type="text" name="phone" class="form-control" value="<%= (phone != null) ? phone : "" %>">
                                                            </div>
                                                            <div class="mb-2">
                                                                <label class="form-label small fw-bold">Username</label>
                                                                <input type="text" class="form-control bg-light" value="<%= uname %>" readonly>
                                                                <small class="text-muted">Unique identifier cannot be modified.</small>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary rounded-pill px-4">Save Changes</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <%      }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    }
                                    if (!hasUsers) {
                                %>
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">No candidate accounts registered in database yet.</td>
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
        setupTableSearch('userSearchInput', 'usersTable');
    </script>
</body>
</html>
