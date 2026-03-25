package com.library.controller.admin;

import com.library.model.Publisher;
import com.library.repository.PublisherRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/admin/publishers/*")
public class AdminPublisherServlet extends HttpServlet {

    private final PublisherRepository publisherRepo = new PublisherRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/", "/list" -> list(req, res);
            case "/new"       -> showForm(req, res, null);
            case "/edit"      -> edit(req, res);
            case "/delete"    -> delete(req, res);
            default -> res.sendRedirect(req.getContextPath() + "/admin/publishers/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        if ("/save".equals(req.getPathInfo())) save(req, res);
        else res.sendRedirect(req.getContextPath() + "/admin/publishers/list");
    }

    private void list(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("publishers", publisherRepo.findAll());
        req.getRequestDispatcher("/views/admin/publishers/list.jsp").forward(req, res);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse res, Publisher p)
            throws ServletException, IOException {
        req.setAttribute("publisher", p);
        req.getRequestDispatcher("/views/admin/publishers/form.jsp").forward(req, res);
    }

    private void edit(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Long id = parseLong(req.getParameter("id"));
        if (id == null) { res.sendRedirect(req.getContextPath() + "/admin/publishers/list"); return; }
        Optional<Publisher> opt = publisherRepo.findById(id);
        if (opt.isEmpty()) { res.sendRedirect(req.getContextPath() + "/admin/publishers/list"); return; }
        showForm(req, res, opt.get());
    }

    private void delete(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long id = parseLong(req.getParameter("id"));
        String base = req.getContextPath() + "/admin/publishers/list";
        if (id == null) {
            res.sendRedirect(base);
            return;
        }
        if (publisherRepo.countBooksByPublisherId(id) > 0) {
            res.sendRedirect(base + "?error=publisher_in_use");
            return;
        }
        try {
            publisherRepo.delete(id);
            res.sendRedirect(base + "?success=deleted");
        } catch (Exception ex) {
            res.sendRedirect(base + "?error=delete_failed");
        }
    }

    private void save(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String name = req.getParameter("name");
        String note = req.getParameter("note");
        Long id = parseLong(req.getParameter("id"));
        String listUrl = req.getContextPath() + "/admin/publishers/list";

        if (name == null || name.isBlank()) {
            req.setAttribute("error", "Tên nhà xuất bản là bắt buộc.");
            showForm(req, res, null);
            return;
        }

        String trimmed = name.trim();
        Publisher p = id != null ? publisherRepo.findById(id).orElse(null) : new Publisher();
        if (id != null && p == null) {
            res.sendRedirect(listUrl + "?error=not_found");
            return;
        }

        Optional<Publisher> existing = publisherRepo.findByName(trimmed);
        if (existing.isPresent()) {
            if (p.getId() == null) {
                res.sendRedirect(listUrl + "?error=duplicate_name");
                return;
            }
            if (!existing.get().getId().equals(p.getId())) {
                try {
                    publisherRepo.mergePublisherInto(p.getId(), existing.get().getId());
                    res.sendRedirect(listUrl + "?success=merged");
                } catch (Exception ex) {
                    res.sendRedirect(listUrl + "?error=merge_failed");
                }
                return;
            }
        }

        p.setName(trimmed);
        p.setNote(note);
        try {
            publisherRepo.save(p);
            res.sendRedirect(listUrl + "?success=saved");
        } catch (Exception ex) {
            res.sendRedirect(listUrl + "?error=save_failed");
        }
    }

    private Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }
}
