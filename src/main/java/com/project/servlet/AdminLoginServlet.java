package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email") != null
                ? req.getParameter("email").trim() : "";

        String password = req.getParameter("password");

        String sql = "SELECT name FROM accounts "
                + "WHERE LOWER(TRIM(email)) = LOWER(TRIM(?)) "
                + "AND TRIM(password) = TRIM(?) "
                + "AND LOWER(TRIM(role)) = 'admin'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    HttpSession oldSession = req.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    HttpSession session = req.getSession(true);

                    session.setAttribute("username", rs.getString("name"));
                    session.setAttribute("role", "admin");

                    res.sendRedirect(req.getContextPath()
                            + "/admin-dashboard.jsp");

                } else {

                    req.setAttribute("loginError",
                            "Invalid email or password.");

                    req.getRequestDispatcher("/admin-login.jsp")
                            .forward(req, res);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            req.setAttribute("loginError",
                    "A database error occurred. Please try again.");

            req.getRequestDispatcher("/admin-login.jsp")
                    .forward(req, res);
        }
    }
}