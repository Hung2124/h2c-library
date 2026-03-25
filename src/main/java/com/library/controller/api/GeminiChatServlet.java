package com.library.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet("/api/gemini-chat")
public class GeminiChatServlet extends HttpServlet {

    private static final Gson GSON = new Gson();
    private static final HttpClient HTTP = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(15))
            .build();

    /**
     * Theo tài liệu Google (2026): 2.0 Flash đã deprecated; 1.5-flash có thể không còn trên v1beta.
     * Dùng 2.5 (stable) cho chat miễn phí; lite trước (rẻ, quota tốt).
     */
    private static final String[] DEFAULT_FALLBACK_MODELS = {
            "gemini-2.5-flash-lite",
            "gemini-2.5-flash",
            "gemini-2.0-flash",
            "gemini-2.0-flash-lite"
    };

    /**
     * Chỉ dùng v1 — v1beta hay trả "model not found" với cùng model + key AI Studio.
     * Nếu cần: thêm context-param gemini.api.versions = v1,v1beta
     */
    private static final String[] API_VERSIONS_DEFAULT = {"v1"};

    private static final String SYSTEM_PROMPT =
            "Bạn là quản thủ thư viện ảo tinh thông sách vở của **H2C LIBRARY**. "
          + "Phong cách: Thông thái, nhiệt huyết, yêu sách, đôi khi pha chút hóm hỉnh nhưng vẫn rất lịch sự.\n\n"
          + "Nhiệm vụ:\n"
          + "- Giải đáp về sách, tác giả (ví dụ: Lão Hạc là tác phẩm kinh điển của Nam Cao, rất cảm động...).\n"
          + "- Hỗ trợ mượn/trả, giờ mở cửa (8h-21h), quy định thư viện.\n"
          + "- Luôn giữ ngữ cảnh cuộc trò chuyện. Nếu người dùng khen sách hay hoặc đang nói về một cuốn sách, "
          + "hãy thảo luận sâu hơn và gợi ý thêm vài cuốn cùng thể loại.\n\n"
          + "Tuyệt đối không bịa đặt thông tin không có thật về thư viện.";
    
    private static final int MAX_HISTORY = 10;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setCharacterEncoding(StandardCharsets.UTF_8.name());
        res.setContentType("application/json;charset=UTF-8");

        String apiKey = System.getenv("GEMINI_API_KEY");
        if (apiKey == null || apiKey.isBlank()) {
            apiKey = getServletContext().getInitParameter("gemini.api.key");
        }
        if (apiKey != null) {
            apiKey = apiKey.trim();
        }

        if (apiKey == null || apiKey.isBlank()) {
            res.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            res.getWriter().write("{\"error\":\"Chưa cấu hình GEMINI_API_KEY trong web.xml hoặc biến môi trường.\"}");
            return;
        }

        String body;
        try (var reader = req.getReader()) {
            body = reader.lines().reduce("", (a, b) -> a + b);
        }
        if (body == null || body.isBlank()) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            res.getWriter().write("{\"error\":\"Body rỗng\"}");
            return;
        }

        JsonObject in = GSON.fromJson(body, JsonObject.class);
        if (in == null || !in.has("message")) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            res.getWriter().write("{\"error\":\"Thiếu field 'message'\"}");
            return;
        }
        String userMsg = in.get("message").getAsString().trim();
        if (userMsg.isBlank()) {
            res.getWriter().write("{\"reply\":\"Bạn chưa nhập câu hỏi.\"}");
            return;
        }
        if (userMsg.length() > 2000) {
            userMsg = userMsg.substring(0, 2000);
        }

        List<String> models = resolveModelList();
        
        // --- QUẢN LÝ LỊCH SỬ CHAT TRONG SESSION ---
        var session = req.getSession();
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> history = (List<Map<String, Object>>) session.getAttribute("gemini_history");
        if (history == null) {
            history = new ArrayList<>();
        }
        
        // Thêm tin nhắn hiện tại của user vào history
        // Nếu là tin nhắn đầu tiên, đính kèm SYSTEM_PROMPT để bot nắm được vai trò
        String finalUserMsg = userMsg;
        if (history.isEmpty()) {
            finalUserMsg = "SYSTEM INSTRUCTION:\n" + SYSTEM_PROMPT + "\n\nUSER QUESTION:\n" + userMsg;
        }
        
        history.add(Map.of(
            "role", "user",
            "parts", List.of(Map.of("text", finalUserMsg))
        ));
        
        // Giữ history trong giới hạn
        if (history.size() > MAX_HISTORY * 2) {
            history = new ArrayList<>(history.subList(history.size() - MAX_HISTORY * 2, history.size()));
        }
        session.setAttribute("gemini_history", history);

        // --- XÂY DỰNG PAYLOAD ---
        Map<String, Object> payload = Map.of(
                "contents", history,
                "generationConfig", Map.of(
                        "maxOutputTokens", 1024,
                        "temperature", 0.7
                )
        );
        String json = GSON.toJson(payload);

        int lastStatus = 0;
        String lastBody = "";
        boolean saw429 = false;
        String[] apiVersions = resolveApiVersions();

        try {
            for (String model : models) {
                for (String apiVer : apiVersions) {
                    HttpResponse<String> response = sendGenerateContent(apiKey, apiVer, model, json);
                    lastStatus = response.statusCode();
                    lastBody = response.body();

                    if (response.statusCode() / 100 == 2) {
                        JsonObject root = GSON.fromJson(lastBody, JsonObject.class);
                        String reply = extractText(root);
                        if (reply == null || reply.isBlank()) {
                            reply = "Xin lỗi, mình chưa hiểu câu hỏi. Bạn diễn đạt lại giúp nhé?";
                        }
                        
                        // Lưu câu trả lời của bot vào history
                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> currHistory = (List<Map<String, Object>>) session.getAttribute("gemini_history");
                        if (currHistory != null) {
                            currHistory.add(Map.of(
                                "role", "model",
                                "parts", List.of(Map.of("text", reply))
                            ));
                            session.setAttribute("gemini_history", currHistory);
                        }
                        
                        JsonObject out = new JsonObject();
                        out.addProperty("reply", reply);
                        res.getWriter().write(out.toString());
                        return;
                    }

                    if (response.statusCode() == 429) {
                        saw429 = true;
                        getServletContext().log("Gemini 429: Hết quota cho " + apiVer + "/" + model);
                        break;
                    }
                    if (response.statusCode() == 404) {
                        getServletContext().log("Gemini 404: Không tìm thấy model " + apiVer + "/" + model);
                        continue;
                    }

                    if (isRetryableModelError(response.statusCode(), lastBody)) {
                        getServletContext().log("Gemini Retryable Error (" + response.statusCode() + ") for " 
                                + apiVer + "/" + model + ": " + shortGoogleMessage(lastBody));
                        continue;
                    }

                    if (response.statusCode() == 403
                            || (response.statusCode() == 400 && !isRetryableModelError(400, lastBody))) {
                        getServletContext().log("Gemini Fatal Error (" + response.statusCode() + "): " + lastBody);
                        res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        res.getWriter().write("{\"error\":\"" + escapeJson(
                                "API lỗi (" + response.statusCode() + "): " + shortGoogleMessage(lastBody)) + "\"}");
                        return;
                    }

                    getServletContext().log("Gemini Unexpected Status " + response.statusCode() + ": " + lastBody);
                    res.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
                    res.getWriter().write("{\"error\":\"" + escapeJson(
                            "Gemini HTTP " + response.statusCode() + ": " + shortGoogleMessage(lastBody)) + "\"}");
                    return;
                }
            }

            if (saw429 || lastStatus == 429) {
                res.setStatus(503);
                res.getWriter().write("{\"error\":\""
                        + escapeJson("Hết quota miễn phí (429). Đợi 1–2 phút hoặc sang ngày mới; "
                        + "hoặc tạo API key mới tại Google AI Studio.")
                        + "\"}");
                return;
            }

            res.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
            res.getWriter().write("{\"error\":\""
                    + escapeJson("Không gọi được Gemini. Kiểm tra API key tại AI Studio; "
                    + "model 2.0/1.5 có thể đã tắt — dùng 2.5-flash. Chi tiết: "
                    + shortGoogleMessage(lastBody))
                    + "\"}");

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            res.setStatus(HttpServletResponse.SC_GATEWAY_TIMEOUT);
            res.getWriter().write("{\"error\":\"Yêu cầu bị gián đoạn. Thử lại nhé.\"}");
        } catch (Exception e) {
            getServletContext().log("Gemini API error", e);
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write("{\"error\":\"Lỗi kết nối AI. Thử lại sau.\"}");
        }
    }

    private String[] resolveApiVersions() {
        String p = getServletContext().getInitParameter("gemini.api.versions");
        if (p == null || p.isBlank()) {
            return API_VERSIONS_DEFAULT;
        }
        String[] parts = p.split(",");
        List<String> out = new ArrayList<>();
        for (String s : parts) {
            String v = s.trim();
            if (!v.isEmpty()) {
                out.add(v);
            }
        }
        return out.isEmpty() ? API_VERSIONS_DEFAULT : out.toArray(new String[0]);
    }

    private List<String> resolveModelList() {
        String primary = getServletContext().getInitParameter("gemini.model");
        if (primary == null || primary.isBlank()) {
            primary = "gemini-2.5-flash-lite";
        }
        String extra = getServletContext().getInitParameter("gemini.model.fallbacks");

        Set<String> ordered = new LinkedHashSet<>();
        ordered.add(primary.trim());
        if (extra != null && !extra.isBlank()) {
            for (String part : extra.split(",")) {
                String m = part.trim();
                if (!m.isEmpty()) {
                    ordered.add(m);
                }
            }
        } else {
            for (String m : DEFAULT_FALLBACK_MODELS) {
                ordered.add(m);
            }
        }
        return new ArrayList<>(ordered);
    }

    private static HttpResponse<String> sendGenerateContent(
            String apiKey, String apiVersion, String model, String jsonBody)
            throws IOException, InterruptedException {
        String url = "https://generativelanguage.googleapis.com/"
                + apiVersion + "/models/" + model + ":generateContent?key=" + apiKey;
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(30))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
                .build();
        return HTTP.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
    }

    /**
     * 400/404 với thông báo model không tồn tại / không hỗ trợ generateContent → thử model khác.
     */
    private static boolean isRetryableModelError(int status, String jsonBody) {
        if (status == 404) {
            return true;
        }
        if (status != 400 || jsonBody == null) {
            return false;
        }
        String m = jsonBody.toLowerCase();
        return m.contains("not found")
                || m.contains("is not supported")
                || m.contains("does not exist")
                || m.contains("unknown model");
    }

    private static String shortGoogleMessage(String json) {
        if (json == null || json.isBlank()) {
            return "Không có phản hồi từ Google";
        }
        try {
            JsonObject root = GSON.fromJson(json, JsonObject.class);
            if (root == null) {
                return json.length() > 100 ? json.substring(0, 97) + "..." : json;
            }
            if (root.has("error") && root.get("error").isJsonObject()) {
                JsonObject err = root.getAsJsonObject("error");
                if (err.has("message")) {
                    String m = err.get("message").getAsString();
                    return m.length() > 120 ? m.substring(0, 117) + "..." : m;
                }
            }
            // Nếu không có field error nhưng là JSON, trả về một phần JSON
            return json.length() > 100 ? json.substring(0, 97) + "..." : json;
        } catch (Exception ignored) {
            return json.length() > 100 ? json.substring(0, 97) + "..." : json;
        }
    }

    private static String escapeJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ");
    }

    private static String extractText(JsonObject root) {
        try {
            var cands = root.getAsJsonArray("candidates");
            if (cands == null || cands.isEmpty()) {
                return null;
            }
            var content = cands.get(0).getAsJsonObject().getAsJsonObject("content");
            if (content == null) {
                return null;
            }
            var parts = content.getAsJsonArray("parts");
            if (parts == null || parts.isEmpty()) {
                return null;
            }
            return parts.get(0).getAsJsonObject().get("text").getAsString();
        } catch (Exception e) {
            return null;
        }
    }
}
