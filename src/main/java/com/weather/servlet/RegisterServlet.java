package com.weather.servlet;

import java.io.IOException;
import com.weather.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }
	
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		req.getRequestDispatcher("register.jsp").forward(req, res);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		String username = req.getParameter("username");
		String email 	= req.getParameter("email");
		String password = req.getParameter("password");
		String errMsg 	= "all fields are needed to be filled!";
		if (username == null || email == null || password == null ||
		    username.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() ) {
			req.setAttribute("error_msg", errMsg);
			System.out.println("field empty error!");
			req.getRequestDispatcher("register.jsp").forward(req, res);
			return;
		}
		
		try {		
			userService.registerUser(username, email, password);
			System.out.println("Data sent to service successfully.");
			res.sendRedirect(req.getContextPath() + "/login");
		} catch(Exception ex) {
			req.setAttribute("error_msg", ex.getMessage());
			req.getRequestDispatcher("register.jsp").forward(req, res);
			return;
		}
		
	}

}
