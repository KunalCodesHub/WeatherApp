package com.weather.DAO;

import java.util.List;

import com.weather.model.FavoriteCity;

public interface FavoriteCityDAO {

	void addFavorite(FavoriteCity fc);
	
	void removeFavorite(int favoriteId);
	
	List<FavoriteCity> getFavoritesByUserId(int userId);
	
	boolean isFavorite(int userId, String cityName);
	
	List<FavoriteCity> getFavoritesPaginated(int userId, int page, int pageSize);
	
	int getTotalFavoritesCount(int userId);
	
	String getMostFavoritedCountry(int userId);
}
