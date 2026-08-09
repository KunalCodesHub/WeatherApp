package com.weather.servlet;

import java.io.IOException;
import java.util.List;

import com.weather.model.FavoriteCity;
import com.weather.model.User;
import com.weather.service.FavoriteCityService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/favorite")
public class FavoriteCityServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 9;

    private FavoriteCityService favoriteCityService = new FavoriteCityService();

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
            // ── STEP 3: Get total records ──
            int totalRecords = favoriteCityService.getTotalFavoritesCount(user.getId());

            // ── STEP 4: Calculate total pages ──
            int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
            if (totalPages == 0) totalPages = 1;

            // ── STEP 5: Fix page number if too high ──
            if (currentPage > totalPages) currentPage = totalPages;

            // ── STEP 6: Get paginated favorites ──
            List<FavoriteCity> favoriteCities = favoriteCityService
                    .getFavoritesPaginated(user.getId(), currentPage, PAGE_SIZE);

            // ── STEP 7: Get most favorited country for sidebar ──
            String mostFavoritedCountry = favoriteCityService
                    .getMostFavoritedCountry(user.getId());

            // ── STEP 8: Send data to JSP ──
            req.setAttribute("favoriteCities", favoriteCities);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalRecords", totalRecords);
            req.setAttribute("pageSize", PAGE_SIZE);
            req.setAttribute("mostFavoritedCountry", mostFavoritedCountry);

            req.getRequestDispatcher("/favorite.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error_msg", "Error loading favorites: " + e.getMessage());
            req.getRequestDispatcher("/favorite.jsp").forward(req, res);
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
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

        // ── STEP 2: Get action ──
        String action = req.getParameter("action");

        if (action == null || action.isEmpty()) {
            req.setAttribute("error_msg", "Invalid action");
            doGet(req, res);
            return;
        }

        try {
            // ── SAVE ACTION ──
            if ("save".equalsIgnoreCase(action)) {
                String cityName = req.getParameter("cityName");
                String countryName = req.getParameter("countryName");

                if (cityName == null || cityName.isEmpty()
                        || countryName == null || countryName.isEmpty()) {
                    req.setAttribute("error_msg", "City name and country required");
                    doGet(req, res);
                    return;
                }

                favoriteCityService.addFavoriteCity(user, cityName, countryName);
                res.sendRedirect(req.getContextPath() + "/favorite");
                return;
            }

            // ── REMOVE ACTION ──
            if ("remove".equalsIgnoreCase(action)) {
                String idParam = req.getParameter("id");

                if (idParam == null || idParam.isEmpty()) {
                    req.setAttribute("error_msg", "Invalid favorite ID");
                    doGet(req, res);
                    return;
                }

                Integer favId = Integer.parseInt(idParam);
                favoriteCityService.removeFavoriteCity(favId);
                res.sendRedirect(req.getContextPath() + "/favorite");
                return;
            }

            // ── UNKNOWN ACTION ──
            req.setAttribute("error_msg", "Unknown action: " + action);
            doGet(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error_msg", "Error: " + e.getMessage());
            doGet(req, res);
        }
    }
}