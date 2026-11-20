package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        String sql = "SELECT id, name FROM accounts "
                   + "WHERE email = ? AND password = ? AND role = 'user'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    HttpSession session = req.getSession();

                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("username", rs.getString("name"));
                    session.setAttribute("role", "user");

                    res.sendRedirect(req.getContextPath()
                            + "/user-dashboard.jsp");

                } else {

                    req.setAttribute("error", "Invalid email or password");

                    req.getRequestDispatcher("/index.jsp")
                            .forward(req, res);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            req.setAttribute("error",
                    "Unable to process login. Please try again.");

            req.getRequestDispatcher("/index.jsp")
                    .forward(req, res);
        }
    }
}