package com.weather.service;

import java.util.List;

import com.weather.DAO.FavoriteCityDAO;
import com.weather.Implement.FavoriteCityDAOImpl;
import com.weather.model.FavoriteCity;
import com.weather.model.User;
import com.weather.model.WeatherSearch;

public class FavoriteCityService {
	
	private FavoriteCityDAO favoriteCityDAO;
	
	public FavoriteCityService() {
		this.favoriteCityDAO = new FavoriteCityDAOImpl();
	}
	
	public void addFavoriteCity(User user, String cityName, String country) {
		
		if(isCityAlreadyFavorite(user.getId(), cityName)) {
			throw new RuntimeException(cityName + " is already in favorites");
		}
		
		FavoriteCity fc = new FavoriteCity();
		fc.setUser(user);
		fc.setCityName(cityName);
		fc.setCountry(country);
		favoriteCityDAO.addFavorite(fc);
	}
	
	public List<FavoriteCity> getFavoriteCities(int userId) {
		return favoriteCityDAO.getFavoritesByUserId(userId);
	}
	
	public void removeFavoriteCity(int favoriteId) {
		favoriteCityDAO.removeFavorite(favoriteId);
	}
	
	public boolean isCityAlreadyFavorite(int userId, String cityName) {
		return favoriteCityDAO.isFavorite(userId, cityName);
	}
	
	public List<FavoriteCity> getFavoritesPaginated(int userId, int page, int pageSize) {
	    return favoriteCityDAO.getFavoritesPaginated(userId, page, pageSize);
	}

	public int getTotalFavoritesCount(int userId) {
	    return favoriteCityDAO.getTotalFavoritesCount(userId);
	}

	public String getMostFavoritedCountry(int userId) {
	    return favoriteCityDAO.getMostFavoritedCountry(userId);
	}
}
