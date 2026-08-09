<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>WeatherApp</title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>

    <!-- Universal CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css"/>

</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark" id="mainNavbar">
    <div class="container">

        <!-- Brand -->
        <a class="navbar-brand d-flex align-items-center gap-2" href="#">
            <i class="bi bi-cloud-sun-fill fs-4"></i>
            <span class="fw-bold">WeatherApp</span>
        </a>

        <!-- Mobile Toggle Button -->
        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarNav"
                aria-controls="navbarNav"
                aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Nav Links -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">

                <li class="nav-item">
                    <a class="nav-link d-flex align-items-center gap-1"
                       href="<%= request.getContextPath() %>/weather">
                        <i class="bi bi-search"></i>
                        Weather
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link d-flex align-items-center gap-1"
                       href="<%= request.getContextPath() %>/favorite">
                        <i class="bi bi-star-fill"></i>
                        Favorites
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link d-flex align-items-center gap-1"
                       href="<%= request.getContextPath() %>/history">
                        <i class="bi bi-clock-history"></i>
                        History
                    </a>
                </li>

                <!-- Divider (visible on large screens) -->
                <li class="nav-item d-none d-lg-block">
                    <span class="nav-link text-secondary px-1">|</span>
                </li>

                <li class="nav-item">
                    <a class="nav-link d-flex align-items-center gap-1 text-danger-emphasis"
                       href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right"></i>
                        Logout
                    </a>
                </li>

            </ul>
        </div>

    </div>
</nav>

<!-- MAIN CONTENT WRAPPER — closed in footer.jsp -->
<div class="container mt-4 mb-5">