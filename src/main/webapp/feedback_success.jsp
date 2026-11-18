<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Feedback Submitted</title>
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
            width: 450px;
            box-shadow: 0 8px 32px rgba(31,38,135,0.37);
            border: 1px solid rgba(255,255,255,0.18);
            text-align: center;
            color: #000;
        }

        .glass-card h2 {
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 28px;
        }

        .glass-card p {
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 25px;
        }

        a {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 12px;
            background: rgba(255,255,255,0.25);
            border: 1px solid rgba(255,255,255,0.3);
            text-decoration: none;
            color: #000;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        a:hover {
            background: rgba(255,255,255,0.45);
            color: #000;
            box-shadow: 0 6px 20px rgba(0,0,0,0.3), 0 0 15px rgba(255,255,255,0.5);
        }
    </style>
</head>
<body>

<div class="glass-card">
    <h2>Thank you, <%= username %>!</h2>
    <p>Your feedback has been submitted successfully.</p>
    <a href="user-dashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
