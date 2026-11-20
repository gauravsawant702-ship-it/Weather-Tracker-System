package com.project.servlet;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        Class.forName("org.postgresql.Driver");

        String url = System.getenv("DB_URL");
        String username = System.getenv("DB_USERNAME");
        String password = System.getenv("DB_PASSWORD");

        return DriverManager.getConnection(url, username, password);
    }
}
