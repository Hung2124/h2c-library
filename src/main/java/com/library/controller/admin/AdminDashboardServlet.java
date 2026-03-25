package com.library.controller.admin;

import com.library.repository.StatisticsRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final StatisticsRepository statsRepo = new StatisticsRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setAttribute("totalBooks",   statsRepo.countTotalBooks());
        req.setAttribute("totalUsers",   statsRepo.countTotalUsers());
        req.setAttribute("borrowedBooks",statsRepo.countBorrowedBooks());
        req.setAttribute("overdueBooks", statsRepo.countOverdueBooks());

        List<Object[]> mostBorrowed = statsRepo.findMostBorrowedBooks(10);
        req.setAttribute("mostBorrowed", mostBorrowed);

        int year = LocalDate.now().getYear();
        List<Object[]> byMonth = statsRepo.countRequestsByMonth(year);
        req.setAttribute("borrowByMonth", byMonth);
        req.setAttribute("currentYear", year);

        Object[] maxMinAvg = statsRepo.getMaxMinAvgBorrowQty();
        req.setAttribute("maxQty", maxMinAvg != null ? maxMinAvg[0] : 0);
        req.setAttribute("minQty", maxMinAvg != null ? maxMinAvg[1] : 0);
        req.setAttribute("avgQty", maxMinAvg != null ? maxMinAvg[2] : 0);

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, res);
    }
}
