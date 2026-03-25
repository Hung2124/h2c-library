package com.library.controller.borrow;

import com.library.model.User;
import com.library.repository.BorrowRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/borrow/history")
public class BorrowHistoryServlet extends HttpServlet {

    private final BorrowRepository borrowRepo = new BorrowRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loggedUser = session != null ? (User) session.getAttribute("loggedUser") : null;
        if (loggedUser == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login?redirect=" + req.getRequestURI());
            return;
        }

        var history = borrowRepo.findByUserId(loggedUser.getId());
        req.setAttribute("history", history);
        req.getRequestDispatcher("/views/borrow/borrowHistory.jsp").forward(req, res);
    }
}
