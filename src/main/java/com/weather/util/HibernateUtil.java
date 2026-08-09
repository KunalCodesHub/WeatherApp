package com.weather.util;


import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

/**
 * HibernateUtil - Utility class for Hibernate
 * 
 * Purpose:
 *  - Creates ONE SessionFactory for the entire application (Singleton)
 *  - Loads hibernate.cfg.xml automatically
 *  - Provides sessions to DAO classes
 */

public class HibernateUtil {
	
	// Single static SessionFactory (created only once)
	private static SessionFactory sessionFactory;
	
	// Static block - runs ONCE when class is loaded
	static {
		try {
			// Load hibernate.cfg.xml and build SessionFactory
			sessionFactory = new Configuration()
								.configure()
								.buildSessionFactory();
			
			System.out.println("SessionFactory created successfully.");
		}catch (Exception ex) {
			System.err.println("Initial SessionFactory creation failed." + ex.getMessage());
			// Throw runtime exception to stop app if DB config is wrong
            throw new ExceptionInInitializerError(ex);
		}
	}
	
	/**
     * Returns the single SessionFactory instance
     * DAO classes will call this to get sessions
     */
	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}
	
	/**
     * Closes the SessionFactory
     * Should be called when application shuts down
     */
	public static void shutdown() {
		if(sessionFactory != null && !sessionFactory.isClosed()) {
			sessionFactory.close();
			System.out.println("SessionFactory closed successfully.");
		}
	}
	
}
