<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    List<String[]> feedbackList =
        (List<String[]>) request.getAttribute("feedbackList");

    if (feedbackList == null) {
        feedbackList = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Feedback</title>
    <style>
        body {
            background-color: #111; /* dark black background */
            color: #fff; /* white text */
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        h2 {
            color: #ff4d4d; /* bright red heading */
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ff4d4d; /* red borders */
        }
        th {
            background-color: #ff1a1a; /* darker red header */
            color: #fff;
        }
        tr:nth-child(even) {
            background-color: #222; /* dark gray for alternating rows */
        }
        a {
            color: #ff4d4d;
            text-decoration: none;
            font-weight: bold;
        }
        a:hover {
            text-decoration: underline;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 15px;
            background-color: #ff1a1a;
            color: #fff;
            border-radius: 5px;
        }
        .back-link:hover {
            background-color: #ff4d4d;
        }
    </style>
</head>
<body>

<h2>User Feedback</h2>

<table>
<tr>
    <th>ID</th>
    <th>User Email</th>
    <th>Message</th>
    <th>Rating</th>
    <th>Date</th>
    <th>Action</th>
</tr>

<%
    if (feedbackList.isEmpty()) {
%>
<tr>
    <td colspan="6" style="text-align:center;">No feedback available.</td>
</tr>
<%
    } else {
        for (String[] f : feedbackList) {
%>
<tr>
    <td><%= f[0] %></td>
    <td><%= f[1] %></td>
    <td><%= f[2] %></td>
    <td><%= f[3] %></td>
    <td><%= f[4] %></td>
    <td>
        <a href="DeleteFeedbackServlet?feedbackId=<%= f[0] %>"
           onclick="return confirm('Delete this feedback?')">
            Delete
        </a>
    </td>
</tr>
<%
        }
    }
%>
</table>

<a class="back-link" href="admin-dashboard.jsp">Back to Dashboard</a>

</body>
</html>
