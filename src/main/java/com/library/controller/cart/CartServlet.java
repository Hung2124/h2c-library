package com.library.controller.cart;

import com.library.model.Book;
import com.library.model.Cart;
import com.library.repository.BookRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {

    private final BookRepository bookRepo = new BookRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path) || "/view".equals(path)) {
            Cart cart = getOrCreateCart(req);
            req.setAttribute("cart", cart);
            req.getRequestDispatcher("/views/cart/cart.jsp").forward(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/add"    -> handleAdd(req, res);
            case "/remove" -> handleRemove(req, res);
            case "/update" -> handleUpdate(req, res);
            case "/clear"  -> handleClear(req, res);
            default        -> res.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String bookIdStr = req.getParameter("bookId");
        if (bookIdStr == null) { res.sendRedirect(req.getContextPath() + "/books"); return; }

        Long bookId;
        try { bookId = Long.parseLong(bookIdStr); }
        catch (NumberFormatException e) { res.sendRedirect(req.getContextPath() + "/books"); return; }

        Optional<Book> bookOpt = bookRepo.findById(bookId);
        if (bookOpt.isEmpty() || !bookOpt.get().isAvailable()) {
            res.sendRedirect(req.getContextPath() + "/books/detail?id=" + bookId + "&error=unavailable");
            return;
        }

        Book book = bookOpt.get();
        Cart cart = getOrCreateCart(req);
        cart.addItem(bookId, book.getTitle(), book.getImage(), book.getAvailableQuantity());

        String referer = req.getHeader("Referer");
        res.sendRedirect(referer != null ? referer : req.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long bookId = parseLong(req.getParameter("bookId"));
        if (bookId != null) getOrCreateCart(req).removeItem(bookId);
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res) throws IOException {
        Long bookId = parseLong(req.getParameter("bookId"));
        Integer qty = parseInt(req.getParameter("quantity"));
        if (bookId != null && qty != null) getOrCreateCart(req).updateQuantity(bookId, qty);
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleClear(HttpServletRequest req, HttpServletResponse res) throws IOException {
        getOrCreateCart(req).clear();
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    private Cart getOrCreateCart(HttpServletRequest req) {
        HttpSession session = req.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private Long parseLong(String s) {
        if (s == null) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }

    private Integer parseInt(String s) {
        if (s == null) return null;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return null; }
    }
}
