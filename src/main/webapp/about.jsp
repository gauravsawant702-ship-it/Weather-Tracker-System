<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>About Us</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #74ebd5 0%, #ACB6E5 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .glass-card {
            backdrop-filter: blur(15px);
            background-color: rgba(255, 255, 255, 0.15);
            border-radius: 20px;
            padding: 40px 30px;
            width: 500px;
            box-shadow: 0 8px 32px rgba(31,38,135,0.37);
            border: 1px solid rgba(255,255,255,0.18);
            text-align: center;
            color: #000;
        }

        .glass-card h2 {
            margin-bottom: 25px;
            font-weight: 700;
            font-size: 28px;
        }

        .glass-card p {
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 15px;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: underline;
            color: #000;
            transition: color 0.3s ease;
        }
        a:hover { color: #ffd700; }
    </style>
</head>
<body>

<div class="glass-card">
    <h2>About Us</h2>
    <p>
        WeatherApp is a web-based application developed using JSP, Servlets,
        and Oracle Database. It provides real-time weather information and
        user-friendly features for both users and administrators.
    </p>
    <p>
        This project is developed as part of an academic requirement to
        demonstrate Java web technologies.
    </p>

    <a href="user-dashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
