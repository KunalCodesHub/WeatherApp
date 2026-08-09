package com.weather.servlet;

import java.io.IOException;
import java.util.List;

import com.weather.model.User;
import com.weather.model.WeatherSearch;
import com.weather.service.WeatherService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/history")
public class HistoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 9;

    private WeatherService weatherService = new WeatherService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // ── STEP 1: Authentication ──
        HttpSession session = req.getSession(false);
        User user = (session != null)
                ? (User) session.getAttribute("loggedInUser")
                : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // ── STEP 2: Read page parameter ──
        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        try {
            // ── STEP 3: Get counts and stats ──
            int totalRecords = weatherService.getTotalSearchCount(user.getId());

            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
            if (totalPages == 0) totalPages = 1;

            if (currentPage > totalPages) currentPage = totalPages;

            // ── STEP 4: Get paginated data ──
            List<WeatherSearch> history = weatherService
                    .getSearchHistoryPaginated(user.getId(), currentPage, PAGE_SIZE);

            // ── STEP 5: Get sidebar stats ──
            String mostSearchedCity = weatherService.getMostSearchedCity(user.getId());
            String mostCommonCondition = weatherService.getMostCommonCondition(user.getId());

            // ── STEP 6: Send data to JSP ──
            req.setAttribute("history", history);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalRecords", totalRecords);
            req.setAttribute("pageSize", PAGE_SIZE);
            req.setAttribute("mostSearchedCity", mostSearchedCity);
            req.setAttribute("mostCommonCondition", mostCommonCondition);

            req.getRequestDispatcher("history.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error_msg", "Error loading history: " + e.getMessage());
            req.getRequestDispatcher("history.jsp").forward(req, res);
        }
    }
}