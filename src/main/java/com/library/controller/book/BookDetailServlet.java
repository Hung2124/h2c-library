package com.library.controller.book;

import com.library.model.Book;
import com.library.model.User;
import com.library.repository.BookRepository;
import com.library.repository.BookReviewRepository;
import com.library.repository.UserFavoriteRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/books/detail")
public class BookDetailServlet extends HttpServlet {

    private final BookRepository bookRepo = new BookRepository();
    private final UserFavoriteRepository favRepo = new UserFavoriteRepository();
    private final BookReviewRepository reviewRepo = new BookReviewRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        Long bookId;
        try {
            bookId = Long.parseLong(idStr);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        Optional<Book> bookOpt = bookRepo.findById(bookId);
        if (bookOpt.isEmpty()) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
            return;
        }

        Book book = bookOpt.get();
        Long categoryId = book.getCategory() != null ? book.getCategory().getId() : null;
        Long authorId = book.getAuthor() != null ? book.getAuthor().getId() : null;

        req.setAttribute("book", book);
        req.setAttribute("similarBooks", bookRepo.findSimilar(bookId, categoryId, authorId, 4));
        req.setAttribute("reviews", reviewRepo.findByBookId(bookId));
        req.setAttribute("reviewAvg", reviewRepo.averageRating(bookId));
        req.setAttribute("reviewCount", reviewRepo.countByBookId(bookId));

        HttpSession session = req.getSession(false);
        User logged = session != null ? (User) session.getAttribute("loggedUser") : null;
        if (logged != null) {
            req.setAttribute("isFavorite", favRepo.exists(logged.getId(), bookId));
            req.setAttribute("canReview", reviewRepo.hasUserEligibleToReview(logged.getId(), bookId));
            req.setAttribute("myReview", reviewRepo.findByUserAndBook(logged.getId(), bookId).orElse(null));
        } else {
            req.setAttribute("isFavorite", false);
            req.setAttribute("canReview", false);
            req.setAttribute("myReview", null);
        }

        req.getRequestDispatcher("/views/book/bookDetail.jsp").forward(req, res);
    }
}
