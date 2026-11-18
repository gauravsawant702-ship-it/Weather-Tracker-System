package com.project.servlet;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Trim accidental spaces from email input
        String email = req.getParameter("email") != null ? req.getParameter("email").trim() : "";
        String password = req.getParameter("password"); // Keep password un-trimmed to preserve intentional spaces

        try (Connection con = DBConnection.getConnection()) {

            // Bulletproof query for Oracle using TRIM and LOWER to handle spacing and case issues
            PreparedStatement ps = con.prepareStatement(
                "SELECT name FROM accounts WHERE LOWER(TRIM(email)) = LOWER(TRIM(?)) AND TRIM(password) = TRIM(?) AND LOWER(TRIM(role)) = 'admin'"
            );

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Prevent session fixation attacks by clearing old session and creating a new one
                HttpSession oldSession = req.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }
                HttpSession session = req.getSession(true);
                
                session.setAttribute("username", rs.getString("name"));
                session.setAttribute("role", "admin");

                res.sendRedirect("admin-dashboard.jsp");
            } else {
                // Forward (not redirect) so the error message attribute is preserved for the JSP
                req.setAttribute("loginError", "Invalid email or password.");
                req.getRequestDispatcher("admin-login.jsp").forward(req, res);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("loginError", "A database error occurred. Please try again.");
            req.getRequestDispatcher("admin-login.jsp").forward(req, res);
        }
    }
}