package com.library.filter;

import com.library.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
        "/cart/*", "/borrow/*", "/profile", "/profile/*",
        "/favorites/*", "/books/review"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            String loginUrl = req.getContextPath() + "/auth/login";
            res.sendRedirect(loginUrl + "?redirect=" + req.getRequestURI());
            return;
        }

        chain.doFilter(request, response);
    }
}
