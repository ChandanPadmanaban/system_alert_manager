package com.cybersec.servlet;

import com.cybersec.dao.SystemUpdateAlertDAO;
import com.cybersec.model.SystemUpdateAlert;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * SystemUpdateAlertServlet - Controller for the System Update Alert Manager module.
 */
@WebServlet("/systemUpdateAlert")
public class SystemUpdateAlertServlet extends HttpServlet {

    private final SystemUpdateAlertDAO dao = new SystemUpdateAlertDAO();

    // ----------------------------------------------------------------
    // GET — view alerts
    // ----------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req, resp)) return;

        String filter = req.getParameter("filter"); // "failed" or null
        String msg    = req.getParameter("msg");

        List<SystemUpdateAlert> alerts;
        if ("failed".equals(filter)) {
            alerts = dao.getFailedAlerts();
            req.setAttribute("activeFilter", "failed");
        } else {
            alerts = dao.getAllAlerts();
            req.setAttribute("activeFilter", "all");
        }

        req.setAttribute("alerts",         alerts);
        req.setAttribute("totalCount",     dao.countAll());
        req.setAttribute("failedCount",    dao.countFailed());
        req.setAttribute("pendingCount",   dao.countPending());
        if (msg != null) req.setAttribute("successMsg", msg);

        req.getRequestDispatcher("/systemUpdateAlert.jsp").forward(req, resp);
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
            String updateType = req.getParameter("updateType");
            String message    = req.getParameter("message");

            if (updateType != null && !updateType.trim().isEmpty()
                    && message != null && !message.trim().isEmpty()) {

                SystemUpdateAlert alert = new SystemUpdateAlert();
                alert.setUpdateType(updateType.trim().toUpperCase());
                alert.setMessage(message.trim());

                boolean ok = dao.addAlert(alert);
                String msgParam = ok ? "Alert added successfully." : "Failed to add alert.";
                resp.sendRedirect(req.getContextPath() + "/systemUpdateAlert?msg=" + encode(msgParam));
            } else {
                resp.sendRedirect(req.getContextPath() + "/systemUpdateAlert?msg=Please+fill+all+fields.");
            }

        } else if ("delete".equals(action)) {
            String idStr = req.getParameter("updateId");
            try {
                int id = Integer.parseInt(idStr);
                boolean ok = dao.deleteAlert(id);
                String msgParam = ok ? "Alert deleted successfully." : "Delete failed.";
                resp.sendRedirect(req.getContextPath() + "/systemUpdateAlert?msg=" + encode(msgParam));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/systemUpdateAlert?msg=Invalid+ID.");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/systemUpdateAlert");
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
