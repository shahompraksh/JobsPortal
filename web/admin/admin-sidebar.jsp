<%@page pageEncoding="UTF-8"%>
<%@page import="DAO.DaoMessage"%>
<%
    String adminCurrentPage = request.getRequestURI();
    boolean isDash = adminCurrentPage.endsWith("dashboard.jsp");
    boolean isJobs = adminCurrentPage.endsWith("viewalljobs.jsp") || adminCurrentPage.endsWith("addnewjob.jsp") || adminCurrentPage.endsWith("updatejob.jsp") || adminCurrentPage.endsWith("deletejob.jsp");
    boolean isApps = adminCurrentPage.endsWith("viewapplications.jsp");
    boolean isUsers = adminCurrentPage.endsWith("users.jsp");
    boolean isMsgs = adminCurrentPage.endsWith("messages.jsp");
    boolean isAnalytics = adminCurrentPage.endsWith("analytics.jsp");
    boolean isReports = adminCurrentPage.endsWith("reports.jsp");
    boolean isNotifs = adminCurrentPage.endsWith("notifications.jsp");
    boolean isSettings = adminCurrentPage.endsWith("settings.jsp");
    boolean isProfile = adminCurrentPage.endsWith("profile.jsp");

    int unreadCount = 0;
    try {
        unreadCount = DaoMessage.getUnreadCount();
    } catch(Exception e) {
        unreadCount = 0;
    }
%>

<!-- Mobile Backdrop Overlay -->
<div id="sidebarOverlay" class="sidebar-overlay"></div>

<!-- Admin Sidebar -->
<aside id="adminSidebar" class="admin-sidebar">
    <!-- Brand Logo -->
    <a href="dashboard.jsp" class="sidebar-brand">
        <img src="../images/logo.png" alt="Elevate Workforce Logo">
        <span>Elevate Admin</span>
    </a>

    <!-- Navigation Menu -->
    <ul class="sidebar-nav">
        <li class="sidebar-heading">Core</li>
        <li class="nav-item">
            <a href="dashboard.jsp" class="nav-link <%= isDash ? "active" : "" %>" title="Dashboard">
                <i class="bi bi-grid-1x2-fill"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="analytics.jsp" class="nav-link <%= isAnalytics ? "active" : "" %>" title="Analytics">
                <i class="bi bi-bar-chart-line-fill"></i>
                <span>Analytics</span>
            </a>
        </li>

        <li class="sidebar-heading">Management</li>
        <li class="nav-item">
            <a href="viewalljobs.jsp" class="nav-link <%= isJobs ? "active" : "" %>" title="Jobs Management">
                <i class="bi bi-briefcase-fill"></i>
                <span>Jobs (Services)</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="viewapplications.jsp" class="nav-link <%= isApps ? "active" : "" %>" title="Applications">
                <i class="bi bi-file-earmark-person-fill"></i>
                <span>Applications</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="users.jsp" class="nav-link <%= isUsers ? "active" : "" %>" title="Candidate Users">
                <i class="bi bi-people-fill"></i>
                <span>Users</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="messages.jsp" class="nav-link <%= isMsgs ? "active" : "" %>" title="Messages Inbox">
                <i class="bi bi-chat-left-dots-fill"></i>
                <span>Messages</span>
                <% if (unreadCount > 0) { %>
                    <span class="badge bg-danger rounded-pill ms-auto"><%= unreadCount %></span>
                <% } %>
            </a>
        </li>

        <li class="sidebar-heading">Tools & System</li>
        <li class="nav-item">
            <a href="reports.jsp" class="nav-link <%= isReports ? "active" : "" %>" title="Reports & Exports">
                <i class="bi bi-file-earmark-spreadsheet-fill"></i>
                <span>Reports & CSV</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="notifications.jsp" class="nav-link <%= isNotifs ? "active" : "" %>" title="Notifications">
                <i class="bi bi-bell-fill"></i>
                <span>Notifications</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="settings.jsp" class="nav-link <%= isSettings ? "active" : "" %>" title="Settings">
                <i class="bi bi-gear-fill"></i>
                <span>Settings</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="profile.jsp" class="nav-link <%= isProfile ? "active" : "" %>" title="Admin Profile">
                <i class="bi bi-person-badge-fill"></i>
                <span>Admin Profile</span>
            </a>
        </li>
    </ul>

    <!-- Sidebar Footer -->
    <div class="sidebar-footer">
        <div class="d-flex align-items-center justify-content-between">
            <a href="../index.jsp" target="_blank" class="btn btn-sm btn-outline-light rounded-pill px-3 py-1" style="font-size: 0.8rem;">
                <i class="bi bi-box-arrow-up-right me-1"></i> Public Site
            </a>
            <a href="logout.jsp" class="text-danger fs-5" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </div>
</aside>
