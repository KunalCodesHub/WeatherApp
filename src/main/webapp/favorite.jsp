<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/includes/header.jsp" %>
<%@ page import="com.weather.model.FavoriteCity" %>
<%@ page import="java.util.List" %>

<%
    List<FavoriteCity> favoriteCities = (List<FavoriteCity>) request.getAttribute("favoriteCities");
    String errorMsg = (String) request.getAttribute("error_msg");
    String mostFavoritedCountry = (String) request.getAttribute("mostFavoritedCountry");

    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    Integer totalRecordsObj = (Integer) request.getAttribute("totalRecords");

    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
    int totalRecords = (totalRecordsObj != null) ? totalRecordsObj : 0;
    String favCountry = (mostFavoritedCountry != null) ? mostFavoritedCountry : "N/A";
%>

<!-- Page-specific CSS -->
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/favorite.css"/>

<div class="row">

    <!-- ════════════════════════════════════════
         LEFT COLUMN — Main Content (8 cols)
         ════════════════════════════════════════ -->
    <div class="col-lg-8">

        <h2 class="page-title">
            <i class="bi bi-star-fill text-warning"></i>
            My Favorite Cities
        </h2>

        <!-- Error Message -->
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="alert alert-danger d-flex align-items-center">
                <i class="bi bi-exclamation-circle-fill me-2"></i>
                <%= errorMsg %>
            </div>
        <% } %>

        <!-- ── FILTER SEARCH BOX ── -->
        <% if (favoriteCities != null && !favoriteCities.isEmpty()) { %>

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
                                Total: <strong><%= totalRecords %></strong> favorites
                            </small>
                        </div>
                    </div>
                </div>
            </div>

        <% } %>

        <!-- ── FAVORITES TABLE ── -->
        <% if (favoriteCities != null && !favoriteCities.isEmpty()) { %>

            <div class="card favorites-table-card shadow-sm">
                <div class="card-header favorites-table-header">
                    <h5 class="mb-0">
                        <i class="bi bi-star-fill me-1"></i>
                        Saved Cities
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="favoritesTable">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-center" style="width: 60px;">#</th>
                                    <th>City</th>
                                    <th>Country</th>
                                    <th class="text-center" style="width: 220px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    int rowIndex = (currentPage - 1) * 9 + 1;
                                    for (FavoriteCity city : favoriteCities) {
                                %>
                                    <tr class="fav-row"
                                        data-city="<%= city.getCityName().toLowerCase() %>">

                                        <td class="text-center align-middle">
                                            <span class="row-number"><%= rowIndex++ %></span>
                                        </td>

                                        <td class="align-middle">
                                            <i class="bi bi-geo-alt-fill text-primary me-1"></i>
                                            <span class="fw-semibold"><%= city.getCityName() %></span>
                                        </td>

                                        <td class="align-middle">
                                            <span class="country-badge">
                                                <i class="bi bi-flag-fill me-1"></i>
                                                <%= city.getCountry() %>
                                            </span>
                                        </td>

                                        <td class="text-center align-middle">

                                            <!-- Get Weather Button -->
                                            <form action="<%= request.getContextPath() %>/weather"
                                                  method="post"
                                                  class="d-inline">
                                                <input type="hidden" name="cityName"
                                                       value="<%= city.getCityName() %>"/>
                                                <button type="submit"
                                                        class="btn btn-sm btn-weather">
                                                    <i class="bi bi-cloud-sun-fill me-1"></i>
                                                    Weather
                                                </button>
                                            </form>

                                            <!-- Remove Button -->
                                            <form action="<%= request.getContextPath() %>/favorite"
                                                  method="post"
                                                  class="d-inline remove-form">
                                                <input type="hidden" name="action" value="remove"/>
                                                <input type="hidden" name="id"
                                                       value="<%= city.getId() %>"/>
                                                <button type="submit"
                                                        class="btn btn-sm btn-remove"
                                                        data-city="<%= city.getCityName() %>">
                                                    <i class="bi bi-trash-fill"></i>
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

            <!-- No results row (shown when filter matches nothing) -->
            <div id="noResults" class="alert alert-info mt-3" style="display: none;">
                <i class="bi bi-search me-2"></i>
                No cities match your filter
            </div>

            <!-- ── PAGINATION CONTROLS ── -->
            <% if (totalPages > 1) { %>

                <div class="pagination-wrapper mt-4">
                    <nav aria-label="Favorites pagination">
                        <ul class="pagination justify-content-center">

                            <!-- Previous -->
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

                            <!-- Next -->
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
                            of <%= totalRecords %> favorites
                        </small>
                    </p>
                </div>

            <% } %>

        <% } else if (errorMsg == null) { %>

            <!-- ── EMPTY STATE ── -->
            <div class="card empty-state-card shadow-sm">
                <div class="card-body text-center py-5">
                    <div class="empty-icon mb-3">
                        <i class="bi bi-star"></i>
                    </div>
                    <h5 class="fw-bold mb-2">No Favorites Yet</h5>
                    <p class="text-muted mb-0">
                        You haven't saved any cities to your favorites list.
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
                            <i class="bi bi-collection-fill"></i>
                        </div>
                        <div class="ms-3">
                            <p class="stat-label mb-0">Total Favorites</p>
                            <h4 class="stat-number mb-0"><%= totalRecords %></h4>
                        </div>
                    </div>
                </div>

                <hr class="my-3"/>

                <div class="stat-item">
                    <div class="d-flex align-items-center">
                        <div class="stat-icon-sm stat-icon-success">
                            <i class="bi bi-flag-fill"></i>
                        </div>
                        <div class="ms-3">
                            <p class="stat-label mb-0">Top Country</p>
                            <h6 class="stat-number-sm mb-0"><%= favCountry %></h6>
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
                    <a href="<%= request.getContextPath() %>/history"
                       class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-clock-history me-1"></i>
                        View History
                    </a>
                </div>
            </div>
        </div>

        <!-- ── TIPS ── -->
        <div class="card sidebar-card shadow-sm">
            <div class="card-header sidebar-header">
                <h6 class="mb-0">
                    <i class="bi bi-info-circle-fill me-1"></i>
                    How To Use
                </h6>
            </div>
            <div class="card-body">
                <div class="tip-item mb-3">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-1-circle-fill text-primary me-2 mt-1"></i>
                        <small class="text-muted">
                            Search for a city on the Weather page
                        </small>
                    </div>
                </div>
                <div class="tip-item mb-3">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-2-circle-fill text-primary me-2 mt-1"></i>
                        <small class="text-muted">
                            Click "Add to Favorites" on the weather card
                        </small>
                    </div>
                </div>
                <div class="tip-item">
                    <div class="d-flex align-items-start">
                        <i class="bi bi-3-circle-fill text-primary me-2 mt-1"></i>
                        <small class="text-muted">
                            Come back here anytime to check the weather
                        </small>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<!-- ═════════════════════════════════════════
     JavaScript — Filter + Remove Confirmation
     ═════════════════════════════════════════ -->
<script>

    // ─────────────────────────────────────────
    // PART 1: Live Filter Rows
    // ─────────────────────────────────────────

    var filterInput = document.getElementById("cityFilter");
    var rows = document.querySelectorAll(".fav-row");
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

            // Show "No results" message if nothing matches
            if (noResultsBox) {
                if (visibleCount === 0 && searchText.length > 0) {
                    noResultsBox.style.display = "block";
                } else {
                    noResultsBox.style.display = "none";
                }
            }
        });
    }


    // ─────────────────────────────────────────
    // PART 2: Confirm Before Remove
    // ─────────────────────────────────────────

    // Get all remove forms
    var removeForms = document.querySelectorAll(".remove-form");

    removeForms.forEach(function (form) {

        // Listen for form submit
        form.addEventListener("submit", function (event) {

            // Get city name from the remove button
            var button = form.querySelector(".btn-remove");
            var cityName = button.getAttribute("data-city");

            // Show confirmation popup
            var isConfirmed = confirm(
                "Are you sure you want to remove \"" + cityName + "\" from your favorites?"
            );

            // If user clicked Cancel → stop form submission
            if (!isConfirmed) {
                event.preventDefault();
            }

            // If user clicked OK → let the form submit normally
        });
    });

</script>

<%@ include file="/includes/footer.jsp" %>