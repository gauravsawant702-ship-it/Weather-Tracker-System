package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/delete-feedback")
public class DeleteFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        
        if (role == null || !role.equals("admin")) {
            res.sendRedirect("admin-login.jsp");
            return;
        }

        String feedbackIdStr = req.getParameter("feedback_id");

        if (feedbackIdStr != null && !feedbackIdStr.trim().isEmpty()) {
            String sql = "DELETE FROM feedback WHERE feedback_id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, Integer.parseInt(feedbackIdStr.trim()));
                ps.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        res.sendRedirect("admin-feedback");
    }
}