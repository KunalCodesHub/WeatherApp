# WeatherApp

A Java Web Application for checking weather, saving favorite cities, and viewing search history.

## Features

- User Registration and Login (BCrypt password hashing)
- Real-time weather search using OpenWeatherMap API
- Save favorite cities
- View search history with pagination
- Server-side pagination
- Responsive design with Bootstrap 5

## Tech Stack

- **Backend:** Java 17, Jakarta Servlets, Hibernate 7
- **Frontend:** JSP, Bootstrap 5, JavaScript
- **Database:** MySQL
- **Server:** Apache Tomcat 10.1
- **Build Tool:** Maven

## Setup

1. Clone the repository
2. Create MySQL database
3. Configure database connection in `HibernateUtil.java`
4. Add your OpenWeatherMap API key in `WeatherService.java`
5. Build with Maven: `mvn clean package`
6. Deploy WAR file to Tomcat

## API Used

- OpenWeatherMap: https://openweathermap.org/api