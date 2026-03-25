package com.library.controller.admin;

import com.library.model.BorrowRequest;
import com.library.model.BorrowRequestDetail;
import com.library.model.User;
import com.library.repository.BorrowRepository;
import com.library.utils.PaginationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

@WebServlet("/admin/borrows/*")
public class AdminBorrowServlet extends HttpServlet {

    private static final BigDecimal FINE_PER_DAY = new BigDecimal("5000");

    private final BorrowRepository borrowRepo = new BorrowRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/", "/list" -> listRequests(req, res);
            case "/detail"    -> showDetail(req, res);
            default -> res.sendRedirect(req.getContextPath() + "/admin/borrows/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/approve" -> approveRequest(req, res);
            case "/reject"  -> rejectRequest(req, res);
            case "/return"  -> confirmReturn(req, res);
            default -> res.sendRedirect(req.getContextPath() + "/admin/borrows/list");
        }
    }

    private void listRequests(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String status = req.getParameter("status");
        int page = PaginationUtil.safePage(req.getParameter("page"));
        int pageSize = 10;
        long total = borrowRepo.countAll(status);
        int totalPages = PaginationUtil.getTotalPages(total, pageSize);
        int offset = PaginationUtil.getOffset(page, pageSize);

        req.setAttribute("requests", borrowRepo.findAll(status, offset, pageSize));
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalItems", total);
        req.setAttribute("statusFilter", status);
        req.getRequestDispatcher("/views/admin/borrow/list.jsp").forward(req, res);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        Long id = parseLong(req.getParameter("id"));
        if (id == null) { res.sendRedirect(req.getContextPath() + "/admin/borrows/list"); return; }
        Optional<BorrowRequest> opt = borrowRepo.findById(id);
        if (opt.isEmpty()) { res.sendRedirect(req.getContextPath() + "/admin/borrows/list"); return; }
        req.setAttribute("request", opt.get());
        req.getRequestDispatcher("/views/admin/borrow/detail.jsp").forward(req, res);
    }

    private void approveRequest(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long id = parseLong(req.getParameter("id"));
        Integer dueDays = parseInt(req.getParameter("dueDays"));
        if (dueDays == null || dueDays < 1) dueDays = 14;

        HttpSession session = req.getSession(false);
        User admin = (User) session.getAttribute("loggedUser");

        Optional<BorrowRequest> opt = borrowRepo.findById(id);
        if (opt.isPresent()) {
            BorrowRequest br = opt.get();
            br.setStatus("APPROVED");
            br.setApprovedBy(admin);
            br.setApprovedDate(java.time.LocalDateTime.now());
            LocalDate due = LocalDate.now().plusDays(dueDays);
            for (BorrowRequestDetail d : br.getDetails()) {
                d.setDueDate(due);
                d.setStatus("BORROWING");
            }
            borrowRepo.update(br);
        }
        res.sendRedirect(req.getContextPath() + "/admin/borrows/list?success=approved");
    }

    private void rejectRequest(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long id = parseLong(req.getParameter("id"));
        Optional<BorrowRequest> opt = borrowRepo.findById(id);
        if (opt.isPresent()) {
            BorrowRequest br = opt.get();
            br.setStatus("REJECTED");
            // Restore available quantity
            for (BorrowRequestDetail d : br.getDetails()) {
                d.getBook().setAvailableQuantity(
                        d.getBook().getAvailableQuantity() + d.getQuantity());
                d.setStatus("RETURNED");
            }
            borrowRepo.update(br);
        }
        res.sendRedirect(req.getContextPath() + "/admin/borrows/list?success=rejected");
    }

    private void confirmReturn(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long detailId = parseLong(req.getParameter("detailId"));
        Optional<BorrowRequestDetail> opt = borrowRepo.findDetailById(detailId);
        if (opt.isPresent()) {
            BorrowRequestDetail detail = opt.get();
            LocalDate returnDate = LocalDate.now();
            detail.setReturnDate(returnDate);
            detail.setStatus("RETURNED");

            // Calculate fine
            if (detail.getDueDate() != null && returnDate.isAfter(detail.getDueDate())) {
                long overdueDays = detail.getDueDate().until(returnDate, java.time.temporal.ChronoUnit.DAYS);
                BigDecimal fine = FINE_PER_DAY.multiply(BigDecimal.valueOf(overdueDays));
                detail.setFineAmount(fine);
            }

            // Restore available quantity
            detail.getBook().setAvailableQuantity(
                    detail.getBook().getAvailableQuantity() + detail.getQuantity());

            borrowRepo.updateDetail(detail);
        }
        res.sendRedirect(req.getContextPath() + "/admin/borrows/list?success=returned");
    }

    private Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }

    private Integer parseInt(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return null; }
    }
}
