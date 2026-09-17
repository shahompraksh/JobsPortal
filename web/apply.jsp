<%@page import="DAO.DaoUser"%>
<%@page import="DAO.DaoJobs"%>
<%@page import="model.User"%>
<%@page import="model.Job"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?msg=Please login first.");
        return;
    }

    String jobIdParameter = request.getParameter("jobId");
    if (jobIdParameter == null) {
        response.sendRedirect("findajob.jsp?msg=Select+a+job+first.");
        return;
    }
    int jobId;
    try {
        jobId = Integer.parseInt(jobIdParameter);
    } catch (NumberFormatException e) {
        response.sendRedirect("findajob.jsp?msg=Invalid+job.");
        return;
    }
    Job job = DaoJobs.getJobById(jobId);
    User user = DaoUser.getUserByUsername(username);
    if (job == null || user == null) {
        response.sendRedirect("findajob.jsp?msg=That+job+is+not+available.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Apply for <%= job.getTitle() %> | Elevate Workforce</title>
    
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
                
                <!-- Back Link -->
                <div class="mb-3">
                    <a href="findajob.jsp" class="text-slate-600 text-decoration-none small fw-semibold">
                        <i class="bi bi-arrow-left me-1"></i> Back to Jobs
                    </a>
                </div>

                <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                    <!-- Job Banner -->
                    <div class="p-4 bg-primary text-white">
                        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
                            <span class="badge bg-white text-primary rounded-pill px-3 py-1 fw-bold">
                                <%= job.getType() %>
                            </span>
                            <span class="badge bg-primary-subtle text-white border border-white-subtle rounded-pill px-3 py-1">
                                <i class="bi bi-geo-alt-fill me-1"></i> <%= job.getLocation() %>
                            </span>
                        </div>
                        <h3 class="fw-bold mb-1"><%= job.getTitle() %></h3>
                        <p class="mb-0 text-white-50 fs-6"><i class="bi bi-building me-1"></i> <%= job.getCompany() %></p>
                    </div>

                    <!-- Application Body -->
                    <div class="card-body p-4 p-lg-5">
                        <div class="alert alert-info d-flex align-items-center gap-2 rounded-3 small mb-4">
                            <i class="bi bi-info-circle-fill fs-5 text-primary flex-shrink-0"></i>
                            <div>
                                Applying with your verified candidate profile. Please ensure your contact information and resume are up-to-date.
                            </div>
                        </div>

                        <form action="doApplyJob" method="post">
                            <input type="hidden" name="jobId" value="<%= job.getId() %>">

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-slate-700">Candidate Name</label>
                                    <input type="text" class="form-control bg-light" value="<%= user.getName() %>" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-slate-700">Registered Email</label>
                                    <input type="email" class="form-control bg-light" value="<%= user.getEmail() %>" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-slate-700">Phone Number</label>
                                    <input type="text" class="form-control bg-light" value="<%= (user.getPhone() != null && !user.getPhone().isEmpty()) ? user.getPhone() : "Not provided" %>" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-slate-700">Compensation Benchmark</label>
                                    <input type="text" class="form-control bg-light" value="NPR <%= String.format("%,.0f", job.getSalary()) %> / month" readonly>
                                </div>

                                <div class="col-12 mt-4">
                                    <label class="form-label small fw-bold text-slate-700">Attached Resume</label>
                                    <div class="p-3 border rounded-3 bg-light d-flex align-items-center justify-content-between flex-wrap gap-2">
                                        <% if (user.getResume() != null && !user.getResume().isEmpty()) { %>
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="bi bi-file-earmark-pdf-fill text-danger fs-4"></i>
                                                <div>
                                                    <div class="fw-semibold small text-slate-800">Resume on File</div>
                                                    <small class="text-muted">Will be shared securely with <%= job.getCompany() %></small>
                                                </div>
                                            </div>
                                            <a href="<%= user.getResume() %>" target="_blank" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                                <i class="bi bi-eye me-1"></i> Preview Resume
                                            </a>
                                        <% } else { %>
                                            <div class="d-flex align-items-center gap-2 text-warning">
                                                <i class="bi bi-exclamation-triangle-fill fs-4"></i>
                                                <span class="small">No resume uploaded. You can still apply, but uploading a resume in your profile increases hiring chances.</span>
                                            </div>
                                            <a href="profile.jsp" class="btn btn-outline-warning btn-sm rounded-pill px-3">
                                                Upload in Profile
                                            </a>
                                        <% } %>
                                    </div>
                                </div>

                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-primary w-100 rounded-pill py-3 fw-bold shadow-sm">
                                        <i class="bi bi-send-check-fill me-2"></i> Confirm & Submit Application
                                    </button>
                                </div>
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
