package com.library.controller.favorite;

import com.library.model.User;
import com.library.repository.UserFavoriteRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/favorites/*")
public class FavoriteServlet extends HttpServlet {

    private final UserFavoriteRepository favRepo = new UserFavoriteRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        if (path == null) path = "/";

        if ("/".equals(path) || "/list".equals(path)) {
            HttpSession session = req.getSession(false);
            User u = session != null ? (User) session.getAttribute("loggedUser") : null;
            if (u == null) {
                res.sendRedirect(req.getContextPath() + "/auth/login?redirect=" + req.getRequestURI());
                return;
            }
            req.setAttribute("books", favRepo.findBooksByUserId(u.getId()));
            req.getRequestDispatcher("/views/favorites/list.jsp").forward(req, res);
            return;
        }
        res.sendRedirect(req.getContextPath() + "/favorites/list");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String path = req.getPathInfo();
        if (path != null && path.startsWith("/toggle")) {
            HttpSession session = req.getSession(false);
            User u = (User) session.getAttribute("loggedUser");
            Long bookId = parseLong(req.getParameter("bookId"));
            String back = req.getParameter("redirect");
            if (back == null || back.isBlank() || !back.startsWith("/")) {
                back = "/books";
            }
            if (bookId != null) {
                if (favRepo.exists(u.getId(), bookId)) {
                    favRepo.remove(u.getId(), bookId);
                } else {
                    favRepo.add(u.getId(), bookId);
                }
            }
            res.sendRedirect(req.getContextPath() + back);
            return;
        }
        res.sendRedirect(req.getContextPath() + "/favorites/list");
    }

    private Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s); } catch (NumberFormatException e) { return null; }
    }
}
