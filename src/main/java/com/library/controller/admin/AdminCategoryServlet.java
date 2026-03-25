package com.library.controller.admin;

import com.library.model.Category;
import com.library.repository.BookRepository;
import com.library.repository.CategoryRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/admin/categories/*")
public class AdminCategoryServlet extends HttpServlet {

    private final CategoryRepository categoryRepo = new CategoryRepository();
    private final BookRepository bookRepo = new BookRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/", "/list" -> listCategories(req, res);
            case "/new"       -> showForm(req, res, null);
            case "/edit"      -> editCategory(req, res);
            case "/delete"    -> deleteCategory(req, res);
            default -> res.sendRedirect(req.getContextPath() + "/admin/categories/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if ("/save".equals(req.getPathInfo())) saveCategory(req, res);
        else res.sendRedirect(req.getContextPath() + "/admin/categories/list");
    }

    private void listCategories(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setAttribute("categories", categoryRepo.findAll());
        req.getRequestDispatcher("/views/admin/categories/list.jsp").forward(req, res);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse res, Category cat)
            throws ServletException, IOException {
        req.setAttribute("category", cat);
        req.getRequestDispatcher("/views/admin/categories/form.jsp").forward(req, res);
    }

    private void editCategory(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        Long id = parseLong(req.getParameter("id"));
        if (id == null) { res.sendRedirect(req.getContextPath() + "/admin/categories/list"); return; }
        Optional<Category> opt = categoryRepo.findById(id);
        if (opt.isEmpty()) { res.sendRedirect(req.getContextPath() + "/admin/categories/list"); return; }
        showForm(req, res, opt.get());
    }

    private void deleteCategory(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long id = parseLong(req.getParameter("id"));
        String base = req.getContextPath() + "/admin/categories/list";
        if (id == null) {
            res.sendRedirect(base);
            return;
        }
        if (bookRepo.countByCategoryId(id) > 0) {
            res.sendRedirect(base + "?error=category_in_use");
            return;
        }
        try {
            categoryRepo.delete(id);
            res.sendRedirect(base + "?success=deleted");
        } catch (Exception ex) {
            res.sendRedirect(base + "?error=delete_failed");
        }
    }

    private void saveCategory(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name        = req.getParameter("name");
        String description = req.getParameter("description");
        Long id            = parseLong(req.getParameter("id"));

        if (name == null || name.isBlank()) {
            req.setAttribute("error", "Name is required.");
            showForm(req, res, null);
            return;
        }

        Category cat = id != null ? categoryRepo.findById(id).orElse(new Category()) : new Category();
        cat.setName(name.trim());
        cat.setDescription(description);
        categoryRepo.save(cat);
        res.sendRedirect(req.getContextPath() + "/admin/categories/list?success=saved");
    }

    private Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }
}
