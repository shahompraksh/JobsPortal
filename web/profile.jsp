<%@page import="model.User"%>
<%@page import="DAO.DaoUser"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?msg=Please login first.");
        return;
    }

    User user = DaoUser.getUserByUsername(username);
    String profInitial = (user != null && user.getName() != null && !user.getName().isEmpty()) ? user.getName().substring(0, 1).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Elevate Workforce Solutions</title>
    
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

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                
                <!-- Profile Card -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                    <!-- Profile Header Banner -->
                    <div class="p-4 bg-primary text-white text-center position-relative">
                        <div class="user-avatar-badge mx-auto mb-2 shadow" style="width: 70px; height: 70px; font-size: 2rem; background: white; color: var(--primary);">
                            <%= profInitial %>
                        </div>
                        <h3 class="fw-bold mb-1"><%= user.getName() %></h3>
                        <p class="text-white-50 mb-0 small"><i class="bi bi-person-check me-1"></i> @<%= user.getUsername() %></p>
                    </div>

                    <div class="card-body p-4 p-lg-5">
                        <% String msg = request.getParameter("msg");
                           if (msg != null && !msg.isBlank()) { %>
                            <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                                <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <form action="doUserProfile" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="id" value="<%= user.getId() %>">

                            <h5 class="fw-bold text-slate-900 mb-3 pb-2 border-bottom">
                                <i class="bi bi-person-vcard text-primary me-2"></i>Personal Details
                            </h5>

                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-slate-700">Full Name <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-person"></i></span>
                                        <input type="text" name="name" value="<%= user.getName() %>" class="form-control" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-slate-700">Username</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-at"></i></span>
                                        <input type="text" name="username" value="<%= user.getUsername() %>" class="form-control bg-light" readonly>
                                    </div>
                                    <small class="text-muted">Username cannot be altered.</small>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-slate-700">Email Address <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                                        <input type="email" name="email" value="<%= user.getEmail() %>" class="form-control" required>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-slate-700">Phone Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-telephone"></i></span>
                                        <input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" class="form-control" placeholder="+977 98XXXXXXXX">
                                    </div>
                                </div>

                                <div class="col-12">
                                    <label class="form-label small fw-bold text-slate-700">Account Password <span class="text-danger">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light text-muted"><i class="bi bi-lock"></i></span>
                                        <input type="password" name="password" value="<%= user.getPassword() %>" class="form-control" required>
                                    </div>
                                </div>
                            </div>

                            <h5 class="fw-bold text-slate-900 mb-3 pb-2 border-bottom">
                                <i class="bi bi-file-earmark-arrow-up text-primary me-2"></i>Resume & Credentials
                            </h5>

                            <div class="p-3 border rounded-3 bg-light mb-4">
                                <label class="form-label small fw-bold text-slate-700">Upload New Resume (PDF / DOCX)</label>
                                <input type="file" name="resume" class="form-control mb-2">
                                
                                <% if (user.getResume() != null && !user.getResume().isEmpty()) { %>
                                    <div class="d-flex align-items-center gap-2 mt-2">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-2 py-1">
                                            <i class="bi bi-check-lg me-1"></i> Active Resume
                                        </span>
                                        <a href="<%= user.getResume() %>" target="_blank" class="small fw-semibold text-primary text-decoration-none">
                                            <i class="bi bi-box-arrow-up-right me-1"></i> View Current Uploaded Resume
                                        </a>
                                    </div>
                                <% } else { %>
                                    <small class="text-muted">No resume currently on file. Upload one to streamline 1-click job applications.</small>
                                <% } %>
                            </div>

                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-primary rounded-pill py-3 fw-bold shadow-sm">
                                    <i class="bi bi-cloud-check-fill me-2"></i> Save Profile Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
