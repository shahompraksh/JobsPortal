<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, dbHelper.MyConnect"%>
<%
    // If admin is already logged in, redirect straight to dashboard
    String sessionAdmin = (String) session.getAttribute("un");
    if (sessionAdmin == null) {
        sessionAdmin = (String) session.getAttribute("username");
    }
    if (sessionAdmin != null && !sessionAdmin.isBlank()) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        return;
    }

    // Optional database count metrics
    int liveJobs = 24;
    int liveUsers = 3;
    try (Connection conn = MyConnect.connectDatab()) {
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM jobs")) {
            if (rs.next()) liveJobs = rs.getInt(1);
        }
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM user")) {
            if (rs.next()) liveUsers = rs.getInt(1);
        }
    } catch (Exception ignored) {}
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Employer & Admin Zone - Elevate Workforce Solutions</title>
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        :root {
            --ez-blue: #0066cc;
            --ez-blue-hover: #0052a3;
            --ez-navy: #173b75;
            --ez-slate: #0f172a;
            --ez-amber: #f59e0b;
            --ez-cyan: #06b6d4;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: radial-gradient(circle at 10% 20%, rgba(224, 242, 254, 0.55) 0%, transparent 40%),
                        radial-gradient(circle at 90% 60%, rgba(219, 234, 254, 0.55) 0%, transparent 50%),
                        #f8fafc;
            color: #1e293b;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            position: relative;
        }

        /* Decorative background wave lines */
        .bg-wave-art {
            position: absolute;
            top: 60px;
            right: -80px;
            width: 700px;
            height: 700px;
            pointer-events: none;
            opacity: 0.18;
            z-index: 0;
            background-image: radial-gradient(#0284c7 1px, transparent 1px);
            background-size: 24px 24px;
        }

        /* Top Navigation Bar */
        .ez-navbar {
            background: #ffffff;
            border-bottom: 1px solid #e2e8f0;
            padding: 14px 0;
            position: relative;
            z-index: 20;
            box-shadow: 0 1px 3px rgba(15, 23, 42, 0.04);
        }

        .ez-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .ez-brand-logo {
            height: 38px;
            width: auto;
        }

        .ez-nav-link {
            color: #475569;
            font-weight: 500;
            font-size: 0.92rem;
            text-decoration: none;
            padding: 6px 12px;
            transition: color 0.2s;
        }

        .ez-nav-link:hover {
            color: var(--ez-blue);
        }

        /* Hero Main Section */
        .ez-hero-section {
            padding: 40px 0 60px;
            flex-grow: 1;
            position: relative;
            z-index: 10;
        }

        /* Graphic Stage */
        .graphic-stage {
            position: relative;
            width: 100%;
            max-width: 480px;
            height: 340px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Central Executive Avatar */
        .executive-circle {
            width: 230px;
            height: 230px;
            border-radius: 50%;
            object-fit: cover;
            object-position: top center;
            border: 6px solid #ffffff;
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.12);
            position: relative;
            z-index: 2;
        }

        /* Orbit Dotted Ring */
        .orbit-ring {
            position: absolute;
            width: 330px;
            height: 330px;
            border-radius: 50%;
            border: 2px dashed #93c5fd;
            pointer-events: none;
            animation: slowRotate 45s linear infinite;
        }

        @keyframes slowRotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Floating Badges */
        .float-badge-recruit {
            position: absolute;
            top: 20px;
            left: 45px;
            background: var(--ez-amber);
            color: #ffffff;
            font-size: 0.76rem;
            font-weight: 700;
            padding: 5px 14px;
            border-radius: 20px;
            letter-spacing: 0.3px;
            box-shadow: 0 4px 14px rgba(245, 158, 11, 0.4);
            z-index: 4;
            animation: floatUpDown 4s ease-in-out infinite;
        }

        .float-card-left {
            position: absolute;
            left: 0;
            top: 95px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 10px 14px;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
            width: 175px;
            z-index: 4;
            animation: floatUpDown 5s ease-in-out infinite 0.5s;
        }

        .float-card-right-top {
            position: absolute;
            right: 15px;
            top: 15px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 8px 14px;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
            z-index: 4;
            animation: floatUpDown 4.5s ease-in-out infinite 1s;
        }

        .float-badge-cyan {
            position: absolute;
            right: 25px;
            bottom: 75px;
            background: linear-gradient(135deg, #0284c7, #06b6d4);
            color: #ffffff;
            border-radius: 12px;
            padding: 10px 16px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(6, 182, 212, 0.35);
            z-index: 4;
            animation: floatUpDown 5.5s ease-in-out infinite 1.5s;
        }

        @keyframes floatUpDown {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
        }

        /* Hero Text */
        .hero-hire-title {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 2.75rem;
            font-weight: 800;
            color: #0f172a;
            letter-spacing: -0.5px;
            margin-top: 15px;
            text-align: center;
        }

        .hero-hire-title .highlight {
            color: var(--ez-blue);
        }

        .hero-hire-subtitle {
            font-size: 1.15rem;
            color: #64748b;
            text-align: center;
            margin-top: 8px;
        }

        /* Login Card */
        .ez-login-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            box-shadow: 0 12px 35px -4px rgba(15, 23, 42, 0.08);
            padding: 32px 30px;
            max-width: 440px;
            margin: 0 auto;
            position: relative;
            z-index: 10;
        }

        .ez-tabs {
            display: flex;
            border-bottom: 1px solid #e2e8f0;
            margin-bottom: 22px;
        }

        .ez-tab-item {
            flex: 1;
            text-align: center;
            padding: 10px 12px;
            font-weight: 600;
            font-size: 0.95rem;
            color: #64748b;
            cursor: pointer;
            border-bottom: 2.5px solid transparent;
            text-decoration: none;
            transition: all 0.2s;
        }

        .ez-tab-item.active {
            color: var(--ez-blue);
            border-bottom-color: var(--ez-blue);
        }

        .ez-input-label {
            font-weight: 600;
            font-size: 0.86rem;
            color: #334155;
            margin-bottom: 6px;
        }

        .ez-form-control {
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 0.95rem;
            transition: border-color 0.2s, box-shadow 0.2s;
            background: #ffffff;
        }

        .ez-form-control:focus {
            border-color: var(--ez-blue);
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.15);
            outline: none;
        }

        .ez-btn-primary {
            background: var(--ez-blue);
            border: none;
            color: #ffffff;
            font-weight: 600;
            font-size: 1rem;
            padding: 12px;
            border-radius: 8px;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(0, 102, 204, 0.25);
        }

        .ez-btn-primary:hover {
            background: var(--ez-blue-hover);
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(0, 102, 204, 0.35);
        }

        /* Bottom 4 Navy KPI Metric Cards */
        .ez-kpi-section {
            padding: 15px 0 50px;
            position: relative;
            z-index: 10;
        }

        .kpi-navy-card {
            background: var(--ez-navy);
            border-radius: 12px;
            padding: 24px 18px;
            color: #ffffff;
            text-align: center;
            box-shadow: 0 10px 24px rgba(23, 59, 117, 0.22);
            transition: transform 0.25s, box-shadow 0.25s;
            height: 100%;
        }

        .kpi-navy-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 28px rgba(23, 59, 117, 0.32);
        }

        .kpi-number {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 2.1rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 4px;
            color: #ffffff;
        }

        .kpi-label {
            font-size: 0.85rem;
            color: #cbd5e1;
            margin-bottom: 0;
            font-weight: 500;
        }

        @media (max-width: 991px) {
            .hero-hire-title {
                font-size: 2.1rem;
            }
            .graphic-stage {
                height: 310px;
            }
            .executive-circle {
                width: 190px;
                height: 190px;
            }
            .orbit-ring {
                width: 270px;
                height: 270px;
            }
            .float-card-left {
                width: 150px;
                top: 80px;
            }
            .kpi-number {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>

    <!-- Background Subtle Wave Art -->
    <div class="bg-wave-art"></div>

    <!-- Top Navigation Header -->
    <header class="ez-navbar">
        <div class="container d-flex align-items-center justify-content-between">
            <a href="<%= request.getContextPath() %>/index.jsp" class="ez-brand">
                <img src="<%= request.getContextPath() %>/images/logo.png" alt="Elevate Workforce Logo" class="ez-brand-logo">
                <span class="fw-bold text-dark fs-5">Elevate</span>
                <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-2 py-1 small">Employer Zone</span>
            </a>

            <div class="d-flex align-items-center gap-2 gap-md-3">
                <a href="<%= request.getContextPath() %>/findajob.jsp" class="ez-nav-link d-none d-md-inline">Job Directory</a>
                <a href="<%= request.getContextPath() %>/contact.jsp" class="ez-nav-link d-none d-sm-inline">Contact Sales</a>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline-primary rounded-pill px-3 py-1 btn-sm fw-semibold">
                    <i class="bi bi-person me-1"></i> Candidate Login
                </a>
                <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-primary rounded-pill px-3 py-1 btn-sm fw-semibold text-white shadow-sm" style="background: #0284c7; border: none;">
                    Register
                </a>
            </div>
        </div>
    </header>

    <!-- Main Hero Stage -->
    <main class="ez-hero-section">
        <div class="container">
            <div class="row align-items-center g-4 g-lg-5">
                
                <!-- Left Column: Visual Illustration & Headline -->
                <div class="col-lg-7">
                    
                    <!-- Circular Graphic with Orbit & Floating Badges -->
                    <div class="graphic-stage">
                        
                        <!-- Concentric Orbit Ring -->
                        <div class="orbit-ring"></div>

                        <!-- Top-Left Tag: Recruit Now -->
                        <div class="float-badge-recruit">
                            <i class="bi bi-sparkles me-1"></i> Recruit Now
                        </div>

                        <!-- Left Floating Feature Card -->
                        <div class="float-card-left">
                            <div class="d-flex align-items-start gap-2 mb-2">
                                <i class="bi bi-briefcase-fill text-primary mt-1"></i>
                                <div>
                                    <strong class="d-block text-dark" style="font-size: 0.74rem;">Post Job</strong>
                                    <span class="text-muted d-block" style="font-size: 0.65rem; line-height: 1.2;">Publish job in easy guided steps.</span>
                                </div>
                            </div>
                            <div class="border-top pt-1 d-flex align-items-start gap-2">
                                <i class="bi bi-lightning-charge-fill text-warning mt-1"></i>
                                <div>
                                    <strong class="d-block text-dark" style="font-size: 0.74rem;">Insta Hire</strong>
                                    <span class="text-muted d-block" style="font-size: 0.65rem; line-height: 1.2;">Ready-to-hire profiles.</span>
                                </div>
                            </div>
                        </div>

                        <!-- Central Confident Executive Portrait -->
                        <img src="../images/employer-executive.jpg" alt="Recruitment Executive" class="executive-circle">

                        <!-- Top-Right Floating Company Card -->
                        <div class="float-card-right-top">
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span class="badge bg-dark rounded-circle p-1" style="width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center;">
                                    <i class="bi bi-building text-white" style="font-size: 0.6rem;"></i>
                                </span>
                                <strong class="text-dark" style="font-size: 0.74rem;">Trade Nexus Inc.</strong>
                                <i class="bi bi-chevron-down text-muted small ms-1"></i>
                            </div>
                            <div class="text-primary small" style="font-size: 0.68rem; line-height: 1.3;">
                                <div>&bull; Chief Executive</div>
                                <div>&bull; Marketing Officer</div>
                            </div>
                        </div>

                        <!-- Right Cyan Stat Badge -->
                        <div class="float-badge-cyan">
                            <div class="fw-bold fs-5 mb-0"><%= liveUsers > 0 ? (liveUsers * 1000 + "+") : "1M+" %></div>
                            <span style="font-size: 0.66rem; font-weight: 600;">Registered Jobseeker</span>
                        </div>

                    </div>

                    <!-- Main Hero Typography -->
                    <h1 class="hero-hire-title">
                        Hire the <span class="highlight">Best Fit</span>
                    </h1>
                    <p class="hero-hire-subtitle">
                        Make hiring faster & effortless with Elevate AI. <span style="color: #6366f1;">✨</span>
                    </p>

                </div>

                <!-- Right Column: Employer / Admin Login Card -->
                <div class="col-lg-5">
                    <div class="ez-login-card">
                        
                        <!-- Top Tabs: Employer Login / Talk to Sales -->
                        <div class="ez-tabs">
                            <div class="ez-tab-item active" id="tabEmployerLogin" onclick="switchLoginTab('login')">
                                Employer Login
                            </div>
                            <div class="ez-tab-item" id="tabTalkToSales" onclick="switchLoginTab('sales')">
                                Talk to Sales
                            </div>
                        </div>

                        <!-- Feedback Alerts -->
                        <%
                            String msg = request.getParameter("msg");
                            String err = request.getParameter("error");
                            String errorAttr = (String) request.getAttribute("errorMessage");
                            if (msg != null && !msg.isBlank()) {
                        %>
                            <div class="alert alert-success alert-dismissible fade show rounded-3 small py-2 mb-3" role="alert">
                                <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
                                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                            </div>
                        <% } else if (err != null && !err.isBlank()) { %>
                            <div class="alert alert-danger alert-dismissible fade show rounded-3 small py-2 mb-3" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i> <%= err %>
                                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                            </div>
                        <% } else if (errorAttr != null && !errorAttr.isBlank()) { %>
                            <div class="alert alert-danger alert-dismissible fade show rounded-3 small py-2 mb-3" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i> <%= errorAttr %>
                                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                            </div>
                        <% } %>

                        <!-- Login Form View -->
                        <div id="loginFormSection">
                            <p class="text-muted small mb-3">Login with your registered Email & Password</p>

                            <form id="adminLoginForm" action="<%= request.getContextPath() %>/doAdminLogin" method="post">
                                <div class="mb-3">
                                    <label class="ez-input-label">Email / Username</label>
                                    <input type="text" class="form-control ez-form-control" name="username" placeholder="Enter email address or username" required autofocus>
                                </div>

                                <div class="mb-3">
                                    <label class="ez-input-label">Password</label>
                                    <div class="position-relative">
                                        <input type="password" id="adminPassword" class="form-control ez-form-control pe-5" name="password" placeholder="Enter your Password" required>
                                        <button type="button" id="togglePasswordBtn" class="btn position-absolute top-50 end-0 translate-middle-y text-muted pe-3 border-0 bg-transparent" title="Show/Hide Password">
                                            <i id="togglePasswordIcon" class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div class="form-check">
                                         <input class="form-check-input" type="checkbox" id="rememberMe">
                                        <label class="form-check-label small text-muted" for="rememberMe">
                                            Remember Me
                                        </label>
                                    </div>
                                    <a href="#" onclick="alert('Please contact System Administrator or support team at 9761819137 for password reset.'); return false;" class="small text-muted text-decoration-none">Forgot Password?</a>
                                </div>

                                <div class="d-grid mb-3">
                                    <button id="loginSubmitBtn" type="submit" class="btn ez-btn-primary">
                                        <span id="btnText">Login</span>
                                        <span id="btnSpinner" class="spinner-border spinner-border-sm d-none" role="status"></span>
                                    </button>
                                </div>

                                <div class="text-center small text-muted">
                                    Don't have an account? <a href="<%= request.getContextPath() %>/register.jsp" class="fw-bold text-decoration-none" style="color: var(--ez-blue);">Register Now</a>
                                </div>
                            </form>
                        </div>

                        <!-- Talk to Sales View (Toggled via tab) -->
                        <div id="salesSection" class="d-none">
                            <p class="text-muted small mb-3">Connect directly with our Enterprise Solutions advisors:</p>

                            <div class="p-3 bg-light rounded-3 mb-3 border">
                                <div class="d-flex align-items-center gap-3 mb-3">
                                    <div class="p-2 bg-success-subtle text-success rounded-circle">
                                        <i class="bi bi-whatsapp fs-4"></i>
                                    </div>
                                    <div>
                                        <strong class="d-block text-dark">Instant WhatsApp Chat</strong>
                                        <a href="https://wa.me/9779761819137?text=Hello%20Elevate%20Workforce%20Team,%20I%20am%20an%20employer%20interested%20in%20recruitment%20solutions." target="_blank" class="text-success text-decoration-none fw-semibold small">
                                            +977 9761819137 &rarr;
                                        </a>
                                    </div>
                                </div>

                                <div class="d-flex align-items-center gap-3">
                                    <div class="p-2 bg-primary-subtle text-primary rounded-circle">
                                        <i class="bi bi-telephone fs-4"></i>
                                    </div>
                                    <div>
                                        <strong class="d-block text-dark">Corporate Direct Line</strong>
                                        <a href="tel:9761819137" class="text-primary text-decoration-none fw-semibold small">
                                            +977 9761819137
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid">
                                <button type="button" onclick="switchLoginTab('login')" class="btn btn-outline-secondary rounded-pill btn-sm">
                                    &larr; Back to Login Form
                                </button>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </main>

    <!-- Bottom 4 Navy KPI Metric Cards -->
    <section class="ez-kpi-section">
        <div class="container">
            <div class="row g-3 g-lg-4">
                
                <!-- Metric 1: Registered Jobseekers -->
                <div class="col-lg-3 col-6">
                    <div class="kpi-navy-card">
                        <div class="kpi-number">1M+</div>
                        <p class="kpi-label">Registered Jobseekers</p>
                    </div>
                </div>

                <!-- Metric 2: Registered Employers -->
                <div class="col-lg-3 col-6">
                    <div class="kpi-navy-card">
                        <div class="kpi-number">40K+</div>
                        <p class="kpi-label">Registered Employers</p>
                    </div>
                </div>

                <!-- Metric 3: Monthly Visits -->
                <div class="col-lg-3 col-6">
                    <div class="kpi-navy-card">
                        <div class="kpi-number">4.1M+</div>
                        <p class="kpi-label">Monthly Visits</p>
                    </div>
                </div>

                <!-- Metric 4: Success Stories -->
                <div class="col-lg-3 col-6">
                    <div class="kpi-navy-card">
                        <div class="kpi-number">500K+</div>
                        <p class="kpi-label">Success Stories</p>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password Visibility Toggle
        const toggleBtn = document.getElementById('togglePasswordBtn');
        const pwdInput = document.getElementById('adminPassword');
        const pwdIcon = document.getElementById('togglePasswordIcon');

        if (toggleBtn && pwdInput) {
            toggleBtn.addEventListener('click', () => {
                const isPassword = pwdInput.getAttribute('type') === 'password';
                pwdInput.setAttribute('type', isPassword ? 'text' : 'password');
                pwdIcon.classList.toggle('bi-eye', !isPassword);
                pwdIcon.classList.toggle('bi-eye-slash', isPassword);
            });
        }

        // Form Submit Spinner
        const loginForm = document.getElementById('adminLoginForm');
        const submitBtn = document.getElementById('loginSubmitBtn');
        const btnText = document.getElementById('btnText');
        const btnSpinner = document.getElementById('btnSpinner');

        if (loginForm && submitBtn) {
            loginForm.addEventListener('submit', () => {
                submitBtn.disabled = true;
                btnText.textContent = 'Authenticating...';
                btnSpinner.classList.remove('d-none');
            });
        }

        // Switch between Employer Login and Talk to Sales tabs
        function switchLoginTab(tab) {
            const tabLogin = document.getElementById('tabEmployerLogin');
            const tabSales = document.getElementById('tabTalkToSales');
            const loginSection = document.getElementById('loginFormSection');
            const salesSection = document.getElementById('salesSection');

            if (tab === 'sales') {
                tabLogin.classList.remove('active');
                tabSales.classList.add('active');
                loginSection.classList.add('d-none');
                salesSection.classList.remove('d-none');
            } else {
                tabSales.classList.remove('active');
                tabLogin.classList.add('active');
                salesSection.classList.add('d-none');
                loginSection.classList.remove('d-none');
            }
        }
    </script>
</body>
</html>