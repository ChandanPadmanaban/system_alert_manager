<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cybersec.model.User, com.cybersec.model.DataAccessLog, com.cybersec.model.SystemUpdateAlert, com.cybersec.model.FileIntegrityAlert, java.util.List" %>
<%
  User loggedUser = (User) session.getAttribute("loggedUser");
  if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
  List<DataAccessLog>    recentLogs       = (List<DataAccessLog>)    request.getAttribute("recentLogs");
  List<SystemUpdateAlert> recentAlerts    = (List<SystemUpdateAlert>) request.getAttribute("recentAlerts");
  List<FileIntegrityAlert> recentFileAlerts = (List<FileIntegrityAlert>) request.getAttribute("recentFileAlerts");
  int totalLogs       = (Integer) request.getAttribute("totalLogs");
  int unauthorizedCount = (Integer) request.getAttribute("unauthorizedCount");
  int totalUpdates    = (Integer) request.getAttribute("totalUpdates");
  int failedUpdates   = (Integer) request.getAttribute("failedUpdates");
  int totalFileAlerts = (Integer) request.getAttribute("totalFileAlerts");
  int modifiedFiles   = (Integer) request.getAttribute("modifiedFiles");
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Dashboard | Cyber Security Monitoring System</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <link rel="stylesheet" href="<%= ctx %>/css/cyber.css"/>
</head>
<body>
<!-- No particles for simple UI -->
<div class="scan-overlay"></div>

<!-- ── SIDEBAR ── -->
<nav class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <i class="fa-solid fa-shield-halved"></i>
    <div class="sidebar-brand-text">CYBER<br/>SHIELD</div>
  </div>
  <ul class="sidebar-nav" style="list-style:none;padding:16px 0;">
    <li class="nav-section-label">MAIN</li>
    <li class="nav-item">
      <a href="<%= ctx %>/dashboard" class="nav-link active">
        <i class="fa-solid fa-gauge-high"></i> Dashboard
      </a>
    </li>
    <li class="nav-section-label">MODULES</li>
    <li class="nav-item">
      <a href="<%= ctx %>/dataAccessLog" class="nav-link">
        <i class="fa-solid fa-database"></i> Data Access Logs
        <% if (unauthorizedCount > 0) { %>
          <span class="nav-badge"><%= unauthorizedCount %></span>
        <% } %>
      </a>
    </li>
    <li class="nav-item">
      <a href="<%= ctx %>/systemUpdateAlert" class="nav-link">
        <i class="fa-solid fa-rotate"></i> System Update Alerts
        <% if (failedUpdates > 0) { %>
          <span class="nav-badge"><%= failedUpdates %></span>
        <% } %>
      </a>
    </li>
    <li class="nav-item">
      <a href="<%= ctx %>/fileIntegrityAlert" class="nav-link">
        <i class="fa-solid fa-file-shield"></i> File Integrity Monitor
        <% if (modifiedFiles > 0) { %>
          <span class="nav-badge"><%= modifiedFiles %></span>
        <% } %>
      </a>
    </li>
    <li class="nav-section-label">ACCOUNT</li>
    <li class="nav-item">
      <a href="<%= ctx %>/logout" class="nav-link">
        <i class="fa-solid fa-right-from-bracket"></i> Logout
      </a>
    </li>
  </ul>
  <div class="sidebar-footer">
    <div class="sidebar-user">
      <div class="user-avatar"><%= loggedUser.getFullName().substring(0,1).toUpperCase() %></div>
      <div class="user-info">
        <div class="user-name"><%= loggedUser.getFullName() %></div>
        <div class="user-role"><%= loggedUser.getRole().toUpperCase() %></div>
      </div>
    </div>
  </div>
</nav>

<!-- ── MAIN WRAPPER ── -->
<div class="main-wrapper" id="mainWrapper">

  <!-- Topbar -->
  <div class="topbar">
    <div style="display:flex;align-items:center;gap:14px;">
      <button id="sidebarToggle"><i class="fa-solid fa-bars"></i></button>
      <span class="topbar-title"><i class="fa-solid fa-gauge-high" style="margin-right:6px;"></i>DASHBOARD</span>
    </div>
    <div class="topbar-actions">
      <button class="topbar-btn">
        <i class="fa-solid fa-bell"></i>
        <span class="notif-dot"></span>
      </button>
      <button class="topbar-btn"><i class="fa-solid fa-gear"></i></button>
      <a href="<%= ctx %>/logout" class="topbar-btn" style="text-decoration:none;color:var(--text-dim);">
        <i class="fa-solid fa-right-from-bracket"></i>
      </a>
    </div>
  </div>

  <!-- Page Content -->
  <div class="page-content">

    <!-- Animated line -->
    <div class="cyber-line"></div>

    <!-- Welcome Banner -->
    <div class="welcome-banner">
      <h2 id="welcomeHeading" data-text="WELCOME BACK, <%= loggedUser.getFullName().toUpperCase() %>">
        WELCOME BACK, <%= loggedUser.getFullName().toUpperCase() %>
      </h2>
      <p><i class="fa-solid fa-circle" style="color:var(--green);font-size:0.6rem;"></i>
        &nbsp;All systems operational &nbsp;|&nbsp;
        Security monitoring active &nbsp;|&nbsp;
        <span style="color:var(--cyan);"><%= new java.util.Date() %></span>
      </p>
    </div>

    <!-- Stats Grid -->
    <div class="stats-grid">

      <div class="stat-card">
        <div class="stat-icon icon-cyan"><i class="fa-solid fa-database"></i></div>
        <div class="stat-number"><%= totalLogs %></div>
        <div class="stat-label">Total Access Logs</div>
        <div class="stat-sub">Unauthorized: <span><%= unauthorizedCount %></span></div>
      </div>

      <div class="stat-card">
        <div class="stat-icon icon-red"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="stat-number"><%= unauthorizedCount %></div>
        <div class="stat-label">Unauthorized Access</div>
        <div class="stat-sub">Requires immediate review</div>
      </div>

      <div class="stat-card">
        <div class="stat-icon icon-yellow"><i class="fa-solid fa-rotate"></i></div>
        <div class="stat-number"><%= totalUpdates %></div>
        <div class="stat-label">System Update Alerts</div>
        <div class="stat-sub">Failed: <span><%= failedUpdates %></span></div>
      </div>

      <div class="stat-card">
        <div class="stat-icon icon-purple"><i class="fa-solid fa-file-shield"></i></div>
        <div class="stat-number"><%= totalFileAlerts %></div>
        <div class="stat-label">File Integrity Alerts</div>
        <div class="stat-sub">Modified: <span><%= modifiedFiles %></span></div>
      </div>

    </div>

    <!-- Two-column: Recent Logs + Recent Updates -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;margin-bottom:24px;">

      <!-- Recent Access Logs -->
      <div class="cyber-panel">
        <div class="panel-header">
          <span class="panel-title"><i class="fa-solid fa-database"></i> Recent Access Logs</span>
          <a href="<%= ctx %>/dataAccessLog" style="color:var(--cyan);font-size:0.75rem;text-decoration:none;">
            View All <i class="fa-solid fa-arrow-right"></i>
          </a>
        </div>
        <table class="cyber-table">
          <thead>
            <tr><th>#</th><th>TYPE</th><th>MESSAGE</th></tr>
          </thead>
          <tbody>
            <% if (recentLogs != null) {
                 int shown = 0;
                 for (DataAccessLog log : recentLogs) {
                   if (shown++ >= 5) break;
                   String badgeClass = log.isUnauthorized() ? "badge-unauthorized" : "badge-authorized";
            %>
            <tr>
              <td style="color:var(--text-dim);"><%= log.getAccessId() %></td>
              <td><span class="badge-cyber <%= badgeClass %>">
                <span class="badge-dot"></span><%= log.getAccessType() %>
              </span></td>
              <td style="color:var(--text-dim);font-size:0.8rem;">
                <%= log.getMessage().length() > 35 ? log.getMessage().substring(0,35)+"…" : log.getMessage() %>
              </td>
            </tr>
            <% }} %>
          </tbody>
        </table>
      </div>

      <!-- Recent Update Alerts -->
      <div class="cyber-panel">
        <div class="panel-header">
          <span class="panel-title"><i class="fa-solid fa-rotate"></i> Recent Update Alerts</span>
          <a href="<%= ctx %>/systemUpdateAlert" style="color:var(--cyan);font-size:0.75rem;text-decoration:none;">
            View All <i class="fa-solid fa-arrow-right"></i>
          </a>
        </div>
        <table class="cyber-table">
          <thead>
            <tr><th>#</th><th>TYPE</th><th>MESSAGE</th></tr>
          </thead>
          <tbody>
            <% if (recentAlerts != null) {
                 int shown2 = 0;
                 for (SystemUpdateAlert alert : recentAlerts) {
                   if (shown2++ >= 5) break;
                   String bc = alert.isFailed() ? "badge-failed"
                             : "PENDING".equals(alert.getUpdateType()) ? "badge-pending" : "badge-success";
            %>
            <tr>
              <td style="color:var(--text-dim);"><%= alert.getUpdateId() %></td>
              <td><span class="badge-cyber <%= bc %>">
                <span class="badge-dot"></span><%= alert.getUpdateType() %>
              </span></td>
              <td style="color:var(--text-dim);font-size:0.8rem;">
                <%= alert.getMessage().length() > 35 ? alert.getMessage().substring(0,35)+"…" : alert.getMessage() %>
              </td>
            </tr>
            <% }} %>
          </tbody>
        </table>
      </div>

    </div>

    <!-- Recent File Integrity Alerts -->
    <div class="cyber-panel">
      <div class="panel-header">
        <span class="panel-title"><i class="fa-solid fa-file-shield"></i> Recent File Integrity Alerts</span>
        <a href="<%= ctx %>/fileIntegrityAlert" style="color:var(--cyan);font-size:0.75rem;text-decoration:none;">
          View All <i class="fa-solid fa-arrow-right"></i>
        </a>
      </div>
      <table class="cyber-table">
        <thead>
          <tr><th>#</th><th>TYPE</th><th>ABBR</th><th>DESCRIPTION</th></tr>
        </thead>
        <tbody>
          <% if (recentFileAlerts != null) {
               int shown3 = 0;
               for (FileIntegrityAlert fa : recentFileAlerts) {
                 if (shown3++ >= 5) break;
                 String bc = fa.isModified() ? "badge-modified"
                           : "DELETED".equals(fa.getAlertType()) ? "badge-unauthorized"
                           : "badge-created";
          %>
          <tr>
            <td style="color:var(--text-dim);"><%= fa.getAlertId() %></td>
            <td><span class="badge-cyber <%= bc %>">
              <span class="badge-dot"></span><%= fa.getAlertType() %>
            </span></td>
            <td style="color:var(--cyan);font-family:'Orbitron',monospace;font-size:0.75rem;">
              <%= fa.getAlertTypeAbbr() %>
            </td>
            <td style="color:var(--text-dim);font-size:0.8rem;">
              <%= fa.getDescription().length() > 50 ? fa.getDescription().substring(0,50)+"…" : fa.getDescription() %>
            </td>
          </tr>
          <% }} %>
        </tbody>
      </table>
    </div>

  </div><!-- /page-content -->
</div><!-- /main-wrapper -->

<!-- No particles script for simple UI -->
<script src="<%= ctx %>/js/cyber.js"></script>
</body>
</html>
