package com.project.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DeleteUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        String role = (session != null)
                ? (String) session.getAttribute("role") : null;

        if (role == null || !role.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        String userId = request.getParameter("id");

        if (userId != null && !userId.trim().isEmpty()) {

            String sql = "DELETE FROM accounts WHERE id = ? AND role <> 'admin'";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, Integer.parseInt(userId.trim()));

                ps.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
                throw new ServletException("Unable to delete user.", e);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin-users");
    }
}