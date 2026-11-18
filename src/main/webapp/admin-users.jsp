<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.project.servlet.User" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manage Users - Admin Dashboard</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    min-height: 100vh;
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
    max-width: 950px;
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
.container-box {
    backdrop-filter: blur(15px);
    background-color: rgba(255, 255, 255, 0.05);
    border-radius: 20px;
    padding: 30px;
    width: 100%;
    max-width: 950px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.5);
    border: 1px solid rgba(255,255,255,0.1);
}
h2 {
    color: #ff4d4d;
    margin-bottom: 20px;
    font-weight: 700;
    text-shadow: 0 2px 5px rgba(0,0,0,0.5);
}
.table {
    color: #fff;
    background-color: rgba(0, 0, 0, 0.2);
    border-radius: 10px;
    overflow: hidden;
}
.table th {
    background-color: rgba(255, 77, 77, 0.2);
    color: #ff4d4d;
    border-color: rgba(255, 255, 255, 0.1);
}
.table td, .table th {
    border-color: rgba(255, 255, 255, 0.1);
    vertical-align: middle;
}
.btn-danger {
    background-color: #dc3545;
    border: none;
    font-weight: 600;
    border-radius: 8px;
    padding: 5px 12px;
}
.btn-danger:hover {
    background-color: #bb2d3b;
}
</style>
</head>
<body>

<nav>
    <a href="admin-dashboard.jsp">Dashboard</a>
    <a href="AdminUsersServlet" style="color: #ff4d4d;">Manage Users</a>
    <a href="AdminFeedbackServlet">View Feedback</a>
    <a href="LogoutServlet" style="margin-left:auto; color:#ff4d4d;">Logout</a>
</nav>

<div class="container-box">
    <h2>Registered Users</h2>
    <p class="text-muted text-light">View and manage registered user accounts.</p>
    
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th class="text-center">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<User> users = (List<User>) request.getAttribute("users");
                    if (users != null && !users.isEmpty()) {
                        for (User u : users) {
                %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><%= u.getName() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getRole() %></td>
                    <td class="text-center">
                        <form action="DeleteUserServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete user: <%= u.getName() %>?');">
                            <input type="hidden" name="id" value="<%= u.getId() %>">
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="5" class="text-center text-muted">No non-admin users found.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>