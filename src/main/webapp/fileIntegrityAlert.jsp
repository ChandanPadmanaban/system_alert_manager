<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cybersec.model.User, com.cybersec.model.FileIntegrityAlert, java.util.List" %>
<%
  User loggedUser = (User) session.getAttribute("loggedUser");
  if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
  List<FileIntegrityAlert> alerts = (List<FileIntegrityAlert>) request.getAttribute("alerts");
  int totalCount   = (Integer) request.getAttribute("totalCount");
  int modifiedCount= (Integer) request.getAttribute("modifiedCount");
  String activeFilter = (String) request.getAttribute("activeFilter");
  String successMsg   = (String) request.getAttribute("successMsg");
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>File Integrity Monitor | Cyber Security Monitoring System</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <link rel="stylesheet" href="<%= ctx %>/css/cyber.css"/>
</head>
<body>
<!-- No particles for simple UI -->
<div class="scan-overlay"></div>

<!-- SIDEBAR -->
<nav class="sidebar" id="sidebar">
  <div class="sidebar-brand">
    <i class="fa-solid fa-shield-halved"></i>
    <div class="sidebar-brand-text">CYBER<br/>SHIELD</div>
  </div>
  <ul class="sidebar-nav" style="list-style:none;padding:16px 0;">
    <li class="nav-section-label">MAIN</li>
    <li class="nav-item"><a href="<%= ctx %>/dashboard" class="nav-link"><i class="fa-solid fa-gauge-high"></i> Dashboard</a></li>
    <li class="nav-section-label">MODULES</li>
    <li class="nav-item"><a href="<%= ctx %>/dataAccessLog" class="nav-link"><i class="fa-solid fa-database"></i> Data Access Logs</a></li>
    <li class="nav-item"><a href="<%= ctx %>/systemUpdateAlert" class="nav-link"><i class="fa-solid fa-rotate"></i> System Update Alerts</a></li>
    <li class="nav-item">
      <a href="<%= ctx %>/fileIntegrityAlert" class="nav-link active">
        <i class="fa-solid fa-file-shield"></i> File Integrity Monitor
        <% if (modifiedCount > 0) { %><span class="nav-badge"><%= modifiedCount %></span><% } %>
      </a>
    </li>
    <li class="nav-section-label">ACCOUNT</li>
    <li class="nav-item"><a href="<%= ctx %>/logout" class="nav-link"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
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

<!-- MAIN -->
<div class="main-wrapper" id="mainWrapper">
  <div class="topbar">
    <div style="display:flex;align-items:center;gap:14px;">
      <button id="sidebarToggle"><i class="fa-solid fa-bars"></i></button>
      <span class="topbar-title"><i class="fa-solid fa-file-shield" style="margin-right:6px;"></i>FILE INTEGRITY MONITOR</span>
    </div>
    <div class="topbar-actions">
      <a href="<%= ctx %>/logout" class="topbar-btn" style="text-decoration:none;color:var(--text-dim);">
        <i class="fa-solid fa-right-from-bracket"></i>
      </a>
    </div>
  </div>

  <div class="page-content">
    <div class="cyber-line"></div>

    <div class="page-header">
      <h1><i class="fa-solid fa-file-shield"></i> File Integrity Monitor</h1>
      <p>Detect and track unauthorized file modifications, deletions, and new file creation events.</p>
    </div>

    <!-- Success -->
    <% if (successMsg != null) { %>
    <div class="cyber-success" id="successAlert">
      <i class="fa-solid fa-circle-check"></i> <%= successMsg %>
    </div>
    <% } %>

    <!-- Mini Stats -->
    <div style="display:flex;gap:16px;margin-bottom:24px;flex-wrap:wrap;">
      <div class="stat-card" style="flex:1;min-width:150px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;"><%= totalCount %></div><div class="stat-label">Total Alerts</div></div>
          <i class="fa-solid fa-file-shield" style="font-size:1.8rem;color:var(--cyan);opacity:0.4;"></i>
        </div>
      </div>
      <div class="stat-card" style="flex:1;min-width:150px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;color:var(--red);"><%= modifiedCount %></div><div class="stat-label">Modified</div></div>
          <i class="fa-solid fa-file-pen" style="font-size:1.8rem;color:var(--red);opacity:0.4;"></i>
        </div>
      </div>
      <div class="stat-card" style="flex:1;min-width:150px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;color:var(--purple);">
            <%= totalCount - modifiedCount %>
          </div><div class="stat-label">Other Events</div></div>
          <i class="fa-solid fa-file-circle-exclamation" style="font-size:1.8rem;color:var(--purple);opacity:0.4;"></i>
        </div>
      </div>
    </div>

    <!-- Add Form -->
    <div class="cyber-form-card">
      <div class="panel-header">
        <span class="panel-title"><i class="fa-solid fa-plus"></i> ADD NEW FILE INTEGRITY ALERT</span>
      </div>
      <form action="<%= ctx %>/fileIntegrityAlert" method="post" id="addAlertForm">
        <input type="hidden" name="action" value="add"/>
        <div style="display:flex;gap:16px;flex-wrap:wrap;align-items:flex-end;">
          <div style="flex:0 0 200px;">
            <label class="form-label">Alert Type</label>
            <select name="alertType" class="cyber-select" required>
              <option value="" disabled selected>-- Select Type --</option>
              <option value="MODIFIED">MODIFIED</option>
              <option value="DELETED">DELETED</option>
              <option value="CREATED">CREATED</option>
            </select>
          </div>
          <div style="flex:1;min-width:250px;">
            <label class="form-label">Description</label>
            <input type="text" name="description" class="form-control cyber-input"
                   placeholder="Describe the file integrity event..." required/>
          </div>
          <div>
            <button type="submit" class="btn-cyber-primary">
              <i class="fa-solid fa-plus"></i> ADD ALERT
            </button>
          </div>
        </div>
      </form>
    </div>

    <!-- Filter -->
    <div style="display:flex;gap:10px;margin-bottom:16px;flex-wrap:wrap;">
      <a href="<%= ctx %>/fileIntegrityAlert" class="btn-cyber-filter <%= "all".equals(activeFilter) ? "active" : "" %>">
        <i class="fa-solid fa-list"></i> All Alerts (<%= totalCount %>)
      </a>
      <a href="<%= ctx %>/fileIntegrityAlert?filter=modified" class="btn-cyber-filter <%= "modified".equals(activeFilter) ? "active" : "" %>">
        <i class="fa-solid fa-file-pen"></i> Modified Only (<%= modifiedCount %>)
      </a>
    </div>

    <!-- Table -->
    <div class="cyber-panel">
      <div class="panel-header">
        <span class="panel-title">
          <i class="fa-solid fa-table-list"></i>
          <%= "modified".equals(activeFilter) ? "FILE MODIFICATION ALERTS" : "ALL FILE INTEGRITY ALERTS" %>
        </span>
        <span style="color:var(--text-dim);font-size:0.8rem;">Sorted by Alert ID (ASC)</span>
      </div>
      <div style="overflow-x:auto;">
        <table class="cyber-table">
          <thead>
            <tr>
              <th>ALERT ID</th>
              <th>ICON</th>
              <th>ABBR</th>
              <th>TYPE</th>
              <th>DESCRIPTION</th>
              <th>FORMATTED SUMMARY</th>
              <th>ACTION</th>
            </tr>
          </thead>
          <tbody>
            <% if (alerts == null || alerts.isEmpty()) { %>
            <tr>
              <td colspan="7" style="text-align:center;padding:40px;color:var(--text-dim);">
                <i class="fa-solid fa-inbox" style="font-size:2rem;display:block;margin-bottom:10px;"></i>
                No alerts found.
              </td>
            </tr>
            <% } else {
                 for (FileIntegrityAlert alert : alerts) {
                   String bc = alert.isModified() ? "badge-modified"
                             : "DELETED".equals(alert.getAlertType()) ? "badge-unauthorized" : "badge-created";
                   String iconClass = alert.isModified() ? "fa-file-pen"
                                    : "DELETED".equals(alert.getAlertType()) ? "fa-file-minus" : "fa-file-plus";
            %>
            <tr>
              <td style="font-family:'Orbitron',monospace;color:var(--cyan);">#<%= alert.getAlertId() %></td>
              <td style="text-align:center;">
                <span class="badge-cyber <%= bc %>" style="padding:6px 10px;">
                  <i class="fa-solid <%= iconClass %>"></i>
                </span>
              </td>
              <td>
                <span style="font-family:'Orbitron',monospace;font-size:0.75rem;color:var(--purple);
                             border:1px solid var(--purple);padding:2px 8px;border-radius:4px;">
                  <%= alert.getAlertTypeAbbr() %>
                </span>
              </td>
              <td><span class="badge-cyber <%= bc %>">
                <span class="badge-dot"></span><%= alert.getAlertType() %>
              </span></td>
              <td style="color:var(--text-dim);max-width:220px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                <%= alert.getDescription() %>
              </td>
              <td style="color:var(--text-dim);font-size:0.78rem;font-style:italic;max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                <%= alert.getFormattedSummary() %>
              </td>
              <td>
                <form action="<%= ctx %>/fileIntegrityAlert" method="post" style="display:inline;"
                      onsubmit="return confirmDelete();">
                  <input type="hidden" name="action" value="delete"/>
                  <input type="hidden" name="alertId" value="<%= alert.getAlertId() %>"/>
                  <button type="submit" class="btn-cyber-danger">
                    <i class="fa-solid fa-trash-can"></i> Delete
                  </button>
                </form>
              </td>
            </tr>
            <% }} %>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</div>

<!-- No particles script for simple UI -->
<script src="<%= ctx %>/js/cyber.js"></script>
<script>
function confirmDelete() {
  return confirm('⚠️ Permanently delete this file integrity alert?');
}
</script>
</body>
</html>
