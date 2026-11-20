package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        String sql = "INSERT INTO accounts (name, email, password, role) "
                   + "VALUES (?, ?, ?, 'user')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                res.sendRedirect("index.jsp");
            } else {
                res.sendRedirect("register.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("register.jsp");
        }
    }
}