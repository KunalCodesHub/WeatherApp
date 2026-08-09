package com.weather.servlet;

import java.io.IOException;

import com.weather.model.User;
import com.weather.model.WeatherSearch;
import com.weather.service.WeatherService;

import jakarta.servlet.annotation.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/weather")
public class WeatherServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private WeatherService weatherService;
	
	public void init() {
		weatherService = new WeatherService();
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		User user = (session != null) ? (User)session.getAttribute("loggedInUser") : null;
		if(user == null) {
			res.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		req.getRequestDispatcher("weather.jsp").forward(req, res);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		User user = (session != null) ? (User)session.getAttribute("loggedInUser") : null;
		if(user == null) {
			res.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		String cityName = req.getParameter("cityName");
		if (cityName == null || cityName.trim().isEmpty()) {
			req.setAttribute("error_msg", "Please enter a city name");
			req.getRequestDispatcher("weather.jsp").forward(req, res);
			return;
		}
		
		try {
			WeatherSearch ws = weatherService.getWeatherByCity(cityName);
			ws.setUser(user); // add loggedIn user to WeatherSearch object
			weatherService.saveWeatherSearch(ws);
			req.setAttribute("weather", ws);
			req.getRequestDispatcher("weather.jsp").forward(req, res);
			
		} catch(Exception ex) {
			req.setAttribute("error_msg", ex.getMessage());
			req.getRequestDispatcher("weather.jsp").forward(req, res);
		}
		
	}

}
