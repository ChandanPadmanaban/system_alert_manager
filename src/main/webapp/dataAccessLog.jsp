<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cybersec.model.User, com.cybersec.model.DataAccessLog, java.util.List" %>
<%
  User loggedUser = (User) session.getAttribute("loggedUser");
  if (loggedUser == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
  List<DataAccessLog> logs = (List<DataAccessLog>) request.getAttribute("logs");
  int totalCount       = (Integer) request.getAttribute("totalCount");
  int unauthorizedCount= (Integer) request.getAttribute("unauthorizedCount");
  String activeFilter  = (String)  request.getAttribute("activeFilter");
  String successMsg    = (String)  request.getAttribute("successMsg");
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Data Access Logs | Cyber Security Monitoring System</title>
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
    <li class="nav-item"><a href="<%= ctx %>/dataAccessLog" class="nav-link active"><i class="fa-solid fa-database"></i> Data Access Logs<% if(unauthorizedCount>0){%><span class="nav-badge"><%=unauthorizedCount%></span><%}%></a></li>
    <li class="nav-item"><a href="<%= ctx %>/systemUpdateAlert" class="nav-link"><i class="fa-solid fa-rotate"></i> System Update Alerts</a></li>
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
      <span class="topbar-title"><i class="fa-solid fa-database" style="margin-right:6px;"></i>DATA ACCESS LOG MANAGER</span>
    </div>
    <div class="topbar-actions">
      <a href="<%= ctx %>/logout" class="topbar-btn" style="text-decoration:none;color:var(--text-dim);">
        <i class="fa-solid fa-right-from-bracket"></i>
      </a>
    </div>
  </div>

  <div class="page-content">
    <div class="cyber-line"></div>

    <!-- Page Header -->
    <div class="page-header">
      <h1><i class="fa-solid fa-database"></i> Data Access Log Manager</h1>
      <p>Monitor, record and audit all data access events in the system.</p>
    </div>

    <!-- Success Message -->
    <% if (successMsg != null) { %>
    <div class="cyber-success" id="successAlert">
      <i class="fa-solid fa-circle-check"></i> <%= successMsg %>
    </div>
    <% } %>

    <!-- Stats Mini Row -->
    <div style="display:flex;gap:16px;margin-bottom:24px;flex-wrap:wrap;">
      <div class="stat-card" style="flex:1;min-width:160px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;"><%= totalCount %></div><div class="stat-label">Total Logs</div></div>
          <i class="fa-solid fa-database" style="font-size:1.8rem;color:var(--cyan);opacity:0.4;"></i>
        </div>
      </div>
      <div class="stat-card" style="flex:1;min-width:160px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;color:var(--red);"><%= unauthorizedCount %></div><div class="stat-label">Unauthorized</div></div>
          <i class="fa-solid fa-ban" style="font-size:1.8rem;color:var(--red);opacity:0.4;"></i>
        </div>
      </div>
      <div class="stat-card" style="flex:1;min-width:160px;padding:16px 20px;">
        <div style="display:flex;align-items:center;justify-content:space-between;">
          <div><div class="stat-number" style="font-size:1.6rem;color:var(--green);"><%= totalCount - unauthorizedCount %></div><div class="stat-label">Authorized</div></div>
          <i class="fa-solid fa-circle-check" style="font-size:1.8rem;color:var(--green);opacity:0.4;"></i>
        </div>
      </div>
    </div>

    <!-- Add Log Form -->
    <div class="cyber-form-card">
      <div class="panel-header">
        <span class="panel-title"><i class="fa-solid fa-plus"></i> ADD NEW ACCESS LOG</span>
      </div>
      <form action="<%= ctx %>/dataAccessLog" method="post" id="addLogForm">
        <input type="hidden" name="action" value="add"/>
        <div style="display:flex;gap:16px;flex-wrap:wrap;align-items:flex-end;">
          <div style="flex:0 0 200px;">
            <label class="form-label">Access Type</label>
            <select name="accessType" class="cyber-select" required id="accessTypeSelect">
              <option value="" disabled selected>-- Select Type --</option>
              <option value="AUTHORIZED">AUTHORIZED</option>
              <option value="UNAUTHORIZED">UNAUTHORIZED</option>
            </select>
          </div>
          <div style="flex:1;min-width:250px;">
            <label class="form-label">Message</label>
            <input type="text" name="message" class="form-control cyber-input"
                   placeholder="Describe the access event..." required id="messageInput"/>
          </div>
          <div>
            <button type="submit" class="btn-cyber-primary" id="addBtn">
              <i class="fa-solid fa-plus"></i> ADD LOG
            </button>
          </div>
        </div>
      </form>
    </div>

    <!-- Filter Buttons -->
    <div style="display:flex;gap:10px;margin-bottom:16px;flex-wrap:wrap;">
      <a href="<%= ctx %>/dataAccessLog" class="btn-cyber-filter <%= "all".equals(activeFilter) ? "active" : "" %>">
        <i class="fa-solid fa-list"></i> All Logs (<%= totalCount %>)
      </a>
      <a href="<%= ctx %>/dataAccessLog?filter=unauthorized" class="btn-cyber-filter <%= "unauthorized".equals(activeFilter) ? "active" : "" %>">
        <i class="fa-solid fa-ban"></i> Unauthorized Only (<%= unauthorizedCount %>)
      </a>
    </div>

    <!-- Logs Table -->
    <div class="cyber-panel">
      <div class="panel-header">
        <span class="panel-title">
          <i class="fa-solid fa-table-list"></i>
          <%= "unauthorized".equals(activeFilter) ? "UNAUTHORIZED ACCESS LOGS" : "ALL ACCESS LOGS" %>
        </span>
        <span style="color:var(--text-dim);font-size:0.8rem;">Sorted by ID (ASC)</span>
      </div>
      <div style="overflow-x:auto;">
        <table class="cyber-table">
          <thead>
            <tr>
              <th>ACCESS ID</th>
              <th>SHORT CODE</th>
              <th>TYPE</th>
              <th>MESSAGE</th>
              <th>FORMATTED SUMMARY</th>
              <th>ACTION</th>
            </tr>
          </thead>
          <tbody>
            <% if (logs == null || logs.isEmpty()) { %>
            <tr>
              <td colspan="6" style="text-align:center;padding:40px;color:var(--text-dim);">
                <i class="fa-solid fa-inbox" style="font-size:2rem;display:block;margin-bottom:10px;"></i>
                No logs found.
              </td>
            </tr>
            <% } else {
                 for (DataAccessLog log : logs) {
                   String badgeClass = log.isUnauthorized() ? "badge-unauthorized" : "badge-authorized";
            %>
            <tr>
              <td style="font-family:'Orbitron',monospace;color:var(--cyan);">#<%= log.getAccessId() %></td>
              <td>
                <span style="font-family:'Orbitron',monospace;font-size:0.75rem;color:var(--purple);
                             border:1px solid var(--purple);padding:2px 8px;border-radius:4px;">
                  <%= log.getAccessTypeShortCode() %>
                </span>
              </td>
              <td><span class="badge-cyber <%= badgeClass %>">
                <span class="badge-dot"></span><%= log.getAccessType() %>
              </span></td>
              <td style="color:var(--text-dim);max-width:250px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                <%= log.getMessage() %>
              </td>
              <td style="color:var(--text-dim);font-size:0.78rem;font-style:italic;max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                <%= log.getFormattedSummary() %>
              </td>
              <td>
                <form action="<%= ctx %>/dataAccessLog" method="post" style="display:inline;"
                      onsubmit="return confirmDelete();">
                  <input type="hidden" name="action" value="delete"/>
                  <input type="hidden" name="accessId" value="<%= log.getAccessId() %>"/>
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
  return confirm('⚠️ Permanently delete this log entry?');
}
</script>
</body>
</html>
