package com.library.controller.admin;

import com.library.model.User;
import com.library.repository.UserRepository;
import com.library.utils.PaginationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/admin/users/*")
public class AdminUserServlet extends HttpServlet {

    private final UserRepository userRepo = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/", "/list" -> listUsers(req, res);
            default -> res.sendRedirect(req.getContextPath() + "/admin/users/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/update".equals(path)) updateUser(req, res);
        else res.sendRedirect(req.getContextPath() + "/admin/users/list");
    }

    private void listUsers(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        int page = PaginationUtil.safePage(req.getParameter("page"));
        int pageSize = 15;
        long total = userRepo.count();
        int totalPages = PaginationUtil.getTotalPages(total, pageSize);
        int offset = PaginationUtil.getOffset(page, pageSize);

        req.setAttribute("users", userRepo.findAll(offset, pageSize));
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalItems", total);
        req.getRequestDispatcher("/views/admin/users/list.jsp").forward(req, res);
    }

    private void updateUser(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long id     = parseLong(req.getParameter("id"));
        String role = req.getParameter("role");
        String status = req.getParameter("status");

        if (id != null) {
            Optional<User> opt = userRepo.findById(id);
            opt.ifPresent(u -> {
                if (role != null) u.setRole(role);
                if (status != null) u.setStatus(status);
                userRepo.save(u);
            });
        }
        res.sendRedirect(req.getContextPath() + "/admin/users/list?success=updated");
    }

    private Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }
}
