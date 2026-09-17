<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Elevate Workforce Solutions | Connecting Talent Across Nepal</title>
    <meta name="description" content="Nepal's premier workforce and job portal. Find verified jobs in IT, Marketing, Finance, Design, and more across Kathmandu, Pokhara, and Lalitpur.">
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Modern Design System Stylesheet -->
    <link rel="stylesheet" href="modern-style.css">
</head>
<body>

    <!-- Header Navigation -->
    <jsp:include page="header.jsp" />

    <!-- ==========================================================================
         Hero Section with Background Image, Gradient Overlay & Parallax Feel
         ========================================================================== -->
    <section class="hero-section">
        <div class="hero-overlay"></div>
        <div class="hero-glow-1"></div>
        <div class="hero-glow-2"></div>

        <!-- Floating Stat Badges for Desktop -->
        <div class="floating-stat-badge badge-top-left">
            <div class="user-avatar-badge" style="background: var(--success); width: 36px; height: 36px; font-size: 1.1rem;">
                <i class="bi bi-briefcase-fill"></i>
            </div>
            <div>
                <div class="fw-bold fs-6">5,000+ Active Jobs</div>
                <small class="text-slate-300">Verified Companies</small>
            </div>
        </div>

        <div class="floating-stat-badge badge-bottom-right">
            <div class="user-avatar-badge" style="background: var(--accent); width: 36px; height: 36px; font-size: 1.1rem;">
                <i class="bi bi-star-fill"></i>
            </div>
            <div>
                <div class="fw-bold fs-6">99.2% Match Rate</div>
                <small class="text-slate-300">Top-Tier Placements</small>
            </div>
        </div>

        <div class="container hero-content text-center">
            <!-- Pill Tag -->
            <div class="reveal-item">
                <span class="hero-pill-tag">
                    <span class="pill-pulse"></span>
                    <span>Nepal's #1 Trusted Employment Network</span>
                </span>
            </div>

            <!-- Main Heading -->
            <h1 class="hero-title reveal-item">
                Connecting Exceptional Talent with <br class="d-none d-md-inline">
                <span class="text-gradient">Extraordinary Opportunities</span>
            </h1>

            <!-- Subtitle -->
            <p class="hero-subtitle reveal-item">
                Elevate Workforce Solutions bridges the gap between ambitious professionals and visionary companies across Nepal. Find verified jobs, transparent salaries, and advance your career today.
            </p>

            <!-- Action Buttons -->
            <div class="hero-btn-group reveal-item">
                <a href="findajob.jsp" class="btn btn-primary-modern">
                    <i class="bi bi-search"></i> Explore All Jobs
                </a>
                <a href="register.jsp" class="btn btn-secondary-modern">
                    <i class="bi bi-person-plus"></i> Join as Candidate
                </a>
            </div>

            <!-- Quick Search Card -->
            <div class="hero-search-card reveal-item text-start">
                <form action="findajob.jsp" method="get">
                    <div class="row g-3 align-items-center">
                        <div class="col-lg-5 col-md-12">
                            <label class="form-label small fw-bold text-slate-600 mb-1">
                                <i class="bi bi-search text-primary me-1"></i> Job Title or Keywords
                            </label>
                            <input type="text" class="form-control" name="search" placeholder="e.g. Software Engineer, Designer, Manager...">
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label small fw-bold text-slate-600 mb-1">
                                <i class="bi bi-grid text-primary me-1"></i> Category
                            </label>
                            <select name="category" class="form-select">
                                <option value="">All Categories</option>
                                <option value="IT">IT & Software</option>
                                <option value="Marketing">Marketing & Growth</option>
                                <option value="Finance">Finance & Accounting</option>
                                <option value="Design">UI/UX & Design</option>
                            </select>
                        </div>
                        <div class="col-lg-2 col-md-6">
                            <label class="form-label small fw-bold text-slate-600 mb-1">
                                <i class="bi bi-geo-alt text-primary me-1"></i> Location
                            </label>
                            <select name="location" class="form-select">
                                <option value="">Anywhere</option>
                                <option value="Kathmandu">Kathmandu</option>
                                <option value="Pokhara">Pokhara</option>
                                <option value="Lalitpur">Lalitpur</option>
                            </select>
                        </div>
                        <div class="col-lg-2 col-md-12 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100 search-btn">
                                <i class="bi bi-arrow-right-circle-fill"></i> Search
                            </button>
                        </div>
                    </div>
                </form>
            </div>

        </div>
    </section>

    <!-- ==========================================================================
         Top Employers Running Marquee Ticker
         ========================================================================== -->
    <jsp:include page="top-employers-ticker.jsp" />

    <!-- ==========================================================================
         Key Features Section
         ========================================================================== -->
    <section class="section-padding bg-white">
        <div class="container">
            <div class="section-header reveal-item">
                <span class="section-tag">Platform Features</span>
                <h2 class="section-title">Built for Faster, Smarter Hiring</h2>
                <p class="section-description">Everything you need to discover verified roles, submit clean applications, and elevate your career trajectory.</p>
            </div>

            <div class="row g-4">
                <!-- Feature 1 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="modern-card">
                        <div class="icon-box icon-box-primary">
                            <i class="bi bi-patch-check-fill"></i>
                        </div>
                        <h4>100% Verified Listings</h4>
                        <p>Every job posted on Elevate is vetted and authentic. Say goodbye to spam listings, outdated roles, and ghost recruiters.</p>
                    </div>
                </div>

                <!-- Feature 2 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="modern-card">
                        <div class="icon-box icon-box-accent">
                            <i class="bi bi-lightning-fill"></i>
                        </div>
                        <h4>1-Click Quick Apply</h4>
                        <p>Store your updated resume and professional profile securely to apply for multiple high-paying roles in just a single click.</p>
                    </div>
                </div>

                <!-- Feature 3 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="modern-card">
                        <div class="icon-box icon-box-success">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                        <h4>Transparent Salary Insights</h4>
                        <p>Clear compensation figures provided upfront in NPR. Know your market value and filter jobs based on your expected salary.</p>
                    </div>
                </div>

                <!-- Feature 4 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="modern-card">
                        <div class="icon-box icon-box-warning">
                            <i class="bi bi-kanban-fill"></i>
                        </div>
                        <h4>Real-Time Application Tracking</h4>
                        <p>Never wonder about your status again. Monitor each application in real time—from Pending to Shortlisted or Hired.</p>
                    </div>
                </div>

                <!-- Feature 5 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="modern-card">
                        <div class="icon-box icon-box-primary">
                            <i class="bi bi-funnel-fill"></i>
                        </div>
                        <h4>Multi-Parameter Filtering</h4>
                        <p>Pinpoint the exact role for you with intelligent filters: Job Category, Location, Employment Type, and Maximum Salary.</p>
                    </div>
                </div>

                <!-- Feature 6 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="modern-card">
                        <div class="icon-box icon-box-accent">
                            <i class="bi bi-shield-lock-fill"></i>
                        </div>
                        <h4>Enterprise Privacy & Security</h4>
                        <p>Your personal data and uploaded resumes are safeguarded with industry-standard session management and data protection.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==========================================================================
         Popular Categories / Skills Section
         ========================================================================== -->
    <section class="section-padding bg-light">
        <div class="container">
            <div class="section-header reveal-item">
                <span class="section-tag">Explore Opportunities</span>
                <h2 class="section-title">Browse by In-Demand Categories</h2>
                <p class="section-description">Discover high-growth career openings categorized across top industry domains.</p>
            </div>

            <div class="row g-4">
                <div class="col-lg-4 col-md-6 reveal-item">
                    <a href="findajob.jsp?category=IT" class="category-card">
                        <div class="category-icon">
                            <i class="bi bi-code-slash"></i>
                        </div>
                        <div class="category-info">
                            <h5>IT & Software Development</h5>
                            <span>Full-Stack, Cloud, Mobile, QA</span>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 reveal-item">
                    <a href="findajob.jsp?category=Marketing" class="category-card">
                        <div class="category-icon">
                            <i class="bi bi-graph-up-arrow"></i>
                        </div>
                        <div class="category-info">
                            <h5>Marketing & Growth</h5>
                            <span>SEO, Social Media, Content, Ads</span>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 reveal-item">
                    <a href="findajob.jsp?category=Finance" class="category-card">
                        <div class="category-icon">
                            <i class="bi bi-wallet2"></i>
                        </div>
                        <div class="category-info">
                            <h5>Finance & Banking</h5>
                            <span>Accounting, Auditing, Analysis</span>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 reveal-item">
                    <a href="findajob.jsp?category=Design" class="category-card">
                        <div class="category-icon">
                            <i class="bi bi-bezier2"></i>
                        </div>
                        <div class="category-info">
                            <h5>UI/UX & Creative Design</h5>
                            <span>Product Design, Figma, Branding</span>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 reveal-item">
                    <a href="findajob.jsp?type=Remote" class="category-card">
                        <div class="category-icon">
                            <i class="bi bi-laptop"></i>
                        </div>
                        <div class="category-info">
                            <h5>Remote & Hybrid Roles</h5>
                            <span>Work from Anywhere in Nepal</span>
                        </div>
                    </a>
                </div>

                <div class="col-lg-4 col-md-6 reveal-item">
                    <a href="findajob.jsp?type=Full-Time" class="category-card">
                        <div class="category-icon">
                            <i class="bi bi-briefcase"></i>
                        </div>
                        <div class="category-info">
                            <h5>Full-Time Corporate Roles</h5>
                            <span>Permanent Careers with Benefits</span>
                        </div>
                    </a>
                </div>
            </div>

            <div class="text-center mt-5 reveal-item">
                <a href="findajob.jsp" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-semibold">
                    View All Categories <i class="bi bi-arrow-right ms-1"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- ==========================================================================
         About Us Section
         ========================================================================== -->
    <section class="section-padding bg-white">
        <div class="container">
            <div class="row align-items-center g-5">
                
                <!-- Left Visual with Floating Experience Badge -->
                <div class="col-lg-6 reveal-item">
                    <div class="about-visual-wrapper pe-lg-4">
                        <img src="images/about-team.jpg" alt="Elevate Workforce Team Collaboration" class="about-img-main">
                        <div class="about-floating-card">
                            <div class="badge-icon">
                                <i class="bi bi-trophy-fill"></i>
                            </div>
                            <div>
                                <h6 class="fw-bold mb-1">Decade of Excellence</h6>
                                <p class="small text-slate-500 mb-0">Empowering Nepal's workforce</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Content -->
                <div class="col-lg-6 reveal-item">
                    <span class="section-tag">About Elevate</span>
                    <h2 class="section-title">Pioneering the Future of Employment in Nepal</h2>
                    <p class="text-slate-600 mt-3">
                        Elevate Workforce Solutions is Nepal's leading human capital and employment acceleration platform. 
                        We specialize in connecting ambitious, highly skilled individuals with reputable companies across diverse industries.
                    </p>
                    <p class="text-slate-600">
                        Through modern digital transformation and intuitive user workflows, we bridge the gap between corporate hiring demands and aspiring professionals seeking fulfilling careers.
                    </p>

                    <!-- Feature Checkmarks -->
                    <ul class="about-feature-list">
                        <li>
                            <i class="bi bi-check-circle-fill"></i>
                            <span><strong>Inclusive Opportunities:</strong> Dedicated to equal-opportunity employment across Kathmandu, Pokhara, and rural hubs.</span>
                        </li>
                        <li>
                            <i class="bi bi-check-circle-fill"></i>
                            <span><strong>Direct Recruiter Reach:</strong> Cut out third-party middleman delays with verified direct employer listings.</span>
                        </li>
                        <li>
                            <i class="bi bi-check-circle-fill"></i>
                            <span><strong>Career Advancement:</strong> Comprehensive tools for resume storage, job tracking, and professional growth.</span>
                        </li>
                    </ul>

                    <div class="d-flex align-items-center gap-3">
                        <a href="contact.jsp" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold">
                            Get in Touch <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                        <a href="findajob.jsp" class="btn btn-outline-secondary rounded-pill px-4 py-2 fw-semibold">
                            Browse Jobs
                        </a>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <!-- ==========================================================================
         Live Statistics Section with Animated Counters
         ========================================================================== -->
    <section class="section-padding stats-section">
        <div class="container">
            <div class="section-header text-center mb-5 reveal-item">
                <span class="section-tag" style="background: rgba(37, 99, 235, 0.25); color: #93c5fd;">Our Track Record</span>
                <h2 class="section-title text-white">Proven Impact Across Nepal's Job Market</h2>
                <p class="section-description" style="color: #94a3b8;">Real numbers representing our commitment to empowering both job seekers and hiring companies.</p>
            </div>

            <div class="row g-4">
                <div class="col-lg-3 col-6 reveal-item">
                    <div class="stat-item-card">
                        <div class="stat-number" data-counter="5200" data-suffix="+">0</div>
                        <p class="stat-label">Jobs Posted</p>
                    </div>
                </div>
                <div class="col-lg-3 col-6 reveal-item">
                    <div class="stat-item-card">
                        <div class="stat-number" data-counter="18500" data-suffix="+">0</div>
                        <p class="stat-label">Candidates Registered</p>
                    </div>
                </div>
                <div class="col-lg-3 col-6 reveal-item">
                    <div class="stat-item-card">
                        <div class="stat-number" data-counter="850" data-suffix="+">0</div>
                        <p class="stat-label">Partner Employers</p>
                    </div>
                </div>
                <div class="col-lg-3 col-6 reveal-item">
                    <div class="stat-item-card">
                        <div class="stat-number" data-counter="99.2" data-suffix="%" data-decimal="true">0</div>
                        <p class="stat-label">Satisfaction Rate</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==========================================================================
         How It Works (3-Step Guide)
         ========================================================================== -->
    <section class="section-padding bg-light">
        <div class="container">
            <div class="section-header reveal-item">
                <span class="section-tag">Simple Process</span>
                <h2 class="section-title">How It Works for Candidates</h2>
                <p class="section-description">Take 3 simple steps to find and secure your next role on Elevate Workforce Solutions.</p>
            </div>

            <div class="row g-4">
                <div class="col-md-4 reveal-item">
                    <div class="step-card">
                        <div class="step-number">1</div>
                        <h4>Create Your Account</h4>
                        <p>Register in less than a minute. Complete your profile details and upload your PDF/DOCX resume for recruiters.</p>
                    </div>
                </div>
                <div class="col-md-4 reveal-item">
                    <div class="step-card">
                        <div class="step-number">2</div>
                        <h4>Discover & Filter Roles</h4>
                        <p>Search through thousands of live openings. Filter by industry category, salary benchmark, and city location.</p>
                    </div>
                </div>
                <div class="col-md-4 reveal-item">
                    <div class="step-card">
                        <div class="step-number">3</div>
                        <h4>Apply & Track Progress</h4>
                        <p>Submit applications with a single click and monitor your review status straight from your personal dashboard.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==========================================================================
         Testimonials Section
         ========================================================================== -->
    <section class="section-padding bg-white">
        <div class="container">
            <div class="section-header reveal-item">
                <span class="section-tag">Success Stories</span>
                <h2 class="section-title">What Our Candidates & Employers Say</h2>
                <p class="section-description">Hear directly from the professionals and hiring managers who found their match through Elevate.</p>
            </div>

            <div class="row g-4">
                <!-- Testimonial 1 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="testimonial-card">
                        <div>
                            <div class="testimonial-rating">
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                            </div>
                            <p class="testimonial-quote">
                                "Within two weeks of uploading my resume on Elevate, I landed a Senior Software Engineer position with a top tech firm in Kathmandu. The transparency in salary was refreshing!"
                            </p>
                        </div>
                        <div class="testimonial-user">
                            <div class="testimonial-avatar">A</div>
                            <div class="testimonial-info">
                                <h6>Aayush Shrestha</h6>
                                <p>Full-Stack Developer, Kathmandu</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Testimonial 2 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="testimonial-card">
                        <div>
                            <div class="testimonial-rating">
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                            </div>
                            <p class="testimonial-quote">
                                "Elevate transformed our recruitment pipeline. We hired 4 qualified marketing specialists in one month. The candidate profiles were verified and perfectly aligned with our needs."
                            </p>
                        </div>
                        <div class="testimonial-user">
                            <div class="testimonial-avatar" style="background: linear-gradient(135deg, #10b981, #06b6d4);">P</div>
                            <div class="testimonial-info">
                                <h6>Pooja Thapa</h6>
                                <p>HR Director, Himalayan Media</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Testimonial 3 -->
                <div class="col-lg-4 col-md-6 reveal-item">
                    <div class="testimonial-card">
                        <div>
                            <div class="testimonial-rating">
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                                <i class="bi bi-star-fill"></i>
                            </div>
                            <p class="testimonial-quote">
                                "The application tracking dashboard is super clean and easy to use. I loved receiving clear updates on my application status instead of being left in the dark."
                            </p>
                        </div>
                        <div class="testimonial-user">
                            <div class="testimonial-avatar" style="background: linear-gradient(135deg, #8b5cf6, #ec4899);">R</div>
                            <div class="testimonial-info">
                                <h6>Rohan Regmi</h6>
                                <p>Product Designer, Pokhara</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ==========================================================================
         Call to Action (CTA) Section
         ========================================================================== -->
    <section class="container my-5 reveal-item">
        <div class="cta-section">
            <h2 class="cta-title">Ready to Elevate Your Professional Career?</h2>
            <p class="cta-subtitle">
                Join over 18,000 ambitious professionals who have accelerated their career through Elevate Workforce Solutions.
            </p>
            <div class="d-flex flex-wrap justify-content-center gap-3">
                <a href="findajob.jsp" class="btn btn-light text-primary fw-bold px-4 py-3 rounded-pill shadow">
                    <i class="bi bi-briefcase-fill me-1"></i> Browse Open Positions
                </a>
                <a href="register.jsp" class="btn btn-outline-light fw-bold px-4 py-3 rounded-pill">
                    <i class="bi bi-person-plus-fill me-1"></i> Create Free Account
                </a>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />

    <!-- Bootstrap 5.3.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>