package com.library.controller.admin;

import com.library.model.Book;
import com.library.repository.AuthorRepository;
import com.library.repository.BookRepository;
import com.library.repository.CategoryRepository;
import com.library.repository.PublisherRepository;
import com.library.utils.FileUploadUtil;
import com.library.utils.PaginationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.persistence.PersistenceException;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/admin/books/*")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
public class AdminBookServlet extends HttpServlet {

    private final BookRepository bookRepo = new BookRepository();
    private final CategoryRepository categoryRepo = new CategoryRepository();
    private final AuthorRepository authorRepo = new AuthorRepository();
    private final PublisherRepository publisherRepo = new PublisherRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/", "/list" -> listBooks(req, res);
            case "/new"       -> showForm(req, res, null);
            case "/edit"      -> editBook(req, res);
            case "/delete"    -> deleteBook(req, res);
            default -> res.sendRedirect(req.getContextPath() + "/admin/books/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        if ("/save".equals(path)) {
            saveBook(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/admin/books/list");
        }
    }

    private void listBooks(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String catIdStr = req.getParameter("categoryId");
        String authorIdStr = req.getParameter("authorId");
        String pubIdStr = req.getParameter("publisherId");
        String yearStr = req.getParameter("publishYear");
        String language = req.getParameter("language");
        String availStr = req.getParameter("available");
        String sort = req.getParameter("sort");
        String statusFilter = req.getParameter("status");

        int page = PaginationUtil.safePage(req.getParameter("page"));
        int pageSize = 10;

        Long categoryId = parseLong(catIdStr);
        Long authorId = parseLong(authorIdStr);
        Long publisherId = parseLong(pubIdStr);
        Integer publishYear = parseInt(yearStr);
        Boolean available = "1".equals(availStr) ? Boolean.TRUE : null;
        String bookStatus = (statusFilter != null && !statusFilter.isBlank()) ? statusFilter : null;

        long total = bookRepo.countWithFilters(keyword, categoryId, authorId, publishYear, language,
                available, bookStatus, publisherId);
        int totalPages = PaginationUtil.getTotalPages(total, pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;

        int offset = PaginationUtil.getOffset(page, pageSize);
        var books = bookRepo.findWithFilters(keyword, categoryId, authorId, publishYear, language,
                available, bookStatus, publisherId, sort != null ? sort : "newest", offset, pageSize);

        req.setAttribute("books", books);
        req.setAttribute("categories", categoryRepo.findAll());
        req.setAttribute("authors", authorRepo.findAll());
        req.setAttribute("publishers", publisherRepo.findAll());
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalItems", total);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("selectedAuthorId", authorId);
        req.setAttribute("selectedPublisherId", publisherId);
        req.setAttribute("publishYear", publishYear);
        req.setAttribute("language", language);
        req.setAttribute("available", availStr);
        req.setAttribute("sort", sort);
        req.setAttribute("statusFilter", bookStatus);
        req.getRequestDispatcher("/views/admin/books/list.jsp").forward(req, res);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse res, Book book)
            throws ServletException, IOException {
        req.setAttribute("book", book);
        req.setAttribute("categories", categoryRepo.findAll());
        req.setAttribute("authors", authorRepo.findAll());
        req.setAttribute("publishers", publisherRepo.findAll());
        req.getRequestDispatcher("/views/admin/books/form.jsp").forward(req, res);
    }

    private void editBook(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        Long id = parseLong(req.getParameter("id"));
        if (id == null) { res.sendRedirect(req.getContextPath() + "/admin/books/list"); return; }
        Optional<Book> bookOpt = bookRepo.findById(id);
        if (bookOpt.isEmpty()) { res.sendRedirect(req.getContextPath() + "/admin/books/list"); return; }
        showForm(req, res, bookOpt.get());
    }

    private void deleteBook(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long id = parseLong(req.getParameter("id"));
        String base = req.getContextPath() + "/admin/books/list";
        if (id == null) {
            res.sendRedirect(base);
            return;
        }
        if (bookRepo.countBorrowDetailsByBookId(id) > 0) {
            res.sendRedirect(base + "?error=book_borrowed");
            return;
        }
        try {
            bookRepo.delete(id);
            res.sendRedirect(base + "?success=deleted");
        } catch (PersistenceException ex) {
            res.sendRedirect(base + "?error=delete_failed");
        }
    }

    private void saveBook(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        String title = req.getParameter("title");
        String yearStr = req.getParameter("publishYear");
        String language = req.getParameter("language");
        String qtyStr = req.getParameter("quantity");
        String aqtyStr = req.getParameter("availableQuantity");
        String description = req.getParameter("description");
        String status = req.getParameter("status");
        Long categoryId = parseLong(req.getParameter("categoryId"));
        Long authorId = parseLong(req.getParameter("authorId"));
        Long publisherId = parseLong(req.getParameter("publisherId"));

        if (title == null || title.isBlank()) {
            req.setAttribute("error", "Title is required.");
            showForm(req, res, null);
            return;
        }

        Book book;
        Long id = parseLong(idStr);
        if (id != null) {
            book = bookRepo.findById(id).orElse(new Book());
        } else {
            book = new Book();
        }

        book.setTitle(title.trim());
        book.setLanguage(language);
        book.setDescription(description);
        book.setStatus(status != null ? status : "AVAILABLE");
        if (yearStr != null && !yearStr.isBlank()) book.setPublishYear(Integer.parseInt(yearStr));
        if (qtyStr != null && !qtyStr.isBlank()) book.setQuantity(Integer.parseInt(qtyStr));
        if (aqtyStr != null && !aqtyStr.isBlank()) book.setAvailableQuantity(Integer.parseInt(aqtyStr));

        if (categoryId != null) {
            categoryRepo.findById(categoryId).ifPresent(book::setCategory);
        } else {
            book.setCategory(null);
        }
        if (authorId != null) {
            authorRepo.findById(authorId).ifPresent(book::setAuthor);
        } else {
            book.setAuthor(null);
        }
        if (publisherId != null) {
            publisherRepo.findById(publisherId).ifPresent(book::setPublisher);
        } else {
            book.setPublisher(null);
        }

        Part imagePart = req.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            String uploadDir = getServletContext().getRealPath("/assets/images/uploads");
            String fileName = FileUploadUtil.saveImage(imagePart, uploadDir);
            if (fileName != null) book.setImage(fileName);
        }

        bookRepo.save(book);
        res.sendRedirect(req.getContextPath() + "/admin/books/list?success=saved");
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
