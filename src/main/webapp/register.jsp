<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Register - WeatherApp</title>

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
          href="<%= request.getContextPath() %>/css/register.css"/>
          
   	<!-- Sky Background CSS -->
	<link rel="stylesheet"
	      href="<%= request.getContextPath() %>/css/sky-background.css"/>
</head>
<body class="register-page">

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

<div class="register-wrapper">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-5">

                <div class="card register-card shadow-lg border-0">
                    <div class="card-body p-4 p-md-5">

                        <!-- Logo / Heading -->
                        <div class="text-center mb-4">
                            <div class="register-icon mb-3">
                                <i class="bi bi-cloud-sun-fill"></i>
                            </div>
                            <h2 class="fw-bold mb-2">Create Account</h2>
                            <p class="text-muted mb-0">
                                Join WeatherApp and track your favorite cities
                            </p>
                        </div>

                        <!-- Error Message from Server -->
                        <%
                            String errorMsg = (String) request.getAttribute("error_msg");
                            if (errorMsg != null && !errorMsg.isEmpty()) {
                        %>
                            <div class="alert alert-danger">
                                <%= errorMsg %>
                            </div>
                        <%
                            }
                        %>

                        <!-- Registration Form -->
                        <form action="<%= request.getContextPath() %>/register"
                              method="post"
                              id="registerForm">

                            <!-- Username -->
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">
                                    Username
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-person-fill"></i>
                                    </span>
                                    <input type="text"
                                           class="form-control"
                                           id="username"
                                           name="username"
                                           placeholder="Enter username"
                                           required
                                           autocomplete="username"/>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">
                                    Email
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-envelope-fill"></i>
                                    </span>
                                    <input type="email"
                                           class="form-control"
                                           id="email"
                                           name="email"
                                           placeholder="Enter email address"
                                           required
                                           autocomplete="email"/>
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
                                           autocomplete="new-password"/>
                                </div>

                                <!-- Strength Bar -->
                                <div class="mt-2">
                                    <div class="progress" style="height: 6px;">
                                        <div class="progress-bar"
                                             id="strengthBar"
                                             role="progressbar"
                                             style="width: 0%;">
                                        </div>
                                    </div>
                                    <small id="strengthText" class="mt-1 d-block"></small>
                                </div>
                            </div>

                            <!-- Confirm Password -->
                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label fw-semibold">
                                    Confirm Password
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-shield-lock-fill"></i>
                                    </span>
                                    <input type="password"
                                           class="form-control"
                                           id="confirmPassword"
                                           name="confirmPassword"
                                           placeholder="Confirm your password"
                                           required
                                           autocomplete="new-password"/>
                                </div>

                                <!-- Match Message -->
                                <small id="matchMessage" class="mt-1 d-block"></small>
                            </div>

                            <!-- Register Button -->
                            <div class="d-grid mb-3">
                                <button type="submit"
                                        class="btn btn-primary btn-lg"
                                        id="registerBtn"
                                        disabled>
                                    <i class="bi bi-person-plus-fill me-2"></i>
                                    Register
                                </button>
                            </div>

                            <!-- Login Link -->
                            <div class="text-center">
                                <span class="text-muted">Already have an account?</span>
                                <a href="<%= request.getContextPath() %>/login"
                                   class="login-link ms-1">
                                    Login here
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
     INLINE JAVASCRIPT — Password Strength + Match Check
     ============================================================ -->
<script>

    // ─────────────────────────────────────────
    // STEP 1: Get all the HTML elements we need
    // ─────────────────────────────────────────

    // This gets the password input field
    var passwordInput = document.getElementById("password");

    // This gets the confirm password input field
    var confirmInput = document.getElementById("confirmPassword");

    // This gets the colored progress bar
    var strengthBar = document.getElementById("strengthBar");

    // This gets the text below progress bar (e.g., "Strong")
    var strengthText = document.getElementById("strengthText");

    // This gets the text below confirm field (e.g., "Passwords do not match")
    var matchMessage = document.getElementById("matchMessage");

    // This gets the Register button
    var registerBtn = document.getElementById("registerBtn");


    // ─────────────────────────────────────────
    // STEP 2: Listen for typing in password field
    // ─────────────────────────────────────────
    // "keyup" means: every time user releases a key, run this function

    passwordInput.addEventListener("keyup", function () {

        // Get what user typed so far
        var password = passwordInput.value;

        // Check the strength (our custom function below)
        var result = checkStrength(password);

        // Update the progress bar width (e.g., 25%, 50%, 75%, 100%)
        strengthBar.style.width = result.percent + "%";

        // Update the progress bar color
        strengthBar.className = "progress-bar " + result.barClass;

        // Update the text below bar (e.g., "Medium")
        strengthText.textContent = result.label;

        // Update the text color
        strengthText.className = "mt-1 d-block " + result.textClass;

        // Also re-check if passwords match (because password changed)
        checkMatch();
    });


    // ─────────────────────────────────────────
    // STEP 3: Listen for typing in confirm field
    // ─────────────────────────────────────────

    confirmInput.addEventListener("keyup", function () {

        // Every time user types in confirm field, check if they match
        checkMatch();
    });


    // ─────────────────────────────────────────
    // STEP 4: Function to check password strength
    // ─────────────────────────────────────────
    // This function takes the password string
    // and returns an object with: label, percent, barClass, textClass

    function checkStrength(password) {

        // Start with a score of zero
        var score = 0;

        // If password is empty, return nothing
        if (password.length === 0) {
            return {
                label: "",
                percent: 0,
                barClass: "",
                textClass: ""
            };
        }

        // ── RULE 1: Check length ──
        // If 6 or more characters, add 1 point
        if (password.length >= 6) {
            score = score + 1;
        }

        // If 8 or more characters, add 1 more point
        if (password.length >= 8) {
            score = score + 1;
        }

        // ── RULE 2: Check if has lowercase letter ──
        // /[a-z]/ means: does it contain any letter from a to z?
        if (/[a-z]/.test(password)) {
            score = score + 1;
        }

        // ── RULE 3: Check if has uppercase letter ──
        // /[A-Z]/ means: does it contain any letter from A to Z?
        if (/[A-Z]/.test(password)) {
            score = score + 1;
        }

        // ── RULE 4: Check if has a number ──
        // /[0-9]/ means: does it contain any digit?
        if (/[0-9]/.test(password)) {
            score = score + 1;
        }

        // ── RULE 5: Check if has special character ──
        // /[^a-zA-Z0-9]/ means: anything that is NOT a letter or digit
        if (/[^a-zA-Z0-9]/.test(password)) {
            score = score + 1;
        }

        // ── Now decide the level based on score ──

        // Score 0-1 → Very Weak
        if (score <= 1) {
            return {
                label: "Very Weak",
                percent: 15,
                barClass: "bg-danger",
                textClass: "text-danger"
            };
        }

        // Score 2 → Weak
        if (score === 2) {
            return {
                label: "Weak",
                percent: 35,
                barClass: "bg-warning",
                textClass: "text-warning"
            };
        }

        // Score 3-4 → Medium
        if (score <= 4) {
            return {
                label: "Medium",
                percent: 65,
                barClass: "bg-info",
                textClass: "text-info"
            };
        }

        // Score 5-6 → Strong
        return {
            label: "Strong",
            percent: 100,
            barClass: "bg-success",
            textClass: "text-success"
        };
    }


    // ─────────────────────────────────────────
    // STEP 5: Function to check if passwords match
    // ─────────────────────────────────────────

    function checkMatch() {

        // Get current values from both fields
        var password = passwordInput.value;
        var confirm = confirmInput.value;

        // If confirm field is empty, clear the message and disable button
        if (confirm.length === 0) {
            matchMessage.textContent = "";
            matchMessage.className = "mt-1 d-block";
            registerBtn.disabled = true;
            return;
        }

        // If both fields match
        if (password === confirm) {

            // Show green success message
            matchMessage.textContent = "Passwords match";
            matchMessage.className = "mt-1 d-block text-success fw-semibold";

            // Enable the register button
            registerBtn.disabled = false;

        } else {

            // Show red error message
            matchMessage.textContent = "Passwords do not match";
            matchMessage.className = "mt-1 d-block text-danger fw-semibold";

            // Disable the register button
            registerBtn.disabled = true;
        }
    }

</script>

</body>
</html>