
# 🌦️ WeatherApp

A full-stack Java Web Application that allows users to search real-time weather data,
save favorite cities, and view their search history — all with a clean, 
responsive Bootstrap 5 interface.

> 🎓 Built as a portfolio project to demonstrate full-stack Java web development skills.

---

## 🌍 Live Demo

> Coming soon — deploying to Render + Aiven MySQL

---

## 📸 Screenshots

> Coming soon

---

## ✨ Features

- 🔐 **User Registration & Login**
  - Login with username OR email
  - BCrypt password hashing
  - Session-based authentication
  - Password strength indicator
  - Password visibility toggle

- 🌤️ **Real-Time Weather Search**
  - Search any city worldwide
  - Displays temperature, humidity, wind speed, condition, description
  - Weather icons based on condition
  - Auto-saves search to history

- ⭐ **Favorite Cities**
  - Save cities to favorites
  - Remove favorites with confirmation
  - Paginated list (9 per page)
  - Live filter/search
  - Quick weather lookup from favorites

- 📜 **Search History**
  - Full paginated history (9 per page)
  - Live filter/search
  - View detailed info in modal popup
  - Add to favorites directly from history
  - Most searched city + most common condition stats

- 📱 **Responsive UI**
  - Bootstrap 5 design
  - Works on desktop, tablet, mobile
  - Custom CSS per page
  - Animated sky background on login/register

---

## 🛠️ Tech Stack
```
| Layer          | Technology                              |
|----------------|-----------------------------------------|
| Language       | Java 17                                 |
| Backend        | Jakarta Servlets (jakarta.* API)        |
| ORM            | Hibernate 7                             |
| Database       | MySQL 8+                                |
| Frontend       | JSP, HTML5, CSS3, JavaScript            |
| UI Framework   | Bootstrap 5 + Bootstrap Icons           |
| Server         | Apache Tomcat 10.1                      |
| Build Tool     | Apache Maven                            |
| Security       | BCrypt password hashing                 |
| Weather API    | OpenWeatherMap API                      |
| Cloud Database | Aiven MySQL (deployment)                |
| Hosting        | Render (deployment)                     |
| Version Control| Git + GitHub                            |

```
---
## 📂 Project Structure

```
WeatherApp/
├── src/main/java/com/weather/
│   ├── model/
│   │   ├── User.java
│   │   ├── WeatherSearch.java
│   │   └── FavoriteCity.java
│   │
│   ├── servlet/
│   │   ├── RegisterServlet.java
│   │   ├── LoginServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── WeatherServlet.java
│   │   ├── FavoriteCityServlet.java
│   │   └── HistoryServlet.java
│   │
│   ├── service/
│   │   ├── UserService.java
│   │   ├── WeatherService.java
│   │   └── FavoriteCityService.java
│   │
│   ├── DAO/
│   │   ├── UserDAO.java
│   │   ├── WeatherSearchDAO.java
│   │   └── FavoriteCityDAO.java
│   │
│   ├── Implement/
│   │   ├── UserDAOImpl.java
│   │   ├── WeatherSearchDAOImpl.java
│   │   └── FavoriteCityDAOImpl.java
│   │
│   └── util/
│       └── HibernateUtil.java
│
├── src/main/resources/
│   └── hibernate.cfg.xml
│
├── src/main/webapp/
│   ├── css/
│   │   ├── style.css
│   │   ├── register.css
│   │   ├── login.css
│   │   ├── weather.css
│   │   ├── favorite.css
│   │   ├── history.css
│   │   └── sky-background.css
│   │
│   ├── includes/
│   │   ├── header.jsp
│   │   └── footer.jsp
│   │
│   ├── WEB-INF/
│   │   └── web.xml
│   │
│   ├── register.jsp
│   ├── login.jsp
│   ├── weather.jsp
│   ├── favorite.jsp
│   └── history.jsp
│
├── .gitignore
├── README.md
└── pom.xml
```

---

## 🗄️ Database Schema

### users
```sql
CREATE TABLE users (
    id       INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50)  NOT NULL UNIQUE,
    email    VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);
```

### weather_search
```sql
CREATE TABLE weather_search (
    id                INT PRIMARY KEY AUTO_INCREMENT,
    city_name         VARCHAR(100),
    country           VARCHAR(100),
    temperature       DOUBLE,
    humidity          INT,
    wind_speed        DOUBLE,
    weather_condition VARCHAR(100),
    description       VARCHAR(255),
    search_date       DATETIME,
    user_id           INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### favorite_city
```sql
CREATE TABLE favorite_city (
    id           INT PRIMARY KEY AUTO_INCREMENT,
    city_name    VARCHAR(100),
    country_name VARCHAR(100),
    user_id      INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

> ✅ Tables are auto-created by Hibernate (`hbm2ddl.auto=update`)
> You only need to create the database manually.

---

## ⚙️ Prerequisites

Before running this project, make sure you have:

- ✅ JDK 17 or higher
- ✅ Apache Maven 3.6+
- ✅ Apache Tomcat 10.1+
- ✅ MySQL 8+
- ✅ OpenWeatherMap API Key (free at openweathermap.org)

---

## 🚀 How to Run Locally

### Step 1 — Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/WeatherApp.git
cd WeatherApp
```

---

### Step 2 — Create the Database

Open MySQL and run:

```sql
CREATE DATABASE weather_db;
```

> Tables will be auto-created by Hibernate when the app first starts.

---

### Step 3 — Get an OpenWeatherMap API Key

1. Go to [https://openweathermap.org/api](https://openweathermap.org/api)
2. Create a free account
3. Copy your API key

---

### Step 4 — Set Environment Variables

#### Windows (Command Prompt as Administrator):

```cmd
setx WEATHER_API_KEY "your_openweather_api_key"
setx DB_URL "jdbc:mysql://localhost:3306/weather_db"
setx DB_USERNAME "your_mysql_username"
setx DB_PASSWORD "your_mysql_password"
```

#### Mac / Linux (Terminal):

```bash
export WEATHER_API_KEY="your_openweather_api_key"
export DB_URL="jdbc:mysql://localhost:3306/weather_db"
export DB_USERNAME="your_mysql_username"
export DB_PASSWORD="your_mysql_password"
```

> ⚠️ On Windows, restart your IDE/terminal after setting environment variables.

---

### Step 5 — Build the Project

```bash
mvn clean package
```

This generates:

```
target/WeatherApp.war
```

---

### Step 6 — Deploy to Tomcat

1. Copy `target/WeatherApp.war` to Tomcat's `webapps/` folder
2. Start Tomcat
3. Open your browser and go to:

```
http://localhost:8080/WeatherApp/
```

---

## 🔐 Security Notes

- ✅ Passwords are hashed using **BCrypt** (never stored as plain text)
- ✅ All sensitive credentials stored in **environment variables**
- ✅ No hardcoded API keys or database passwords in source code
- ✅ Session-based authentication with proper invalidation on logout
- ✅ SQL injection prevented via **Hibernate HQL parameterized queries**

---

## 🌐 Deployment (Cloud)
```
This app is configured for cloud deployment using:<br>

| Service        | Purpose                     |
|----------------|-----------------------------|
| Aiven MySQL    | Cloud-hosted MySQL database |
| Render         | Java web app hosting        |
-```

### Environment Variables for Cloud:

```
WEATHER_API_KEY = your_openweather_api_key
DB_URL          = jdbc:mysql://HOST:PORT/defaultdb?sslmode=require
DB_USERNAME     = avnadmin
DB_PASSWORD     = your_aiven_password
```

---

## 🧪 Key Technical Decisions```

- Uses `jakarta.*` API (Tomcat 10+ / Jakarta EE)
- Hibernate ORM with HQL (no raw SQL)
- Server-side pagination (9 records per page)
- PRG pattern (Post/Redirect/Get) to prevent form resubmission
- JSP scriptlets (no EL/Expression Language)
- Static JSP includes for header and footer
- Environment variables for all sensitive configuration
- `getSession(false)` used throughout (never auto-creates session)```

---

## 📦 Dependencies
```
| Dependency                  | Version    | Purpose                    |
|-----------------------------|------------|----------------------------|
| jakarta.servlet-api         | 6.0.0      | Servlet API                |
| hibernate-core              | 7.4.1.Final| ORM Framework              |
| jakarta.servlet.jsp-api     | 3.1.0      | JSP API                    |
| jakarta.servlet.jsp.jstl-api| 3.0.0      | JSTL API                   |
| mysql-connector-j           | 9.7.0      | MySQL JDBC Driver          |
| jbcrypt                     | 0.4        | BCrypt Password Hashing    |
| org.json                    | 20251224   | JSON Parsing (Weather API) |
```
---

## 👤 Author

**Your Name**
- GitHub: [@YOUR_USERNAME](https://github.com/YOUR_USERNAME)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/YOUR_PROFILE)

---

## 📜 License

This project is built for **portfolio and educational purposes**.

---

## 🙏 Acknowledgements

- [OpenWeatherMap](https://openweathermap.org/) for the free Weather API
- [Bootstrap](https://getbootstrap.com/) for the UI framework
- [Aiven](https://aiven.io/) for free cloud MySQL hosting
- [Render](https://render.com/) for free Java app hosting
```

---

## ✅ How to Use This

### Step 1
Copy the entire content above

### Step 2
Open your `README.md` file in VS Code or any editor

### Step 3
Select all existing content (`Ctrl + A`) and delete it

### Step 4
Paste the new content (`Ctrl + V`)

### Step 5
Replace these placeholders:
- `YOUR_USERNAME` → your GitHub username
- `Your Name` → your actual name
- `Your LinkedIn` → your LinkedIn profile URL

### Step 6
Save (`Ctrl + S`) then push:

```bash
git add README.md
git commit -m "Updated README with complete project documentation"
git push
```

---

