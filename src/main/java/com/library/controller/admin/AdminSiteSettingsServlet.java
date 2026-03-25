package com.library.controller.admin;

import com.library.repository.SiteSettingRepository;
import com.library.util.SiteSettingsLoader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/settings", "/admin/settings/*"})
public class AdminSiteSettingsServlet extends HttpServlet {

    private final SiteSettingRepository repo = new SiteSettingRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path) || "/edit".equals(path)) {
            Map<String, String> m = repo.findAllAsMap();
            req.setAttribute("settings", m);
            req.getRequestDispatcher("/views/admin/settings.jsp").forward(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/admin/settings");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Map<String, String> updates = new LinkedHashMap<>();
        updates.put("footer_line1", nullToEmpty(req.getParameter("footer_line1")));
        updates.put("footer_line2", nullToEmpty(req.getParameter("footer_line2")));
        updates.put("footer_show_year", "on".equalsIgnoreCase(req.getParameter("footer_show_year")) ? "true" : "false");
        updates.put("mail_enabled", "on".equalsIgnoreCase(req.getParameter("mail_enabled")) ? "true" : "false");
        String maxRenew = req.getParameter("max_borrow_renewals");
        updates.put("max_borrow_renewals",
                (maxRenew != null && !maxRenew.isBlank()) ? maxRenew.trim() : "2");
        String renewDays = req.getParameter("renew_extend_days");
        updates.put("renew_extend_days",
                (renewDays != null && !renewDays.isBlank()) ? renewDays.trim() : "14");
        repo.saveAll(updates);
        SiteSettingsLoader.reload(getServletContext());
        res.sendRedirect(req.getContextPath() + "/admin/settings?success=saved");
    }

    private static String nullToEmpty(String s) {
        return s == null ? "" : s;
    }
}
