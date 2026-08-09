package com.weather.model;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "favorite_cities")
public class FavoriteCity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private int id;
	
	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
	
	@Column(name = "city_name", nullable = false, length = 100)
	private String cityName;
	
	@Column(name = "country", length = 50)
	private String country;
	
	@Column(name = "added_date", updatable = false)
	private LocalDateTime addedAt;
	
	// Default Constructor
	public FavoriteCity() {	
	}
	
	// Auto set addedAt before saving to the database
	@PrePersist
	protected void onCreate() {
		this.addedAt = LocalDateTime.now();
	}
	
	// Getters and Setters
	public int getId() { return id; }
	public void setId(int id) { this.id = id; }

	public User getUser() { return user; }
	public void setUser(User user) { this.user = user; }
	
	public String getCityName() { return cityName; }
	public void setCityName(String cityName) { this.cityName = cityName; }
	
	public String getCountry() { return country; }
	public void setCountry(String country) { this.country = country; }

	public LocalDateTime getAddedAt() { return addedAt; }
	public void setAddedAt(LocalDateTime addedAt) { this.addedAt = addedAt; }

	// Override toString for better logging and debugging
	@Override
	public String toString() {
		return "FavoriteCity {"
				+ "id=" + id 
				+ ", user=" + user 
				+ ", cityName=" + cityName 
				+ ", country=" + country
				+ ", addedAt=" + addedAt 
				+ "}";
	}
}
