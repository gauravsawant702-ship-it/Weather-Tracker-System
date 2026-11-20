package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-users")
public class AdminUsersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        String role = (session != null)
                ? (String) session.getAttribute("role") : null;

        if (role == null || !role.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        List<User> users = new ArrayList<>();

        String sql = "SELECT id, name, email, role "
                   + "FROM accounts "
                   + "WHERE LOWER(TRIM(role)) <> 'admin' "
                   + "ORDER BY id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                User user = new User(
                        rs.getString("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("role")
                );

                users.add(user);
            }

            request.setAttribute("users", users);

            request.getRequestDispatcher("/admin-users.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Database error while fetching users", e);
        }
    }
}