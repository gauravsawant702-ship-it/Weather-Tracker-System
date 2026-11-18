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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        String sql = "SELECT ID, NAME FROM accounts "
                   + "WHERE EMAIL = ? AND PASSWORD = ? AND ROLE = 'user'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    HttpSession session = req.getSession();

                    session.setAttribute("userId", rs.getInt("ID"));
                    session.setAttribute("username", rs.getString("NAME"));
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





//package com.project.servlet;
//
//import java.io.IOException;
//import java.sql.*;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//public class LoginServlet extends HttpServlet {
//
//    protected void doPost(HttpServletRequest req, HttpServletResponse res)
//            throws ServletException, IOException {
//
//        String email = req.getParameter("email");
//        String password = req.getParameter("password");
//
//        try (Connection con = DBConnection.getConnection()) {
//
//            PreparedStatement ps = con.prepareStatement(
//                "SELECT user_id, name FROM accounts WHERE email=? AND password=? AND role='user'"
//            );
//            ps.setString(1, email);
//            ps.setString(2, password);
//
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                HttpSession session = req.getSession();
//                session.setAttribute("userId", rs.getInt("user_id"));  // Correct attribute
//                session.setAttribute("username", rs.getString("name"));
//                session.setAttribute("role", "user");
//
//                res.sendRedirect("user-dashboard.jsp");
//            } else {
//                req.setAttribute("error", "Invalid credentials");
//                req.getRequestDispatcher("index.jsp").forward(req, res);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            res.sendRedirect("index.jsp");
//        }
//    }
//}
//
//
//
//
