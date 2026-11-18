<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.lang.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Login</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
html, body {
    height: 100%; margin:0; overflow:hidden;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-size: cover;
    background-position: center;
    position: relative;
    transition: background 1s ease;
}

/* Glassmorphic login form */
.glass-card {
    position: absolute; top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    backdrop-filter: blur(15px);
    border-radius: 20px;
    padding: 50px 35px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.25);
    width: 380px; text-align:center;
    z-index: 10;
    transition: transform 0.3s ease, box-shadow 0.3s ease, background-color 0.5s ease;
}
.glass-card:hover { transform: translate(-50%, -50%) scale(1.05); }
.glass-card h2 { margin-bottom:30px; font-weight:700; text-shadow: 0 2px 5px rgba(0,0,0,0.3); }

.form-control { border-radius:12px; background: rgba(255,255,255,0.25); border:1px solid rgba(255,255,255,0.3); color:#000; font-weight:500; transition: all 0.3s ease; }
.form-control:focus { background: rgba(255,255,255,0.35); box-shadow:0 0 10px rgba(255,255,255,0.4); color:#000; }
.btn-primary { border-radius:12px; width:100%; font-weight:600; background: rgba(255,255,255,0.25); border:1px solid rgba(255,255,255,0.3); color:#000; transition: all 0.3s ease; }
.btn-primary:hover { background: rgba(255,255,255,0.4); color:#000; }
.links a { color:#000; text-decoration:underline; }
.links a:hover { color:#ffd700; }

.alert-custom {
    position: absolute; top: 20px; left:50%; transform:translateX(-50%);
    z-index:20; width: 350px;
}

/* ---------------- Snowy Theme ---------------- */
body.snowy::before {
    content:"";
    position:absolute; top:0; left:0; width:100%; height:100%;
    background: rgba(0, 100, 200, 0.25); 
    pointer-events:none; z-index:1;
}

.snowflake {
    position: absolute;
    top: -10px;
    color: #fff;
    font-size: 12px;
    user-select: none;
    z-index: 5;
    pointer-events: none;
    animation-name: snowFall;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
}
@keyframes snowFall {
    0% { transform: translateY(0px) rotate(0deg); opacity:0; }
    10% { opacity:1; }
    100% { transform: translateY(100vh) rotate(360deg); opacity:0; }
}
.snowman {
    position:absolute; bottom:0; left:50%;
    transform: translateX(-50%);
    width:120px; z-index:10;
}

/* ---------------- Rainy Theme ---------------- */
.rain {
    position:absolute; top:0; left:0; width:100%; height:100%;
    pointer-events:none; z-index:5; overflow:hidden;
}
.drop {
    position:absolute;
    width:2px; height:15px;
    background: rgba(255,255,255,0.7);
    animation-name: fall; animation-timing-function: linear; animation-iteration-count: infinite;
}
@keyframes fall {
    0% { transform: translateY(-20px) rotate(0deg); opacity:0; }
    10% { opacity:1; }
    100% { transform: translateY(100vh) rotate(0deg); opacity:0; }
}
body.rainy {
    background: linear-gradient(to bottom, #0a0f2b 0%, #a3c4f3 100%);
}

/* ---------------- Sunny Theme ---------------- */
body.sunny {
    background: linear-gradient(to bottom, #fff176 0%, #ff9800 100%);
    position: relative;
    overflow: hidden;
}
body.sunny .grass {
    position: absolute;
    bottom: 0;
    width: 100%;
    height: 150px;
    background: linear-gradient(to top, #4CAF50, #8BC34A);
    border-radius: 50%;
}
body.sunny .sun {
    position: absolute;
    top: 50px;
    left: 50%;
    transform: translateX(-50%);
    width: 120px;
    height: 120px;
    background: radial-gradient(circle, #FFD700 0%, #FFA500 70%);
    border-radius: 50%;
    z-index: 1;
    box-shadow: 0 0 50px 20px rgba(255, 223, 0, 0.5);
}
body.sunny .ray {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 4px;
    height: 100px;
    background: rgba(255, 223, 0, 0.5);
    transform-origin: bottom center;
    animation: rayRotate 3s linear infinite;
}
@keyframes rayRotate {
    0% { transform: rotate(0deg) translateX(-50%) translateY(-50%); opacity: 0.5; }
    50% { opacity: 1; }
    100% { transform: rotate(360deg) translateX(-50%) translateY(-50%); opacity: 0.5; }
}
body.sunny .particle {
    position: absolute;
    width: 6px; height: 6px;
    background: rgba(255, 255, 255, 0.7);
    border-radius: 50%;
    animation: floatParticle 6s linear infinite;
}
@keyframes floatParticle {
    0% { transform: translateY(0) translateX(0); opacity: 0; }
    10% { opacity: 1; }
    100% { transform: translateY(-200px) translateX(50px); opacity: 0; }
}
</style>
</head>
<body>

<%-- Displays login error if forwarded from LoginServlet --%>
<%
String errorMsg = (String) request.getAttribute("loginError");
if (errorMsg != null) {
%>
<div class="alert alert-danger alert-custom" role="alert">
    <%= errorMsg %>
</div>
<%
}
%>

<div class="glass-card">
    <h2>User Login</h2>
    <form action="LoginServlet" method="post">
        <div class="mb-3">
            <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
        </div>
        <div class="mb-3">
            <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
        </div>
        <button type="submit" class="btn btn-primary mb-3">Login</button>
    </form>
    <div class="links">
        <p><a href="register.jsp">New User? Register Here</a></p>
        <p><a href="admin-login.jsp">Admin Login</a></p>
    </div>
</div>

<!-- Snowman -->
<img src="https://upload.wikimedia.org/wikipedia/commons/1/1b/Snowman_icon.png" class="snowman" alt="Snowman" />

<!-- Rain container -->
<div class="rain" id="rain"></div>

<!-- Sunny elements -->
<div class="sunny-elements" style="display:none;">
    <div class="grass"></div>
    <div class="sun"></div>
    <!-- Sun rays -->
    <div class="ray" style="transform: rotate(0deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(30deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(60deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(90deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(120deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(150deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(180deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(210deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(240deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(270deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(300deg) translateX(-50%) translateY(-50%)"></div>
    <div class="ray" style="transform: rotate(330deg) translateX(-50%) translateY(-50%)"></div>
</div>

<script>
const bodyEl = document.body;
const rainContainer = document.getElementById('rain');
const snowman = document.querySelector('.snowman');
const sunnyElements = document.querySelector('.sunny-elements');

function clearEffects() {
    rainContainer.innerHTML = "";
    const oldSnow = document.getElementById('snow-container');
    if(oldSnow) oldSnow.remove();
    snowman.style.display = "none";
    sunnyElements.style.display = "none";
}

// Snowflakes
function createSnow() {
    const snowContainer = document.createElement('div');
    snowContainer.id = 'snow-container';
    document.body.appendChild(snowContainer);

    for(let i = 50; i < 250; i++){
        const snow = document.createElement('div');
        snow.className = 'snowflake';
        snow.style.left = Math.random() * 100 + 'vw';
        snow.style.animationDuration = (1 + Math.random() * 3) + 's';
        snow.style.fontSize = ((10 + Math.random() * 10) * 4) + 'px';
        snow.innerHTML = '❄';
        snowContainer.appendChild(snow);
    }
}

// Raindrops
function createRain() {
    for(let i = 0; i < 150; i++){
        const drop = document.createElement('div');
        drop.className = 'drop';
        drop.style.left = Math.random() * 100 + '%';
        drop.style.height = (10 + Math.random() * 10) + 'px';
        drop.style.animationDuration = (0.5 + Math.random() * 0.5) + 's';
        rainContainer.appendChild(drop);
    }
}

// Snowy theme
function setSnowy() {
    clearEffects();
    bodyEl.className = 'snowy';
    createSnow();
    snowman.style.display = "block";
    document.querySelector('.glass-card').style.backgroundColor = 'rgba(255,255,255,0.15)';
    document.querySelector('.glass-card').style.color = '#000';
}

// Rainy theme
function setRainy() {
    clearEffects();
    bodyEl.className = 'rainy';
    createRain();
    document.querySelector('.glass-card').style.backgroundColor = 'rgba(255,255,255,0.2)';
    document.querySelector('.glass-card').style.color = '#fff';
}

// Sunny theme
function setSunny() {
    clearEffects();
    bodyEl.className = 'sunny';
    sunnyElements.style.display = "block";
    document.querySelector('.glass-card').style.backgroundColor = 'rgba(255,255,255,0.25)';
    document.querySelector('.glass-card').style.color = '#000';
}

// Theme rotation
const themes = [setSnowy, setRainy, setSunny];
let idx = 0;
themes[idx]();
idx++;

setInterval(() => {
    themes[idx % themes.length]();
    idx++;
}, 6000);

// Sunny particles
const sunnyParticlesContainer = sunnyElements;
for(let i = 0; i < 30; i++){
    const particle = document.createElement('div');
    particle.className = 'particle';
    particle.style.left = Math.random() * 100 + 'vw';
    particle.style.bottom = Math.random() * 150 + 'px';
    particle.style.animationDuration = (4 + Math.random() * 4) + 's';
    sunnyParticlesContainer.appendChild(particle);
}
</script>
</body>
</html>