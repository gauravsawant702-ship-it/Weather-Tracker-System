<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Registration</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
/* BODY & BACKGROUND */
body {
    height: 100vh;
    margin: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #74ebd5 0%, #ACB6E5 100%);
    overflow: hidden;
    position: relative;
    color: #000; /* default font color black */
}

/* SNOW CONTAINER */
#snow-container {
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    pointer-events: none;
    overflow: hidden;
    z-index: 0;
}

.snowflake {
    position: absolute;
    top: -50px;
    color: #fff; /* keep snowflakes white */
    user-select: none;
    pointer-events: none;
    animation-name: fall, drift;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
}

@keyframes fall {
    0% { transform: translateY(0); opacity: 0.9; }
    100% { transform: translateY(110vh); opacity: 0.5; }
}

@keyframes drift {
    0% { transform: translateX(0); }
    50% { transform: translateX(20px); }
    100% { transform: translateX(0); }
}

/* GLASSMORPHISM CARD */
.glass-card {
    backdrop-filter: blur(15px);
    background-color: rgba(255, 255, 255, 0.15);
    border-radius: 20px;
    padding: 40px 30px;
    width: 400px;
    box-shadow: 0 8px 32px rgba(31,38,135,0.37);
    border: 1px solid rgba(255,255,255,0.18);
    text-align: center;
    z-index: 1;
    position: relative;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    color: #000; /* font inside card black */
}
.glass-card:hover {
    transform: scale(1.05);
    box-shadow: 0 12px 40px rgba(31,38,135,0.5);
}

.glass-card h2 {
    color: #000; /* heading black */
    margin-bottom: 30px;
    font-weight: 600;
}

/* FLOATING LABELS */
.floating-label {
    position: relative;
    margin-bottom: 25px;
}

.floating-label input {
    width: 100%;
    border-radius: 12px;
    background: rgba(255,255,255,0.25);
    border: 1px solid rgba(255,255,255,0.3);
    color: #000; /* input text black */
    font-weight: 500;
    padding: 14px 15px 14px 15px;
    transition: all 0.3s ease, box-shadow 0.3s ease;
    box-shadow: inset 2px 2px 8px rgba(0,0,0,0.2);
}

.floating-label input:focus {
    background: rgba(255,255,255,0.4);
    color: #000;
    border: 1px solid #000;
    box-shadow: 0 0 15px rgba(0,0,0,0.3), inset 2px 2px 8px rgba(0,0,0,0.2);
}

.floating-label input::placeholder {
    color: transparent;
}

.floating-label label {
    position: absolute;
    top: 50%;
    left: 15px;
    color: rgba(0,0,0,0.7); /* label black */
    pointer-events: none;
    transform: translateY(-50%);
    transition: all 0.3s ease;
    font-weight: 400;
}

.floating-label input:focus + label,
.floating-label input:not(:placeholder-shown) + label {
    top: -10px;
    left: 12px;
    font-size: 12px;
    color: #000; /* label black when floated */
    background: rgba(255,255,255,0.2);
    padding: 0 5px;
    border-radius: 4px;
}

/* BUTTONS */
.btn-primary {
    border-radius: 12px;
    width: 100%;
    font-weight: 600;
    background: rgba(255,255,255,0.25);
    border: 1px solid rgba(255,255,255,0.3);
    color: #000; /* button text black */
    padding: 12px;
    transition: all 0.3s ease, box-shadow 0.3s ease;
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}
.btn-primary:hover {
    background: rgba(255,255,255,0.45);
    color: #000;
    box-shadow: 0 6px 20px rgba(0,0,0,0.3), 0 0 15px rgba(0,0,0,0.2);
}

/* LINKS */
.links a {
    color: #000; /* links black */
    text-decoration: underline;
    transition: color 0.3s ease;
}
.links a:hover { color: #555; }

/* ALERT */
.alert-custom {
    position: absolute;
    top: 20px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 2;
    width: 350px;
    color: #000; /* alert text black */
}

</style>
</head>
<body>

<!-- SNOW -->
<div id="snow-container"></div>

<%-- Registration Error --%>
<%
String errorMsg = (String) request.getAttribute("registerError");
if (errorMsg != null) {
%>
<div class="alert alert-danger alert-custom" role="alert">
    <%= errorMsg %>
</div>
<%
}
%>

<!-- REGISTRATION FORM -->
<div class="glass-card">
    <h2>User Registration</h2>
    <form action="RegisterServlet" method="post" novalidate>
        <div class="floating-label">
            <input type="text" name="name" placeholder=" " required>
            <label>Enter your name</label>
            <div class="invalid-feedback">Please enter a valid name.</div>
        </div>
        <div class="floating-label">
            <input type="email" name="email" placeholder=" " required>
            <label>Enter your email</label>
            <div class="invalid-feedback">Please enter a valid email address.</div>
        </div>
        <div class="floating-label">
            <input type="password" name="password" placeholder=" " required minlength="6">
            <label>Enter your password</label>
            <div class="invalid-feedback">Password must be at least 6 characters.</div>
        </div>
        <button type="submit" class="btn btn-primary mb-3">Register</button>
    </form>
    <div class="links">
        <p><a href="index.jsp">Back to Login</a></p>
    </div>
</div>

<!-- BOOTSTRAP FORM VALIDATION -->
<script>
(function () {
  'use strict'
  const forms = document.querySelectorAll('form')
  Array.from(forms).forEach(function (form) {
    form.addEventListener('submit', function (event) {
      if (!form.checkValidity()) {
        event.preventDefault()
        event.stopPropagation()
      }
      form.classList.add('was-validated')
    }, false)
  })
})()
</script>

<!-- SNOW SCRIPT -->
<script>
function createSnow() {
    const snowContainer = document.getElementById('snow-container');
    const snowCount = 150;
    for(let i = 0; i < snowCount; i++){
        const snow = document.createElement('div');
        snow.className = 'snowflake';
        snow.innerHTML = '❄';
        snow.style.left = Math.random() * 100 + 'vw';
        snow.style.fontSize = (10 + Math.random() * 15) + 'px';
        snow.style.animationDuration = (5 + Math.random() * 10) + 's, ' + (3 + Math.random() * 5) + 's';
        snow.style.opacity = Math.random();
        snowContainer.appendChild(snow);
    }
}
createSnow();
</script>

</body>
</html>
