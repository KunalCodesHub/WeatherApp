<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>
<%@ page import="com.weather.model.WeatherSearch" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    List<WeatherSearch> history = (List<WeatherSearch>) request.getAttribute("history");
    String errorMsg = (String) request.getAttribute("error_msg");
    String mostSearchedCity = (String) request.getAttribute("mostSearchedCity");
    String mostCommonCondition = (String) request.getAttribute("mostCommonCondition");

    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    Integer totalRecordsObj = (Integer) request.getAttribute("totalRecords");

    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
    int totalRecords = (totalRecordsObj != null) ? totalRecordsObj : 0;

    String topCity = (mostSearchedCity != null) ? mostSearchedCity : "N/A";
    String topCondition = (mostCommonCondition != null) ? mostCommonCondition : "N/A";

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy • HH:mm");
    DateTimeFormatter shortDateFormatter = DateTimeFormatter.ofPattern("MMM dd, HH:mm");
%>

<!-- Page-specific CSS -->
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/history.css"/>

<div class="row">

    <!-- ════════════════════════════════════════
         LEFT COLUMN — Main Content (8 cols)
         ════════════════════════════════════════ -->
    <div class="col-lg-8">

        <h2 class="page-title">
            <i class="bi bi-clock-history text-primary"></i>
            Search History
        </h2>

        <!-- Error Message -->
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="alert alert-danger d-flex align-items-center">
                <i class="bi bi-exclamation-circle-fill me-2"></i>
                <%= errorMsg %>
            </div>
        <% } %>

        <!-- ── FILTER SEARCH BOX ── -->
        <% if (history != null && !history.isEmpty()) { %>

            <div class="card filter-card shadow-sm mb-4">
                <div class="card-body py-3">
                    <div class="row align-items-center g-2">
                        <div class="col-md-8">
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="bi bi-funnel-fill"></i>
                                </span>
                                <input type="text"
                                       id="cityFilter"
                                       class="form-control"
                                       placeholder="Filter by city name..."/>
                            </div>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <small class="text-muted">
                                <i class="bi bi-info-circle me-1"></i>
                                Total: <strong><%= totalRecords %></strong> searches
                            </small>
                        </div>
                    </div>
                </div>
            </div>

        <% } %>

        <!-- ── HISTORY TABLE ── -->
        <% if (history != null && !history.isEmpty()) { %>

            <div class="card history-table-card shadow-sm">
                <div class="card-header history-table-header">
                    <h5 class="mb-0">
                        <i class="bi bi-clock-history me-1"></i>
                        Recent Searches
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="historyTable">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-center" style="width: 50px;">#</th>
                                    <th>City</th>
                                    <th class="text-center">Temp</th>
                                    <th class="d-none d-md-table-cell">Condition</th>
                                    <th class="d-none d-lg-table-cell">Date</th>
                                    <th class="text-center" style="width: 140px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int rowIndex = (currentPage - 1) * 9 + 1;
                                    for (WeatherSearch search : history) {
                                %>
                                    <tr class="history-row"
                                        data-city="<%= search.getCityName().toLowerCase() %>">

                                        <td class="text-center align-middle">
                                            <span class="row-number"><%= rowIndex++ %></span>
                                        </td>

                                        <td class="align-middle">
                                            <div>
                                                <i class="bi bi-geo-alt-fill text-primary me-1"></i>
                                                <span class="fw-semibold"><%= search.getCityName() %></span>
                                            </div>
                                            <small class="text-muted ms-4">
                                                <i class="bi bi-flag-fill me-1"></i>
                                                <%= search.getCountry() %>
                                            </small>
                                        </td>

                                        <td class="text-center align-middle">
                                            <span class="temp-badge">
                                                <%= (int) search.getTemperature() %>°C
                                            </span>
                                        </td>

                                        <td class="align-middle d-none d-md-table-cell">
                                            <span class="condition-inline <%= getConditionClass(search.getWeatherCondition()) %>">
                                                <i class="bi <%= getWeatherIcon(search.getWeatherCondition()) %> me-1"></i>
                                                <%= search.getWeatherCondition() %>
                                            </span>
                                        </td>

                                        <td class="align-middle d-none d-lg-table-cell">
                                            <small class="text-muted">
                                                <i class="bi bi-calendar-event me-1"></i>
                                                <%= search.getSearchDate().format(shortDateFormatter) %>
                                            </small>
                                        </td>

                                        <td class="text-center align-middle">

                                            <!-- View Details Button -->
                                            <button type="button"
                                                    class="btn btn-sm btn-details-inline"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#detailsModal<%= search.getId() %>"
                                                    title="View Details">
                                                <i class="bi bi-eye-fill"></i>
                                            </button>

                                            <!-- Add to Favorites -->
                                            <form action="<%= request.getContextPath() %>/favorite"
                                                  method="post"
                                                  class="d-inline">
                                                <input type="hidden" name="action" value="save"/>
                                                <input type="hidden" name="cityName"
                                                       value="<%= search.getCityName() %>"/>
                                                <input type="hidden" name="countryName"
                                                       value="<%= search.getCountry() %>"/>
                                                <button type="submit"
                                                        class="btn btn-sm btn-favorite-inline"
                                                        title="Add to Favorites">
                                                    <i class="bi bi-star-fill"></i>
                                                </button>
                                            </form>

                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- No results row -->
            <div id="noResults" class="alert alert-info mt-3" style="display: none;">
                <i class="bi bi-search me-2"></i>
                No searches match your filter
            </div>

            <!-- ── MODALS (One per row) ── -->
            <% for (WeatherSearch search : history) { %>

                <div class="modal fade"
                     id="detailsModal<%= search.getId() %>"
                     tabindex="-1"
                     aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">

                            <div class="modal-header <%= getConditionClass(search.getWeatherCondition()) %>">
                                <h5 class="modal-title">
                                    <i class="bi bi-geo-alt-fill me-1"></i>
                                    <%= search.getCityName() %>, <%= search.getCountry() %>
                                </h5>
                                <button type="button"
                                        class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                            </div>

                            <div class="modal-body">

                                <div class="text-center mb-4">
                                    <i class="bi <%= getWeatherIcon(search.getWeatherCondition()) %> modal-big-icon"></i>
                                    <h2 class="modal-temp mt-2"><%= search.getTemperature() %> °C</h2>
                                    <p class="modal-condition mb-0">
                                        <%= search.getWeatherCondition() %>
                                    </p>
                                </div>

                                <p class="modal-description text-center mb-4">
                                    <em><%= search.getWeatherDescription() %></em>
                                </p>

                                <div class="row text-center g-2">
                                    <div class="col-4">
                                        <div class="modal-stat">
                                            <i class="bi bi-thermometer-half text-danger"></i>
                                            <p class="modal-stat-label">Temp</p>
                                            <p class="modal-stat-value"><%= search.getTemperature() %>°C</p>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="modal-stat">
                                            <i class="bi bi-droplet-fill text-info"></i>
                                            <p class="modal-stat-label">Humidity</p>
                                            <p class="modal-stat-value"><%= search.getHumidity() %>%</p>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="modal-stat">
                                            <i class="bi bi-wind text-secondary"></i>
                                            <p class="modal-stat-label">Wind</p>
                                            <p class="modal-stat-value"><%= search.getWindSpeed() %> km/h</p>
                                        </div>
                                    </div>
                                </div>

                                <hr class="my-3"/>

                                <p class="text-center text-muted mb-0">
                                    <i class="bi bi-calendar-event me-1"></i>
                                    <small>Searched on <%= search.getSearchDate().format(dateFormatter) %></small>
                                </p>
                            </div>

                            <div class="modal-footer">
                                <button type="button"
                                        class="btn btn-secondary"
                                        data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>

            <% } %>

            <!-- ── PAGINATION ── -->
            <% if (totalPages > 1) { %>

                <div class="pagination-wrapper mt-4">
                    <nav aria-label="History pagination">
                        <ul class="pagination justify-content-center">

                            <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                                <a class="page-link" href="?page=<%= currentPage - 1 %>">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>

                            <%
                                int startPage = Math.max(1, currentPage - 2);
                                int endPage = Math.min(totalPages, currentPage + 2);

                                if (startPage > 1) {
                            %>
                                <li class="page-item">
                                    <a class="page-link" href="?page=1">1</a>
                                </li>
                                <% if (startPage > 2) { %>
                                    <li class="page-item disabled">
                                        <span class="page-link">...</span>
                                    </li>
                                <% } %>
                            <% } %>

                            <% for (int i = startPage; i <= endPage; i++) { %>
                                <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                                    <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                                </li>
                            <% } %>

                            <% if (endPage < totalPages) { %>
                                <% if (endPage < totalPages - 1) { %>
                                    <li class="page-item disabled">
                                        <span class="page-link">...</span>
                                    </li>
                                <% } %>
                                <li class="page-item">
                                    <a class="page-link" href="?page=<%= totalPages %>"><%= totalPages %></a>
                                </li>
                            <% } %>

                            <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                                <a class="page-link" href="?page=<%= currentPage + 1 %>">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>

                        </ul>
                    </nav>

                    <p class="text-center text-muted mt-2 mb-0">
                        <small>
                            Page <strong><%= currentPage %></strong> of <strong><%= totalPages %></strong>
                            &nbsp;•&nbsp;
                            Showing <%= (currentPage - 1) * 9 + 1 %>
                            to <%= Math.min(currentPage * 9, totalRecords) %>
                            of <%= totalRecords %> searches
                        </small>
                    </p>
                </div>

            <% } %>

        <% } else if (errorMsg == null) { %>

            <!-- ── EMPTY STATE ── -->
            <div class="card empty-state-card shadow-sm">
                <div class="card-body text-center py-5">
                    <div class="empty-icon mb-3">
                        <i class="bi bi-inbox"></i>
                    </div>
                    <h5 class="fw-bold mb-2">No Search History Yet</h5>
                    <p class="text-muted mb-0">
                        You haven't searched for any city weather yet.
                    </p>
                </div>
            </div>

        <% } %>

    </div>

    <!-- ════════════════════════════════════════
         RIGHT COLUMN — Sidebar (4 cols)
         ════════════════════════════════════════ -->
    <div class="col-lg-4 mt-4 mt-lg-0">

        <!-- ── STATS CARD ── -->
        <div class="card sidebar-card shadow-sm mb-4">
            <div class="card-header sidebar-header">
                <h6 class="mb-0">
                    <i class="bi bi-bar-chart-fill me-1"></i>
                    Quick Stats
                </h6>
            </div>
            <div class="card-body">

                <div class="stat-item mb-3">
                    <div class="d-flex align-items-center">
                        <div class="stat-icon-sm stat-icon-primary">
                            <i class="bi bi-search"></i>
                        </div>
                        <div class="ms-3">
                            <p class="stat-label mb-0">Total Searches</p>
                            <h4 class="stat-number mb-0"><%= totalRecords %></h4>
                        </div>
                    </div>
                </div>

                <hr class="my-3"/>

                <div class="stat-item mb-3">
                    <div class="d-flex align-items-center">
                        <div class="stat-icon-sm stat-icon-success">
                            <i class="bi bi-geo-alt-fill"></i>
                        </div>
                        <div class="ms-3">
                            <p class="stat-label mb-0">Most Searched City</p>
                            <h6 class="stat-number-sm mb-0"><%= topCity %></h6>
                        </div>
                    </div>
                </div>

                <hr class="my-3"/>

                <div class="stat-item">
                    <div class="d-flex align-items-center">
                        <div class="stat-icon-sm stat-icon-warning">
                            <i class="bi <%= getWeatherIcon(topCondition) %>"></i>
                        </div>
                        <div class="ms-3">
                            <p class="stat-label mb-0">Common Weather</p>
                            <h6 class="stat-number-sm mb-0"><%= topCondition %></h6>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- ── QUICK ACCESS ── -->
        <div class="card sidebar-card shadow-sm mb-4">
            <div class="card-header sidebar-header">
                <h6 class="mb-0">
                    <i class="bi bi-lightning-fill me-1"></i>
                    Quick Access
                </h6>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="<%= request.getContextPath() %>/weather"
                       class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-cloud-sun me-1"></i>
                        Search Weather
                    </a>
                    <a href="<%= request.getContextPath() %>/favorite"
                       class="btn btn-outline-warning btn-sm">
                        <i class="bi bi-star-fill me-1"></i>
                        View Favorites
                    </a>
                </div>
            </div>
        </div>

        <!-- ── TIPS ── -->
        <div class="card sidebar-card shadow-sm">
            <div class="card-header sidebar-header">
                <h6 class="mb-0">
                    <i class="bi bi-info-circle-fill me-1"></i>
                    Did You Know?
                </h6>
            </div>
            <div class="card-body">
                <div class="tip-item mb-3">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-lightbulb-fill text-warning me-2 mt-1"></i>
                        <small class="text-muted">
                            Click the eye icon to see full weather details
                        </small>
                    </div>
                </div>
                <div class="tip-item mb-3">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-star-fill text-warning me-2 mt-1"></i>
                        <small class="text-muted">
                            Save cities to favorites for quick access
                        </small>
                    </div>
                </div>
                <div class="tip-item">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-funnel-fill text-primary me-2 mt-1"></i>
                        <small class="text-muted">
                            Use the filter to find past searches quickly
                        </small>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<!-- ═════════════════════════════════════════
     JavaScript — Live Filter Rows
     ═════════════════════════════════════════ -->
<script>

    var filterInput = document.getElementById("cityFilter");
    var rows = document.querySelectorAll(".history-row");
    var noResultsBox = document.getElementById("noResults");

    if (filterInput) {

        filterInput.addEventListener("keyup", function () {

            var searchText = filterInput.value.toLowerCase().trim();
            var visibleCount = 0;

            rows.forEach(function (row) {
                var cityName = row.getAttribute("data-city");
                if (cityName.indexOf(searchText) !== -1) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            });

            if (noResultsBox) {
                if (visibleCount === 0 && searchText.length > 0) {
                    noResultsBox.style.display = "block";
                } else {
                    noResultsBox.style.display = "none";
                }
            }
        });
    }

</script>

<!-- ═════════════════════════════════════════
     HELPER FUNCTIONS
     ═════════════════════════════════════════ -->
<%!
    public String getWeatherIcon(String condition) {
        if (condition == null) return "bi-cloud";
        String lower = condition.toLowerCase();

        if (lower.contains("clear") || lower.contains("sunny")) return "bi-sun-fill";
        if (lower.contains("cloud") || lower.contains("overcast")) return "bi-cloud-fill";
        if (lower.contains("rain") || lower.contains("drizzle")) return "bi-cloud-rain-fill";
        if (lower.contains("thunder") || lower.contains("storm")) return "bi-cloud-lightning-rain-fill";
        if (lower.contains("snow") || lower.contains("sleet")) return "bi-snow";
        if (lower.contains("mist") || lower.contains("fog") || lower.contains("haze")) return "bi-cloud-haze-fill";
        if (lower.contains("wind")) return "bi-wind";
        return "bi-cloud";
    }

    public String getConditionClass(String condition) {
        if (condition == null) return "condition-default";
        String lower = condition.toLowerCase();

        if (lower.contains("clear") || lower.contains("sunny")) return "condition-sunny";
        if (lower.contains("cloud") || lower.contains("overcast")) return "condition-cloudy";
        if (lower.contains("rain") || lower.contains("drizzle")) return "condition-rainy";
        if (lower.contains("thunder") || lower.contains("storm")) return "condition-stormy";
        if (lower.contains("snow") || lower.contains("sleet")) return "condition-snowy";
        if (lower.contains("mist") || lower.contains("fog") || lower.contains("haze")) return "condition-misty";
        return "condition-default";
    }
%>

<%@ include file="/includes/footer.jsp" %>