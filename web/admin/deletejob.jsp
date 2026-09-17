<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, DAO.DaoJobs, model.Job" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String prefillId = request.getParameter("id");
    List<Job> allJobs = DaoJobs.getAllJobs();
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Job Post | Elevate Admin</title>
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Admin Design System -->
    <link rel="stylesheet" href="admin-modern.css">
</head>
<body>

    <div class="admin-wrapper">
        <jsp:include page="admin-sidebar.jsp" />

        <div class="admin-main">
            <jsp:include page="admin-topbar.jsp" />

            <main class="admin-content">
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h2 class="fw-bold mb-1"><i class="bi bi-trash3-fill text-danger me-2"></i>Delete Job Posting</h2>
                        <p class="text-muted mb-0">Permanently remove a position listing from Elevate Workforce</p>
                    </div>
                    <div>
                        <a href="viewalljobs.jsp" class="btn btn-outline-secondary rounded-pill px-3 py-2 btn-sm">
                            <i class="bi bi-arrow-left me-1"></i> Back to All Jobs
                        </a>
                    </div>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-6 col-md-8">
                        <div class="adm-card p-4 p-md-5 border-danger-subtle shadow-sm">
                            
                            <div class="text-center mb-4">
                                <div class="badge bg-danger-subtle text-danger rounded-circle p-3 mb-3 fs-3" style="width: 72px; height: 72px; display: inline-flex; align-items: center; justify-content: center;">
                                    <i class="bi bi-exclamation-triangle-fill"></i>
                                </div>
                                <h4 class="fw-bold text-danger mb-1">Confirm Permanent Deletion</h4>
                                <p class="text-muted small mb-0">
                                    Deleting a job posting will also remove its associated candidate records and prevent applicants from submitting applications for this vacancy.
                                </p>
                            </div>

                            <form action="../doDeleteJob" method="post" onsubmit="return confirm('Are you absolutely sure you want to permanently delete this job? This action cannot be reversed.');">
                                <div class="mb-4">
                                    <label class="form-label small fw-bold">Select Job to Delete <span class="text-danger">*</span></label>
                                    <select name="id" id="jobSelect" class="form-select form-select-lg" required>
                                        <option value="">-- Choose Job Opening --</option>
                                        <% for (Job j : allJobs) { %>
                                            <option value="<%= j.getId() %>" <%= (prefillId != null && prefillId.equals(String.valueOf(j.getId()))) ? "selected" : "" %>>
                                                #<%= j.getId() %> - <%= j.getTitle() %> (<%= j.getCompany() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                    <small class="text-muted mt-1 d-block">Or enter the specific Job ID number below if known.</small>
                                </div>

                                <div class="d-grid gap-2">
                                    <button type="submit" class="btn btn-danger btn-lg rounded-pill fw-bold shadow-sm py-2">
                                        <i class="bi bi-trash3 me-2"></i> Delete This Job Permanently
                                    </button>
                                    <a href="viewalljobs.jsp" class="btn btn-outline-secondary rounded-pill py-2">
                                        Cancel & Return
                                    </a>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <!-- Bootstrap & Admin JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="admin-modern.js"></script>
</body>
</html>