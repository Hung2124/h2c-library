package com.library.controller.book;

import com.library.repository.AuthorRepository;
import com.library.repository.BookRepository;
import com.library.repository.CategoryRepository;
import com.library.utils.PaginationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/books")
public class BookListServlet extends HttpServlet {

    private final BookRepository bookRepo = new BookRepository();
    private final CategoryRepository categoryRepo = new CategoryRepository();
    private final AuthorRepository authorRepo = new AuthorRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String keyword     = req.getParameter("keyword");
        String catIdStr    = req.getParameter("categoryId");
        String authorIdStr = req.getParameter("authorId");
        String yearStr     = req.getParameter("publishYear");
        String language    = req.getParameter("language");
        String availStr    = req.getParameter("available");
        String sort        = req.getParameter("sort");
        int page           = PaginationUtil.safePage(req.getParameter("page"));
        int pageSize       = PaginationUtil.DEFAULT_PAGE_SIZE;

        Long categoryId   = parseLong(catIdStr);
        Long authorId     = parseLong(authorIdStr);
        Integer publishYear = parseInt(yearStr);
        Boolean available  = "1".equals(availStr) ? Boolean.TRUE : null;

        long totalItems = bookRepo.countWithFilters(keyword, categoryId, authorId,
                                                     publishYear, language, available, null, null);
        int totalPages = PaginationUtil.getTotalPages(totalItems, pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;

        int offset = PaginationUtil.getOffset(page, pageSize);
        var books = bookRepo.findWithFilters(keyword, categoryId, authorId,
                                              publishYear, language, available,
                                              null, null,
                                              sort, offset, pageSize);

        req.setAttribute("books", books);
        req.setAttribute("categories", categoryRepo.findAll());
        req.setAttribute("authors", authorRepo.findAll());
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("selectedAuthorId", authorId);
        req.setAttribute("publishYear", publishYear);
        req.setAttribute("language", language);
        req.setAttribute("available", availStr);
        req.setAttribute("sort", sort);

        req.getRequestDispatcher("/views/book/bookList.jsp").forward(req, res);
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
