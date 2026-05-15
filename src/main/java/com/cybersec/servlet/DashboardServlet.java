package com.cybersec.servlet;

import com.cybersec.dao.DataAccessLogDAO;
import com.cybersec.dao.FileIntegrityAlertDAO;
import com.cybersec.dao.SystemUpdateAlertDAO;
import com.cybersec.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * DashboardServlet - Loads summary statistics and recent alerts for the main dashboard.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DataAccessLogDAO    dalDAO  = new DataAccessLogDAO();
    private final SystemUpdateAlertDAO suaDAO  = new SystemUpdateAlertDAO();
    private final FileIntegrityAlertDAO fiaDAO = new FileIntegrityAlertDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        // Load statistics
        req.setAttribute("totalLogs",          dalDAO.countAll());
        req.setAttribute("unauthorizedCount",  dalDAO.countUnauthorized());
        req.setAttribute("totalUpdates",       suaDAO.countAll());
        req.setAttribute("failedUpdates",      suaDAO.countFailed());
        req.setAttribute("pendingUpdates",     suaDAO.countPending());
        req.setAttribute("totalFileAlerts",    fiaDAO.countAll());
        req.setAttribute("modifiedFiles",      fiaDAO.countModified());

        // Recent items (last 5 of each)
        req.setAttribute("recentLogs",         dalDAO.getAllLogs());
        req.setAttribute("recentAlerts",       suaDAO.getAllAlerts());
        req.setAttribute("recentFileAlerts",   fiaDAO.getAllAlerts());
        req.setAttribute("loggedUser",         user);

        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}
