package com.library.listener;

import com.library.job.OverdueBorrowNotifierJob;
import com.library.seeder.DataSeeder;
import com.library.util.SiteSettingsLoader;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class AppStartupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        SiteSettingsLoader.reload(ctx);

        Thread seederThread = new Thread(() -> {
            try {
                DataSeeder.seedIfEmpty();
            } catch (Exception e) {
                ctx.log("DataSeeder error: " + e.getMessage());
            }
        }, "data-seeder");
        seederThread.setDaemon(true);
        seederThread.start();

        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "overdue-mail");
            t.setDaemon(true);
            return t;
        });
        scheduler.scheduleAtFixedRate(new OverdueBorrowNotifierJob(ctx), 2, 6, TimeUnit.HOURS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
}
