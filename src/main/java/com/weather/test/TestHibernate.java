package com.weather.test;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.weather.model.FavoriteCity;
import com.weather.model.User;
import com.weather.model.WeatherSearch;
import com.weather.util.HibernateUtil;

public class TestHibernate {
	public static void main(String[] args) {
		
		Session session = null;
		Transaction tx = null;
		
		try {
			// 1. Open Session
			session = HibernateUtil.getSessionFactory().openSession();
			
			// 2. Begin Transaction
			tx = session.beginTransaction();
			
			// 3. Create & Test User
			User user = new User();
			user.setUsername("testuser1");
			user.setEmail("test1@gmail.com");
			user.setPassword("1234");
			session.persist(user);
			
			// Test WeatherSearch
			WeatherSearch ws = new WeatherSearch();
			ws.setUser(user);              // Attach the user
			ws.setCityName("London");
			ws.setCountry("UK");
			ws.setTemperature(22.5);
			ws.setHumidity(70);
			ws.setWindSpeed(5.5);
			ws.setWeatherCondition("Cloudy");
			ws.setWeatherDescription("Overcast clouds");
			session.persist(ws);

			// Test FavoriteCity
			FavoriteCity fc = new FavoriteCity();
			fc.setUser(user);
			fc.setCityName("New York");
			fc.setCountry("USA");
			session.persist(fc);
			
			// 4. Save user
			// session.persist(user);
			// session.persist(ws);
			// session.persist(fc);
			
			// 5. Commit transaction
			tx.commit();
			
			System.out.println("all saved successfully with Id: " + ws.getId());
		} catch(Exception ex) {
			if(tx != null) tx.rollback();
			System.err.println(ex.getMessage());
		} finally {
			if(session != null) session.clear();
			HibernateUtil.shutdown();
		}
	}
}
