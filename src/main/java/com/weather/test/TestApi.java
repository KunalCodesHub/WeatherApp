package com.weather.test;

import com.weather.model.WeatherSearch;
import com.weather.service.WeatherService;

public class TestApi {
	public static void main(String[] args) {
		WeatherService weatherService = new WeatherService();

        // Test 1 — Valid city
        System.out.println("=== Test 1: Valid City ===");
        WeatherSearch ws = weatherService.getWeatherByCity("Balasore");
        System.out.println("City: "        + ws.getCityName());
        System.out.println("Country: "     + ws.getCountry());
        System.out.println("Temperature: " + ws.getTemperature());
        System.out.println("Humidity: "    + ws.getHumidity());
        System.out.println("Wind Speed: "  + ws.getWindSpeed());
        System.out.println("Condition: "   + ws.getWeatherCondition());
        System.out.println("Description: " + ws.getWeatherDescription());

        // Test 2 — Invalid city
        System.out.println("\n=== Test 2: Invalid City ===");
        try {
            WeatherSearch ws2 = weatherService.getWeatherByCity("XYZABC123");
            System.out.println("Should not reach here!");
        } catch (RuntimeException e) {
            System.out.println("Caught expected error: " + e.getMessage());
        }
	}
}
