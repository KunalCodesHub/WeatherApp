package com.weather.service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;
import com.weather.DAO.WeatherSearchDAO;
import com.weather.Implement.WeatherSearchDAOImpl;
import com.weather.model.WeatherSearch;

public class WeatherService {
	
	private WeatherSearchDAO weatherSearchDAO;
	private static final String API_KEY = getApiKey();
	private static final String BASE_URL = "https://api.openweathermap.org/data/2.5/weather";


	private static String getApiKey() {
	    String key = System.getenv("WEATHER_API_KEY");
	    
	    if (key == null || key.trim().isEmpty()) {
	        String errorMsg = 
	            "══════════════════════════════════════════════════\n" +
	            "❌ ERROR: WEATHER_API_KEY environment variable not set!\n" +
	            "══════════════════════════════════════════════════\n" +
	            "Get free API key from:\n" +
	            "  https://openweathermap.org/api\n" +
	            "\n" +
	            "Then set it:\n" +
	            "  Windows:  setx WEATHER_API_KEY \"your_key\"\n" +
	            "  Linux:    export WEATHER_API_KEY=your_key\n" +
	            "\n" +
	            "Restart your IDE/server after setting.\n" +
	            "══════════════════════════════════════════════════";
	        
	        System.err.println(errorMsg);
	        throw new IllegalStateException("WEATHER_API_KEY not configured");
	    }
	    
	    return key;
	}
	public WeatherService() {
		this.weatherSearchDAO = new WeatherSearchDAOImpl();
		
		if(API_KEY == null || API_KEY.isEmpty()) {
			System.err.println("WARNING: WEATHER_API_KEY enviroment variable not set!");
		}
	}
	/**
	 * Get paginated search history for a user.
	 * @param userId    User ID
	 * @param page      Current page number (1-based)
	 * @param pageSize  Number of records per page
	 * @return List of WeatherSearch objects
	 */
	public List<WeatherSearch> getSearchHistoryPaginated(int userId, int page, int pageSize) {
	    return weatherSearchDAO.getSearchHistoryPaginated(userId, page, pageSize);
	}


	/**
	 * Get total count of searches for a user.
	 * Used to calculate total pages in pagination.
	 */
	public int getTotalSearchCount(int userId) {
	    return weatherSearchDAO.getTotalSearchCount(userId);
	}
	
	public WeatherSearch getWeatherByCity(String cityName) {
		 if (API_KEY == null || API_KEY.isEmpty()) {
		        throw new RuntimeException("API key not configured. Please set WEATHER_API_KEY environment variable.");
		    }
		try {
			// Creating url
			String fullUrl = BASE_URL + "?q=" + cityName
					+ "&appid=" + API_KEY
					+ "&units=metric";
			
			// Creating client
			HttpClient client = HttpClient.newHttpClient();
			
			// Creating request
			HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(fullUrl))
				.GET()
				.build();
			
			// Sending the request and get response
			HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
			
			// convert the json body to string
			String responseBody = response.body();
			
			// 
			JSONObject json = new JSONObject(responseBody);
			
			if(json.has("cod")) {
				int cod = Integer.parseInt(json.get("cod").toString());
				if (cod != 200) {
					throw new RuntimeException("City not found: " + cityName);
				}
			}
			
			String city = json.getString("name");
			String country = json.getJSONObject("sys").getString("country");
			
			double temperature = json.getJSONObject("main").getDouble("temp");
			int humidity = json.getJSONObject("main").getInt("humidity");
			double windSpeed = json.getJSONObject("wind").getDouble("speed");
			
			JSONArray weatherArr = json.getJSONArray("weather");
			JSONObject weatherObject = weatherArr.getJSONObject(0);
			
			String condition = weatherObject.getString("main");
		    String description = weatherObject.getString("description");
		    
		    WeatherSearch ws = new WeatherSearch();
	        ws.setCityName(city);
	        ws.setCountry(country);
	        ws.setTemperature(temperature);
	        ws.setHumidity(humidity);
	        ws.setWindSpeed(windSpeed);
	        ws.setWeatherCondition(condition);
	        ws.setWeatherDescription(description);
	        
	        return ws;
		} catch(Exception ex) {
			throw new RuntimeException("Error fetching weather data", ex);
		}
	}
	
	public void saveWeatherSearch(WeatherSearch ws) {
		weatherSearchDAO.saveSearch(ws);
	}
	
	public List<WeatherSearch> getSearchHistory(int userId) {
		return weatherSearchDAO.getSearchesByUser(userId);
	}
	
	/**
	 * Get the city user searched most often.
	 * Used for sidebar stats.
	 */
	public String getMostSearchedCity(int userId) {
	    return weatherSearchDAO.getMostSearchedCity(userId);
	}


	/**
	 * Get the weather condition that appears most in user's searches.
	 * Used for sidebar stats.
	 */
	public String getMostCommonCondition(int userId) {
	    return weatherSearchDAO.getMostCommonCondition(userId);
	}
}
