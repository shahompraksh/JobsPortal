<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, dbHelper.MyConnect"%>
<%
    String username = (String) session.getAttribute("un");
    if (username == null) username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Application Status Counts
    int pendingCount = 0, shortlistedCount = 0, hiredCount = 0, rejectedCount = 0;
    
    // Location breakdown
    java.util.Map<String, Integer> locationMap = new java.util.LinkedHashMap<>();
    
    // Type breakdown
    java.util.Map<String, Integer> typeMap = new java.util.LinkedHashMap<>();

    // Salary benchmarks
    double avgSalary = 0, maxSalary = 0, minSalary = 0;

    try (Connection conn = MyConnect.connectDatab()) {
        // Status counts
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT status, COUNT(*) FROM applications GROUP BY status")) {
            while (rs.next()) {
                String s = rs.getString(1);
                int c = rs.getInt(2);
                if ("Pending".equalsIgnoreCase(s)) pendingCount = c;
                else if ("Shortlisted".equalsIgnoreCase(s)) shortlistedCount = c;
                else if ("Hired".equalsIgnoreCase(s)) hiredCount = c;
                else if ("Rejected".equalsIgnoreCase(s)) rejectedCount = c;
            }
        }

        // Location counts
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT location, COUNT(*) FROM jobs GROUP BY location ORDER BY COUNT(*) DESC LIMIT 6")) {
            while (rs.next()) {
                locationMap.put(rs.getString(1), rs.getInt(2));
            }
        }

        // Type counts
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT type, COUNT(*) FROM jobs GROUP BY type")) {
            while (rs.next()) {
                typeMap.put(rs.getString(1), rs.getInt(2));
            }
        }

        // Salary stats
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT AVG(salary), MAX(salary), MIN(salary) FROM jobs")) {
            if (rs.next()) {
                avgSalary = rs.getDouble(1);
                maxSalary = rs.getDouble(2);
                minSalary = rs.getDouble(3);
            }
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics & Insights - Elevate Workforce Admin</title>
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Modern Admin Stylesheet -->
    <link rel="stylesheet" href="admin-modern.css">
</head>
<body>
    <div class="admin-wrapper">
        <jsp:include page="admin-sidebar.jsp" />

        <div class="admin-main">
            <jsp:include page="admin-topbar.jsp" />

            <main class="admin-content">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="fw-bold mb-1">Recruitment Analytics</h2>
                        <p class="text-muted mb-0 small">Visual distribution of job openings, candidate conversion, and regional demand.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <select class="form-select form-select-sm rounded-pill px-3" style="width: 160px;">
                            <option>All Historical Data</option>
                            <option>Current Quarter</option>
                            <option>This Year</option>
                        </select>
                    </div>
                </div>

                <!-- KPI Metric Highlights -->
                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="adm-card p-4">
                            <span class="text-muted small fw-bold text-uppercase">Average Offered Salary</span>
                            <h3 class="fw-bold text-primary mt-1 mb-0">NPR <%= String.format("%,.0f", avgSalary) %></h3>
                            <small class="text-muted">Calculated across all listed positions</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="adm-card p-4">
                            <span class="text-muted small fw-bold text-uppercase">Peak Executive Salary</span>
                            <h3 class="fw-bold text-success mt-1 mb-0">NPR <%= String.format("%,.0f", maxSalary) %></h3>
                            <small class="text-muted">Highest compensation on platform</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="adm-card p-4">
                            <span class="text-muted small fw-bold text-uppercase">Entry-Level Baseline</span>
                            <h3 class="fw-bold text-info mt-1 mb-0">NPR <%= String.format("%,.0f", minSalary) %></h3>
                            <small class="text-muted">Competitive starting threshold</small>
                        </div>
                    </div>
                </div>

                <!-- Charts Row 1 -->
                <div class="row g-4 mb-4">
                    <!-- Status Doughnut Chart -->
                    <div class="col-lg-5">
                        <div class="adm-card h-100">
                            <h5 class="fw-bold mb-1">Application Pipeline Breakdown</h5>
                            <small class="text-muted d-block mb-4">Candidate lifecycle progression from submission to hiring</small>
                            <div style="height: 280px; position: relative;">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Location Bar Chart -->
                    <div class="col-lg-7">
                        <div class="adm-card h-100">
                            <h5 class="fw-bold mb-1">Geographic Job Distribution</h5>
                            <small class="text-muted d-block mb-4">Active vacancies categorized by metropolitan region</small>
                            <div style="height: 280px; position: relative;">
                                <canvas id="locationChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row 2 -->
                <div class="row g-4">
                    <!-- Employment Type Chart -->
                    <div class="col-lg-6">
                        <div class="adm-card h-100">
                            <h5 class="fw-bold mb-1">Opportunities by Employment Type</h5>
                            <small class="text-muted d-block mb-4">Full-time, Part-time, Internship, and Remote offerings</small>
                            <div style="height: 260px; position: relative;">
                                <canvas id="typeChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Hiring Conversion Card -->
                    <div class="col-lg-6">
                        <div class="adm-card h-100">
                            <h5 class="fw-bold mb-1">Hiring Funnel Conversion</h5>
                            <small class="text-muted d-block mb-4">Candidate progression rates across evaluation stages</small>
                            
                            <%
                                int totalPipeline = pendingCount + shortlistedCount + hiredCount + rejectedCount;
                                double hiredPct = totalPipeline > 0 ? (hiredCount * 100.0 / totalPipeline) : 0;
                                double shortPct = totalPipeline > 0 ? (shortlistedCount * 100.0 / totalPipeline) : 0;
                                double pendPct = totalPipeline > 0 ? (pendingCount * 100.0 / totalPipeline) : 0;
                            %>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between small fw-bold mb-1">
                                    <span>Hired & Placed Candidates</span>
                                    <span class="text-success"><%= String.format("%.1f", hiredPct) %>%</span>
                                </div>
                                <div class="progress" style="height: 10px;">
                                    <div class="progress-bar bg-success" style="width: <%= hiredPct %>%;"></div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between small fw-bold mb-1">
                                    <span>Shortlisted for Interviews</span>
                                    <span class="text-info"><%= String.format("%.1f", shortPct) %>%</span>
                                </div>
                                <div class="progress" style="height: 10px;">
                                    <div class="progress-bar bg-info" style="width: <%= shortPct %>%;"></div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <div class="d-flex justify-content-between small fw-bold mb-1">
                                    <span>Pending Initial Review</span>
                                    <span class="text-warning"><%= String.format("%.1f", pendPct) %>%</span>
                                </div>
                                <div class="progress" style="height: 10px;">
                                    <div class="progress-bar bg-warning" style="width: <%= pendPct %>%;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="admin-modern.js"></script>
    
    <script>
        // Status Doughnut Chart
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Pending', 'Shortlisted', 'Hired', 'Rejected'],
                datasets: [{
                    data: [<%= pendingCount %>, <%= shortlistedCount %>, <%= hiredCount %>, <%= rejectedCount %>],
                    backgroundColor: ['#f59e0b', '#06b6d4', '#10b981', '#ef4444'],
                    borderWidth: 2,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom' }
                },
                cutout: '65%'
            }
        });

        // Location Bar Chart
        const locationCtx = document.getElementById('locationChart').getContext('2d');
        new Chart(locationCtx, {
            type: 'bar',
            data: {
                labels: [<% 
                    int locIdx = 0;
                    for (String loc : locationMap.keySet()) { 
                        if (locIdx++ > 0) out.print(", ");
                        out.print("'" + loc + "'");
                    } 
                %>],
                datasets: [{
                    label: 'Number of Openings',
                    data: [<% 
                        int valIdx = 0;
                        for (Integer val : locationMap.values()) { 
                            if (valIdx++ > 0) out.print(", ");
                            out.print(val);
                        } 
                    %>],
                    backgroundColor: '#2563eb',
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: { beginAtZero: true, ticks: { stepSize: 1 } }
                }
            }
        });

        // Employment Type Chart
        const typeCtx = document.getElementById('typeChart').getContext('2d');
        new Chart(typeCtx, {
            type: 'polarArea',
            data: {
                labels: [<% 
                    int tIdx = 0;
                    for (String t : typeMap.keySet()) { 
                        if (tIdx++ > 0) out.print(", ");
                        out.print("'" + t + "'");
                    } 
                %>],
                datasets: [{
                    data: [<% 
                        int tvIdx = 0;
                        for (Integer val : typeMap.values()) { 
                            if (tvIdx++ > 0) out.print(", ");
                            out.print(val);
                        } 
                    %>],
                    backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'right' }
                }
            }
        });
    </script>
</body>
</html>
