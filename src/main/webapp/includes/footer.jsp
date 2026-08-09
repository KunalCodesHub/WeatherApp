</div>
<%-- ↑ Closes <div class="container mt-4 mb-5"> opened in header.jsp --%>

<!-- FOOTER -->
<footer id="mainFooter">
    <div class="container">
        <div class="row align-items-center">

            <!-- Left — Brand -->
            <div class="col-md-4 text-center text-md-start mb-2 mb-md-0">
                <span class="d-flex align-items-center gap-2 justify-content-center
                             justify-content-md-start">
                    <i class="bi bi-cloud-sun-fill"></i>
                    <span class="fw-semibold">WeatherApp</span>
                </span>
            </div>

            <!-- Center — Copyright -->
            <div class="col-md-4 text-center mb-2 mb-md-0">
                <small class="text-muted">
                    &copy; 2026 WeatherApp. All rights reserved.
                </small>
            </div>

            <!-- Right — Nav Links -->
            <div class="col-md-4 text-center text-md-end">
                <a href="${pageContext.request.contextPath}/weather"
                   class="footer-link me-2">Weather</a>
                <a href="${pageContext.request.contextPath}/favorite"
                   class="footer-link me-2">Favorites</a>
                <a href="${pageContext.request.contextPath}/history"
                   class="footer-link">History</a>
            </div>

        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>