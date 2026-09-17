<%@page pageEncoding="UTF-8"%>
<%@page import="DAO.DaoMessage"%>
<%
    String adminUsername = (String) session.getAttribute("un");
    if (adminUsername == null) {
        adminUsername = (String) session.getAttribute("username");
    }
    if (adminUsername == null) {
        adminUsername = "Admin";
    }
    String adminInitial = adminUsername.substring(0, 1).toUpperCase();

    int topbarUnreadCount = 0;
    try {
        topbarUnreadCount = DaoMessage.getUnreadCount();
    } catch(Exception e) {
        topbarUnreadCount = 0;
    }
%>

<!-- Admin Top Navigation Bar -->
<header class="admin-topbar">
    <div class="topbar-left">
        <!-- Sidebar Toggle -->
        <button id="sidebarToggleBtn" class="topbar-btn" title="Toggle Sidebar" aria-label="Toggle Sidebar">
            <i class="bi bi-list"></i>
        </button>

        <!-- Search Bar -->
        <form action="viewalljobs.jsp" method="get" class="topbar-search">
            <i class="bi bi-search"></i>
            <input type="text" name="search" placeholder="Search jobs, users, or records...">
        </form>
    </div>

    <div class="topbar-right">
        <!-- Live Clock -->
        <div id="topbarClock" class="topbar-clock d-none d-md-flex"></div>

        <!-- Light / Dark Mode Toggle -->
        <button id="themeToggleBtn" class="topbar-btn" title="Toggle Theme (Light / Dark)" aria-label="Toggle Theme">
            <i id="themeIcon" class="bi bi-moon-stars-fill"></i>
        </button>

        <!-- Notifications Dropdown -->
        <div class="dropdown">
            <button class="topbar-btn position-relative" type="button" id="notifDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-bell-fill"></i>
                <% if (topbarUnreadCount > 0) { %>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.65rem;">
                        <%= topbarUnreadCount %>
                    </span>
                <% } %>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-lg rounded-4 p-2 border-0" style="min-width: 300px;" aria-labelledby="notifDropdown">
                <li class="px-3 py-2 border-bottom d-flex align-items-center justify-content-between">
                    <span class="fw-bold small">System Notifications</span>
                    <a href="notifications.jsp" class="small text-primary text-decoration-none">View All</a>
                </li>
                <% if (topbarUnreadCount > 0) { %>
                    <li>
                        <a href="messages.jsp" class="dropdown-item py-2 px-3 rounded-3 small d-flex align-items-start gap-2">
                            <i class="bi bi-envelope-exclamation-fill text-primary fs-5"></i>
                            <div>
                                <strong class="d-block text-slate-800">New Contact Inquiries</strong>
                                <span class="text-muted small">You have <%= topbarUnreadCount %> unread message(s) in your inbox.</span>
                            </div>
                        </a>
                    </li>
                <% } else { %>
                    <li class="px-3 py-3 text-center text-muted small">
                        <i class="bi bi-check-circle-fill text-success fs-4 d-block mb-1"></i>
                        All notifications cleared
                    </li>
                <% } %>
                <li>
                    <a href="viewapplications.jsp" class="dropdown-item py-2 px-3 rounded-3 small d-flex align-items-start gap-2">
                        <i class="bi bi-file-earmark-check-fill text-success fs-5"></i>
                        <div>
                            <strong class="d-block text-slate-800">Job Applications</strong>
                            <span class="text-muted small">Check latest candidate applications submitted today.</span>
                        </div>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Admin Profile Menu -->
        <div class="dropdown">
            <button class="admin-user-btn" type="button" id="adminUserDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <div class="admin-avatar"><%= adminInitial %></div>
                <div class="d-none d-sm-block text-start">
                    <div class="fw-bold small lh-1"><%= adminUsername %></div>
                    <span class="text-muted" style="font-size: 0.72rem;">Administrator</span>
                </div>
                <i class="bi bi-chevron-down small text-muted ms-1"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-lg rounded-4 p-2 border-0" style="min-width: 220px;" aria-labelledby="adminUserDropdown">
                <li class="px-3 py-2 border-bottom mb-1">
                    <small class="text-muted d-block">Signed in as</small>
                    <strong class="text-slate-900"><%= adminUsername %></strong>
                </li>
                <li>
                    <a class="dropdown-item py-2 rounded-3 small" href="profile.jsp">
                        <i class="bi bi-person-gear text-primary me-2"></i> Admin Profile
                    </a>
                </li>
                <li>
                    <a class="dropdown-item py-2 rounded-3 small" href="settings.jsp">
                        <i class="bi bi-sliders text-info me-2"></i> System Settings
                    </a>
                </li>
                <li>
                    <a class="dropdown-item py-2 rounded-3 small" href="../index.jsp" target="_blank">
                        <i class="bi bi-globe me-2 text-success"></i> Public Website
                    </a>
                </li>
                <li><hr class="dropdown-divider my-1"></li>
                <li>
                    <a class="dropdown-item py-2 rounded-3 small text-danger fw-semibold" href="logout.jsp">
                        <i class="bi bi-box-arrow-right me-2"></i> Sign Out
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>
