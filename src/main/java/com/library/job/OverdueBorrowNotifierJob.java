package com.library.job;

import com.library.model.BorrowRequestDetail;
import com.library.repository.BorrowRepository;
import com.library.repository.SiteSettingRepository;
import com.library.service.EmailService;
import jakarta.servlet.ServletContext;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class OverdueBorrowNotifierJob implements Runnable {

    private final ServletContext ctx;

    public OverdueBorrowNotifierJob(ServletContext ctx) {
        this.ctx = ctx;
    }

    @Override
    public void run() {
        try {
            SiteSettingRepository settingsRepo = new SiteSettingRepository();
            String mailFlag = settingsRepo.getValue("mail_enabled").orElse("false");
            if (!"true".equalsIgnoreCase(mailFlag.trim())) {
                return;
            }
            BorrowRepository borrowRepo = new BorrowRepository();
            LocalDate today = LocalDate.now();
            List<BorrowRequestDetail> list = borrowRepo.findPastDueNeedingNotification(today);
            for (BorrowRequestDetail d : list) {
                try {
                    String email = d.getBorrowRequest().getUser().getEmail();
                    String bookTitle = d.getBook().getTitle();
                    String body = "Xin chào,\n\nSách \"" + bookTitle + "\" đã quá hạn trả (hạn: " + d.getDueDate() + "). "
                            + "Vui lòng mang sách đến thư viện hoặc liên hệ thủ thư.\n\nH2C LIBRARY";
                    EmailService.send(ctx, email, "[H2C LIBRARY] Nhắc nhở sách quá hạn", body);
                    d.setStatus("OVERDUE");
                    d.setOverdueEmailSentAt(LocalDateTime.now());
                    borrowRepo.updateDetail(d);
                } catch (Exception ex) {
                    ctx.log("Overdue mail failed for detail " + d.getId(), ex);
                }
            }
        } catch (Exception e) {
            ctx.log("OverdueBorrowNotifierJob failed", e);
        }
    }
}
