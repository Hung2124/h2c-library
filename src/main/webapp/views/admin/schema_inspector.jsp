<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head><title>DB Schema Inspector</title></head>
<body>
    <h2>Books Table Schema</h2>
    <%
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SmartLibraryDB;encrypt=false;trustServerCertificate=true";
        String user = "sa";
        String pass = "hunghunghung";
        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='books'")) {
                out.println("<ul>");
                while(rs.next()) {
                    out.println("<li>" + rs.getString(1) + " : " + rs.getString(2) + "</li>");
                }
                out.println("</ul>");
            }
            
            out.println("<h2>Borrow Request Details Table Schema</h2><ul>");
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='borrow_request_details'")) {
                while(rs.next()) {
                    out.println("<li>" + rs.getString(1) + " : " + rs.getString(2) + "</li>");
                }
            }
            out.println("</ul>");
            
        } catch (Exception e) {
            out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
        }
    %>
</body>
</html>
