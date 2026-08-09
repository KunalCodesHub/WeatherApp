<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Login - WeatherApp</title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>

    <!-- Universal CSS -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css"/>

    <!-- Page-specific CSS -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/login.css"/>
          
    <!-- Sky Background CSS -->
	<link rel="stylesheet"
	      href="<%= request.getContextPath() %>/css/sky-background.css"/>      
</head>
<body class="login-page">
<!-- ═══════════════════════════════════════
     SKY BACKGROUND — Floating Circles
     ═══════════════════════════════════════ -->
<div class="sky-background">
    <div class="circle circle-medium circle-1"></div>
    <div class="circle circle-large  circle-2"></div>
    <div class="circle circle-small  circle-3"></div>
    <div class="circle circle-medium circle-4"></div>
    <div class="circle circle-large  circle-5"></div>
    <div class="circle circle-small  circle-6"></div>
    <div class="circle circle-medium circle-7"></div>
    <div class="circle circle-small  circle-8"></div>
</div>

<div class="login-wrapper">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-12 col-sm-10 col-md-8 col-lg-5 col-xl-4">

                <div class="card login-card shadow-lg border-0">
                    <div class="card-body p-4 p-md-5">

                        <!-- Logo / Heading -->
                        <div class="text-center mb-4">
                            <div class="login-icon mb-3">
                                <i class="bi bi-cloud-sun-fill"></i>
                            </div>
                            <h2 class="fw-bold mb-2">Welcome Back</h2>
                            <p class="text-muted mb-0">
                                Login to access your weather dashboard
                            </p>
                        </div>

                        <!-- Success Message from Registration -->
                        <%
                            String successMsg = (String) request.getAttribute("success_msg");
                            if (successMsg != null && !successMsg.isEmpty()) {
                        %>
                            <div class="alert alert-success d-flex align-items-center">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                <%= successMsg %>
                            </div>
                        <%
                            }
                        %>

                        <!-- Error Message -->
                        <%
                            String errorMsg = (String) request.getAttribute("error_msg");
                            if (errorMsg != null && !errorMsg.isEmpty()) {
                        %>
                            <div class="alert alert-danger d-flex align-items-center">
                                <i class="bi bi-exclamation-circle-fill me-2"></i>
                                <%= errorMsg %>
                            </div>
                        <%
                            }
                        %>

                        <!-- Login Form -->
                        <form action="<%= request.getContextPath() %>/login"
                              method="post"
                              id="loginForm">

                            <!-- Username or Email -->
                            <div class="mb-3">
                                <label for="usernameOrEmail" class="form-label fw-semibold">
                                    Username or Email
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-person-fill"></i>
                                    </span>
                                    <input type="text"
                                           class="form-control"
                                           id="usernameOrEmail"
                                           name="usernameOrEmail"
                                           placeholder="Enter username or email"
                                           required
                                           autocomplete="username"/>
                                </div>
                            </div>

                            <!-- Password -->
                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">
                                    Password
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-lock-fill"></i>
                                    </span>
                                    <input type="password"
                                           class="form-control"
                                           id="password"
                                           name="password"
                                           placeholder="Enter password"
                                           required
                                           autocomplete="current-password"/>
                                    <!-- Toggle Password Visibility Button -->
                                    <button class="btn btn-outline-secondary"
                                            type="button"
                                            id="togglePassword">
                                        <i class="bi bi-eye-fill" id="toggleIcon"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Remember Me -->
                            <div class="mb-4 d-flex align-items-center">
                                <div class="form-check">
                                    <input class="form-check-input"
                                           type="checkbox"
                                           id="rememberMe"
                                           name="rememberMe"
                                           value="true"/>
                                    <label class="form-check-label" for="rememberMe">
                                        Remember me
                                    </label>
                                </div>
                            </div>

                            <!-- Login Button -->
                            <div class="d-grid mb-3">
                                <button type="submit"
                                        class="btn btn-primary btn-lg"
                                        id="loginBtn">
                                    <i class="bi bi-box-arrow-in-right me-2"></i>
                                    Login
                                </button>
                            </div>

                            <!-- Register Link -->
                            <div class="text-center">
                                <span class="text-muted">Don't have an account?</span>
                                <a href="<%= request.getContextPath() %>/register"
                                   class="register-link ms-1">
                                    Register here
                                </a>
                            </div>

                        </form>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js">
</script>

<!-- ============================================================
     INLINE JAVASCRIPT — Toggle Password Visibility
     ============================================================ -->
<script>

    // ─────────────────────────────────────────
    // STEP 1: Get the elements we need
    // ─────────────────────────────────────────

    // This gets the password input field
    var passwordField = document.getElementById("password");

    // This gets the toggle button (eye icon button)
    var toggleButton = document.getElementById("togglePassword");

    // This gets the icon inside the button
    var toggleIcon = document.getElementById("toggleIcon");


    // ─────────────────────────────────────────
    // STEP 2: Listen for click on toggle button
    // ─────────────────────────────────────────
    // When user clicks the eye icon button, run this function

    toggleButton.addEventListener("click", function () {

        // Check current type of password field
        // If it is "password" → text is hidden (dots)
        // If it is "text" → text is visible

        if (passwordField.type === "password") {

            // Change to text → password becomes visible
            passwordField.type = "text";

            // Change icon to "eye-slash" (closed eye)
            toggleIcon.className = "bi bi-eye-slash-fill";

        } else {

            // Change back to password → password becomes hidden
            passwordField.type = "password";

            // Change icon back to "eye" (open eye)
            toggleIcon.className = "bi bi-eye-fill";
        }
    });

</script>
</body>
</html>