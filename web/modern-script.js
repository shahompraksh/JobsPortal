/**
 * Elevate Workforce Solutions - Modern Interactive Scripts
 */

document.addEventListener('DOMContentLoaded', () => {
    initStickyNavbar();
    initScrollReveal();
    initCounterAnimations();
    initBackToTop();
    initMobileNavEnhancements();
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
