package com.library.utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUploadUtil {

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String[] ALLOWED_TYPES = {"image/jpeg", "image/png", "image/gif", "image/webp"};

    private FileUploadUtil() {}

    public static String saveImage(Part part, String uploadDir) throws IOException {
        if (part == null || part.getSize() == 0) return null;

        if (!isValidImageType(part.getContentType())) {
            throw new IOException("Invalid file type. Only JPEG, PNG, GIF, WEBP allowed.");
        }
        if (part.getSize() > MAX_FILE_SIZE) {
            throw new IOException("File too large. Maximum 5MB allowed.");
        }

        String originalFileName = getFileName(part);
        String extension = getExtension(originalFileName);
        String fileName = UUID.randomUUID().toString() + extension;

        File uploadDirectory = new File(uploadDir);
        if (!uploadDirectory.exists()) {
            uploadDirectory.mkdirs();
        }

        part.write(uploadDir + File.separator + fileName);
        return fileName;
    }

    public static void deleteImage(String uploadDir, String fileName) {
        if (fileName == null || fileName.isBlank()) return;
        File file = new File(uploadDir + File.separator + fileName);
        if (file.exists()) {
            file.delete();
        }
    }

    private static boolean isValidImageType(String contentType) {
        if (contentType == null) return false;
        for (String type : ALLOWED_TYPES) {
            if (type.equals(contentType)) return true;
        }
        return false;
    }

    private static String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown";
    }

    private static String getExtension(String fileName) {
        int dotIndex = fileName.lastIndexOf('.');
        return dotIndex >= 0 ? fileName.substring(dotIndex).toLowerCase() : ".jpg";
    }
}
