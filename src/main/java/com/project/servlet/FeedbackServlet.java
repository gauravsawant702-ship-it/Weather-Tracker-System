package com.project.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.sql.*;

public class FeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");
        String message = request.getParameter("message");
        String ratingStr = request.getParameter("rating");

        // Validate userId
        int userId = 0;
        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is missing.");
            return;
        }

        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID.");
            return;
        }

        // Validate message
        if (message == null || message.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Feedback cannot be empty.");
            return;
        }

        // Validate rating
        int rating = 0;
        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Rating must be between 1 and 5.");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid rating.");
            return;
        }

        // Insert feedback into Oracle DB
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(
                     "INSERT INTO feedback (feedback_id, user_id, message, rating, feedback_date) VALUES (feedback_seq.NEXTVAL, ?, ?, ?, SYSDATE)"
             )) {

            pst.setInt(1, userId);
            pst.setString(2, message);
            pst.setInt(3, rating);

            int rows = pst.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("feedback_success.jsp");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to save feedback.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
