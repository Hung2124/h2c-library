<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Migration</title>
</head>
<body>
    <h2>Migrating Publishers Data...</h2>
    <%
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SmartLibraryDB;encrypt=false;trustServerCertificate=true";
        String user = "sa";
        String pass = "hunghunghung";
        
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                
                out.println("<p>Connected to database.</p>");
                
                // 1. Check if 'publisher' column exists in books
                boolean hasOldColumn = false;
                try (ResultSet rs = conn.getMetaData().getColumns(null, null, "books", "publisher")) {
                    if (rs.next()) hasOldColumn = true;
                }
                
                if (!hasOldColumn) {
                    out.println("<p>No old 'publisher' column found. Migration might have already been done, or database was wiped.</p>");
                } else {
                    out.println("<p>Found old 'publisher' column. Migrating...</p>");
                    
                    // 2. Fetch all distinct publishers from books
                    try (Statement stmt = conn.createStatement();
                         ResultSet rs = stmt.executeQuery("SELECT DISTINCT publisher FROM books WHERE publisher IS NOT NULL AND publisher != ''")) {
                        
                        while(rs.next()) {
                            String pubName = rs.getString(1);
                            
                            // Check if publisher exists in publishers table
                            long pubId = -1;
                            try (PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM publishers WHERE name = ?")) {
                                checkStmt.setNString(1, pubName);
                                try (ResultSet checkRs = checkStmt.executeQuery()) {
                                    if (checkRs.next()) {
                                        pubId = checkRs.getLong(1);
                                    }
                                }
                            }
                            
                            // Insert if not exists
                            if (pubId == -1) {
                                try (PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO publishers (name, note) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS)) {
                                    insertStmt.setNString(1, pubName);
                                    insertStmt.setNString(2, "Migrated from books table");
                                    insertStmt.executeUpdate();
                                    try (ResultSet keys = insertStmt.getGeneratedKeys()) {
                                        if (keys.next()) pubId = keys.getLong(1);
                                    }
                                    out.println("<p>Created publisher: " + pubName + " (ID: " + pubId + ")</p>");
                                } catch (SQLException insertEx) {
                                    // Handle concurrent insert or previous check failure due to collation
                                    try (PreparedStatement checkStmt2 = conn.prepareStatement("SELECT id FROM publishers WHERE name = ?")) {
                                        checkStmt2.setNString(1, pubName);
                                        try (ResultSet checkRs2 = checkStmt2.executeQuery()) {
                                            if (checkRs2.next()) pubId = checkRs2.getLong(1);
                                        }
                                    }
                                    if (pubId != -1) {
                                        out.println("<p>Publisher already existed: " + pubName + " (ID: " + pubId + ")</p>");
                                    }
                                }
                            }
                            
                            // Update books table with new publisher_id
                            if (pubId != -1) {
                                try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE books SET publisher_id = ? WHERE publisher = ?")) {
                                    updateStmt.setLong(1, pubId);
                                    updateStmt.setNString(2, pubName);
                                    int rows = updateStmt.executeUpdate();
                                    out.println("<p>Updated " + rows + " books for publisher: " + pubName + "</p>");
                                }
                            }
                        }
                    }
                    
                    // 3. Drop old column 
                    // Note: If you want to drop it, uncomment the following line carefully
                    // try (Statement dropStmt = conn.createStatement()) {
                    //     dropStmt.execute("ALTER TABLE books DROP COLUMN publisher");
                    //     out.println("<p>Dropped old 'publisher' column.</p>");
                    // }
                    
                    out.println("<h3>Migration completed successfully!</h3>");
                }
            }
        } catch (Exception e) {
            out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
            e.printStackTrace();
            out.println("<pre>");
            for(StackTraceElement el : e.getStackTrace()) {
                out.println(el.toString());
            }
            out.println("</pre>");
        }
    %>
</body>
</html>
