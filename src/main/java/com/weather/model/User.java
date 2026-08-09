package com.weather.model;

import java.time.LocalDateTime;
import jakarta.persistence.*;


@Entity
@Table(name = "users")
public class User {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private int id;
	
	@Column(name = "username", nullable = false, unique = true, length = 50)
	private String username;
	
	@Column(name = "email", nullable = false, unique = true, length = 100)
	private String email;
	
	@Column(name = "password", nullable = false, length = 255)
	private String password;
	
	@Column(name = "created_at", updatable = false)
	private LocalDateTime createdAt;
	
	// Default Constructors
	public User() {
	}
	
	
	// Auto-set createdAt before saving to the database
	@PrePersist
	protected void onCreate() {
		this.createdAt = LocalDateTime.now();
	}
	
	// Getters and Setters
	public int getId() { return id; }
	public void setId(int id) { this.id = id; }
	
	public String getUsername() { return username; }
	public void setUsername(String username) { this.username = username; }
	
	public String getEmail() { return email; }
	public void setEmail(String email) { this.email = email; }
	
	public String getPassword() { return password; }
	public void setPassword(String password) { this.password = password; }
	
	public LocalDateTime getCreatedAt() { return createdAt; }
	public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

	// Override toString for better logging and debugging
	@Override
	public String toString() {
		return "User{"
				+ "id=" + id 
				+ ", username=" + username 
				+ ", email=" + email 
				+ ", password=" + password
				+ ", createdAt=" + createdAt 
				+ "}";
	}
}
