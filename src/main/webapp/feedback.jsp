<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("userId");

    if (username == null || userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Feedback</title>
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
            width: 400px;
            box-shadow: 0 8px 32px rgba(31,38,135,0.37);
            border: 1px solid rgba(255,255,255,0.18);
            text-align: center;
            color: #000;
        }

        .glass-card h2 {
            margin-bottom: 30px;
            font-weight: 600;
        }

        .form-control {
            border-radius: 12px;
            background: rgba(255,255,255,0.25);
            border: 1px solid rgba(255,255,255,0.3);
            color: #000;
            font-weight: 500;
            padding: 12px 15px;
            margin-bottom: 20px;
            transition: all 0.3s ease, box-shadow 0.3s ease;
        }

        .form-control:focus {
            background: rgba(255,255,255,0.35);
            box-shadow: 0 0 10px rgba(255,255,255,0.4);
            outline: none;
        }

        .btn-primary {
            border-radius: 12px;
            width: 100%;
            font-weight: 600;
            background: rgba(255,255,255,0.25);
            border: 1px solid rgba(255,255,255,0.3);
            color: #000;
            padding: 12px;
            transition: all 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .btn-primary:hover {
            background: rgba(255,255,255,0.45);
            color: #000;
            box-shadow: 0 6px 20px rgba(0,0,0,0.3), 0 0 15px rgba(255,255,255,0.5);
        }

        a {
            display: inline-block;
            margin-top: 15px;
            text-decoration: underline;
            color: #000;
            transition: color 0.3s ease;
        }
        a:hover { color: #ffd700; }
    </style>
</head>
<body>

<div class="glass-card">
    <h2>Feedback</h2>
    <form action="FeedbackServlet" method="post">
        <input type="hidden" name="userId" value="<%= userId %>">

        <textarea name="message" class="form-control" rows="5" placeholder="Write your feedback..." required></textarea>

        <input type="number" name="rating" class="form-control" min="1" max="5" placeholder="Rating (1-5)" required>

        <button type="submit" class="btn btn-primary">Submit Feedback</button>
    </form>

    <a href="user-dashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
