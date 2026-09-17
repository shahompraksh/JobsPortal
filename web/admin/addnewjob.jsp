<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post New Job - Elevate Workforce Admin</title>
    
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
                    <a href="viewalljobs.jsp" class="text-muted small text-decoration-none">
                        <i class="bi bi-arrow-left me-1"></i> Back to All Jobs
                    </a>
                    <h2 class="fw-bold mt-2 mb-1">Create New Job Listing</h2>
                    <p class="text-muted small">Fill out the job specifications below to publish directly to the live portal.</p>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-10">
                        <div class="adm-card p-4 p-md-5">
                            <form action="../doAddJob" method="post">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="title" class="form-label small fw-bold">Job Title <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-briefcase"></i></span>
                                            <input type="text" id="title" name="title" class="form-control" placeholder="e.g. Senior Software Engineer" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="company" class="form-label small fw-bold">Hiring Company <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-building"></i></span>
                                            <input type="text" id="company" name="company" class="form-control" placeholder="e.g. Nepal IT Solutions" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="location" class="form-label small fw-bold">Location <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted"><i class="bi bi-geo-alt"></i></span>
                                            <input type="text" id="location" name="location" class="form-control" placeholder="e.g. Kathmandu, Pokhara, Remote" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="salary" class="form-label small fw-bold">Monthly Salary (NPR)</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-light text-muted">NPR</span>
                                            <input type="number" id="salary" name="salary" class="form-control" placeholder="e.g. 75000">
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="type" class="form-label small fw-bold">Employment Type <span class="text-danger">*</span></label>
                                        <select id="type" name="type" class="form-select" required>
                                            <option value="">-- Select Employment Type --</option>
                                            <option value="Full-time">Full-time</option>
                                            <option value="Part-time">Part-time</option>
                                            <option value="Internship">Internship</option>
                                            <option value="Remote">Remote</option>
                                        </select>
                                    </div>

                                    <div class="col-12">
                                        <label for="description" class="form-label small fw-bold">Job Description & Requirements <span class="text-danger">*</span></label>
                                        <textarea id="description" name="description" rows="6" class="form-control" placeholder="Specify key responsibilities, required skills, and qualification benchmarks..." required></textarea>
                                    </div>

                                    <div class="col-12 mt-4 d-flex justify-content-end gap-2">
                                        <a href="viewalljobs.jsp" class="btn btn-outline-secondary rounded-pill px-4">Cancel</a>
                                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold shadow-sm">
                                            <i class="bi bi-check-lg me-1"></i> Publish Job Listing
                                        </button>
                                    </div>
                                </div>
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
