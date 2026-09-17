<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, dbHelper.MyConnect, DAO.DaoMessage" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String clearAction = request.getParameter("markAllRead");
    if ("true".equalsIgnoreCase(clearAction)) {
        try (Connection conn = MyConnect.connectDatab();
             Statement st = conn.createStatement()) {
            st.executeUpdate("UPDATE messages SET status = 'Read' WHERE status = 'Unread'");
        } catch(Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("notifications.jsp?msg=All+notifications+marked+as+read.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notification Center - Elevate Workforce Admin</title>
    
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
                        <h2 class="fw-bold mb-1">System Notifications Center</h2>
                        <p class="text-muted mb-0 small">Real-time alert stream of new candidate applications, contact inquiries, and portal events.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <a href="notifications.jsp?markAllRead=true" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-semibold btn-sm">
                            <i class="bi bi-check2-all me-1"></i> Mark All as Read
                        </a>
                    </div>
                </div>

                <%
                    String msg = request.getParameter("msg");
                    if (msg != null && !msg.isBlank()) {
                %>
                    <div class="alert alert-success alert-dismissible fade show rounded-4 small mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Notifications Stream -->
                <div class="row g-4 justify-content-center">
                    <div class="col-lg-10">
                        <div class="d-flex flex-column gap-3">
                            
                            <!-- System Health Alert -->
                            <div class="adm-card p-3 d-flex align-items-center gap-3 border-start border-4 border-success">
                                <div class="stat-widget-icon stat-icon-success flex-shrink-0" style="width: 44px; height: 44px; font-size: 1.25rem;">
                                    <i class="bi bi-cpu-fill"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h6 class="fw-bold mb-1">Portal System Operational</h6>
                                        <span class="badge bg-success-subtle text-success rounded-pill px-2 py-1 small">Live</span>
                                    </div>
                                    <p class="text-muted small mb-0">MySQL database and Apache Tomcat server responding with optimal response times.</p>
                                </div>
                            </div>

                            <!-- Real Application Notifications -->
                            <%
                                try (Connection conn = MyConnect.connectDatab();
                                     Statement st = conn.createStatement();
                                     ResultSet rs = st.executeQuery(
                                        "SELECT a.id, a.applied_date, u.name as user_name, j.title as job_title, j.company " +
                                        "FROM applications a JOIN user u ON a.user_id = u.id JOIN jobs j ON a.job_id = j.id " +
                                        "ORDER BY a.applied_date DESC LIMIT 5")) {
                                    while (rs.next()) {
                                        String uName = rs.getString("user_name");
                                        String jTitle = rs.getString("job_title");
                                        String comp = rs.getString("company");
                                        String aDate = rs.getString("applied_date");
                            %>
                            <div class="adm-card p-3 d-flex align-items-center gap-3 border-start border-4 border-primary">
                                <div class="stat-widget-icon stat-icon-primary flex-shrink-0" style="width: 44px; height: 44px; font-size: 1.25rem;">
                                    <i class="bi bi-file-earmark-person-fill"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h6 class="fw-bold mb-1">New Job Application Submitted</h6>
                                        <small class="text-muted"><%= aDate %></small>
                                    </div>
                                    <p class="text-muted small mb-0">
                                        <strong><%= uName %></strong> applied for <strong><%= jTitle %></strong> at <%= comp %>.
                                    </p>
                                </div>
                                <a href="viewapplications.jsp" class="btn btn-sm btn-outline-primary rounded-pill px-3">Review</a>
                            </div>
                            <%      }
                                } catch(Exception e) {
                                    e.printStackTrace();
                                }
                            %>

                            <!-- Real Inquiries Notifications -->
                            <%
                                try (Connection conn = MyConnect.connectDatab();
                                     Statement st = conn.createStatement();
                                     ResultSet rs = st.executeQuery("SELECT id, name, email, message, created_at, status FROM messages ORDER BY id DESC LIMIT 4")) {
                                    while (rs.next()) {
                                        int mId = rs.getInt("id");
                                        String mName = rs.getString("name");
                                        String mEmail = rs.getString("email");
                                        String mBody = rs.getString("message");
                                        String mDate = rs.getString("created_at");
                                        boolean isUnread = "Unread".equalsIgnoreCase(rs.getString("status"));
                            %>
                            <div class="adm-card p-3 d-flex align-items-center gap-3 border-start border-4 <%= isUnread ? "border-danger" : "border-secondary" %>">
                                <div class="stat-widget-icon <%= isUnread ? "stat-icon-warning" : "stat-icon-accent" %> flex-shrink-0" style="width: 44px; height: 44px; font-size: 1.25rem;">
                                    <i class="bi bi-envelope-fill"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h6 class="fw-bold mb-1">Inquiry from <%= mName %> <%= isUnread ? "<span class='badge bg-danger ms-1'>New</span>" : "" %></h6>
                                        <small class="text-muted"><%= mDate %></small>
                                    </div>
                                    <p class="text-muted small mb-0 text-truncate" style="max-width: 500px;">
                                        <%= mBody %>
                                    </p>
                                </div>
                                <a href="messages.jsp" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Open</a>
                            </div>
                            <%      }
                                } catch(Exception e) {
                                    e.printStackTrace();
                                }
                            %>

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
