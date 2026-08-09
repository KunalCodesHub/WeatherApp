package com.weather.DAO;

import java.util.List;

import com.weather.model.WeatherSearch;

public interface WeatherSearchDAO {
	
	void saveSearch(WeatherSearch ws);
	
	List<WeatherSearch> getSearchesByUser(int userId);
	
	List<WeatherSearch> getRecentSearchesByUser(int userId, int limit);
	
	List<WeatherSearch> getSearchHistoryPaginated(int userId,int page, int pageSize);
	
	String getMostSearchedCity(int userId);

	String getMostCommonCondition(int userId);
	
	int getTotalSearchCount(int userId);
	
	void deleteSearchesByUser(int userId);
}
