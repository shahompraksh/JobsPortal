/**
 * Elevate Workforce Solutions - Interactive Client-Side Portal Engine
 * Powers search, filtering, application management, and session simulation
 */

(function () {
    'use strict';

    // ── INITIALIZE STORAGE ──────────────────────────────────────
    const DEFAULT_APPLICATIONS = [
        {
            id: 101,
            jobId: 2,
            jobTitle: "Senior UI/UX Designer",
            company: "Nepal IT Solution",
            location: "Pokhara",
            salary: 50000,
            type: "Full-time",
            appliedDate: "Sep 16, 2026",
            status: "Shortlisted"
        },
        {
            id: 102,
            jobId: 9,
            jobTitle: "Data Integration Specialist (Bipad Portal)",
            company: "Sajag Nepal Project",
            location: "Kathmandu",
            salary: 85000,
            type: "Remote",
            appliedDate: "Sep 17, 2026",
            status: "Pending"
        },
        {
            id: 103,
            jobId: 18,
            jobTitle: "Operations Manager",
            company: "International Federation of Red Cross (IFRC)",
            location: "Kathmandu",
            salary: 110000,
            type: "Full-time",
            appliedDate: "Sep 10, 2026",
            status: "Hired"
        }
    ];

    function getApplications() {
        try {
            const stored = localStorage.getItem('elevate_applications');
            if (stored) return JSON.parse(stored);
            localStorage.setItem('elevate_applications', JSON.stringify(DEFAULT_APPLICATIONS));
            return DEFAULT_APPLICATIONS;
        } catch (e) {
            return DEFAULT_APPLICATIONS;
        }
    }

    function saveApplications(apps) {
        try {
            localStorage.setItem('elevate_applications', JSON.stringify(apps));
        } catch (e) {}
    }

    function getCurrentUser() {
        try {
            const u = localStorage.getItem('elevate_user');
            return u ? JSON.parse(u) : null;
        } catch (e) {
            return null;
        }
    }

    function setCurrentUser(user) {
        try {
            if (user) {
                localStorage.setItem('elevate_user', JSON.stringify(user));
            } else {
                localStorage.removeItem('elevate_user');
            }
        } catch (e) {}
    }

    // ── NAVBAR USER STATE SYNC ─────────────────────────────────
    function syncNavbarUserState() {
        const authContainer = document.getElementById('navbarAuthContainer');
        if (!authContainer) return;

        const user = getCurrentUser();
        if (user) {
            const initial = (user.username || 'U').charAt(0).toUpperCase();
            authContainer.innerHTML = `
                <div class="dropdown">
                    <button class="btn user-dropdown-btn dropdown-toggle d-flex align-items-center gap-2" type="button" id="userMenuBtn" data-bs-toggle="dropdown" aria-expanded="false">
                        <span class="user-avatar-badge">${initial}</span>
                        <span class="d-inline-block text-truncate fw-semibold" style="max-width: 120px;">${escapeHtml(user.username)}</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3 mt-2" aria-labelledby="userMenuBtn">
                        <li class="px-3 py-2 border-bottom mb-1">
                            <small class="text-muted d-block">Signed in as</small>
                            <strong class="text-dark">${escapeHtml(user.username)}</strong>
                        </li>
                        <li><a class="dropdown-item py-2" href="userdashboard.html"><i class="bi bi-grid-1x2 text-primary me-2"></i>Dashboard</a></li>
                        <li><a class="dropdown-item py-2" href="applications.html"><i class="bi bi-file-earmark-text text-success me-2"></i>My Applications</a></li>
                        <li><a class="dropdown-item py-2" href="findajob.html"><i class="bi bi-search text-info me-2"></i>Browse Jobs</a></li>
                        <li><hr class="dropdown-divider my-1"></li>
                        <li><a class="dropdown-item py-2 text-danger" href="#" id="btnLogoutAction"><i class="bi bi-box-arrow-right text-danger me-2"></i>Logout</a></li>
                    </ul>
                </div>
            `;
            const logoutBtn = document.getElementById('btnLogoutAction');
            if (logoutBtn) {
                logoutBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    setCurrentUser(null);
                    showToast("You have been signed out.", "info");
                    setTimeout(() => {
                        window.location.reload();
                    }, 600);
                });
            }
        } else {
            authContainer.innerHTML = `
                <div class="d-flex align-items-center gap-2">
                    <a href="login.html" class="btn btn-outline-primary rounded-pill px-3 py-1 fw-semibold">Login</a>
                    <a href="register.html" class="btn btn-primary rounded-pill px-3 py-1 fw-semibold shadow-sm">Register</a>
                </div>
            `;
        }
    }

    // ── TOAST NOTIFICATIONS ────────────────────────────────────
    function showToast(message, type = 'success') {
        let container = document.getElementById('toastContainer');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toastContainer';
            container.className = 'position-fixed bottom-0 end-0 p-3';
            container.style.zIndex = '9999';
            document.body.appendChild(container);
        }

        const toastId = 'toast_' + Date.now();
        const bgClass = type === 'success' ? 'bg-success text-white' : type === 'danger' ? 'bg-danger text-white' : 'bg-dark text-white';
        const icon = type === 'success' ? 'bi-check-circle-fill' : type === 'danger' ? 'bi-exclamation-triangle-fill' : 'bi-info-circle-fill';

        const toastEl = document.createElement('div');
        toastEl.id = toastId;
        toastEl.className = `toast align-items-center border-0 rounded-4 shadow-lg mb-2 ${bgClass}`;
        toastEl.setAttribute('role', 'alert');
        toastEl.setAttribute('aria-live', 'assertive');
        toastEl.setAttribute('aria-atomic', 'true');
        toastEl.innerHTML = `
            <div class="d-flex">
                <div class="toast-body d-flex align-items-center gap-2 fs-6">
                    <i class="bi ${icon} fs-5"></i>
                    <div>${message}</div>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        `;
        container.appendChild(toastEl);

        if (window.bootstrap && window.bootstrap.Toast) {
            const bsToast = new window.bootstrap.Toast(toastEl, { delay: 4000 });
            bsToast.show();
            toastEl.addEventListener('hidden.bs.toast', () => toastEl.remove());
        } else {
            setTimeout(() => toastEl.remove(), 4000);
        }
    }

    // ── UTILITY: ESCAPE HTML ───────────────────────────────────
    function escapeHtml(str) {
        if (!str) return '';
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }

    // ── JOB BOARD RENDERER & FILTERS ───────────────────────────
    function initJobBoard() {
        const jobsContainer = document.getElementById('jobsListContainer');
        if (!jobsContainer) return;

        const allJobs = window.ELEVATE_JOBS || [];
        const totalCountEl = document.getElementById('totalJobsCount');
        const searchInput = document.getElementById('filterSearch');
        const categorySelect = document.getElementById('filterCategory');
        const locationSelect = document.getElementById('filterLocation');
        const salaryRange = document.getElementById('filterSalary');
        const salaryValueDisplay = document.getElementById('salaryValueDisplay');
        const sortSelect = document.getElementById('sortBy');
        const clearBtn = document.getElementById('clearFiltersBtn');

        // Check URL query parameters for initial state (e.g. from homepage search)
        const urlParams = new URLSearchParams(window.location.search);
        if (searchInput && urlParams.get('search')) {
            searchInput.value = urlParams.get('search');
        }
        if (categorySelect && urlParams.get('category')) {
            categorySelect.value = urlParams.get('category');
        }
        if (locationSelect && urlParams.get('location')) {
            locationSelect.value = urlParams.get('location');
        }
        if (urlParams.get('type')) {
            const radio = document.querySelector(`input[name="filterType"][value="${urlParams.get('type')}"]`);
            if (radio) radio.checked = true;
        }

        function filterAndRender() {
            const query = (searchInput ? searchInput.value : '').toLowerCase().trim();
            const category = categorySelect ? categorySelect.value : '';
            const location = locationSelect ? locationSelect.value : '';
            const maxSalary = salaryRange ? parseFloat(salaryRange.value) : 0;
            const sort = sortSelect ? sortSelect.value : '';

            const selectedTypeRadio = document.querySelector('input[name="filterType"]:checked');
            const type = selectedTypeRadio ? selectedTypeRadio.value : '';

            let filtered = allJobs.filter(job => {
                // Text search match on title, company, description, or tags
                if (query) {
                    const matchTitle = job.title.toLowerCase().includes(query);
                    const matchCompany = job.company.toLowerCase().includes(query);
                    const matchDesc = job.description.toLowerCase().includes(query);
                    const matchTags = (job.tags || []).some(t => t.toLowerCase().includes(query));
                    if (!matchTitle && !matchCompany && !matchDesc && !matchTags) return false;
                }

                // Category match
                if (category && job.category !== category) {
                    return false;
                }

                // Location match
                if (location) {
                    if (location === 'Remote') {
                        if (job.type !== 'Remote' && !job.location.toLowerCase().includes('remote')) return false;
                    } else if (!job.location.toLowerCase().includes(location.toLowerCase())) {
                        return false;
                    }
                }

                // Type match
                if (type && type !== 'All') {
                    if (job.type.toLowerCase() !== type.toLowerCase()) return false;
                }

                // Salary match (salary must be <= maxSalary if slider moved from max)
                if (salaryRange && maxSalary < 120000 && maxSalary > 0) {
                    if (job.salary > maxSalary) return false;
                }

                return true;
            });

            // Sorting
            if (sort === 'salaryDesc') {
                filtered.sort((a, b) => b.salary - a.salary);
            } else if (sort === 'salaryAsc') {
                filtered.sort((a, b) => a.salary - b.salary);
            } else if (sort === 'titleAsc') {
                filtered.sort((a, b) => a.title.localeCompare(b.title));
            }

            if (totalCountEl) {
                totalCountEl.textContent = `${filtered.length} verified job${filtered.length === 1 ? '' : 's'} available`;
            }

            if (filtered.length === 0) {
                jobsContainer.innerHTML = `
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                        <div class="user-avatar-badge mx-auto mb-3" style="width: 64px; height: 64px; font-size: 1.75rem; background: var(--slate-100); color: var(--slate-400);">
                            <i class="bi bi-search"></i>
                        </div>
                        <h4 class="fw-bold text-slate-800 mb-2">No Matching Jobs Found</h4>
                        <p class="text-slate-500 max-w-md mx-auto mb-4" style="max-width: 440px;">
                            We couldn't find any openings matching your exact search criteria. Try adjusting your keyword, removing filters, or resetting the salary filter.
                        </p>
                        <div>
                            <button type="button" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-semibold" id="emptyResetFiltersBtn">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Reset All Filters
                            </button>
                        </div>
                    </div>
                `;
                const resetBtn = document.getElementById('emptyResetFiltersBtn');
                if (resetBtn) {
                    resetBtn.addEventListener('click', resetFilters);
                }
                return;
            }

            // Render Job Cards
            jobsContainer.innerHTML = filtered.map(job => {
                const initial = job.company.charAt(0).toUpperCase();
                const typeClass = job.type === 'Remote' ? 'badge-remote' : job.type === 'Part-time' ? 'badge-part-time' : job.type === 'Internship' ? 'badge-internship' : 'badge-full-time';
                const formattedSalary = Number(job.salary).toLocaleString('en-IN');
                const tagsHtml = (job.tags || []).slice(0, 3).map(tag => `<span class="job-tag">${escapeHtml(tag)}</span>`).join('');

                return `
                    <div class="job-listing-card mb-3" data-job-id="${job.id}">
                        <div class="d-flex flex-column flex-sm-row align-items-sm-center justify-content-between gap-3">
                            <div class="d-flex align-items-start gap-3">
                                <div class="company-logo-badge">
                                    ${initial}
                                </div>
                                <div>
                                    <div class="d-flex align-items-center gap-2 flex-wrap mb-1">
                                        <h5 class="fw-bold text-slate-900 mb-0 job-card-title">${escapeHtml(job.title)}</h5>
                                        <span class="badge ${typeClass} rounded-pill">${escapeHtml(job.type)}</span>
                                    </div>
                                    <div class="d-flex align-items-center gap-3 text-slate-500 small flex-wrap">
                                        <span><i class="bi bi-building text-primary me-1"></i>${escapeHtml(job.company)}</span>
                                        <span><i class="bi bi-geo-alt text-danger me-1"></i>${escapeHtml(job.location)}</span>
                                        <span><i class="bi bi-cash-stack text-success me-1"></i>NPR ${formattedSalary}/mo</span>
                                        <span><i class="bi bi-clock text-slate-400 me-1"></i>${escapeHtml(job.postedDate)}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center gap-2 flex-sm-shrink-0 mt-2 mt-sm-0">
                                <button type="button" class="btn btn-outline-secondary rounded-pill btn-sm px-3 py-1 btn-view-job" data-job-id="${job.id}">
                                    <i class="bi bi-eye me-1"></i> Details
                                </button>
                                <button type="button" class="btn btn-primary rounded-pill btn-sm px-3 py-1 btn-apply-job shadow-sm" data-job-id="${job.id}">
                                    <i class="bi bi-send me-1"></i> Apply
                                </button>
                            </div>
                        </div>
                        <p class="text-slate-600 small mt-3 mb-2 line-clamp-2">
                            ${escapeHtml(job.description)}
                        </p>
                        <div class="d-flex align-items-center gap-2 flex-wrap pt-2 border-top mt-2">
                            <small class="text-slate-400 fw-semibold">Skills:</small>
                            ${tagsHtml}
                        </div>
                    </div>
                `;
            }).join('');

            // Attach event listeners to details and apply buttons
            document.querySelectorAll('.btn-view-job').forEach(btn => {
                btn.addEventListener('click', () => {
                    const jid = parseInt(btn.getAttribute('data-job-id'));
                    const j = allJobs.find(item => item.id === jid);
                    if (j) openJobDetailsModal(j);
                });
            });

            document.querySelectorAll('.btn-apply-job').forEach(btn => {
                btn.addEventListener('click', () => {
                    const jid = parseInt(btn.getAttribute('data-job-id'));
                    const j = allJobs.find(item => item.id === jid);
                    if (j) openQuickApplyModal(j);
                });
            });
        }

        function resetFilters() {
            if (searchInput) searchInput.value = '';
            if (categorySelect) categorySelect.value = '';
            if (locationSelect) locationSelect.value = '';
            if (salaryRange) {
                salaryRange.value = 120000;
                if (salaryValueDisplay) salaryValueDisplay.textContent = 'Up to NPR 120,000+';
            }
            if (sortSelect) sortSelect.value = '';
            const allRadio = document.querySelector('input[name="filterType"][value="All"]');
            if (allRadio) allRadio.checked = true;
            filterAndRender();
        }

        // Event listeners
        if (searchInput) searchInput.addEventListener('input', debounce(filterAndRender, 250));
        if (categorySelect) categorySelect.addEventListener('change', filterAndRender);
        if (locationSelect) locationSelect.addEventListener('change', filterAndRender);
        if (sortSelect) sortSelect.addEventListener('change', filterAndRender);
        if (clearBtn) clearBtn.addEventListener('click', resetFilters);

        document.querySelectorAll('input[name="filterType"]').forEach(r => {
            r.addEventListener('change', filterAndRender);
        });

        if (salaryRange) {
            salaryRange.addEventListener('input', (e) => {
                const val = parseFloat(e.target.value);
                if (salaryValueDisplay) {
                    salaryValueDisplay.textContent = val >= 120000 ? 'Any Salary (No Limit)' : `Up to NPR ${val.toLocaleString('en-IN')}`;
                }
                filterAndRender();
            });
        }

        // Initial render
        filterAndRender();
    }

    // ── JOB DETAILS MODAL ──────────────────────────────────────
    function openJobDetailsModal(job) {
        let modalEl = document.getElementById('jobDetailsModal');
        if (!modalEl) {
            modalEl = document.createElement('div');
            modalEl.id = 'jobDetailsModal';
            modalEl.className = 'modal fade';
            modalEl.tabIndex = -1;
            modalEl.setAttribute('aria-hidden', 'true');
            document.body.appendChild(modalEl);
        }

        const formattedSalary = Number(job.salary).toLocaleString('en-IN');
        const reqHtml = (job.requirements || []).map(r => `<li class="mb-2"><i class="bi bi-check2-circle text-primary me-2"></i>${escapeHtml(r)}</li>`).join('');
        const tagsHtml = (job.tags || []).map(t => `<span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-1 me-1 mb-1">${escapeHtml(t)}</span>`).join('');

        modalEl.innerHTML = `
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="modal-header bg-light border-bottom p-4">
                        <div class="d-flex align-items-center gap-3">
                            <div class="company-logo-badge" style="width: 52px; height: 52px; font-size: 1.5rem;">
                                ${job.company.charAt(0).toUpperCase()}
                            </div>
                            <div>
                                <h4 class="fw-bold mb-1 text-slate-900">${escapeHtml(job.title)}</h4>
                                <div class="d-flex align-items-center gap-3 text-slate-600 small flex-wrap">
                                    <span><i class="bi bi-building text-primary me-1"></i>${escapeHtml(job.company)}</span>
                                    <span><i class="bi bi-geo-alt text-danger me-1"></i>${escapeHtml(job.location)}</span>
                                    <span><i class="bi bi-cash-stack text-success me-1"></i>NPR ${formattedSalary}/month</span>
                                    <span class="badge bg-primary rounded-pill px-2 py-1">${escapeHtml(job.type)}</span>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-4">
                            <h6 class="fw-bold text-slate-900 mb-2">Role Overview & Responsibilities</h6>
                            <p class="text-slate-600 leading-relaxed">${escapeHtml(job.description)}</p>
                        </div>
                        <div class="mb-4">
                            <h6 class="fw-bold text-slate-900 mb-2">Key Qualifications & Skills</h6>
                            <ul class="list-unstyled text-slate-600 mb-0">
                                ${reqHtml}
                            </ul>
                        </div>
                        <div class="mb-3">
                            <h6 class="fw-bold text-slate-900 mb-2">Technology & Tools</h6>
                            <div class="d-flex flex-wrap">${tagsHtml}</div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-top p-3 d-flex justify-content-between align-items-center">
                        <div class="small text-slate-500">
                            <i class="bi bi-shield-check text-success me-1"></i> Verified Direct Listing
                        </div>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4 py-2 fw-semibold" data-bs-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-sm" id="modalApplyBtn">
                                <i class="bi bi-send me-1"></i> Apply Now
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        if (window.bootstrap && window.bootstrap.Modal) {
            const bsModal = new window.bootstrap.Modal(modalEl);
            bsModal.show();
            const applyBtn = document.getElementById('modalApplyBtn');
            if (applyBtn) {
                applyBtn.addEventListener('click', () => {
                    bsModal.hide();
                    setTimeout(() => openQuickApplyModal(job), 300);
                });
            }
        }
    }

    // ── QUICK APPLY MODAL ──────────────────────────────────────
    function openQuickApplyModal(job) {
        let modalEl = document.getElementById('quickApplyModal');
        if (!modalEl) {
            modalEl = document.createElement('div');
            modalEl.id = 'quickApplyModal';
            modalEl.className = 'modal fade';
            modalEl.tabIndex = -1;
            modalEl.setAttribute('aria-hidden', 'true');
            document.body.appendChild(modalEl);
        }

        const user = getCurrentUser() || { username: '', email: '', phone: '' };

        modalEl.innerHTML = `
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="modal-header bg-primary text-white p-4">
                        <div>
                            <span class="badge bg-white text-primary rounded-pill px-3 py-1 small fw-bold mb-1">Quick 1-Click Application</span>
                            <h5 class="modal-title fw-bold mb-0 text-white">${escapeHtml(job.title)}</h5>
                            <small class="text-white-50">${escapeHtml(job.company)} • ${escapeHtml(job.location)}</small>
                        </div>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="quickApplyForm">
                        <div class="modal-body p-4">
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-slate-700">Full Name *</label>
                                <input type="text" class="form-control rounded-3" id="applyFullName" required value="${escapeHtml(user.username)}" placeholder="e.g. Aayush Shrestha">
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-slate-700">Email Address *</label>
                                <input type="email" class="form-control rounded-3" id="applyEmail" required value="${escapeHtml(user.email || 'candidate@gmail.com')}" placeholder="you@example.com">
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-slate-700">Phone / WhatsApp Number *</label>
                                <input type="tel" class="form-control rounded-3" id="applyPhone" required value="${escapeHtml(user.phone || '+977 9800000000')}" placeholder="+977 98xxxxxxxx">
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-slate-700">Attach Resume (PDF / DOCX)</label>
                                <input type="file" class="form-control rounded-3" id="applyResume" accept=".pdf,.docx,.doc">
                                <small class="text-slate-400 d-block mt-1">Default verified candidate profile will be attached if omitted.</small>
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-bold text-slate-700">Brief Note to Hiring Manager</label>
                                <textarea class="form-control rounded-3" id="applyNote" rows="2" placeholder="Tell the recruiter why you are a great match for this role..."></textarea>
                            </div>
                        </div>
                        <div class="modal-footer bg-light border-top p-3 d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-outline-secondary rounded-pill px-4 py-2 fw-semibold" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-sm" id="btnSubmitApplication">
                                <i class="bi bi-send-fill me-1"></i> Submit Application
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        `;

        if (window.bootstrap && window.bootstrap.Modal) {
            const bsModal = new window.bootstrap.Modal(modalEl);
            bsModal.show();

            const form = document.getElementById('quickApplyForm');
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                const btn = document.getElementById('btnSubmitApplication');
                btn.disabled = true;
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Submitting...';

                setTimeout(() => {
                    // Record application
                    const apps = getApplications();
                    const newApp = {
                        id: Date.now(),
                        jobId: job.id,
                        jobTitle: job.title,
                        company: job.company,
                        location: job.location,
                        salary: job.salary,
                        type: job.type,
                        appliedDate: "Just now",
                        status: "Pending"
                    };
                    apps.unshift(newApp);
                    saveApplications(apps);

                    // Ensure user is signed in as demo if not already
                    if (!getCurrentUser()) {
                        setCurrentUser({
                            username: document.getElementById('applyFullName').value.trim() || 'Candidate',
                            email: document.getElementById('applyEmail').value.trim(),
                            phone: document.getElementById('applyPhone').value.trim(),
                            role: 'candidate'
                        });
                        syncNavbarUserState();
                    }

                    bsModal.hide();
                    showToast(`Application for <strong>${escapeHtml(job.title)}</strong> submitted successfully!`, 'success');

                    // If on applications page, refresh list
                    if (document.getElementById('applicationsTableBody')) {
                        initApplicationsTracker();
                    }
                }, 800);
            });
        }
    }

    // ── APPLICATIONS TRACKER PAGE ──────────────────────────────
    function initApplicationsTracker() {
        const tableBody = document.getElementById('applicationsTableBody');
        const emptyState = document.getElementById('applicationsEmptyState');
        const tableWrapper = document.getElementById('applicationsTableWrapper');
        const countBadge = document.getElementById('applicationsCountBadge');
        if (!tableBody && !emptyState) return;

        const apps = getApplications();
        if (countBadge) {
            countBadge.textContent = `${apps.length} Total Application${apps.length === 1 ? '' : 's'}`;
        }

        if (apps.length === 0) {
            if (tableWrapper) tableWrapper.classList.add('d-none');
            if (emptyState) emptyState.classList.remove('d-none');
            return;
        }

        if (tableWrapper) tableWrapper.classList.remove('d-none');
        if (emptyState) emptyState.classList.add('d-none');

        tableBody.innerHTML = apps.map((app, index) => {
            let statusBadge = '';
            if (app.status === 'Hired') {
                statusBadge = '<span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill px-3 py-1"><i class="bi bi-check-circle-fill me-1"></i>Hired</span>';
            } else if (app.status === 'Shortlisted') {
                statusBadge = '<span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-1"><i class="bi bi-star-fill me-1"></i>Shortlisted</span>';
            } else if (app.status === 'Rejected') {
                statusBadge = '<span class="badge bg-danger-subtle text-danger border border-danger-subtle rounded-pill px-3 py-1"><i class="bi bi-x-circle-fill me-1"></i>Not Selected</span>';
            } else {
                statusBadge = '<span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle rounded-pill px-3 py-1"><i class="bi bi-hourglass-split me-1"></i>Under Review</span>';
            }

            const formattedSalary = Number(app.salary).toLocaleString('en-IN');

            return `
                <tr>
                    <td class="ps-4 fw-bold text-slate-500">${index + 1}</td>
                    <td>
                        <div class="fw-bold text-slate-900">${escapeHtml(app.jobTitle)}</div>
                        <small class="text-slate-500">${escapeHtml(app.type || 'Full-time')} • NPR ${formattedSalary}</small>
                    </td>
                    <td>
                        <div class="d-flex align-items-center gap-2">
                            <span class="user-avatar-badge" style="width: 32px; height: 32px; font-size: 0.9rem; background: #e0f2fe; color: #0284c7;">
                                ${app.company.charAt(0).toUpperCase()}
                            </span>
                            <span class="fw-semibold text-slate-800">${escapeHtml(app.company)}</span>
                        </div>
                    </td>
                    <td>
                        <div class="small text-slate-600">${escapeHtml(app.appliedDate)}</div>
                    </td>
                    <td>
                        ${statusBadge}
                    </td>
                    <td class="pe-4 text-end">
                        <button type="button" class="btn btn-outline-danger btn-sm rounded-pill px-3 btn-withdraw-app" data-app-id="${app.id}">
                            <i class="bi bi-trash3 me-1"></i> Withdraw
                        </button>
                    </td>
                </tr>
            `;
        }).join('');

        document.querySelectorAll('.btn-withdraw-app').forEach(btn => {
            btn.addEventListener('click', () => {
                const aid = parseInt(btn.getAttribute('data-app-id'));
                if (confirm("Are you sure you want to withdraw this application?")) {
                    const current = getApplications();
                    const updated = current.filter(a => a.id !== aid);
                    saveApplications(updated);
                    showToast("Application withdrawn.", "info");
                    initApplicationsTracker();
                }
            });
        });
    }

    // ── CANDIDATE DASHBOARD PAGE ───────────────────────────────
    function initUserDashboard() {
        const dashWelcomeName = document.getElementById('dashWelcomeName');
        const dashInitialBadge = document.getElementById('dashInitialBadge');
        const statAppliedCount = document.getElementById('statAppliedCount');
        const statShortlistedCount = document.getElementById('statShortlistedCount');
        if (!dashWelcomeName) return;

        let user = getCurrentUser();
        if (!user) {
            user = { username: "Om Prakash Shah", email: "shahomprakash2004@gmail.com", role: "candidate" };
            setCurrentUser(user);
        }

        dashWelcomeName.textContent = user.username;
        if (dashInitialBadge) {
            dashInitialBadge.textContent = user.username.charAt(0).toUpperCase();
        }

        const apps = getApplications();
        if (statAppliedCount) statAppliedCount.textContent = apps.length;
        if (statShortlistedCount) {
            const count = apps.filter(a => a.status === 'Shortlisted' || a.status === 'Hired').length;
            statShortlistedCount.textContent = count;
        }

        const recentListContainer = document.getElementById('recentApplicationsList');
        if (recentListContainer) {
            if (apps.length === 0) {
                recentListContainer.innerHTML = `<p class="text-muted small mb-0 py-3 text-center">No applications submitted yet. Browse jobs to apply.</p>`;
            } else {
                recentListContainer.innerHTML = apps.slice(0, 3).map(a => `
                    <div class="d-flex align-items-center justify-content-between p-3 border-bottom">
                        <div>
                            <div class="fw-bold text-slate-900">${escapeHtml(a.jobTitle)}</div>
                            <small class="text-slate-500">${escapeHtml(a.company)} • ${escapeHtml(a.appliedDate)}</small>
                        </div>
                        <span class="badge ${a.status === 'Hired' ? 'bg-success' : a.status === 'Shortlisted' ? 'bg-primary' : 'bg-warning text-dark'} rounded-pill px-3 py-1">
                            ${escapeHtml(a.status)}
                        </span>
                    </div>
                `).join('');
            }
        }
    }

    // ── DEBOUNCE HELPER ────────────────────────────────────────
    function debounce(func, wait) {
        let timeout;
        return function (...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, args), wait);
        };
    }

    // ── RUN ON DOM READY ───────────────────────────────────────
    document.addEventListener('DOMContentLoaded', () => {
        syncNavbarUserState();
        initJobBoard();
        initApplicationsTracker();
        initUserDashboard();
    });

    // Expose helpers globally
    window.ElevatePortal = {
        showToast,
        openJobDetailsModal,
        openQuickApplyModal,
        getCurrentUser,
        setCurrentUser,
        syncNavbarUserState
    };

})();
