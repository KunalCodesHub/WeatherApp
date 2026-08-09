<%@ include file="/includes/header.jsp" %>
<%@ page import="com.weather.model.WeatherSearch" %>

<%
    WeatherSearch weather = (WeatherSearch) request.getAttribute("weather");
    String errorMsg = (String) request.getAttribute("error_msg");
%>

<!-- Page-specific CSS -->
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/weather.css"/>

<div class="row">

    <!-- ════════════════════════════════════════
         LEFT COLUMN — Main Content (8 cols)
         ════════════════════════════════════════ -->
    <div class="col-lg-8">

        <!-- Page Title -->
        <h2 class="page-title">
            <i class="bi bi-cloud-sun-fill text-primary"></i>
            Search Weather
        </h2>

        <!-- Error Message -->
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="alert alert-danger d-flex align-items-center">
                <i class="bi bi-exclamation-circle-fill me-2"></i>
                <%= errorMsg %>
            </div>
        <% } %>

        <!-- ── SEARCH FORM ── -->
        <div class="card search-card shadow-sm mb-4">
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/weather"
                      method="post"
                      class="row g-2 align-items-center">
                    <div class="col-sm-9">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-geo-alt-fill"></i>
                            </span>
                            <input type="text"
                                   name="cityName"
                                   class="form-control"
                                   placeholder="Enter city name... (e.g., London, Tokyo)"
                                   required/>
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <button type="submit"
                                class="btn btn-primary w-100">
                            <i class="bi bi-search me-1"></i>
                            Search
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ── WEATHER RESULT CARD ── -->
        <% if (weather != null) { %>

            <div class="card weather-result-card shadow-sm mb-4">

                <!-- Card Header -->
                <div class="card-header weather-card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-0">
                                <i class="bi bi-geo-alt-fill me-1"></i>
                                <%= weather.getCityName() %>, <%= weather.getCountry() %>
                            </h4>
                        </div>
                        <div>
                            <span class="badge weather-badge">
                                <i class="bi <%= getWeatherIcon(weather.getWeatherCondition()) %> me-1"></i>
                                <%= weather.getWeatherCondition() %>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Card Body -->
                <div class="card-body">

                    <!-- Description -->
                    <p class="weather-description mb-4">
                        <i class="bi bi-info-circle me-1"></i>
                        <%= weather.getWeatherDescription() %>
                    </p>

                    <!-- Stats Row -->
                    <div class="row text-center g-3">

                        <!-- Temperature -->
                        <div class="col-md-4">
                            <div class="stat-box">
                                <div class="stat-icon temp-icon">
                                    <i class="bi bi-thermometer-half"></i>
                                </div>
                                <p class="stat-label">Temperature</p>
                                <p class="stat-value"><%= weather.getTemperature() %> °C</p>
                            </div>
                        </div>

                        <!-- Humidity -->
                        <div class="col-md-4">
                            <div class="stat-box">
                                <div class="stat-icon humidity-icon">
                                    <i class="bi bi-droplet-fill"></i>
                                </div>
                                <p class="stat-label">Humidity</p>
                                <p class="stat-value"><%= weather.getHumidity() %> %</p>
                            </div>
                        </div>

                        <!-- Wind Speed -->
                        <div class="col-md-4">
                            <div class="stat-box">
                                <div class="stat-icon wind-icon">
                                    <i class="bi bi-wind"></i>
                                </div>
                                <p class="stat-label">Wind Speed</p>
                                <p class="stat-value"><%= weather.getWindSpeed() %> km/h</p>
                            </div>
                        </div>

                    </div>

                    <!-- Warning Field Placeholder — Will be added later -->
                    <!--
                    <div class="alert alert-warning mt-4 d-flex align-items-center">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        Warning message will appear here
                    </div>
                    -->

                    <!-- Add to Favorites Button -->
                    <div class="mt-4 text-center">
                        <form action="<%= request.getContextPath() %>/favorite"
                              method="post"
                              class="d-inline">
                            <input type="hidden" name="action" value="save"/>
                            <input type="hidden" name="cityName"
                                   value="<%= weather.getCityName() %>"/>
                            <input type="hidden" name="countryName"
                                   value="<%= weather.getCountry() %>"/>
                            <button type="submit"
                                    class="btn btn-favorite">
                                <i class="bi bi-star-fill me-2"></i>
                                Add to Favorites
                            </button>
                        </form>
                    </div>

                </div>
            </div>

        <% } %>

        <!-- ── EMPTY STATE — Tips (shown when no search yet) ── -->
        <% if (weather == null && (errorMsg == null || errorMsg.isEmpty())) { %>

            <div class="card tips-card shadow-sm">
                <div class="card-body text-center py-5">
                    <div class="tips-icon mb-3">
                        <i class="bi bi-cloud-sun"></i>
                    </div>
                    <h5 class="fw-bold mb-3">Search for any city worldwide</h5>
                    <p class="text-muted mb-4">
                        Get real-time weather information for any city in the world
                    </p>
                    <div class="row justify-content-center g-3">
                        <div class="col-sm-6 col-md-4">
                            <div class="tip-item">
                                <i class="bi bi-lightbulb text-warning"></i>
                                <small>Try searching "London"</small>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-4">
                            <div class="tip-item">
                                <i class="bi bi-lightbulb text-warning"></i>
                                <small>Try searching "Tokyo"</small>
                            </div>
                        </div>
                        <div class="col-sm-6 col-md-4">
                            <div class="tip-item">
                                <i class="bi bi-lightbulb text-warning"></i>
                                <small>Try searching "New York"</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <% } %>

    </div>

    <!-- ════════════════════════════════════════
         RIGHT COLUMN — Sidebar (4 cols)
         ════════════════════════════════════════ -->
    <div class="col-lg-4 mt-4 mt-lg-0">

        <!-- ── Quick Stats (visible only when result exists) ── -->
        <% if (weather != null) { %>

            <div class="card sidebar-card shadow-sm mb-4">
                <div class="card-header sidebar-header">
                    <h6 class="mb-0">
                        <i class="bi bi-speedometer2 me-1"></i>
                        Quick Summary
                    </h6>
                </div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item sidebar-item">
                            <span class="sidebar-item-label">
                                <i class="bi bi-geo-alt text-primary me-2"></i>
                                City
                            </span>
                            <span class="sidebar-item-value">
                                <%= weather.getCityName() %>
                            </span>
                        </li>
                        <li class="list-group-item sidebar-item">
                            <span class="sidebar-item-label">
                                <i class="bi bi-flag text-success me-2"></i>
                                Country
                            </span>
                            <span class="sidebar-item-value">
                                <%= weather.getCountry() %>
                            </span>
                        </li>
                        <li class="list-group-item sidebar-item">
                            <span class="sidebar-item-label">
                                <i class="bi bi-thermometer-half text-danger me-2"></i>
                                Temp
                            </span>
                            <span class="sidebar-item-value">
                                <%= weather.getTemperature() %> °C
                            </span>
                        </li>
                        <li class="list-group-item sidebar-item">
                            <span class="sidebar-item-label">
                                <i class="bi bi-droplet-fill text-info me-2"></i>
                                Humidity
                            </span>
                            <span class="sidebar-item-value">
                                <%= weather.getHumidity() %> %
                            </span>
                        </li>
                        <li class="list-group-item sidebar-item">
                            <span class="sidebar-item-label">
                                <i class="bi bi-wind text-secondary me-2"></i>
                                Wind
                            </span>
                            <span class="sidebar-item-value">
                                <%= weather.getWindSpeed() %> km/h
                            </span>
                        </li>
                        <li class="list-group-item sidebar-item">
                            <span class="sidebar-item-label">
                                <i class="bi bi-cloud text-warning me-2"></i>
                                Condition
                            </span>
                            <span class="sidebar-item-value">
                                <%= weather.getWeatherCondition() %>
                            </span>
                        </li>
                    </ul>
                </div>
            </div>

        <% } %>

        <!-- ── Favorite Cities Quick Access ── -->
        <div class="card sidebar-card shadow-sm mb-4">
            <div class="card-header sidebar-header">
                <h6 class="mb-0">
                    <i class="bi bi-star-fill me-1"></i>
                    Quick Access
                </h6>
            </div>
            <div class="card-body text-center">
                <p class="text-muted mb-3">
                    <small>Quickly search your favorite cities</small>
                </p>
                <a href="<%= request.getContextPath() %>/favorite"
                   class="btn btn-outline-warning btn-sm w-100">
                    <i class="bi bi-star me-1"></i>
                    View Favorites
                </a>
            </div>
        </div>

        <!-- ── Weather Tips ── -->
        <div class="card sidebar-card shadow-sm">
            <div class="card-header sidebar-header">
                <h6 class="mb-0">
                    <i class="bi bi-info-circle-fill me-1"></i>
                    Weather Tips
                </h6>
            </div>
            <div class="card-body">
                <div class="weather-tip mb-3">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-umbrella-fill text-primary me-2 mt-1"></i>
                        <small class="text-muted">
                            Always check humidity levels before heading out
                        </small>
                    </div>
                </div>
                <div class="weather-tip mb-3">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-wind text-info me-2 mt-1"></i>
                        <small class="text-muted">
                            High wind speeds may affect travel plans
                        </small>
                    </div>
                </div>
                <div class="weather-tip">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-sun-fill text-warning me-2 mt-1"></i>
                        <small class="text-muted">
                            Temperatures above 35°C require extra hydration
                        </small>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<!-- ════════════════════════════════════════
     WEATHER ICON MAPPING FUNCTION
     ════════════════════════════════════════ -->
<%!
    public String getWeatherIcon(String condition) {
        if (condition == null) return "bi-cloud";

        String lowerCondition = condition.toLowerCase();

        if (lowerCondition.contains("clear") || lowerCondition.contains("sunny")) {
            return "bi-sun-fill";
        }
        if (lowerCondition.contains("cloud") || lowerCondition.contains("overcast")) {
            return "bi-cloud-fill";
        }
        if (lowerCondition.contains("rain") || lowerCondition.contains("drizzle")) {
            return "bi-cloud-rain-fill";
        }
        if (lowerCondition.contains("thunder") || lowerCondition.contains("storm")) {
            return "bi-cloud-lightning-rain-fill";
        }
        if (lowerCondition.contains("snow") || lowerCondition.contains("sleet")) {
            return "bi-snow";
        }
        if (lowerCondition.contains("mist") || lowerCondition.contains("fog") || lowerCondition.contains("haze")) {
            return "bi-cloud-haze-fill";
        }
        if (lowerCondition.contains("wind")) {
            return "bi-wind";
        }

        return "bi-cloud";
    }
%>

<%@ include file="/includes/footer.jsp" %>