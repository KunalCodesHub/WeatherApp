package com.weather.DAO;

import com.weather.model.User;

public interface UserDAO {
	
	// CRUD operations for User entity
	void saveUser(User user);
	
	User findByUsername(String username);
	
	User findByEmail(String email);
	
	User findById(int id);
}
