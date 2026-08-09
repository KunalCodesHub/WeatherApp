package com.weather.service;

import org.mindrot.jbcrypt.BCrypt;
import com.weather.DAO.UserDAO;
import com.weather.Implement.UserDAOImpl;
import com.weather.model.User;

public class UserService {
	
	private UserDAO userDAO;
	
	public UserService() {
		this.userDAO = new UserDAOImpl();
	}
	
	public void registerUser(String username, String email, String password) {
		
		User existingUserByUsername = userDAO.findByUsername(username);
		if (existingUserByUsername != null) {
			throw new RuntimeException("Username already exists");
		}
		
		User existingUserByEmail = userDAO.findByEmail(email);
		if (existingUserByEmail != null) {
			throw new RuntimeException("Email already exists");
		}
		
		User newUser = new User();
		newUser.setUsername(username);
		newUser.setEmail(email);
		String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
		newUser.setPassword(hashedPassword); 
		
		userDAO.saveUser(newUser);
		
	}
	
	public User loginUser(String usernameOrEmail, String password) {
		User user = null;
		boolean isEmail = usernameOrEmail.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
		if(isEmail) {
			user = userDAO.findByEmail(usernameOrEmail);
		} else {
			user = userDAO.findByUsername(usernameOrEmail);
		}
		if (user == null) {
			if(isEmail) {	
				throw new RuntimeException("Invalid email");
			} else {
				throw new RuntimeException("Invalid username");
			}
		}
		
		if (!BCrypt.checkpw(password, user.getPassword())) {
			throw new RuntimeException("Invalid password");
		}
		
		return user; // Return a User object if authentication is successful
	} 
}
