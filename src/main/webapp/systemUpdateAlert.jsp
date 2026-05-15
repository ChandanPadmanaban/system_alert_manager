<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cybersec.model.User, com.cybersec.model.SystemUpdateAlert, java.util.List" %>
<%
  User loggedUser = (User) session.getAttribute("loggedUser");
  if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
  List<SystemUpdateAlert> alerts = (List<SystemUpdateAlert>) request.getAttribute("alerts");
  int totalCount   = (Integer) request.getAttribute("totalCount");
  int failedCount  = (Integer) request.getAttribute("failedCount");
  int pendingCount = (Integer) request.getAttribute("pendingCount");
  String activeFilter = (String) request.getAttribute("activeFilter");
  String successMsg   = (String) request.getAttribute("successMsg");
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>System Update Alerts | Cyber Security Monitoring System</title>
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
    <li class="nav-item">
      <a href="<%= ctx %>/systemUpdateAlert" class="nav-link active">
        <i class="fa-solid fa-rotate"></i> System Update Alerts
        <% if (failedCount > 0) { %><span class="nav-badge"><%= failedCount %></span><% } %>
      </a>
    </li>
    <li class="nav-item"><a href="<%= ctx %>/fileIntegrityAlert" class="nav-link"><i class="fa-solid fa-file-shield"></i> File Integrity Monitor</a></li>
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
      <span class="topbar-title"><i class="fa-solid fa-rotate" style="margin-right:6px;"></i>SYSTEM UPDATE ALERT MANAGER</span>
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
      <h1><i class="fa-solid fa-rotate"></i> System Update Alert Manager</h1>
      <p>Track system patch status, failed updates, and pending security patches.</p>
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
          <i class="fa-solid fa-rotate" style="font-size:1.8rem;color:var(--cyan);opacity:0.4;"></i>
        </div>
      </div>
      <div class="stat-card" style="flex:1;min-width:150px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;color:var(--red);"><%= failedCount %></div><div class="stat-label">Failed</div></div>
          <i class="fa-solid fa-xmark" style="font-size:1.8rem;color:var(--red);opacity:0.4;"></i>
        </div>
      </div>
      <div class="stat-card" style="flex:1;min-width:150px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;color:var(--yellow);"><%= pendingCount %></div><div class="stat-label">Pending</div></div>
          <i class="fa-solid fa-clock" style="font-size:1.8rem;color:var(--yellow);opacity:0.4;"></i>
        </div>
      </div>
      <div class="stat-card" style="flex:1;min-width:150px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;color:var(--green);"><%= totalCount - failedCount - pendingCount %></div><div class="stat-label">Success</div></div>
          <i class="fa-solid fa-circle-check" style="font-size:1.8rem;color:var(--green);opacity:0.4;"></i>
        </div>
      </div>
    </div>

    <!-- Add Form -->
    <div class="cyber-form-card">
      <div class="panel-header">
        <span class="panel-title"><i class="fa-solid fa-plus"></i> ADD NEW UPDATE ALERT</span>
      </div>
      <form action="<%= ctx %>/systemUpdateAlert" method="post" id="addAlertForm">
        <input type="hidden" name="action" value="add"/>
        <div style="display:flex;gap:16px;flex-wrap:wrap;align-items:flex-end;">
          <div style="flex:0 0 200px;">
            <label class="form-label">Update Type</label>
            <select name="updateType" class="cyber-select" required>
              <option value="" disabled selected>-- Select Type --</option>
              <option value="SUCCESS">SUCCESS</option>
              <option value="FAILED">FAILED</option>
              <option value="PENDING">PENDING</option>
            </select>
          </div>
          <div style="flex:1;min-width:250px;">
            <label class="form-label">Message</label>
            <input type="text" name="message" class="form-control cyber-input"
                   placeholder="Describe the update event..." required/>
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
      <a href="<%= ctx %>/systemUpdateAlert" class="btn-cyber-filter <%= "all".equals(activeFilter) ? "active" : "" %>">
        <i class="fa-solid fa-list"></i> All Alerts (<%= totalCount %>)
      </a>
      <a href="<%= ctx %>/systemUpdateAlert?filter=failed" class="btn-cyber-filter <%= "failed".equals(activeFilter) ? "active" : "" %>">
        <i class="fa-solid fa-xmark"></i> Failed Only (<%= failedCount %>)
      </a>
    </div>

    <!-- Table -->
    <div class="cyber-panel">
      <div class="panel-header">
        <span class="panel-title">
          <i class="fa-solid fa-table-list"></i>
          <%= "failed".equals(activeFilter) ? "FAILED UPDATE ALERTS" : "ALL UPDATE ALERTS" %>
        </span>
        <span style="color:var(--text-dim);font-size:0.8rem;">Sorted by Update ID (ASC)</span>
      </div>
      <div style="overflow-x:auto;">
        <table class="cyber-table">
          <thead>
            <tr>
              <th>UPDATE ID</th>
              <th>TYPE CODE</th>
              <th>TYPE</th>
              <th>MESSAGE</th>
              <th>FORMATTED SUMMARY</th>
              <th>ACTION</th>
            </tr>
          </thead>
          <tbody>
            <% if (alerts == null || alerts.isEmpty()) { %>
            <tr>
              <td colspan="6" style="text-align:center;padding:40px;color:var(--text-dim);">
                <i class="fa-solid fa-inbox" style="font-size:2rem;display:block;margin-bottom:10px;"></i>
                No alerts found.
              </td>
            </tr>
            <% } else {
                 for (SystemUpdateAlert alert : alerts) {
                   String bc = alert.isFailed() ? "badge-failed"
                             : "PENDING".equals(alert.getUpdateType()) ? "badge-pending" : "badge-success";
            %>
            <tr>
              <td style="font-family:'Orbitron',monospace;color:var(--cyan);">#<%= alert.getUpdateId() %></td>
              <td>
                <span style="font-family:'Orbitron',monospace;font-size:0.75rem;color:var(--purple);
                             border:1px solid var(--purple);padding:2px 8px;border-radius:4px;">
                  <%= alert.getUpdateTypeCode() %>
                </span>
              </td>
              <td><span class="badge-cyber <%= bc %>">
                <span class="badge-dot"></span><%= alert.getUpdateType() %>
              </span></td>
              <td style="color:var(--text-dim);max-width:260px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                <%= alert.getMessage() %>
              </td>
              <td style="color:var(--text-dim);font-size:0.78rem;font-style:italic;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                <%= alert.getFormattedSummary() %>
              </td>
              <td>
                <form action="<%= ctx %>/systemUpdateAlert" method="post" style="display:inline;"
                      onsubmit="return confirmDelete();">
                  <input type="hidden" name="action" value="delete"/>
                  <input type="hidden" name="updateId" value="<%= alert.getUpdateId() %>"/>
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
  return confirm('⚠️ Permanently delete this alert?');
}
</script>
</body>
</html>
