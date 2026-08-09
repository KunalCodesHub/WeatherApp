package com.weather.servlet;

import java.io.IOException;

import com.weather.model.User;
import com.weather.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService;
	
	@Override
    public void init() {
        userService = new UserService();
    }

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		req.getRequestDispatcher("login.jsp").forward(req, res);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		String usernameOrEmail = req.getParameter("usernameOrEmail");
		String password = req.getParameter("password");
		if(usernameOrEmail == null || password == null || usernameOrEmail.trim().isEmpty() || password.trim().isEmpty()) {
			req.setAttribute("error_msg", "All fields must be filled.");
			req.getRequestDispatcher("login.jsp").forward(req, res);
			return;
		}
			
		
		try {
			User user = userService.loginUser(usernameOrEmail, password);
			System.out.println(user.getUsername() + "logged in successfully.");
			HttpSession session = req.getSession();
			session.setAttribute("loggedInUser", user);
			res.sendRedirect(req.getContextPath() + "/weather");
		} catch(Exception ex) {
			req.setAttribute("error_msg", ex.getMessage());
			req.getRequestDispatcher("login.jsp").forward(req, res);
			return;
		}
		
	}

}
