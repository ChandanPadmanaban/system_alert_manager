# 🛡️ Cyber Security Monitoring System

A **futuristic 3D cybersecurity dashboard** built with Java Servlets, JSP, JDBC, MySQL, and a stunning cyberpunk UI.

---

## 🖥️ Technology Stack

| Layer      | Technology                                    |
|------------|-----------------------------------------------|
| Language   | Java 11+                                      |
| Server     | Apache Tomcat 9+                              |
| Database   | MySQL 8+                                      |
| JDBC Driver| mysql-connector-java 8.0.33                   |
| Frontend   | HTML5, CSS3, Bootstrap 5, JavaScript          |
| Icons      | Font Awesome 6                                |
| Animations | Particles.js, CSS keyframes, 3D transforms    |
| Build      | Manual (IDE based) or Ant                    |

---

## 📁 Project Structure

```
CyberSecurityMonitoringSystem/
├── cyber_monitoring_system.sql
└── src/main/
    ├── java/com/cybersec/
    │   ├── model/
    │   │   ├── User.java
    │   │   ├── DataAccessLog.java
    │   │   ├── SystemUpdateAlert.java
    │   │   └── FileIntegrityAlert.java
    │   ├── dao/
    │   │   ├── UserDAO.java
    │   │   ├── DataAccessLogDAO.java
    │   │   ├── SystemUpdateAlertDAO.java
    │   │   └── FileIntegrityAlertDAO.java
    │   ├── servlet/
    │   │   ├── LoginServlet.java
    │   │   ├── LogoutServlet.java
    │   │   ├── DashboardServlet.java
    │   │   ├── DataAccessLogServlet.java
    │   │   ├── SystemUpdateAlertServlet.java
    │   │   └── FileIntegrityAlertServlet.java
    │   └── utility/
    │       └── DBConnection.java
    └── webapp/
        ├── WEB-INF/web.xml
        ├── css/cyber.css
        ├── js/cyber.js
        ├── login.jsp
        ├── dashboard.jsp
        ├── dataAccessLog.jsp
        ├── systemUpdateAlert.jsp
        └── fileIntegrityAlert.jsp
```

---

## ⚙️ Setup Instructions (Standalone Local Run)

This project has been configured to run **standalone** without needing a separate MySQL server or Apache Tomcat installation. It uses an **embedded H2 Database** (in-memory) and **Jetty Runner**.

### Prerequisites
- **Java Runtime (JRE/JDK) 8 or higher**

---

### Step 1 — Database Initialization
The system automatically initializes its database from `cyber_monitoring_system.sql` on startup. No manual SQL import is required.

---

### Step 2 — Run in VS Code / Terminal

You can run the application directly from the VS Code terminal:

1. Open the project folder in VS Code.
2. Open a new Terminal (`Ctrl + ``).
3. Run the following command:

```bash
java -jar jetty-runner.jar --port 8080 src/main/webapp
```

4. Alternatively, just double-click the `run.bat` file in the project root.

---

### Step 3 — Access the Dashboard

Once the server starts, open your browser and go to:
**[http://localhost:8080/](http://localhost:8080/)**

---

## 🔐 Default Login

| Field    | Value  |
|----------|--------|
| Username | admin  |
| Password | admin123 |


---

## 📋 Modules

### 1. Data Access Log Manager (`/dataAccessLog`)
- Add AUTHORIZED / UNAUTHORIZED access logs
- View all logs sorted by `access_id`
- Filter to show only UNAUTHORIZED logs
- Uses `substring()` for short code, `StringBuffer` for formatted summary
- Delete individual logs

### 2. System Update Alert Manager (`/systemUpdateAlert`)
- Add SUCCESS / FAILED / PENDING update alerts
- View all alerts sorted by `update_id`
- Filter to show only FAILED updates
- Uses `substring()` for type code, `StringBuffer` for formatted summary
- Delete individual alerts

### 3. File Integrity Monitor (`/fileIntegrityAlert`)
- Add MODIFIED / DELETED / CREATED file alerts
- View all alerts sorted by `alert_id`
- Filter to show only MODIFIED file alerts
- Uses `substring()` for icon code & abbreviation, `StringBuffer` for formatted summary
- Delete individual alerts

---

## 🎨 UI Features

- 🌑 Dark cyberpunk theme (black, dark blue, neon cyan, purple)
- 💎 Glassmorphism panels with backdrop-blur
- 🔮 3D floating cards with mouse-tilt effect
- ✨ Neon glow on text, buttons, borders
- 🌊 Animated particles background (Particles.js)
- 📡 Scan-line overlay animation
- 🔄 Count-up animation on stat numbers
- 📱 Fully responsive (mobile sidebar toggle)
- ⚡ Smooth hover transitions throughout

---

## 🗄️ Database Tables

```sql
users              (id, username, password, full_name, role)
data_access_logs   (access_id, access_type, message, created_at)
system_update_alerts (update_id, update_type, message, created_at)
file_integrity_alerts (alert_id, alert_type, description, created_at)
```

---

## 🛠️ Troubleshooting

| Problem | Solution |
|---------|----------|
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | Add MySQL connector JAR to Tomcat lib or rebuild with Maven |
| `Access denied for user 'root'@'localhost'` | Update credentials in `DBConnection.java` |
| `HTTP 404` on `/login` | Ensure context path matches WAR name |
| Tables not found | Run `cyber_monitoring_system.sql` in MySQL first |
| Port conflict | Change Tomcat port in `server.xml` or IDE config |
