package com.cybersec.servlet;

import com.cybersec.dao.FileIntegrityAlertDAO;
import com.cybersec.model.FileIntegrityAlert;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * FileIntegrityAlertServlet - Controller for the File Integrity Monitor module.
 */
@WebServlet("/fileIntegrityAlert")
public class FileIntegrityAlertServlet extends HttpServlet {

    private final FileIntegrityAlertDAO dao = new FileIntegrityAlertDAO();

    // ----------------------------------------------------------------
    // GET — view alerts
    // ----------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req, resp)) return;

        String filter = req.getParameter("filter"); // "modified" or null
        String msg    = req.getParameter("msg");

        List<FileIntegrityAlert> alerts;
        if ("modified".equals(filter)) {
            alerts = dao.getModifiedAlerts();
            req.setAttribute("activeFilter", "modified");
        } else {
            alerts = dao.getAllAlerts();
            req.setAttribute("activeFilter", "all");
        }

        req.setAttribute("alerts",         alerts);
        req.setAttribute("totalCount",     dao.countAll());
        req.setAttribute("modifiedCount",  dao.countModified());
        if (msg != null) req.setAttribute("successMsg", msg);

        req.getRequestDispatcher("/fileIntegrityAlert.jsp").forward(req, resp);
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
            String alertType    = req.getParameter("alertType");
            String description  = req.getParameter("description");

            if (alertType != null && !alertType.trim().isEmpty()
                    && description != null && !description.trim().isEmpty()) {

                FileIntegrityAlert alert = new FileIntegrityAlert();
                alert.setAlertType(alertType.trim().toUpperCase());
                alert.setDescription(description.trim());

                boolean ok = dao.addAlert(alert);
                String msgParam = ok ? "Alert added successfully." : "Failed to add alert.";
                resp.sendRedirect(req.getContextPath() + "/fileIntegrityAlert?msg=" + encode(msgParam));
            } else {
                resp.sendRedirect(req.getContextPath() + "/fileIntegrityAlert?msg=Please+fill+all+fields.");
            }

        } else if ("delete".equals(action)) {
            String idStr = req.getParameter("alertId");
            try {
                int id = Integer.parseInt(idStr);
                boolean ok = dao.deleteAlert(id);
                String msgParam = ok ? "Alert deleted successfully." : "Delete failed.";
                resp.sendRedirect(req.getContextPath() + "/fileIntegrityAlert?msg=" + encode(msgParam));
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/fileIntegrityAlert?msg=Invalid+ID.");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/fileIntegrityAlert");
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
