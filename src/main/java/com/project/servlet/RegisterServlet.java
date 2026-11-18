package com.project.servlet;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO accounts(name, email, password, role) VALUES (?, ?, ?, 'user')"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);

            ps.executeUpdate();
            res.sendRedirect("index.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("register.jsp");
        }
    }
}
