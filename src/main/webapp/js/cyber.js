/* ============================================================
   cyber.js — Cyber Security Monitoring System
   Handles: Particles, Sidebar toggle, Animations, Charts
   ============================================================ */

// ── PARTICLES CONFIG ──────────────────────────────────────────
function initParticles() {
  // Particles disabled for simple UI
}

// ── SIDEBAR TOGGLE ────────────────────────────────────────────
function initSidebar() {
  const btn     = document.getElementById('sidebarToggle');
  const sidebar = document.getElementById('sidebar');
  const wrapper = document.getElementById('mainWrapper');
  if (!btn || !sidebar) return;

  btn.addEventListener('click', () => {
    const isMobile = window.innerWidth <= 768;
    if (isMobile) {
      sidebar.classList.toggle('mobile-open');
    } else {
      sidebar.classList.toggle('collapsed');
      wrapper.classList.toggle('expanded');
    }
  });

  // Close sidebar on mobile when clicking outside
  document.addEventListener('click', (e) => {
    if (window.innerWidth <= 768
        && sidebar.classList.contains('mobile-open')
        && !sidebar.contains(e.target)
        && e.target !== btn) {
      sidebar.classList.remove('mobile-open');
    }
  });
}

// ── ACTIVE NAV LINK ───────────────────────────────────────────
function highlightNav() {
  const path = window.location.pathname;
  document.querySelectorAll('.nav-link').forEach(link => {
    const href = link.getAttribute('href') || '';
    if (path.includes(href.split('?')[0]) && href !== '#') {
      link.classList.add('active');
    }
  });
}

// ── COUNT-UP ANIMATION ────────────────────────────────────────
function animateCounters() {
  document.querySelectorAll('.stat-number').forEach(el => {
    const target = parseInt(el.textContent) || 0;
    let current  = 0;
    const step   = Math.ceil(target / 40);
    const timer  = setInterval(() => {
      current += step;
      if (current >= target) { el.textContent = target; clearInterval(timer); }
      else { el.textContent = current; }
    }, 30);
  });
}

// ── FORM LOADING SPINNER ──────────────────────────────────────
function initFormSpinner() {
  document.querySelectorAll('form').forEach(form => {
      if (spinner) spinner.style.display = 'flex';
      // btn.disabled = true; // Removed for simple UI to prevent lockups
    });
  });
}

// ── AUTO HIDE SUCCESS MSG ─────────────────────────────────────
function autoHideAlerts() {
  document.querySelectorAll('.cyber-success').forEach(el => {
    setTimeout(() => {
      el.style.transition = 'opacity 0.6s';
      el.style.opacity = '0';
      setTimeout(() => el.remove(), 700);
    }, 3500);
  });
}

// ── CARD HOVER 3D TILT ────────────────────────────────────────
function initCardTilt() {
  // 3D Tilt disabled for simple UI
}

// ── TABLE ROW FADE-IN ─────────────────────────────────────────
function animateTableRows() {
  document.querySelectorAll('.cyber-table tbody tr').forEach((row, i) => {
    row.style.opacity = '0';
    row.style.transform = 'translateX(-10px)';
    row.style.transition = `opacity 0.3s ${i * 0.04}s, transform 0.3s ${i * 0.04}s`;
    requestAnimationFrame(() => {
      row.style.opacity = '1';
      row.style.transform = 'translateX(0)';
    });
  });
}

// ── TYPED EFFECT FOR WELCOME ──────────────────────────────────
function typeEffect(el, text, speed) {
  if (!el) return;
  el.textContent = text; // Direct assignment for simple UI
}

// ── CONFIRM DELETE ────────────────────────────────────────────
function confirmDelete() {
  return confirm('⚠️  Permanently delete this record?');
}

// ── INIT ──────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  initParticles();
  initSidebar();
  highlightNav();
  animateCounters();
  initFormSpinner();
  autoHideAlerts();
  initCardTilt();
  animateTableRows();

  // Type the welcome heading if present
  const welcomeEl = document.getElementById('welcomeHeading');
  if (welcomeEl) typeEffect(welcomeEl, welcomeEl.dataset.text || welcomeEl.textContent);
});
