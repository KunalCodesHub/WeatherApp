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
	private static final SessionFactory sessionFactory = buildSessionFactory();
	
	// Static block - runs ONCE when class is loaded
	private static SessionFactory buildSessionFactory(){
		try {
			Configuration configuration = new Configuration();
			
			// Load hibernate.cfg.xml (base config)
			configuration.configure("hibernate.cfg.xml");
			
			/* Read database settings from environment variables
               Falls back to local defaults if not set */
			String dbUrl = getEnv("DB_URL");
            String dbUsername = getEnv("DB_USERNAME");
            String dbPassword = getEnv("DB_PASSWORD");
			
         // ⚠️ Validate all required vars are set
            if (isEmpty(dbUrl) || isEmpty(dbUsername) || isEmpty(dbPassword)) {
                String errorMsg = 
                    "══════════════════════════════════════════════════\n" +
                    "❌ ERROR: Missing required environment variables!\n" +
                    "══════════════════════════════════════════════════\n" +
                    "Please set these environment variables:\n" +
                    "  DB_URL       (e.g., jdbc:mysql://localhost:3306/weather_db)\n" +
                    "  DB_USERNAME  (e.g., root)\n" +
                    "  DB_PASSWORD  (e.g., your_password)\n" +
                    "\n" +
                    "See README.md for setup instructions.\n" +
                    "══════════════════════════════════════════════════";
                
                System.err.println(errorMsg);
                throw new IllegalStateException("Database environment variables not configured");
            }
            
         // Set connection properties dynamically
            configuration.setProperty("hibernate.connection.url", dbUrl);
            configuration.setProperty("hibernate.connection.username", dbUsername);
            configuration.setProperty("hibernate.connection.password", dbPassword);
            
         // Log which database is being used (helpful for debugging)
            System.out.println("═══════════════════════════════════════");
            System.out.println("Connecting to database:");
            System.out.println("URL: " + dbUrl);
            System.out.println("User: " + dbUsername);
            System.out.println("═══════════════════════════════════════");
            
            return configuration.buildSessionFactory();
		}catch (Exception ex) {
			System.err.println("Initial SessionFactory creation failed." + ex.getMessage());
			// Throw runtime exception to stop app if DB config is wrong
            throw new ExceptionInInitializerError(ex);
		}
	}
	
	// Helper method
	private static boolean isEmpty(String value) {
	    return value == null || value.trim().isEmpty();
	}
	
	/**
     * Read environment variable, or return default value if not set.
     */
    private static String getEnv(String key) {
        String value = System.getenv(key);
        return value;
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
