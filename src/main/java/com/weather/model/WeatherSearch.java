package com.weather.model;

import java.time.LocalDateTime;
import jakarta.persistence.*;

@Entity
@Table(name = "weather_searches")
public class WeatherSearch {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private int id;
	
	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
	
	@Column(name = "humidity")
	private int humidity;
	
	@Column(name = "temperature")
	private double temperature;
	
	@Column(name = "wind_speed")
	private double windSpeed;
	
	@Column(name = "city_name", nullable = false, length = 100)
	private String cityName;
	
	@Column(name = "country", length = 50)
	private String country;
	
	@Column(name = "weather_condition", length = 100)
	private String weatherCondition;
	
	@Column(name = "description", length = 255)
	private String description;
	
	@Column(name = "search_date", updatable = false)
	private LocalDateTime searchDate;
	
	// Default Constructor
	public WeatherSearch() {
	}
	
	// Auto set searchDate before saving to the database
	@PrePersist
	protected void onCreate() {
		this.searchDate = LocalDateTime.now();
	}

	// Getters and Setters
	public int getId() { return id; }
	public void setId(int id) { this.id = id; }

	public User getUser() { return user; }
	public void setUser(User user) { this.user = user; }

	public int getHumidity() { return humidity; }
	public void setHumidity(int humidity) { this.humidity = humidity; }

	public double getTemperature() { return temperature; }
	public void setTemperature(double temperature) { this.temperature = temperature; }

	public double getWindSpeed() { return windSpeed; }
	public void setWindSpeed(double windSpeed) { this.windSpeed = windSpeed; }

	public String getCityName() { return cityName; }
	public void setCityName(String cityName) { this.cityName = cityName; }

	public String getCountry() { return country; }
	public void setCountry(String country) { this.country = country; }

	public String getWeatherCondition() { return weatherCondition; }
	public void setWeatherCondition(String weatherCondition) { this.weatherCondition = weatherCondition; }

	public String getWeatherDescription() { return description; }
	public void setWeatherDescription(String description) { this.description = description; }

	public LocalDateTime getSearchDate() { return searchDate; }
	public void setSearchDate(LocalDateTime searchDate) { this.searchDate = searchDate; }

	// toString method for debugging
	@Override
	public String toString() {
		return  "WeatherSearch{" +
                "id=" + id +
                ", user=" + (user != null ? user.getUsername() : "null") +
                ", cityName='" + cityName + '\'' +
                ", country='" + country + '\'' +
                ", temperature=" + temperature +
                ", humidity=" + humidity +
                ", windSpeed=" + windSpeed +
                ", weatherCondition='" + weatherCondition + '\'' +
                ", description='" + description + '\'' +
                ", searchDate=" + searchDate +
                '}';
	}
}
