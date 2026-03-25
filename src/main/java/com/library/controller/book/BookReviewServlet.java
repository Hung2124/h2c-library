package com.library.controller.book;

import com.library.model.BookReview;
import com.library.model.User;
import com.library.repository.BookRepository;
import com.library.repository.BookReviewRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/books/review")
public class BookReviewServlet extends HttpServlet {

    private final BookReviewRepository reviewRepo = new BookReviewRepository();
    private final BookRepository bookRepo = new BookRepository();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        Long bookId = parseLong(req.getParameter("bookId"));
        String redirect = req.getParameter("redirect");
        if (redirect == null || redirect.isBlank()) {
            redirect = bookId != null ? "/books/detail?id=" + bookId : "/books";
        }

        if (bookId == null) {
            res.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        String q = redirect.contains("?") ? "&" : "?";

        if (!reviewRepo.hasUserEligibleToReview(user.getId(), bookId)) {
            res.sendRedirect(req.getContextPath() + redirect + q + "reviewError=not_eligible");
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(req.getParameter("rating"));
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + redirect + q + "reviewError=invalid");
            return;
        }
        if (rating < 1 || rating > 5) {
            res.sendRedirect(req.getContextPath() + redirect + q + "reviewError=invalid");
            return;
        }

        String comment = req.getParameter("comment");
        if (comment != null && comment.length() > 5000) {
            comment = comment.substring(0, 5000);
        }

        var bookOpt = bookRepo.findById(bookId);
        if (bookOpt.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/books");
            return;
        }

        BookReview r = reviewRepo.findByUserAndBook(user.getId(), bookId).orElse(new BookReview());
        r.setUser(user);
        r.setBook(bookOpt.get());
        r.setRating(rating);
        r.setComment(comment);
        reviewRepo.save(r);

        res.sendRedirect(req.getContextPath() + redirect + q + "reviewSuccess=1");
    }

    private Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }
}
