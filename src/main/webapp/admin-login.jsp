<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Login</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    height: 100vh;
    margin: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #1f4037 0%, #99f2c8 100%);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Glassmorphic card */
.glass-card {
    backdrop-filter: blur(15px);
    background-color: rgba(255, 255, 255, 0.15);
    border-radius: 20px;
    padding: 50px 35px;
    width: 380px;
    box-shadow: 0 8px 32px rgba(31,38,135,0.37);
    border: 1px solid rgba(255,255,255,0.18);
    text-align: center;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.glass-card:hover {
    transform: scale(1.05);
    box-shadow: 0 12px 40px rgba(31,38,135,0.5);
}

.glass-card h2 {
    color: #fff;
    margin-bottom: 30px;
    font-weight: 700;
    text-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

.form-control {
    border-radius: 12px;
    background: rgba(255,255,255,0.25);
    border: 1px solid rgba(255,255,255,0.3);
    color: #fff;
    font-weight: 500;
    transition: all 0.3s ease;
}
.form-control:focus {
    background: rgba(255,255,255,0.35);
    box-shadow: 0 0 10px rgba(255,255,255,0.4);
    color: #000;
}

.btn-primary {
    border-radius: 12px;
    width: 100%;
    font-weight: 600;
    background: rgba(255,255,255,0.25);
    border: 1px solid rgba(255,255,255,0.3);
    color: #fff;
    transition: all 0.3s ease;
}
.btn-primary:hover {
    background: rgba(255,255,255,0.4);
    color: #000;
}

.links a {
    color: #fff;
    text-decoration: underline;
}
.links a:hover {
    color: #ffd700;
}

.alert-custom {
    position: absolute;
    top: 20px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 20;
    width: 350px;
}
</style>
</head>
<body>

<%-- Display login error if exists --%>
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
    <h2>Admin Login</h2>
    <!-- Context-safe form action -->
    <form action="${pageContext.request.contextPath}/AdminLoginServlet" method="post" novalidate>
        <div class="mb-3">
            <input type="email" name="email" class="form-control" placeholder="Enter your admin email" required>
            <div class="invalid-feedback">Please enter a valid email address.</div>
        </div>
        <div class="mb-3">
            <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
            <div class="invalid-feedback">Password is required.</div>
        </div>
        <button type="submit" class="btn btn-primary mb-3">Login</button>
    </form>
    <div class="links">
        <p><a href="index.jsp">Back to User Login</a></p>
    </div>
</div>

<script>
// Bootstrap form validation
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

</body>
</html>