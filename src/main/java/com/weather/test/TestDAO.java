package com.weather.test;


import java.util.List;
import com.weather.DAO.FavoriteCityDAO;
import com.weather.DAO.UserDAO;
import com.weather.DAO.WeatherSearchDAO;
import com.weather.Implement.FavoriteCityDAOImpl;
import com.weather.Implement.UserDAOImpl;
import com.weather.Implement.WeatherSearchDAOImpl;
import com.weather.model.FavoriteCity;
import com.weather.model.User;
import com.weather.model.WeatherSearch;
import com.weather.util.HibernateUtil;

public class TestDAO {

	/* DAO Instances */
	static private UserDAO userDao;
	static private WeatherSearchDAO wsDao;
	static private FavoriteCityDAO fcDao;
	
	static {
		userDao = new UserDAOImpl();
		wsDao 	= new WeatherSearchDAOImpl();
		fcDao   = new FavoriteCityDAOImpl();
	}
	
	public static void main(String[] args) {
		System.out.println("------------------------\n"
						  +"  STARTING DAO TESTING  \n"
						  +"------------------------\n");
		
		// TEST 1 SAVE USER 
		System.out.println("\n---- Test 1: saveUser() ----");
		User user = new User();
		user.setUsername("testuser44");
		user.setEmail("user44@gmail.com");
		user.setPassword("12345");
		//userDao.saveUser(user);
		
		// TEST 2 FIND BY USERNAME 
		System.out.println("\n---- Test 2: findByUsername() ----");
		User foundUserByUsername = userDao.findByUsername(user.getUsername());
		System.out.println("found by username: " + foundUserByUsername.getUsername());
		
		// TEST 3 FIND BY EMAIL 
		System.out.println("\n---- Test 3: findByEmail() ----");
		User foundUserByEmail = userDao.findByEmail(user.getEmail());
		System.out.println("found by email: " + foundUserByEmail.getEmail());
		
		// TEST 4 FIND BY ID 
		System.out.println("\n---- Test 4: findById() ----");
		User foundUserById = userDao.findById(user.getId());
		System.out.println("found by id: " + foundUserById.getId());
		
		// TEST 5 SAVE SEARCH 
		System.out.println("\n---- Test 5: saveSearch() ----");
		WeatherSearch ws = new WeatherSearch();
		ws.setUser(userDao.findById(8));
		ws.setCityName("Tokyo");
		ws.setCountry("Japan");
		ws.setHumidity(85);
		ws.setTemperature(30.5);
		ws.setWindSpeed(11.5);
		ws.setWeatherCondition("mostly cloudy");
		ws.setWeatherDescription("Warm and humid with mostly cloudy skies");
		wsDao.saveSearch(ws);
		System.out.println("search saved. id " + ws.getId() + " for user " + ws.getUser().getUsername());
		
		// TEST 6 GET SEARCHES BY USER 
		System.out.println("\n---- Test 6: getSearchesByUser() ----");
		List<WeatherSearch> allSearches = wsDao.getSearchesByUser(8);
		System.out.println("Total search found: " + allSearches.size());
		allSearches.forEach(search -> System.out.println("city: " + search.getCityName()
														+"country: " + search.getCountry()));
		
		// TEST 7 GET RECENT SEARCHES BY USER 
		System.out.println("\n---- Test 7: getRecentSearchesByUser() ----");
		List<WeatherSearch> recentSearches = wsDao.getRecentSearchesByUser(8, 5);
		System.out.println("Total recent search found: " + recentSearches.size());
		
		// TEST 8 ADD FAVORITE 
		System.out.println("\n---- Test 8: addFavorite() ----");
		FavoriteCity fc = new FavoriteCity();
		fc.setUser(userDao.findById(8));
		fc.setCityName(wsDao.getSearchesByUser(8).get(0).getCityName());
		fc.setCountry(wsDao.getSearchesByUser(8).get(0).getCountry());
		fcDao.addFavorite(fc);
		System.out.println("Favorite city added successfully with id - " + fc.getId());
		
		// TEST 9 IS FAVORITE 
		System.out.println("\n---- Test 9: isFavorite() ----");
		boolean favorite = fcDao.isFavorite(8, fc.getCityName());
		System.out.println("Is " + fc.getCityName() + " city is favorite for user: " + fc.getUser().getUsername() + " - " + favorite);
		
		// TEST 10 GET FAVORITE BY USER-ID 
		System.out.println("\n---- Test 10: getFavoritesByUserId() ----");
		List<FavoriteCity> favoritesCities = fcDao.getFavoritesByUserId(8);
		System.out.println("Total favorite cities found: " + favoritesCities.size());
		favoritesCities.forEach(city -> System.out.println("Favorite cities\n" + "city: " + city.getCityName()));
		
		// TEST 11 REMOVE FAVORITE
		System.out.println("\n---- Test 11: removeFavorite() ----");
		String cityToRemove = fcDao.getFavoritesByUserId(8).get(0).getCityName();
		fcDao.removeFavorite(1);
		boolean isStillFavorite = fcDao.isFavorite(8, cityToRemove);
		System.out.println("After removal is " + cityToRemove + " city is still favorite for user: " + userDao.findById(8).getUsername() + "?\n" + isStillFavorite);
		
		// TEST 12 DELETE SEARCHES BY USER 
		System.out.println("\n---- Test 12: deleteSearchesByUser() ----");
		int userIdToDeleteSearches = 8;
		wsDao.deleteSearchesByUser(userIdToDeleteSearches);
		int size = wsDao.getSearchesByUser(userIdToDeleteSearches).size();
		System.out.println("After deletion, total searches for user id " + userIdToDeleteSearches + " is: " + size);
		
		// ── DONE ───────────────────────────────────────────
		System.out.println("\n------------------------\n"
						  +"  DAO TESTING COMPLETE  \n"
						  +"------------------------\n");
		
		HibernateUtil.shutdown();
	}

}
