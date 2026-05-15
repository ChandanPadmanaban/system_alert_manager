package com.cybersec.servlet;

import com.cybersec.dao.DataAccessLogDAO;
import com.cybersec.model.DataAccessLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * DataAccessLogServlet - Controller for the Data Access Log Manager module.
 * Handles: view all, view unauthorized, add, delete.
 */
@WebServlet("/dataAccessLog")
public class DataAccessLogServlet extends HttpServlet {

    private final DataAccessLogDAO dao = new DataAccessLogDAO();

    // ----------------------------------------------------------------
    // GET — view logs
    // ----------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req, resp)) return;

        String filter = req.getParameter("filter"); // "unauthorized" or null
        String msg    = req.getParameter("msg");

        List<DataAccessLog> logs;
        if ("unauthorized".equals(filter)) {
            logs = dao.getUnauthorizedLogs();
            req.setAttribute("activeFilter", "unauthorized");
        } else {
            logs = dao.getAllLogs();
            req.setAttribute("activeFilter", "all");
        }

        req.setAttribute("logs",          logs);
        req.setAttribute("totalCount",    dao.countAll());
        req.setAttribute("unauthorizedCount", dao.countUnauthorized());
        if (msg != null) req.setAttribute("successMsg", msg);

        req.getRequestDispatcher("/dataAccessLog.jsp").forward(req, resp);
    }

    // ----------------------------------------------------------------
    // POST — add or delete
    // ----------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req, resp)) return;

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            String accessType = req.getParameter("accessType");
            String message    = req.getParameter("message");

            if (accessType != null && !accessType.trim().isEmpty()
                    && message != null && !message.trim().isEmpty()) {

                DataAccessLog log = new DataAccessLog();
                log.setAccessType(accessType.trim().toUpperCase());
                log.setMessage(message.trim());

                boolean ok = dao.addLog(log);
                String msgParam = ok ? "Log added successfully." : "Failed to add log.";
                resp.sendRedirect(req.getContextPath() + "/dataAccessLog?msg=" + encode(msgParam));
            } else {
                resp.sendRedirect(req.getContextPath() + "/dataAccessLog?msg=Please+fill+all+fields.");
            }

        } else if ("delete".equals(action)) {
            String idStr = req.getParameter("accessId");
            try {
                int id = Integer.parseInt(idStr);
                boolean ok = dao.deleteLog(id);
                String msgParam = ok ? "Log deleted successfully." : "Delete failed.";
                resp.sendRedirect(req.getContextPath() + "/dataAccessLog?msg=" + encode(msgParam));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/dataAccessLog?msg=Invalid+ID.");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/dataAccessLog");
        }
    }

    // ----------------------------------------------------------------
    // Helpers
    // ----------------------------------------------------------------
    private boolean isLoggedIn(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private String encode(String s) {
        try {
            return java.net.URLEncoder.encode(s, "UTF-8");
        } catch (java.io.UnsupportedEncodingException e) {
            return s;
        }
    }
}
