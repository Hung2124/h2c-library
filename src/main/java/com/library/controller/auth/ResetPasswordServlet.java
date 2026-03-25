package com.library.controller.auth;

import com.library.repository.UserRepository;
import com.library.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/auth/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserRepository userRepo = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String token = req.getParameter("token");
        if (token == null || token.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        var opt = userRepo.findByPasswordResetToken(token);
        if (opt.isEmpty() || opt.get().getPasswordResetExpires() == null
                || opt.get().getPasswordResetExpires().isBefore(LocalDateTime.now())) {
            req.setAttribute("error", "Liên kết không hợp lệ hoặc đã hết hạn.");
            req.getRequestDispatcher("/views/auth/resetPassword.jsp").forward(req, res);
            return;
        }
        req.setAttribute("token", token);
        req.getRequestDispatcher("/views/auth/resetPassword.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String token = req.getParameter("token");
        String p1 = req.getParameter("password");
        String p2 = req.getParameter("password2");

        if (token == null || p1 == null || p2 == null || !p1.equals(p2) || p1.length() < 6) {
            req.setAttribute("token", token);
            req.setAttribute("error", "Mật khẩu tối thiểu 6 ký tự và hai lần nhập phải khớp.");
            req.getRequestDispatcher("/views/auth/resetPassword.jsp").forward(req, res);
            return;
        }

        var opt = userRepo.findByPasswordResetToken(token);
        if (opt.isEmpty() || opt.get().getPasswordResetExpires() == null
                || opt.get().getPasswordResetExpires().isBefore(LocalDateTime.now())) {
            req.setAttribute("error", "Liên kết không hợp lệ hoặc đã hết hạn.");
            req.getRequestDispatcher("/views/auth/resetPassword.jsp").forward(req, res);
            return;
        }

        var user = opt.get();
        user.setPassword(PasswordUtil.hash(p1));
        user.setPasswordResetToken(null);
        user.setPasswordResetExpires(null);
        userRepo.save(user);

        res.sendRedirect(req.getContextPath() + "/auth/login?reset=ok");
    }
}
