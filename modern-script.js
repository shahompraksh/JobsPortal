/**
 * Elevate Workforce Solutions - Modern Interactive Scripts
 */

document.addEventListener('DOMContentLoaded', () => {
    initStickyNavbar();
    initScrollReveal();
    initCounterAnimations();
    initBackToTop();
    initMobileNavEnhancements();
    initGlobalAuth();
});

/**
 * Sticky Navbar Scroll State
 */
function initStickyNavbar() {
    const navbar = document.querySelector('.navbar-modern');
    if (!navbar) return;

    const handleScroll = () => {
        if (window.scrollY > 30) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    handleScroll(); // run once on mount
}

/**
 * Scroll Reveal Animations via IntersectionObserver
 */
function initScrollReveal() {
    const revealItems = document.querySelectorAll('.reveal-item');
    if (!revealItems.length) return;

    if (!('IntersectionObserver' in window)) {
        revealItems.forEach(el => el.classList.add('is-revealed'));
        return;
    }

    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('is-revealed');
                obs.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.12,
        rootMargin: '0px 0px -40px 0px'
    });

    revealItems.forEach(el => observer.observe(el));
}

/**
 * Animated Number Counters
 */
function initCounterAnimations() {
    const counters = document.querySelectorAll('[data-counter]');
    if (!counters.length) return;

    const runCounter = (el) => {
        const target = parseFloat(el.getAttribute('data-counter'));
        const prefix = el.getAttribute('data-prefix') || '';
        const suffix = el.getAttribute('data-suffix') || '';
        const isDecimal = el.getAttribute('data-decimal') === 'true';
        const duration = 2000; // 2 seconds
        const startTime = performance.now();

        function update(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            
            // Ease out cubic
            const easeOut = 1 - Math.pow(1 - progress, 3);
            const currentVal = easeOut * target;

            if (isDecimal) {
                el.textContent = prefix + currentVal.toFixed(1) + suffix;
            } else {
                el.textContent = prefix + Math.floor(currentVal).toLocaleString() + suffix;
            }

            if (progress < 1) {
                requestAnimationFrame(update);
            } else {
                if (isDecimal) {
                    el.textContent = prefix + target.toFixed(1) + suffix;
                } else {
                    el.textContent = prefix + target.toLocaleString() + suffix;
                }
            }
        }

        requestAnimationFrame(update);
    };

    if (!('IntersectionObserver' in window)) {
        counters.forEach(runCounter);
        return;
    }

    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                runCounter(entry.target);
                obs.unobserve(entry.target);
            }
        });
    }, { threshold: 0.25 });

    counters.forEach(counter => observer.observe(counter));
}

/**
 * Back to Top Floating Button
 */
function initBackToTop() {
    const btn = document.getElementById('backToTop');
    if (!btn) return;

    window.addEventListener('scroll', () => {
        if (window.scrollY > 350) {
            btn.classList.add('show');
        } else {
            btn.classList.remove('show');
        }
    }, { passive: true });

    btn.addEventListener('click', (e) => {
        e.preventDefault();
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}

/**
 * Mobile Navigation Enhancements
 */
function initMobileNavEnhancements() {
    const navLinks = document.querySelectorAll('.navbar-modern .nav-link:not(.dropdown-toggle)');
    const navCollapse = document.getElementById('navbarNav');
    
    if (navCollapse && window.bootstrap) {
        navLinks.forEach(link => {
            link.addEventListener('click', () => {
                if (window.innerWidth < 992 && navCollapse.classList.contains('show')) {
                    const bsCollapse = bootstrap.Collapse.getInstance(navCollapse);
                    if (bsCollapse) bsCollapse.hide();
                }
            });
        });
    }
}

/**
 * Global Candidate Authentication Persistence
 */
function initGlobalAuth() {
    const authContainer = document.getElementById('navAuthSection');
    const userStr = localStorage.getItem('elevate_user');
    
    if (!authContainer) return;

    if (userStr) {
        try {
            const user = JSON.parse(userStr);
            const name = user.name || user.username || 'Candidate';
            const initial = name.charAt(0).toUpperCase();

            authContainer.innerHTML = `
                <div class="dropdown">
                    <button class="btn user-dropdown-btn dropdown-toggle d-flex align-items-center gap-2 border-0 bg-transparent py-1 px-2" type="button" id="globalUserMenuBtn" data-bs-toggle="dropdown" aria-expanded="false">
                        <span class="user-avatar-badge" style="width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #0066cc, #06b6d4); color: white; border-radius: 50%; font-weight: 700; font-size: 0.95rem;">${initial}</span>
                        <span class="d-inline-block text-truncate fw-semibold text-slate-800" style="max-width: 140px;">${name}</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-3 p-2" aria-labelledby="globalUserMenuBtn" style="min-width: 200px;">
                        <li class="px-3 py-2 border-bottom mb-1">
                            <small class="text-muted d-block" style="font-size: 0.75rem;">Signed in as</small>
                            <strong class="text-dark d-block text-truncate" style="max-width: 170px;">${name}</strong>
                        </li>
                        <li><a class="dropdown-item rounded-2 py-2" href="userdashboard.html"><i class="bi bi-grid-1x2 text-primary me-2"></i> Dashboard</a></li>
                        <li><a class="dropdown-item rounded-2 py-2" href="profile.html"><i class="bi bi-person-gear text-info me-2"></i> Profile</a></li>
                        <li><a class="dropdown-item rounded-2 py-2" href="applications.html"><i class="bi bi-file-earmark-text text-success me-2"></i> Applications</a></li>
                        <li><hr class="dropdown-divider my-1"></li>
                        <li><a class="dropdown-item rounded-2 py-2 text-danger" href="javascript:void(0)" onclick="logoutUser()"><i class="bi bi-box-arrow-right text-danger me-2"></i> Logout</a></li>
                    </ul>
                </div>
            `;
        } catch(e) {
            console.error('Error parsing session user', e);
        }
    }
}

function logoutUser() {
    localStorage.removeItem('elevate_user');
    window.location.href = 'login.html';
}

/**
 * Universal In-Page Toast Interceptor
 * Ensures no browser dialogs ("shahompraksh.github.io says") can pop up
 */
(function() {
    window.alert = function(message) {
        if (!message) return;
        let container = document.getElementById('globalSystemToastContainer');
        if (!container) {
            container = document.createElement('div');
            container.id = 'globalSystemToastContainer';
            container.style.position = 'fixed';
            container.style.top = '24px';
            container.style.left = '50%';
            container.style.transform = 'translateX(-50%)';
            container.style.zIndex = '999999';
            container.style.maxWidth = '92%';
            container.style.width = '420px';
            container.style.pointerEvents = 'none';
            document.body.appendChild(container);
        }

        const toast = document.createElement('div');
        toast.className = 'alert alert-primary alert-dismissible fade show rounded-4 py-3 px-4 shadow-lg border-0 d-flex align-items-center justify-content-between mb-2';
        toast.style.background = '#ffffff';
        toast.style.borderLeft = '4px solid #0066cc';
        toast.style.boxShadow = '0 12px 36px rgba(15, 23, 42, 0.16)';
        toast.style.color = '#0f172a';
        toast.style.pointerEvents = 'auto';
        toast.innerHTML = `
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-info-circle-fill text-primary fs-5"></i>
                <div style="font-size: 0.9rem; font-weight: 500;">${message}</div>
            </div>
            <button type="button" class="btn-close ms-2" style="font-size: 0.75rem;" onclick="this.parentElement.remove()"></button>
        `;
        container.appendChild(toast);
        setTimeout(() => {
            if (toast.parentElement) toast.remove();
        }, 4000);
    };
})();


