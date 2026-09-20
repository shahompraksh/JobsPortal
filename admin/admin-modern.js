/**
 * Elevate Workforce Solutions - Admin Dashboard Scripts
 * Handles Dark/Light Mode, Sidebar Collapse/Drawer, Live Clock, Table Filtering, and CSV Exports
 */

document.addEventListener('DOMContentLoaded', () => {
    initTheme();
    initSidebar();
    initLiveClock();
    initAutoDismissAlerts();
});

/**
 * Theme Management (Light / Dark)
 */
function initTheme() {
    const savedTheme = localStorage.getItem('admin-theme') || 'light';
    applyTheme(savedTheme);

    const themeToggleBtn = document.getElementById('themeToggleBtn');
    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', () => {
            const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
            const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';
            applyTheme(nextTheme);
            localStorage.setItem('admin-theme', nextTheme);
        });
    }
}

function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
    const icon = document.getElementById('themeIcon');
    if (icon) {
        if (theme === 'dark') {
            icon.className = 'bi bi-sun-fill text-warning';
        } else {
            icon.className = 'bi bi-moon-stars-fill text-slate-600';
        }
    }
}

/**
 * Sidebar Collapse & Mobile Offcanvas Drawer
 */
function initSidebar() {
    const sidebarToggleBtn = document.getElementById('sidebarToggleBtn');
    const sidebar = document.getElementById('adminSidebar');
    const overlay = document.getElementById('sidebarOverlay');

    // Restore desktop collapsed state
    if (window.innerWidth >= 992) {
        const isCollapsed = localStorage.getItem('admin-sidebar-collapsed') === 'true';
        if (isCollapsed) {
            document.body.classList.add('sidebar-collapsed');
        }
    }

    if (sidebarToggleBtn) {
        sidebarToggleBtn.addEventListener('click', () => {
            if (window.innerWidth < 992) {
                // Mobile drawer toggle
                if (sidebar) sidebar.classList.toggle('show');
                if (overlay) overlay.classList.toggle('show');
            } else {
                // Desktop collapse toggle
                document.body.classList.toggle('sidebar-collapsed');
                const isCollapsed = document.body.classList.contains('sidebar-collapsed');
                localStorage.setItem('admin-sidebar-collapsed', isCollapsed);
            }
        });
    }

    if (overlay) {
        overlay.addEventListener('click', () => {
            if (sidebar) sidebar.classList.remove('show');
            overlay.classList.remove('show');
        });
    }
}

/**
 * Live Digital Clock
 */
function initLiveClock() {
    const clockEl = document.getElementById('topbarClock');
    if (!clockEl) return;

    function update() {
        const now = new Date();
        const options = { weekday: 'short', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true };
        clockEl.innerHTML = '<i class="bi bi-clock me-1 text-primary"></i> ' + now.toLocaleString('en-US', options);
    }
    update();
    setInterval(update, 1000);
}

/**
 * Auto-dismiss Alert Toasts after 5 seconds
 */
function initAutoDismissAlerts() {
    const alerts = document.querySelectorAll('.alert-auto-dismiss');
    alerts.forEach(alert => {
        setTimeout(() => {
            if (window.bootstrap && bootstrap.Alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            } else {
                alert.style.display = 'none';
            }
        }, 5000);
    });
}

/**
 * Table Search Utility
 */
function setupTableSearch(inputId, tableId) {
    const input = document.getElementById(inputId);
    const table = document.getElementById(tableId);
    if (!input || !table) return;

    input.addEventListener('keyup', () => {
        const filter = input.value.toLowerCase();
        const rows = table.querySelectorAll('tbody tr');
        let visibleCount = 0;

        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            if (text.includes(filter)) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        // Show empty state if count is 0
        const emptyState = document.getElementById(tableId + 'EmptyState');
        if (emptyState) {
            emptyState.style.display = visibleCount === 0 ? '' : 'none';
        }
    });
}

/**
 * Export Table to CSV Utility
 */
function exportTableToCSV(tableId, filename) {
    const table = document.getElementById(tableId);
    if (!table) return;

    let csv = [];
    const rows = table.querySelectorAll('tr');

    rows.forEach(row => {
        if (row.style.display === 'none') return; // skip filtered out rows
        let cols = [];
        // headers or data
        const cells = row.querySelectorAll('th, td');
        cells.forEach((cell, idx) => {
            // Ignore last action column if requested
            if (cell.classList.contains('no-export')) return;
            let text = cell.innerText.replace(/"/g, '""').trim();
            // remove multiple whitespace and newlines
            text = text.replace(/\s+/g, ' ');
            cols.push('"' + text + '"');
        });
        if (cols.length > 0) {
            csv.push(cols.join(','));
        }
    });

    const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + encodeURIComponent(csv.join('\n'));
    const link = document.createElement('a');
    link.setAttribute('href', csvContent);
    link.setAttribute('download', filename || 'export.csv');
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
