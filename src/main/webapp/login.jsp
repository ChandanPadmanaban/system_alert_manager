<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login | Cyber Security Monitoring System</title>
  <meta name="description" content="Secure login portal for the Cyber Security Monitoring System dashboard."/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/cyber.css"/>
  <style>
    .grid-bg {
      position:fixed; top:0; left:0; width:100%; height:100%;
      background-image:
        linear-gradient(rgba(0,245,255,0.04) 1px, transparent 1px),
        linear-gradient(90deg, rgba(0,245,255,0.04) 1px, transparent 1px);
      background-size:50px 50px; z-index:0; pointer-events:none;
    }
    .corner-decoration {
      position:absolute; width:60px; height:60px;
    }
    .corner-tl { top:16px; left:16px;
      border-top:2px solid var(--cyan); border-left:2px solid var(--cyan); }
    .corner-tr { top:16px; right:16px;
      border-top:2px solid var(--cyan); border-right:2px solid var(--cyan); }
    .corner-bl { bottom:16px; left:16px;
      border-bottom:2px solid var(--cyan); border-left:2px solid var(--cyan); }
    .corner-br { bottom:16px; right:16px;
      border-bottom:2px solid var(--cyan); border-right:2px solid var(--cyan); }
    .login-version {
      text-align:center; margin-top:20px;
      color:var(--text-dim); font-size:0.7rem; letter-spacing:2px;
    }
    .login-version span { color:var(--cyan); }
    .hex-bg {
      position:fixed; font-family:'Orbitron',monospace;
      font-size:0.65rem; color:rgba(0,245,255,0.06);
      white-space:pre; pointer-events:none; z-index:0;
      top:10%; left:2%; line-height:1.8;
    }
  </style>
</head>
<body>
  <!-- No particles for simple UI -->
  <div class="grid-bg"></div>
  <div class="scan-overlay"></div>

  <!-- Decorative hex code background -->
  <div class="hex-bg">
    01001000 01000001 01000011 01001011<br/>
    00110000 01110111 01001110 00100001<br/>
    11001001 00101011 10110010 01011010<br/>
    01000011 01011001 01000010 01000101<br/>
    01010010 01010011 01000101 01000011
  </div>

  <div class="login-wrapper">
    <div class="login-card">
      <!-- Corner decorations -->
      <div class="corner-decoration corner-tl"></div>
      <div class="corner-decoration corner-tr"></div>
      <div class="corner-decoration corner-bl"></div>
      <div class="corner-decoration corner-br"></div>

      <!-- Logo -->
      <div class="login-logo">
        <i class="fa-solid fa-shield-halved"></i>
      </div>

      <div class="login-title">CYBER SHIELD</div>
      <div class="login-subtitle">Security Monitoring System v2.0</div>

      <!-- Error Message -->
      <% String error = (String) request.getAttribute("error");
         if (error != null && !error.isEmpty()) { %>
        <div class="alert-cyber" id="loginError">
          <i class="fa-solid fa-triangle-exclamation"></i>
          <%= error %>
        </div>
      <% } %>

      <!-- Login Form -->
      <form action="<%= request.getContextPath() %>/login" method="post" id="loginForm">

        <!-- Username -->
        <div class="form-floating">
          <input type="text" id="username" name="username"
                 placeholder=" " autocomplete="off" required/>
          <label for="username"><i class="fa-solid fa-user" style="margin-right:6px;"></i>Username</label>
        </div>

        <!-- Password -->
        <div class="form-floating">
          <input type="password" id="password" name="password"
                 placeholder=" " required/>
          <label for="password"><i class="fa-solid fa-lock" style="margin-right:6px;"></i>Password</label>
        </div>

        <!-- Submit -->
        <button type="submit" class="btn-neon" id="loginBtn">
          <span id="btnText">
            <i class="fa-solid fa-terminal" style="margin-right:8px;"></i>ACCESS SYSTEM
          </span>
          <span class="cyber-spinner" id="loginSpinner">
            <span class="spinner-ring"></span>AUTHENTICATING...
          </span>
        </button>

      </form>

      <div class="login-version">
        SYSTEM STATUS: <span>ONLINE</span> &nbsp;|&nbsp; SECURITY: <span>ACTIVE</span>
      </div>
    </div>
  </div>

  <!-- No particles script for simple UI -->
  <script src="<%= request.getContextPath() %>/js/cyber.js"></script>
  <script>
    // Login spinner
    document.getElementById('loginForm').addEventListener('submit', function() {
      document.getElementById('btnText').style.display = 'none';
      document.getElementById('loginSpinner').style.display = 'flex';
      // document.getElementById('loginBtn').disabled = true; // Removed for simple UI
    });
    // Auto-hide error
    setTimeout(() => {
      const err = document.getElementById('loginError');
      if (err) { err.style.transition='opacity 0.6s'; err.style.opacity='0'; }
    }, 4000);
  </script>
</body>
</html>
