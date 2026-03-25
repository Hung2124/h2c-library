package com.library.listener;

import com.library.config.JPAUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        sce.getServletContext().setAttribute("appName", "H2C LIBRARY");
        sce.getServletContext().setAttribute("appVersion", "1.0");
        sce.getServletContext().log("H2C LIBRARY Application started.");
        // JPA will be initialized lazily on first request
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        JPAUtil.close();
        sce.getServletContext().log("H2C LIBRARY Application stopped. JPA closed.");
    }
}
