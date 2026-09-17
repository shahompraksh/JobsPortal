<%@page pageEncoding="UTF-8"%>
<%
    String hdr_currentPage = request.getRequestURI();
    String hdr_contextPath = request.getContextPath();
    boolean hdr_isHome = hdr_currentPage.endsWith("index.jsp") || hdr_currentPage.equals(hdr_contextPath + "/") || hdr_currentPage.equals(hdr_contextPath);
    boolean hdr_isJobs = hdr_currentPage.endsWith("findajob.jsp") || hdr_currentPage.endsWith("apply.jsp");
    boolean hdr_isContact = hdr_currentPage.endsWith("contact.jsp");
    boolean hdr_isDashboard = hdr_currentPage.endsWith("userdashboard.jsp") || hdr_currentPage.endsWith("profile.jsp") || hdr_currentPage.endsWith("applications.jsp");
    
    Object hdr_userObj = session.getAttribute("username");
    boolean hdr_loggedIn = (hdr_userObj != null);
    String hdr_usernameStr = hdr_loggedIn ? String.valueOf(hdr_userObj) : "";
    String hdr_initial = (!hdr_usernameStr.isEmpty()) ? hdr_usernameStr.substring(0, 1).toUpperCase() : "U";
%>

<!-- Modern Glassmorphic Sticky Navigation -->
<nav class="navbar navbar-expand-lg navbar-modern">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <img src="images/logo.png" alt="Elevate Workforce Logo" class="brand-logo">
            <span class="d-none d-sm-inline fw-bold text-dark ms-1">Elevate</span>
            <span class="brand-badge ms-1">Nepal</span>
        </a>

        <!-- Mobile Toggler -->
        <button class="navbar-toggler" type="button" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <i class="bi bi-list fs-4"></i>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-1 my-3 my-lg-0">
                <li class="nav-item">
                    <a class="nav-link <%= hdr_isHome ? "active" : "" %>" href="index.jsp">
                        <i class="bi bi-house-door me-1 d-lg-none"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= hdr_isJobs ? "active" : "" %>" href="findajob.jsp">
                        <i class="bi bi-briefcase me-1 d-lg-none"></i> Find a Job
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= hdr_isContact ? "active" : "" %>" href="contact.jsp">
                        <i class="bi bi-envelope me-1 d-lg-none"></i> Contact
                    </a>
                </li>

                <!-- Dynamic Login / User Profile -->
                <li class="nav-item ms-lg-3 mt-2 mt-lg-0">
                    <% if (!hdr_loggedIn) { %>
                        <div class="d-flex align-items-center gap-2">
                            <a href="login.jsp" class="btn btn-outline-primary rounded-pill px-3 py-1 fw-semibold">Login</a>
                            <a href="register.jsp" class="btn btn-primary rounded-pill px-3 py-1 fw-semibold shadow-sm">Register</a>
                        </div>
                    <% } else { %>
                        <div class="dropdown">
                            <button class="btn user-dropdown-btn dropdown-toggle" type="button" id="userMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                <span class="user-avatar-badge"><%= hdr_initial %></span>
                                <span class="d-inline-block text-truncate" style="max-width: 130px;"><%= hdr_usernameStr %></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end user-dropdown-menu" aria-labelledby="userMenuButton">
                                <li class="px-3 py-2 border-bottom mb-1">
                                    <small class="text-muted d-block">Signed in as</small>
                                    <strong class="text-dark"><%= hdr_usernameStr %></strong>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="userdashboard.jsp">
                                        <i class="bi bi-grid-1x2 text-primary"></i> Dashboard
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="profile.jsp">
                                        <i class="bi bi-person-gear text-info"></i> Profile
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="applications.jsp">
                                        <i class="bi bi-file-earmark-text text-success"></i> Applications
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider my-1"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="userlogout.jsp">
                                        <i class="bi bi-box-arrow-right text-danger"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </div>
                    <% } %>
                </li>
            </ul>
        </div>
    </div>
</nav>
