package com.project.servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.*;
import java.time.*;
import java.time.format.DateTimeFormatter;
import org.json.*;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

public class MonthlyWeatherReportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String city = req.getParameter("city");
        String monthParam = req.getParameter("month"); // YYYY-MM

        if (city == null || city.isEmpty()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "City is required");
            return;
        }

        if (monthParam == null || monthParam.isEmpty()) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Month is required");
            return;
        }

        try {
            // ---------- GEO CODING ----------
            String geoUrl = "https://geocoding-api.open-meteo.com/v1/search?count=1&name=" +
                    URLEncoder.encode(city, "UTF-8");
            JSONObject geoJson = readJsonFromUrl(geoUrl);
            JSONArray results = geoJson.optJSONArray("results");
            if (results == null || results.length() == 0) {
                res.sendError(HttpServletResponse.SC_NOT_FOUND, "City not found");
                return;
            }

            JSONObject loc = results.getJSONObject(0);
            double lat = loc.getDouble("latitude");
            double lon = loc.getDouble("longitude");

            // ---------- DATE RANGE ----------
            LocalDate now = LocalDate.now();
            LocalDate start;
            try {
                start = LocalDate.parse(monthParam + "-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            } catch (Exception e) {
                start = now.withDayOfMonth(1);
            }

            // Clamp start date to not exceed current month
            if (start.isAfter(now)) start = now.withDayOfMonth(1);

            LocalDate end = start.withDayOfMonth(start.lengthOfMonth());

            // Clamp end date to today if month is partially in the future
            if (end.isAfter(now)) end = now;

            // ---------- WEATHER API ----------
            String weatherUrl = "https://api.open-meteo.com/v1/forecast" +
                    "?latitude=" + lat +
                    "&longitude=" + lon +
                    "&daily=temperature_2m_max,temperature_2m_min,precipitation_sum" +
                    "&start_date=" + start +
                    "&end_date=" + end +
                    "&timezone=auto";

            JSONObject data = readJsonFromUrl(weatherUrl);

            JSONObject daily = data.optJSONObject("daily");
            if (daily == null) {
                res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "No weather data available");
                return;
            }

            JSONArray dates = daily.optJSONArray("time");
            JSONArray maxT = daily.optJSONArray("temperature_2m_max");
            JSONArray minT = daily.optJSONArray("temperature_2m_min");
            JSONArray rain = daily.optJSONArray("precipitation_sum");

            if (dates == null || maxT == null || minT == null || rain == null) {
                res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Incomplete weather data");
                return;
            }

            // ---------- PDF GENERATION ----------
            res.setContentType("application/pdf");
            res.setHeader("Content-Disposition", "attachment; filename=Monthly_Weather_Report_" + city + ".pdf");

            Document doc = new Document();
            PdfWriter.getInstance(doc, res.getOutputStream());
            doc.open();

            doc.add(new Paragraph("Monthly Weather Report", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16)));
            doc.add(new Paragraph("City: " + city));
            doc.add(new Paragraph("Period: " + start + " to " + end));
            doc.add(new Paragraph(" "));

            PdfPTable table = new PdfPTable(4);
            table.setWidths(new int[]{3, 2, 2, 2});
            table.addCell("Date");
            table.addCell("Max Temp (°C)");
            table.addCell("Min Temp (°C)");
            table.addCell("Rain (mm)");

            for (int i = 0; i < dates.length(); i++) {
                table.addCell(dates.optString(i, "-"));
                table.addCell(String.valueOf(maxT.optDouble(i, 0)));
                table.addCell(String.valueOf(minT.optDouble(i, 0)));
                table.addCell(String.valueOf(rain.optDouble(i, 0)));
            }

            doc.add(table);
            doc.close();

        } catch (DocumentException e) {
            throw new ServletException("Error generating PDF", e);
        } catch (IOException e) {
            throw new ServletException("Error fetching weather data", e);
        }
    }

    /* ---------- HELPER ---------- */
    private JSONObject readJsonFromUrl(String url) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        if (conn.getResponseCode() != 200) {
            throw new IOException("HTTP error code: " + conn.getResponseCode());
        }

        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) sb.append(line);
        rd.close();
        return new JSONObject(sb.toString());
    }
}
