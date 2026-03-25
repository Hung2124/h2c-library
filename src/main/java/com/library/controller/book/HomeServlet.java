package com.library.controller.book;

import com.library.model.Category;
import com.library.repository.BookRepository;
import com.library.repository.CategoryRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet({"/home", ""})
public class HomeServlet extends HttpServlet {

    private final BookRepository bookRepo = new BookRepository();
    private final CategoryRepository categoryRepo = new CategoryRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setAttribute("newBooks", bookRepo.findNewBooks(8));
        req.setAttribute("mostBorrowed", bookRepo.findMostBorrowed(6));

        List<Category> categories = categoryRepo.findAll();
        Map<Category, List<?>> booksByCategory = new LinkedHashMap<>();
        for (Category cat : categories) {
            booksByCategory.put(cat, bookRepo.findByCategory(cat.getId(), 4));
        }
        req.setAttribute("categories", categories);
        req.setAttribute("booksByCategory", booksByCategory);

        req.getRequestDispatcher("/views/book/home.jsp").forward(req, res);
    }
}
