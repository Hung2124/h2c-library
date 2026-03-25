package com.library.service;

import jakarta.mail.Message;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletContext;
import java.util.Properties;

public final class EmailService {

    private EmailService() {}

    public static void send(ServletContext ctx, String to, String subject, String text) throws Exception {
        String host = firstNonBlank(ctx.getInitParameter("mail.smtp.host"), System.getenv("MAIL_SMTP_HOST"));
        if (host == null || host.isBlank()) {
            throw new IllegalStateException("mail.smtp.host not configured");
        }
        String portStr = firstNonBlank(ctx.getInitParameter("mail.smtp.port"), System.getenv("MAIL_SMTP_PORT"));
        int port = portStr != null && !portStr.isBlank() ? Integer.parseInt(portStr.trim()) : 587;
        String user = firstNonBlank(ctx.getInitParameter("mail.smtp.user"), System.getenv("MAIL_SMTP_USER"));
        String pass = firstNonBlank(ctx.getInitParameter("mail.smtp.password"), System.getenv("MAIL_SMTP_PASSWORD"));
        String from = firstNonBlank(ctx.getInitParameter("mail.from"), System.getenv("MAIL_FROM"), user);

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", String.valueOf(port));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, null);
        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
        msg.setSubject(subject, "UTF-8");
        msg.setText(text, "UTF-8");

        try (Transport transport = session.getTransport("smtp")) {
            transport.connect(host, port, user, pass);
            transport.sendMessage(msg, msg.getAllRecipients());
        }
    }

    private static String firstNonBlank(String... vals) {
        if (vals == null) return null;
        for (String v : vals) {
            if (v != null && !v.isBlank()) return v.trim();
        }
        return null;
    }
}
