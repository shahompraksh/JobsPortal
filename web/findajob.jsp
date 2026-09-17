<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Job" %>
<%@ page import="DAO.DaoJobs" %>

<%
    // ===== Get parameters =====
    String category = request.getParameter("category") != null ? request.getParameter("category") : "";
    String type = request.getParameter("type") != null ? request.getParameter("type") : "";
    String location = request.getParameter("location") != null ? request.getParameter("location") : "";
    String salaryStr = request.getParameter("salary");
    double maxSalary = 0;
    if(salaryStr != null && !salaryStr.isEmpty()) {
        try {
            maxSalary = Double.parseDouble(salaryStr);
        } catch(Exception e) {
            maxSalary = 0;
        }
    }

    String search = request.getParameter("search") != null ? request.getParameter("search") : "";
    String sortBy = request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "";

    int recordsPerPage = 6;
    int pageNum = 1;
    if(request.getParameter("page") != null) {
        try {
            pageNum = Integer.parseInt(request.getParameter("page"));
        } catch(Exception e) {
            pageNum = 1;
        }
    }
    int offset = (pageNum - 1) * recordsPerPage;

    // ===== Fetch jobs =====
    List<Job> jobs;
    int totalRecords;

    // If "View All" clicked, clear filters
    if(request.getParameter("viewAll") != null) {
        jobs = DaoJobs.getJobs(offset, recordsPerPage, "", "", 0, "", "");
        totalRecords = DaoJobs.getJobCount("", "", 0, "");
        category = type = location = search = sortBy = "";
        maxSalary = 0;
    } else {
        jobs = DaoJobs.getJobs(offset, recordsPerPage, type, location, maxSalary, search, sortBy);
        totalRecords = DaoJobs.getJobCount(type, location, maxSalary, search);
    }

    int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
    int serial = offset + 1;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Find a Job | Elevate Workforce Solutions</title>
    <meta name="description" content="Explore verified job openings across Nepal. Filter by category, location, and salary.">
    
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

    <!-- Header Navigation -->
    <jsp:include page="header.jsp" />

    <!-- Page Title Header -->
    <div class="bg-white border-bottom py-4">
        <div class="container">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-2">
                <div>
                    <h2 class="fw-bold mb-1 text-slate-900">Discover Opportunities</h2>
                    <p class="text-slate-500 mb-0">Showing <%= totalRecords %> verified job <%= (totalRecords == 1) ? "opening" : "openings" %> across Nepal</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-2">
                        <i class="bi bi-clock-history me-1"></i> Live Database
                    </span>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Top Employers Running Marquee Ticker -->
    <jsp:include page="top-employers-ticker.jsp" />

    <!-- Main Content Container -->
    <div class="container my-5">
        <div class="row g-4">
            
            <!-- Sidebar Filters -->
            <div class="col-lg-3 col-md-4">
                <div class="job-filter-sidebar">
                    <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom">
                        <h5 class="fw-bold mb-0 text-slate-900"><i class="bi bi-funnel text-primary me-2"></i>Filters</h5>
                        <% if (!category.isEmpty() || !type.isEmpty() || !location.isEmpty() || maxSalary > 0 || !search.isEmpty()) { %>
                            <a href="findajob.jsp?viewAll=true" class="small text-danger text-decoration-none fw-semibold">Clear All</a>
                        <% } %>
                    </div>

                    <form method="get" action="findajob.jsp">
                        <input type="hidden" name="search" value="<%= search %>">
                        <input type="hidden" name="sortBy" value="<%= sortBy %>">

                        <!-- Job Category -->
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-slate-700">Category</label>
                            <select name="category" class="form-select form-select-sm rounded-3">
                                <option value="">All Categories</option>
                                <option value="IT" <%= "IT".equals(category) ? "selected" : "" %>>IT & Software</option>
                                <option value="Marketing" <%= "Marketing".equals(category) ? "selected" : "" %>>Marketing & Growth</option>
                                <option value="Finance" <%= "Finance".equals(category) ? "selected" : "" %>>Finance & Banking</option>
                                <option value="Design" <%= "Design".equals(category) ? "selected" : "" %>>UI/UX & Design</option>
                            </select>
                        </div>

                        <!-- Job Type (Pills / Radios) -->
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-slate-700 d-block">Employment Type</label>
                            <% String[] types = {"Full-Time", "Part-Time", "Remote"}; %>
                            <div class="d-flex flex-column gap-2">
                                <% for(String t : types) { 
                                    boolean isChecked = t.equals(type);
                                %>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="type" id="type_<%= t %>" value="<%= t %>"
                                               <%= isChecked ? "checked" : "" %>
                                               onclick="handleTypeClick('<%= t %>')">
                                        <label class="form-check-label small text-slate-700" for="type_<%= t %>">
                                            <%= t %>
                                        </label>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                        <!-- Job Location -->
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-slate-700">Location</label>
                            <select name="location" class="form-select form-select-sm rounded-3">
                                <option value="">Any Location</option>
                                <option value="Kathmandu" <%= "Kathmandu".equals(location) ? "selected" : "" %>>Kathmandu</option>
                                <option value="Pokhara" <%= "Pokhara".equals(location) ? "selected" : "" %>>Pokhara</option>
                                <option value="Lalitpur" <%= "Lalitpur".equals(location) ? "selected" : "" %>>Lalitpur</option>
                            </select>
                        </div>

                        <!-- Max Salary -->
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-slate-700">Max Salary (NPR)</label>
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light text-muted">NPR</span>
                                <input type="number" class="form-control" name="salary" placeholder="e.g. 150000" value="<%= maxSalary > 0 ? (long)maxSalary : "" %>">
                            </div>
                        </div>

                        <!-- Buttons -->
                        <button type="submit" class="btn btn-primary w-100 rounded-pill py-2 fw-semibold mb-2 shadow-sm">
                            <i class="bi bi-funnel-fill me-1"></i> Apply Filters
                        </button>
                        <a href="findajob.jsp?viewAll=true" class="btn btn-outline-secondary w-100 rounded-pill py-2 fw-semibold btn-sm">
                            Reset All Filters
                        </a>
                    </form>
                </div>
            </div>

            <!-- Job Listings Column -->
            <div class="col-lg-9 col-md-8">
                
                <!-- Search & Sort Top Toolbar -->
                <div class="bg-white p-3 rounded-4 border mb-4 shadow-sm">
                    <form class="row g-2 align-items-center" method="get" action="findajob.jsp">
                        <input type="hidden" name="category" value="<%= category %>">
                        <input type="hidden" name="type" value="<%= type %>">
                        <input type="hidden" name="location" value="<%= location %>">
                        <input type="hidden" name="salary" value="<%= maxSalary > 0 ? (long)maxSalary : "" %>">

                        <div class="col-md-7 col-12">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                                <input type="text" class="form-control border-start-0" name="search" placeholder="Search by title, role or keywords..." value="<%= search %>">
                            </div>
                        </div>

                        <div class="col-md-3 col-8">
                            <select class="form-select" name="sortBy">
                                <option value="">Sort by: Default</option>
                                <option value="Newest" <%= "Newest".equals(sortBy) ? "selected" : "" %>>Newest First</option>
                                <option value="Oldest" <%= "Oldest".equals(sortBy) ? "selected" : "" %>>Oldest First</option>
                                <option value="Salary: High to Low" <%= "Salary: High to Low".equals(sortBy) ? "selected" : "" %>>Salary: High to Low</option>
                                <option value="Salary: Low to High" <%= "Salary: Low to High".equals(sortBy) ? "selected" : "" %>>Salary: Low to High</option>
                            </select>
                        </div>

                        <div class="col-md-2 col-4">
                            <button type="submit" class="btn btn-primary w-100 fw-semibold">Search</button>
                        </div>
                    </form>
                </div>

                <!-- Job Listings -->
                <% if (jobs == null || jobs.isEmpty()) { %>
                    <div class="card border-0 shadow-sm p-5 text-center rounded-4 bg-white">
                        <div class="user-avatar-badge mx-auto mb-3" style="width: 60px; height: 60px; font-size: 1.8rem; background: var(--slate-100); color: var(--slate-400);">
                            <i class="bi bi-search"></i>
                        </div>
                        <h4 class="fw-bold text-slate-800">No Job Openings Found</h4>
                        <p class="text-slate-500 max-w-md mx-auto mb-4">
                            We couldn't find any job postings matching your specific criteria. Try adjusting your search keywords, clearing filters, or checking back soon.
                        </p>
                        <div>
                            <a href="findajob.jsp?viewAll=true" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold">
                                View All Available Jobs
                            </a>
                        </div>
                    </div>
                <% } else {
                    for(Job j : jobs) { 
                        String badgeClass = "bg-primary-subtle text-primary border border-primary-subtle";
                        if ("Remote".equalsIgnoreCase(j.getType())) {
                            badgeClass = "bg-info-subtle text-info border border-info-subtle";
                        } else if ("Part-Time".equalsIgnoreCase(j.getType())) {
                            badgeClass = "bg-warning-subtle text-warning-emphasis border border-warning-subtle";
                        }
                    %>
                        <div class="job-card-modern">
                            <div class="d-flex align-items-center gap-3">
                                <div class="job-logo-box">
                                    <img src="images/job.png" alt="<%= j.getCompany() %> Logo">
                                </div>
                                <div>
                                    <div class="d-flex align-items-center gap-2 flex-wrap mb-1">
                                        <h5 class="fw-bold mb-0 text-slate-900"><%= j.getTitle() %></h5>
                                        <span class="badge rounded-pill <%= badgeClass %> px-2 py-1 small">
                                            <%= j.getType() %>
                                        </span>
                                    </div>
                                    <p class="text-primary fw-semibold mb-1 small"><%= j.getCompany() %></p>
                                    <div class="d-flex align-items-center gap-3 text-slate-500 small flex-wrap">
                                        <span><i class="bi bi-geo-alt-fill text-muted me-1"></i><%= j.getLocation() %></span>
                                        <span><i class="bi bi-cash-stack text-success me-1"></i>NPR <%= String.format("%,.0f", j.getSalary()) %> / mo</span>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex align-items-center justify-content-between justify-content-md-end gap-3 mt-3 mt-md-0 pt-3 pt-md-0 border-top border-md-0">
                                <div class="text-md-end d-none d-md-block">
                                    <div class="fw-bold text-slate-900">NPR <%= String.format("%,.0f", j.getSalary()) %></div>
                                    <small class="text-muted">Monthly</small>
                                </div>
                                <a href="apply.jsp?jobId=<%= j.getId() %>" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-sm">
                                    Apply Now <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                <%  }
                } %>

                <!-- Pagination -->
                <% if (totalPages > 1) { %>
                    <nav class="mt-5">
                        <ul class="pagination justify-content-center gap-1">
                            <% if(pageNum > 1) { %>
                                <li class="page-item">
                                    <a class="page-link rounded-pill px-3" href="findajob.jsp?page=<%= pageNum-1 %>&category=<%= category %>&type=<%= type %>&location=<%= location %>&salary=<%= maxSalary > 0 ? (long)maxSalary : "" %>&search=<%= search %>&sortBy=<%= sortBy %>">
                                        <i class="bi bi-chevron-left"></i> Previous
                                    </a>
                                </li>
                            <% } %>

                            <% for(int i=1; i<=totalPages; i++) { %>
                                <li class="page-item <%= (i==pageNum) ? "active" : "" %>">
                                    <a class="page-link rounded-circle text-center" style="width: 38px; height: 38px; line-height: 24px;" href="findajob.jsp?page=<%= i %>&category=<%= category %>&type=<%= type %>&location=<%= location %>&salary=<%= maxSalary > 0 ? (long)maxSalary : "" %>&search=<%= search %>&sortBy=<%= sortBy %>"><%= i %></a>
                                </li>
                            <% } %>

                            <% if(pageNum < totalPages) { %>
                                <li class="page-item">
                                    <a class="page-link rounded-pill px-3" href="findajob.jsp?page=<%= pageNum+1 %>&category=<%= category %>&type=<%= type %>&location=<%= location %>&salary=<%= maxSalary > 0 ? (long)maxSalary : "" %>&search=<%= search %>&sortBy=<%= sortBy %>">
                                        Next <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            <% } %>
                        </ul>
                    </nav>
                <% } %>

            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function handleTypeClick(selectedType) {
            let params = new URLSearchParams(window.location.search);

            if(params.get('type') === selectedType) {
                params.set('type', '');
            } else {
                params.set('type', selectedType);
            }
            params.set('page', 1); // reset page
            window.location.href = "findajob.jsp?" + params.toString();
        }
    </script>
</body>
</html>
