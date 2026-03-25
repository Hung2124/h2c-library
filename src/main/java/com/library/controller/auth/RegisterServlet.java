package com.library.controller.auth;

import com.library.model.User;
import com.library.repository.UserRepository;
import com.library.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/auth/register")
public class RegisterServlet extends HttpServlet {

    private final UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm  = req.getParameter("confirmPassword");

        // Validation
        if (isBlank(fullName) || isBlank(email) || isBlank(password) || isBlank(confirm)) {
            req.setAttribute("error", "All fields are required.");
            forwardBack(req, res, fullName, email);
            return;
        }

        if (fullName.trim().length() < 2) {
            req.setAttribute("error", "Full name must be at least 2 characters.");
            forwardBack(req, res, fullName, email);
            return;
        }

        if (!email.trim().matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            req.setAttribute("error", "Invalid email format.");
            forwardBack(req, res, fullName, email);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            forwardBack(req, res, fullName, email);
            return;
        }

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            forwardBack(req, res, fullName, email);
            return;
        }

        if (userRepository.existsByEmail(email.trim().toLowerCase())) {
            req.setAttribute("error", "Email is already registered.");
            forwardBack(req, res, fullName, email);
            return;
        }

        User user = new User(fullName.trim(), email.trim().toLowerCase(),
                             PasswordUtil.hash(password), "MEMBER");
        userRepository.save(user);

        req.setAttribute("success", "Registration successful! Please login.");
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, res);
    }

    private void forwardBack(HttpServletRequest req, HttpServletResponse res,
                              String fullName, String email) throws ServletException, IOException {
        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.getRequestDispatcher("/views/auth/register.jsp").forward(req, res);
    }

    private boolean isBlank(String s) {
        return s == null || s.isBlank();
    }
}
