package com.library.controller.admin;

import com.library.model.Author;
import com.library.repository.AuthorRepository;
import com.library.repository.BookRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/admin/authors/*")
public class AdminAuthorServlet extends HttpServlet {

    private final AuthorRepository authorRepo = new AuthorRepository();
    private final BookRepository bookRepo = new BookRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/", "/list" -> listAuthors(req, res);
            case "/new"       -> showForm(req, res, null);
            case "/edit"      -> editAuthor(req, res);
            case "/delete"    -> deleteAuthor(req, res);
            default -> res.sendRedirect(req.getContextPath() + "/admin/authors/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        if ("/save".equals(req.getPathInfo())) saveAuthor(req, res);
        else res.sendRedirect(req.getContextPath() + "/admin/authors/list");
    }

    private void listAuthors(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setAttribute("authors", authorRepo.findAll());
        req.getRequestDispatcher("/views/admin/authors/list.jsp").forward(req, res);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse res, Author author)
            throws ServletException, IOException {
        req.setAttribute("author", author);
        req.getRequestDispatcher("/views/admin/authors/form.jsp").forward(req, res);
    }

    private void editAuthor(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        Long id = parseLong(req.getParameter("id"));
        if (id == null) { res.sendRedirect(req.getContextPath() + "/admin/authors/list"); return; }
        Optional<Author> opt = authorRepo.findById(id);
        if (opt.isEmpty()) { res.sendRedirect(req.getContextPath() + "/admin/authors/list"); return; }
        showForm(req, res, opt.get());
    }

    private void deleteAuthor(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long id = parseLong(req.getParameter("id"));
        String base = req.getContextPath() + "/admin/authors/list";
        if (id == null) {
            res.sendRedirect(base);
            return;
        }
        if (bookRepo.countByAuthorId(id) > 0) {
            res.sendRedirect(base + "?error=author_in_use");
            return;
        }
        try {
            authorRepo.delete(id);
            res.sendRedirect(base + "?success=deleted");
        } catch (Exception ex) {
            res.sendRedirect(base + "?error=delete_failed");
        }
    }

    private void saveAuthor(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String bio  = req.getParameter("bio");
        Long id     = parseLong(req.getParameter("id"));

        if (name == null || name.isBlank()) {
            req.setAttribute("error", "Name is required.");
            showForm(req, res, null);
            return;
        }

        Author author = id != null ? authorRepo.findById(id).orElse(new Author()) : new Author();
        author.setName(name.trim());
        author.setBio(bio);
        authorRepo.save(author);
        res.sendRedirect(req.getContextPath() + "/admin/authors/list?success=saved");
    }

    private Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }
}
