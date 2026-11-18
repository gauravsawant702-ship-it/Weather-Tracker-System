package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Ensure your DBConnection class is imported if it resides in a different package, e.g.:
// import com.project.db.DBConnection;


public class AdminFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Session validation
        HttpSession session = req.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        
        if (role == null || !role.equals("admin")) {
            res.sendRedirect("admin-login.jsp");
            return;
        }

        List<String[]> feedbackList = new ArrayList<>();
        
        // Oracle SQL Query joining feedback with accounts on 'id'
        String sql = "SELECT f.feedback_id, u.email, f.message, f.rating, f.feedback_date " +
                     "FROM feedback f JOIN accounts u ON f.user_id = u.id " +
                     "ORDER BY f.feedback_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String[] row = new String[5];
                row[0] = String.valueOf(rs.getInt("feedback_id"));
                row[1] = rs.getString("email") != null ? rs.getString("email") : "N/A";
                row[2] = rs.getString("message") != null ? rs.getString("message") : "";
                row[3] = String.valueOf(rs.getInt("rating"));
                
                // Safely extract date as string to avoid type casting errors
                java.sql.Date feedbackDate = rs.getDate("feedback_date");
                row[4] = (feedbackDate != null) ? feedbackDate.toString() : "N/A";
                
                feedbackList.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database SQL Error in AdminFeedbackServlet: " + e.getMessage(), e);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Unexpected Error in AdminFeedbackServlet: " + e.getMessage(), e);
        }

        // Pass data to JSP view
        req.setAttribute("feedbackList", feedbackList);
        req.getRequestDispatcher("admin-feedback.jsp").forward(req, res);
    }
}