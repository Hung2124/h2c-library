package com.library.controller.auth;

import com.library.model.User;
import com.library.repository.UserRepository;
import com.library.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/auth/login")
public class LoginServlet extends HttpServlet {

    private final UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Please enter email and password.");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, res);
            return;
        }

        Optional<User> userOpt = userRepository.findByEmail(email.trim().toLowerCase());

        if (userOpt.isEmpty() || !PasswordUtil.verify(password, userOpt.get().getPassword())) {
            req.setAttribute("error", "Invalid email or password.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, res);
            return;
        }

        User user = userOpt.get();

        if ("INACTIVE".equals(user.getStatus())) {
            req.setAttribute("error", "Your account is disabled. Please contact admin.");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, res);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("loggedUser", user);
        session.setMaxInactiveInterval(60 * 30); // 30 minutes

        String redirect = req.getParameter("redirect");
        if (redirect != null && !redirect.isBlank() && redirect.startsWith("/")) {
            res.sendRedirect(redirect);
        } else if (user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            res.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
