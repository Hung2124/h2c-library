-- =============================================================
-- Cập nhật đường dẫn ảnh sách
-- Đặt ảnh trong: src/main/webapp/assets/images/books/
-- Đổi tên file nếu ảnh của bạn khác (vd: effective_java.jpg)
-- =============================================================

USE SmartLibraryDB;
GO

-- 5 sách mẫu ban đầu (id 1–5)
UPDATE books SET image = 'assets/images/books/effective_java.png' WHERE title = N'Effective Java';
UPDATE books SET image = 'assets/images/books/clean_code.png' WHERE title = N'Clean Code';
UPDATE books SET image = 'assets/images/books/chi_pheo.png' WHERE title = N'Chí Phèo';
UPDATE books SET image = 'assets/images/books/de_men_phieu_luu_ky.png' WHERE title = N'Dế Mèn Phiêu Lưu Ký';
UPDATE books SET image = 'assets/images/books/java_complete_reference.png' WHERE title = N'Java: The Complete Reference';

-- 5 sách thêm sau (nếu đã chạy add_5_books.sql)
UPDATE books SET image = 'assets/images/books/design_patterns.png' WHERE title = N'Design Patterns: Elements of Reusable Object-Oriented Software';
UPDATE books SET image = 'assets/images/books/so_do.png' WHERE title = N'Số Đỏ';
UPDATE books SET image = 'assets/images/books/rich_dad_poor_dad.png' WHERE title = N'Rich Dad Poor Dad';
UPDATE books SET image = 'assets/images/books/brief_history_of_time.png' WHERE title = N'A Brief History of Time';
UPDATE books SET image = 'assets/images/books/dai_viet_su_ky.png' WHERE title = N'Đại Việt Sử Ký';
