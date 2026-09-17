<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get username from session
    String username = (String) session.getAttribute("username");
    
    // If user is not logged in, redirect to login page
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String dashInitial = (!username.isEmpty()) ? username.substring(0, 1).toUpperCase() : "U";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Dashboard - Elevate Workforce Solutions</title>
    
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

    <!-- Dashboard Welcome Header -->
    <div class="bg-white border-bottom py-5">
        <div class="container">
            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="user-avatar-badge shadow-sm" style="width: 64px; height: 64px; font-size: 1.8rem; background: linear-gradient(135deg, var(--primary), var(--accent));">
                        <%= dashInitial %>
                    </div>
                    <div>
                        <div class="d-flex align-items-center gap-2">
                            <h2 class="fw-bold mb-0 text-slate-900">Welcome, <%= username %>!</h2>
                            <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-1 small">
                                <i class="bi bi-patch-check-fill me-1"></i> Active Candidate
                            </span>
                        </div>
                        <p class="text-slate-500 mb-0 small mt-1">Manage your professional career profile and monitor job submissions.</p>
                    </div>
                </div>

                <div class="d-flex align-items-center gap-2">
                    <a href="findajob.jsp" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold btn-sm shadow-sm">
                        <i class="bi bi-search me-1"></i> Browse Open Jobs
                    </a>
                    <a href="userlogout.jsp" class="btn btn-outline-danger rounded-pill px-3 py-2 fw-semibold btn-sm">
                        <i class="bi bi-box-arrow-right me-1"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Dashboard Container -->
    <div class="container my-5">
        <div class="row g-4">
            
            <!-- Card 1: Profile Management -->
            <div class="col-lg-4 col-md-6">
                <div class="modern-card bg-white p-4 h-100">
                    <div class="icon-box icon-box-primary">
                        <i class="bi bi-person-lines-fill"></i>
                    </div>
                    <h4>Profile Management</h4>
                    <p class="text-slate-600 mb-4">
                        Keep your contact details, password, and uploaded resume accurate for recruiters.
                    </p>
                    <div class="mt-auto">
                        <a href="profile.jsp" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-semibold w-100">
                            Edit Profile & Resume <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Card 2: My Applications -->
            <div class="col-lg-4 col-md-6">
                <div class="modern-card bg-white p-4 h-100">
                    <div class="icon-box icon-box-success">
                        <i class="bi bi-file-earmark-check-fill"></i>
                    </div>
                    <h4>My Applications</h4>
                    <p class="text-slate-600 mb-4">
                        Track live recruiter feedback, review status (Pending, Shortlisted, Hired), and history.
                    </p>
                    <div class="mt-auto">
                        <a href="applications.jsp" class="btn btn-outline-success rounded-pill px-4 py-2 fw-semibold w-100">
                            View Applications <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Card 3: Find New Jobs -->
            <div class="col-lg-4 col-md-6">
                <div class="modern-card bg-white p-4 h-100">
                    <div class="icon-box icon-box-accent">
                        <i class="bi bi-briefcase-fill"></i>
                    </div>
                    <h4>Explore Openings</h4>
                    <p class="text-slate-600 mb-4">
                        Filter and apply for thousands of verified full-time, part-time, and remote jobs across Nepal.
                    </p>
                    <div class="mt-auto">
                        <a href="findajob.jsp" class="btn btn-outline-info rounded-pill px-4 py-2 fw-semibold w-100">
                            Search All Jobs <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>

        </div>

        <!-- Helpful Tips Banner -->
        <div class="card border-0 shadow-sm rounded-4 p-4 mt-5 bg-white">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h5 class="fw-bold text-slate-900 mb-1"><i class="bi bi-lightbulb-fill text-warning me-2"></i>Maximize Your Job Search Success</h5>
                    <p class="text-slate-500 mb-0 small">
                        Employers are 3x more likely to shortlist candidates with an updated PDF resume and phone number. Keep your profile up-to-date!
                    </p>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                    <a href="profile.jsp" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold btn-sm">
                        Update Resume Now
                    </a>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
