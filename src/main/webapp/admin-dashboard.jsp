<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("username");
    if (adminName == null) {
        adminName = "Admin";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    height: 100vh;
    margin: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #220000 0%, #660000 100%);
    color: #fff;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px;
}
nav {
    width: 100%;
    max-width: 900px;
    background-color: #111;
    border-radius: 10px;
    padding: 12px 20px;
    margin-bottom: 30px;
    display: flex;
    justify-content: flex-start;
    box-shadow: 0 4px 15px rgba(0,0,0,0.5);
}
nav a {
    color: #fff;
    margin-right: 25px;
    font-weight: 600;
    text-decoration: none;
    transition: 0.3s;
}
nav a:hover {
    color: #ff4d4d;
    text-decoration: underline;
}
.dashboard-card {
    backdrop-filter: blur(15px);
    background-color: rgba(255, 255, 255, 0.05);
    border-radius: 20px;
    padding: 40px 30px;
    width: 450px;
    text-align: center;
    box-shadow: 0 8px 32px rgba(0,0,0,0.5);
    border: 1px solid rgba(255,255,255,0.1);
}
.dashboard-card h2 {
    color: #ff4d4d;
    margin-bottom: 25px;
    font-weight: 700;
    text-shadow: 0 2px 5px rgba(0,0,0,0.5);
}
.dashboard-card ul {
    list-style: none;
    padding: 0;
    text-align: left;
}
.dashboard-card ul li {
    margin: 10px 0;
    font-weight: 500;
}
.dashboard-card ul li::before {
    content: "✔ ";
    color: #ff4d4d;
    font-weight: bold;
}
</style>
</head>
<body>

<nav>
    <a href="AdminUsersServlet" style="color: #ff4d4d;">Manage Users</a>
    <a href="AdminFeedbackServlet">View Feedback</a>
    <a href="LogoutServlet" style="margin-left:auto; color:#ff4d4d;">Logout</a>
</nav>

<div class="dashboard-card">
    <h2>Admin Dashboard</h2>
    <p>Welcome, <%= adminName %></p>
    <ul>
        <li>View registered users</li>
        <li>Delete users</li>
        <li>View feedback</li>
        <li>Delete feedback</li>
    </ul>
</div>

</body>
</html>