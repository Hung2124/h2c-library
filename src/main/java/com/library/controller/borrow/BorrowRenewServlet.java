package com.library.controller.borrow;

import com.library.model.BorrowRequestDetail;
import com.library.model.User;
import com.library.repository.BorrowRepository;
import com.library.repository.SiteSettingRepository;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/borrow/renew")
public class BorrowRenewServlet extends HttpServlet {

    private final BorrowRepository borrowRepo = new BorrowRepository();
    private final SiteSettingRepository settingsRepo = new SiteSettingRepository();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        Long detailId = parseLong(req.getParameter("detailId"));
        String ctx = req.getContextPath();

        if (detailId == null) {
            res.sendRedirect(ctx + "/borrow/history?renewError=invalid");
            return;
        }

        var opt = borrowRepo.findDetailByIdForUser(detailId, user.getId());
        if (opt.isEmpty()) {
            res.sendRedirect(ctx + "/borrow/history?renewError=denied");
            return;
        }

        BorrowRequestDetail d = opt.get();
        var br = d.getBorrowRequest();
        if (!"APPROVED".equals(br.getStatus())) {
            res.sendRedirect(ctx + "/borrow/history?renewError=not_active");
            return;
        }
        if (!"BORROWING".equals(d.getStatus())) {
            res.sendRedirect(ctx + "/borrow/history?renewError=not_borrowing");
            return;
        }
        if (d.getDueDate() != null && d.getDueDate().isBefore(LocalDate.now())) {
            res.sendRedirect(ctx + "/borrow/history?renewError=overdue");
            return;
        }

        int maxRenew = parsePositiveInt(settingsRepo.getValue("max_borrow_renewals").orElse("2"), 2);
        int addDays = parsePositiveInt(settingsRepo.getValue("renew_extend_days").orElse("14"), 14);

        int current = d.getRenewalCount() != null ? d.getRenewalCount() : 0;
        if (current >= maxRenew) {
            res.sendRedirect(ctx + "/borrow/history?renewError=max");
            return;
        }

        LocalDate base = d.getDueDate() != null ? d.getDueDate() : LocalDate.now();
        d.setDueDate(base.plusDays(addDays));
        d.setRenewalCount(current + 1);
        borrowRepo.updateDetail(d);

        res.sendRedirect(ctx + "/borrow/history?renewSuccess=1");
    }

    private static Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }

    private static int parsePositiveInt(String s, int def) {
        try {
            int v = Integer.parseInt(s.trim());
            return v > 0 ? v : def;
        } catch (Exception e) {
            return def;
        }
    }
}
