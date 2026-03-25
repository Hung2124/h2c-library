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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/profile/profile.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loggedUser = (User) (session != null ? session.getAttribute("loggedUser") : null);
        if (loggedUser == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String fullName = req.getParameter("fullName");
        String currentPassword = req.getParameter("currentPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (fullName == null || fullName.isBlank()) {
            req.setAttribute("error", "Họ tên không được để trống.");
            req.getRequestDispatcher("/views/profile/profile.jsp").forward(req, res);
            return;
        }

        User user = userRepository.findById(loggedUser.getId()).orElse(null);
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        user.setFullName(fullName.trim());

        if (newPassword != null && !newPassword.isBlank()) {
            if (currentPassword == null || currentPassword.isBlank()) {
                req.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại để đổi mật khẩu.");
                req.getRequestDispatcher("/views/profile/profile.jsp").forward(req, res);
                return;
            }
            if (!PasswordUtil.verify(currentPassword, user.getPassword())) {
                req.setAttribute("error", "Mật khẩu hiện tại không đúng.");
                req.getRequestDispatcher("/views/profile/profile.jsp").forward(req, res);
                return;
            }
            if (newPassword.length() < 6) {
                req.setAttribute("error", "Mật khẩu mới tối thiểu 6 ký tự.");
                req.getRequestDispatcher("/views/profile/profile.jsp").forward(req, res);
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "Xác nhận mật khẩu không khớp.");
                req.getRequestDispatcher("/views/profile/profile.jsp").forward(req, res);
                return;
            }
            user.setPassword(PasswordUtil.hash(newPassword));
        }

        userRepository.save(user);

        User updated = userRepository.findById(user.getId()).orElse(user);
        session.setAttribute("loggedUser", updated);

        res.sendRedirect(req.getContextPath() + "/profile?success=updated");
    }
}
