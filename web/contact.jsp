<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Contact Us - Elevate Workforce Solutions</title>
    <meta name="description" content="Get in touch with Elevate Workforce Solutions. We are here to support job seekers and employers across Nepal.">
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Modern Design System Stylesheet -->
    <link rel="stylesheet" href="modern-style.css">
</head>
<body class="bg-light">

    <!-- Include Header -->
    <jsp:include page="header.jsp" />

    <!-- Page Header Banner -->
    <div class="bg-white border-bottom py-5">
        <div class="container text-center">
            <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-2 mb-2">
                <i class="bi bi-chat-dots-fill me-1"></i> We're Here to Help
            </span>
            <h1 class="fw-bold text-slate-900 mb-2">Let's Start a Conversation</h1>
            <p class="text-slate-500 max-w-lg mx-auto mb-0" style="max-width: 600px;">
                Whether you're looking for career opportunities, seeking to recruit top-tier talent, or have inquiries about our platform, our team is ready to assist you.
            </p>
        </div>
    </div>

    <!-- Contact Section -->
    <div class="container my-5">
        
        <%
            String contactMsg = request.getParameter("msg");
            if (contactMsg != null && !contactMsg.isBlank()) {
        %>
            <div class="alert alert-success alert-dismissible fade show text-center rounded-4 shadow-sm mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i><strong>Thank you!</strong> <%= contactMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="row g-4 justify-content-center">
            
            <!-- Left: Contact Details Card -->
            <div class="col-lg-5 col-md-6">
                <div class="card border-0 shadow-sm rounded-4 p-4 p-lg-5 bg-white h-100">
                    <h3 class="fw-bold text-slate-900 mb-4">Contact Information</h3>
                    <p class="text-slate-600 mb-4">
                        Reach out directly through any of our channels or visit our headquarters in Kathmandu.
                    </p>

                    <div class="d-flex align-items-start gap-3 mb-4">
                        <div class="icon-box icon-box-primary flex-shrink-0" style="width: 48px; height: 48px; font-size: 1.25rem;">
                            <i class="bi bi-geo-alt-fill"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1 text-slate-900">Head Office</h6>
                            <p class="text-slate-500 mb-0 small">Kathmandu, Bagmati Province, Nepal</p>
                        </div>
                    </div>

                    <div class="d-flex align-items-start gap-3 mb-4">
                        <div class="icon-box icon-box-accent flex-shrink-0" style="width: 48px; height: 48px; font-size: 1.25rem;">
                            <i class="bi bi-envelope-fill"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1 text-slate-900">Email Address</h6>
                            <p class="mb-0 small"><a href="mailto:shahomprakash2004@gmail.com" class="text-primary text-decoration-none">shahomprakash2004@gmail.com</a></p>
                        </div>
                    </div>

                    <div class="d-flex align-items-start gap-3 mb-4">
                        <div class="icon-box icon-box-success flex-shrink-0" style="width: 48px; height: 48px; font-size: 1.25rem;">
                            <i class="bi bi-telephone-fill"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1 text-slate-900">Direct Phone</h6>
                            <p class="mb-0 small"><a href="tel:9761819137" class="text-slate-700 text-decoration-none">+977 9761819137</a></p>
                        </div>
                    </div>

                    <div class="d-flex align-items-start gap-3 mb-4">
                        <div class="icon-box flex-shrink-0" style="width: 48px; height: 48px; font-size: 1.3rem; background: rgba(37, 211, 102, 0.15); color: #25D366; border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                            <i class="bi bi-whatsapp"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1 text-slate-900">Connect with WhatsApp</h6>
                            <p class="mb-1 small"><a href="https://wa.me/9779761819137?text=Hello%20Elevate%20Workforce,%20I%20have%20an%20inquiry" target="_blank" rel="noopener noreferrer" class="text-success text-decoration-none fw-semibold">+977 9761819137</a></p>
                            <a href="https://wa.me/9779761819137?text=Hello%20Elevate%20Workforce,%20I%20have%20an%20inquiry" target="_blank" rel="noopener noreferrer" class="btn btn-sm btn-success rounded-pill px-3 py-1 fw-semibold shadow-sm">
                                <i class="bi bi-whatsapp me-1"></i> Start WhatsApp Chat
                            </a>
                        </div>
                    </div>

                    <div class="d-flex align-items-start gap-3 mb-4">
                        <div class="icon-box icon-box-warning flex-shrink-0" style="width: 48px; height: 48px; font-size: 1.25rem;">
                            <i class="bi bi-clock-fill"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1 text-slate-900">Support Hours</h6>
                            <p class="text-slate-500 mb-0 small">Sunday - Friday: 9:00 AM – 6:00 PM NPT</p>
                        </div>
                    </div>

                    <hr class="my-4 text-slate-200">

                    <h6 class="fw-bold text-slate-900 mb-3">Follow Our Channels</h6>
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <a href="https://wa.me/9779761819137?text=Hello%20Elevate%20Workforce,%20I%20have%20an%20inquiry" target="_blank" rel="noopener noreferrer" class="btn btn-outline-success rounded-pill btn-sm px-3">
                            <i class="bi bi-whatsapp me-1"></i> WhatsApp
                        </a>
                        <a href="https://www.linkedin.com/in/omprakash077?utm_source=share_via&utm_content=profile&utm_medium=member_ios" target="_blank" class="btn btn-outline-primary rounded-pill btn-sm px-3">
                            <i class="bi bi-linkedin me-1"></i> LinkedIn
                        </a>
                        <a href="https://www.facebook.com/share/1E3QEKNVUz/?mibextid=wwXIfr" target="_blank" class="btn btn-outline-primary rounded-pill btn-sm px-3">
                            <i class="bi bi-facebook me-1"></i> Facebook
                        </a>
                        <a href="https://www.instagram.com/shah_omey07?stkn=MTgweWZzYTFjbHFwNQ%3D%3D&utm_source=qr" target="_blank" class="btn btn-outline-primary rounded-pill btn-sm px-3">
                            <i class="bi bi-instagram me-1"></i> Instagram
                        </a>
                    </div>
                </div>
            </div>

            <!-- Right: Contact Form -->
            <div class="col-lg-7 col-md-6">
                <div class="card border-0 shadow-sm rounded-4 p-4 p-lg-5 bg-white h-100">
                    <h3 class="fw-bold text-slate-900 mb-1">Send Us a Message</h3>
                    <p class="text-slate-500 mb-4 small">Fill out the details below and a member of our team will respond within 24 hours.</p>

                    <form method="post" action="ContactController">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="name" class="form-label small fw-bold text-slate-700">Your Full Name <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" id="name" name="name" placeholder="John Doe" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label small fw-bold text-slate-700">Email Address <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                                    <input type="email" class="form-control" id="email" name="email" placeholder="john@example.com" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label for="phone" class="form-label small fw-bold text-slate-700">Phone Number</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light text-muted"><i class="bi bi-telephone"></i></span>
                                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="+977 98XXXXXXXX">
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-slate-700">Preferred Contact Method <span class="text-danger">*</span></label>
                                <select class="form-select" name="contactMethod" required>
                                    <option value="">Select an option</option>
                                    <option value="email">Email</option>
                                    <option value="phone">Phone Call</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label for="message" class="form-label small fw-bold text-slate-700">Your Message <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="message" name="message" rows="5" placeholder="How can we help you?" required></textarea>
                            </div>

                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-primary rounded-pill px-4 py-3 fw-semibold shadow-sm w-100">
                                    <i class="bi bi-send-fill me-2"></i> Submit Inquiry
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

        </div>

        <!-- FAQ / Why Choose Section -->
        <div class="mt-5 pt-4 text-center">
            <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-2 mb-2">Our Commitment</span>
            <h3 class="fw-bold text-slate-900 mb-4">Why Trust Elevate Workforce Solutions?</h3>
            <div class="row g-4 text-start">
                <div class="col-md-4">
                    <div class="modern-card p-4">
                        <i class="bi bi-shield-check fs-2 text-primary mb-3"></i>
                        <h5>Verified Recruiters</h5>
                        <p class="small text-slate-600">Every corporate profile is verified to prevent fraudulent recruitment activities.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="modern-card p-4">
                        <i class="bi bi-speedometer2 fs-2 text-success mb-3"></i>
                        <h5>Rapid Response Time</h5>
                        <p class="small text-slate-600">Our dedicated support desk addresses user queries within 24 business hours.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="modern-card p-4">
                        <i class="bi bi-lock-fill fs-2 text-info mb-3"></i>
                        <h5>Privacy Guaranteed</h5>
                        <p class="small text-slate-600">Your contact data is securely stored and never shared with unauthorized parties.</p>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>