<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Weather Tracker</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
:root {
    --bg: linear-gradient(135deg, #1e3c72, #2a5298);
    --card: rgba(255,255,255,0.15);
    --text: #fff;
}
.light {
    --bg: linear-gradient(135deg, #74ebd5, #ACB6E5);
    --card: rgba(255,255,255,0.4);
    --text: #000;
}
body {
    font-family: 'Segoe UI', sans-serif;
    background: var(--bg);
    min-height: 100vh;
    padding: 20px;
    color: var(--text);
    transition: 0.3s;
}
.navbar {
    background: rgba(0,0,0,0.35);
    padding: 12px 20px;
    border-radius: 15px;
}
.navbar a { color: var(--text); margin-right: 15px; text-decoration: none; }
.container { margin-top: 40px; text-align: center; }
.weather-card {
    margin: 30px auto;
    max-width: 450px;
    background: var(--card);
    backdrop-filter: blur(15px);
    padding: 30px;
    border-radius: 25px;
}
.temp { font-size: 64px; font-weight: bold; }
.forecast {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(120px,1fr));
    gap: 15px;
    margin-top: 25px;
}
.day-card {
    background: var(--card);
    padding: 15px;
    border-radius: 15px;
    font-size: 14px;
}
.toggle-btn {
    border-radius: 20px;
    border: none;
    padding: 6px 12px;
    background: #ff9800;
    font-weight: bold;
}
#cityInput { margin-bottom: 10px; }
</style>
</head>
<body>

<div class="navbar d-flex justify-content-between">
    <div>
        <a href="index.jsp">Home</a>
        
    </div>
    <div>
        <button class="toggle-btn" onclick="toggleTheme()">🌙 / ☀️</button>
        <% if (username != null) { %>
            | Welcome, <b><%= username %></b>
            <a href="user-dashboard.jsp" style="color:#ffeb3b;">Dashboard</a>
            <a href="LogoutServlet" style="color:#ff9800;">Logout</a>
        <% } else { %>
            | <button class="btn btn-warning btn-sm" onclick="goLogin()">Login</button>
            <button class="btn btn-success btn-sm" onclick="goRegister()">Register</button>
        <% } %>
    </div>
</div>

<div class="container">
    <h1>Real Time Weather Tracker</h1>
    <input type="text" id="cityInput" placeholder="Search another city"
           class="form-control w-50 mx-auto">
    <button class="btn btn-warning" onclick="restrictedSearch()">Search</button>
    <div id="weatherDisplay" class="weather-card">Detecting your location...</div>
    <div id="forecast" class="forecast"></div>
</div>

<div class="modal fade" id="authModal">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content text-dark">
      <div class="modal-body text-center">
        <h5>Login Required</h5>
        <p>Search other cities after login</p>
        <a href="login.jsp" class="btn btn-primary">Login</a>
        <a href="register.jsp" class="btn btn-success">Register</a>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
let userLoggedIn = <%= (username != null) %>;
const GEO_API = "https://geocoding-api.open-meteo.com/v1/search?count=1&name=";
const WEATHER_API = "https://api.open-meteo.com/v1/forecast";

window.onload = function () {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(async function(pos){
            const lat = pos.coords.latitude;
            const lon = pos.coords.longitude;

            let cityName = "Pune";

            try {
                const geoRes = await fetch(`https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json`);
                const geoData = await geoRes.json();
                if (geoData.address) {
                    // Fallback chain for city detection
                    cityName = geoData.address.city ||
                               geoData.address.town ||
                               geoData.address.village ||
                               geoData.address.hamlet ||
                               geoData.address.county ||
                               geoData.address.state ||
                               "Your Location";
                }
                document.getElementById("cityInput").value = cityName;
            } catch(e) { console.log("Reverse geocoding failed", e); }

            loadWeather(lat, lon, cityName);
        }, function(){
            document.getElementById("weatherDisplay").innerHTML = "Location denied";
        });
    }
};

function restrictedSearch() {
    if (!userLoggedIn) {
        new bootstrap.Modal(document.getElementById("authModal")).show();
        return;
    }
    fetchByCity();
}

async function fetchByCity() {
    const city = document.getElementById("cityInput").value.trim();
    if (!city) return;

    const res = await fetch(GEO_API + city);
    const geo = await res.json();

    if (!geo.results) {
        document.getElementById("weatherDisplay").innerHTML = "City not found";
        return;
    }

    const c = geo.results[0];
    loadWeather(c.latitude, c.longitude, city);
}

async function loadWeather(lat, lon, label) {
    const url = WEATHER_API +
                "?latitude=" + lat +
                "&longitude=" + lon +
                "&current_weather=true" +
                "&daily=temperature_2m_max,temperature_2m_min" +
                "&timezone=auto";

    const res = await fetch(url);
    const data = await res.json();

    document.getElementById("weatherDisplay").innerHTML =
        "<h3>" + label + "</h3>" +
        "<div class='temp'>" + data.current_weather.temperature + "°C</div>" +
        "<p>Wind: " + data.current_weather.windspeed + " m/s</p>";

    const forecastDiv = document.getElementById("forecast");
    forecastDiv.innerHTML = "";

    for (let i = 0; i < (data.daily.time.length || 7); i++) {
        forecastDiv.innerHTML +=
            "<div class='day-card'>" +
            "<b>" + data.daily.time[i] + "</b><br>" +
            "🌡 " + data.daily.temperature_2m_max[i] + "° / " +
            data.daily.temperature_2m_min[i] + "°" +
            "</div>";
    }
}

function toggleTheme() { document.body.classList.toggle("light"); }
function goLogin() { location.href = "login.jsp"; }
function goRegister() { location.href = "register.jsp"; }
</script>
</body>
</html>
