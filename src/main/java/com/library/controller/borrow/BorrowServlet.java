package com.library.controller.borrow;

import com.library.model.*;
import com.library.repository.BookRepository;
import com.library.repository.BorrowRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/borrow/submit")
public class BorrowServlet extends HttpServlet {

    private final BorrowRepository borrowRepo = new BorrowRepository();
    private final BookRepository bookRepo = new BookRepository();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/cart?error=empty");
            return;
        }

        BorrowRequest request = new BorrowRequest(loggedUser);

        for (CartItem item : cart.getItems()) {
            Optional<Book> bookOpt = bookRepo.findById(item.getBookId());
            if (bookOpt.isEmpty()) continue;
            Book book = bookOpt.get();
            int qty = Math.min(item.getQuantity(), book.getAvailableQuantity());
            if (qty <= 0) continue;

            BorrowRequestDetail detail = new BorrowRequestDetail(request, book, qty);
            request.getDetails().add(detail);
        }

        if (request.getDetails().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/cart?error=unavailable");
            return;
        }

        borrowRepo.save(request);
        session.removeAttribute("cart");

        res.sendRedirect(req.getContextPath() + "/borrow/history?success=submitted");
    }
}
