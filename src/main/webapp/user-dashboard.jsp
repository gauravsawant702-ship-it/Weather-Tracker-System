<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"user".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Weather Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
:root { --bg: linear-gradient(135deg, #74ebd5 0%, #ACB6E5 100%); --card: rgba(255,255,255,0.15); --text: #000; }
body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin:0; padding:20px; color: var(--text); }
nav { background:#333; padding:10px; border-radius:8px; }
nav a { color:white; margin-right:15px; text-decoration:none; font-weight:500; }
.nav-right { float:right; color:#fff; }
.container { margin-top:30px; display:flex; flex-direction:column; align-items:center; }
input[type=text], input[type=month] { padding:10px; width:250px; border-radius:12px; border:none; box-shadow:0 4px 15px rgba(0,0,0,0.2); }
button { padding:10px 15px; margin-left:10px; border-radius:12px; border:none; background-color:#4a90e2; color:#fff; font-weight:600; cursor:pointer; transition:0.3s; }
button:hover { background-color:#357ab8; transform:scale(1.05); }
.weather-card { margin-top:30px; width:90%; max-width:600px; background: var(--card); backdrop-filter:blur(15px); border-radius:20px; padding:30px; box-shadow:0 8px 32px rgba(31,38,135,0.37); border:1px solid rgba(255,255,255,0.18); }
.temp { font-size:48px; font-weight:700; margin-bottom:10px; }
.forecast { display:flex; gap:10px; flex-wrap:wrap; justify-content:center; margin-top:20px; }
.day-card { background:rgba(255,255,255,0.3); padding:15px; border-radius:12px; text-align:center; min-width:90px; }
canvas { margin-top:30px; background: rgba(255,255,255,0.2); border-radius:12px; padding:10px; }
</style>
</head>
<body>

<nav>
    <a href="user-dashboard.jsp">Dashboard</a>
    <a href="feedback.jsp">Feedback</a>
    <a href="about.jsp">About Us</a>
    <span class="nav-right">
        Welcome, <b><%= username %></b> |
        <a href="LogoutServlet" style="color: yellow;">Logout</a>
    </span>
</nav>

<div class="container">
    <!-- City Input -->
    <div class="mb-3">
        <input type="text" id="cityInput" placeholder="Enter city name..." />
        <button onclick="fetchByCity()">Get Weather</button>
    </div>

    <!-- Month Picker & PDF -->
    <div class="mb-3">
        <label for="monthSelect">Select Month:</label>
        <input type="month" id="monthSelect" max="<%= LocalDate.now() %>"/>
        <button onclick="downloadMonthlyReport()">📄 Download Monthly Report (PDF)</button>
    </div>

    <!-- Weather Display -->
    <div id="weatherDisplay" class="weather-card"></div>

    <!-- Forecast Cards -->
    <div id="forecast" class="forecast"></div>

    <!-- Charts -->
    <canvas id="tempChart" width="600" height="250"></canvas>
    <canvas id="rainChart" width="600" height="250"></canvas>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
/* =========================
   API CONFIG
========================= */
const GEO_API = "https://geocoding-api.open-meteo.com/v1/search?count=1&name=";
const WEATHER_API = "https://api.open-meteo.com/v1/forecast";

/* =========================
   AUTO LOAD GEOLOCATION
========================= */
window.onload = () => {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            pos => loadWeather(pos.coords.latitude, pos.coords.longitude, "Your Location"),
            () => document.getElementById("weatherDisplay").innerHTML = "Location access denied"
        );
    }
};

/* =========================
   FETCH WEATHER BY CITY
========================= */
async function fetchByCity() {
    const city = document.getElementById("cityInput").value.trim();
    if (!city) return;

    try {
        const res = await fetch(GEO_API + city);
        const geo = await res.json();

        if (!geo.results) {
            document.getElementById("weatherDisplay").innerHTML = "City not found";
            return;
        }

        const c = geo.results[0];
        loadWeather(c.latitude, c.longitude, city);
    } catch (err) {
        document.getElementById("weatherDisplay").innerHTML = "Error fetching city data";
    }
}

/* =========================
   LOAD WEATHER & FORECAST
========================= */
async function loadWeather(lat, lon, label) {
    try {
        const url = WEATHER_API +
            "?latitude=" + lat +
            "&longitude=" + lon +
            "&current_weather=true" +
            "&daily=temperature_2m_max,temperature_2m_min,precipitation_sum" +
            "&timezone=auto";

        const res = await fetch(url);
        const data = await res.json();

        // Current Weather
        document.getElementById("weatherDisplay").innerHTML =
            "<h3>" + label + "</h3>" +
            "<div class='temp'>" + data.current_weather.temperature + "°C</div>" +
            "<p>Wind: " + data.current_weather.windspeed + " m/s</p>";

        // 7-Day Forecast
        const forecastDiv = document.getElementById("forecast");
        forecastDiv.innerHTML = "";
        for (let i = 0; i < 7; i++) {
            forecastDiv.innerHTML +=
                "<div class='day-card'>" +
                "<b>" + data.daily.time[i] + "</b><br>" +
                "🌡 " + data.daily.temperature_2m_max[i] + "° / " +
                data.daily.temperature_2m_min[i] + "°<br>" +
                "🌧 " + data.daily.precipitation_sum[i] + "mm" +
                "</div>";
        }

        // Store for PDF & charts
        window.lastLat = lat;
        window.lastLon = lon;
        window.lastCity = label;

        // Update charts with 7-day data
        renderCharts(data.daily.time, data.daily.temperature_2m_max, data.daily.temperature_2m_min, data.daily.precipitation_sum);

    } catch (err) {
        document.getElementById("weatherDisplay").innerHTML = "Error fetching weather data. Please check city or month.";
    }
}

/* =========================
   RENDER CHARTS
========================= */
let tempChartInstance, rainChartInstance;

function renderCharts(dates, maxTemps, minTemps, rains) {
    const ctxTemp = document.getElementById("tempChart").getContext("2d");
    const ctxRain = document.getElementById("rainChart").getContext("2d");

    if(tempChartInstance) tempChartInstance.destroy();
    if(rainChartInstance) rainChartInstance.destroy();

    tempChartInstance = new Chart(ctxTemp, {
        type: 'line',
        data: {
            labels: dates,
            datasets: [
                { label: "Max Temp (°C)", data: maxTemps, borderColor: "#ff5733", backgroundColor: "#ff573350", tension:0.3 },
                { label: "Min Temp (°C)", data: minTemps, borderColor: "#33a1ff", backgroundColor: "#33a1ff50", tension:0.3 }
            ]
        },
        options: { responsive:true, plugins:{ legend:{ position:'top' } }, scales:{ y:{ beginAtZero:true } } }
    });

    rainChartInstance = new Chart(ctxRain, {
        type: 'bar',
        data: {
            labels: dates,
            datasets: [
                { label: "Rainfall (mm)", data: rains, backgroundColor: "#4caf50" }
            ]
        },
        options: { responsive:true, plugins:{ legend:{ position:'top' } }, scales:{ y:{ beginAtZero:true } } }
    });
}

/* =========================
   DOWNLOAD MONTHLY REPORT
========================= */
function downloadMonthlyReport() {
    const month = document.getElementById("monthSelect").value;
    if(!month) return alert("Select month first");

    const city = prompt("Enter city for report:", window.lastCity || "");
    if(!city) return alert("City is required");

    // Avoid EL parsing, use string concatenation
    const url = "MonthlyWeatherReportServlet?city=" + encodeURIComponent(city) + "&month=" + month;
    window.location.href = url;
}
</script>

</body>
</html>
