package com.library.controller.auth;

import com.library.repository.SiteSettingRepository;
import com.library.repository.UserRepository;
import com.library.service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet("/auth/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserRepository userRepo = new UserRepository();
    private final SiteSettingRepository settingsRepo = new SiteSettingRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/forgotPassword.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        if (email == null || email.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập email.");
            req.getRequestDispatcher("/views/auth/forgotPassword.jsp").forward(req, res);
            return;
        }

        boolean mailOn = "true".equalsIgnoreCase(settingsRepo.getValue("mail_enabled").orElse("false"));
        if (!mailOn) {
            req.setAttribute("error", "Chức năng email đang tắt. Vui lòng liên hệ quản trị viên.");
            req.getRequestDispatcher("/views/auth/forgotPassword.jsp").forward(req, res);
            return;
        }

        var userOpt = userRepo.findByEmail(email.trim().toLowerCase());
        if (userOpt.isEmpty()) {
            req.setAttribute("info", "Nếu email tồn tại trong hệ thống, bạn sẽ nhận được hướng dẫn đặt lại mật khẩu.");
            req.getRequestDispatcher("/views/auth/forgotPassword.jsp").forward(req, res);
            return;
        }

        var user = userOpt.get();
        String token = UUID.randomUUID().toString().replace("-", "");
        user.setPasswordResetToken(token);
        user.setPasswordResetExpires(LocalDateTime.now().plusHours(1));
        userRepo.save(user);

        String link = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                + req.getContextPath() + "/auth/reset-password?token=" + token;
        try {
            EmailService.send(getServletContext(), user.getEmail(),
                    "[H2C LIBRARY] Đặt lại mật khẩu",
                    "Xin chào " + user.getFullName() + ",\n\nMở liên kết sau để đặt mật khẩu mới (hiệu lực 1 giờ):\n" + link
                            + "\n\nNếu không phải bạn, hãy bỏ qua email này.");
        } catch (Exception e) {
            getServletContext().log("Forgot password mail failed", e);
            req.setAttribute("error", "Không gửi được email. Kiểm tra cấu hình SMTP (web.xml hoặc biến môi trường).");
            req.getRequestDispatcher("/views/auth/forgotPassword.jsp").forward(req, res);
            return;
        }

        req.setAttribute("info", "Đã gửi hướng dẫn tới email của bạn.");
        req.getRequestDispatcher("/views/auth/forgotPassword.jsp").forward(req, res);
    }
}
