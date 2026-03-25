-- =============================================================
-- Thêm 5 đầu sách mới vào Smart Library
-- Chạy script này sau khi đã có schema và dữ liệu mẫu
-- =============================================================

USE SmartLibraryDB;
GO

-- Thêm tác giả mới (nếu chưa có)
INSERT INTO authors (name, bio) VALUES
(N'Erich Gamma', N'Đồng tác giả Design Patterns, kỹ sư phần mềm'),
(N'Vũ Trọng Phụng', N'Nhà văn hiện thực phê phán Việt Nam'),
(N'Robert Kiyosaki', N'Tác giả Rich Dad Poor Dad, chuyên gia tài chính'),
(N'Stephen Hawking', N'Nhà vật lý lý thuyết, tác giả A Brief History of Time'),
(N'Lê Văn Hưu', N'Nhà sử học Việt Nam thời Trần');

-- Thêm 5 đầu sách
INSERT INTO books (title, author_id, category_id, publisher, publish_year, language, quantity, available_quantity, image, description, status)
VALUES
(N'Design Patterns: Elements of Reusable Object-Oriented Software', 6, 1, N'Addison-Wesley', 1994, N'English', 4, 4, 'assets/images/books/design_patterns.png',
 N'Các mẫu thiết kế phần mềm kinh điển', 'AVAILABLE'),
(N'Số Đỏ', 7, 2, N'NXB Văn học', 2018, N'Tiếng Việt', 6, 6, 'assets/images/books/so_do.png',
 N'Tiểu thuyết trào phúng kinh điển của Vũ Trọng Phụng', 'AVAILABLE'),
(N'Rich Dad Poor Dad', 8, 3, N'Warner Books', 2017, N'English', 5, 5, 'assets/images/books/rich_dad_poor_dad.png',
 N'Sách về tư duy tài chính và đầu tư', 'AVAILABLE'),
(N'A Brief History of Time', 9, 4, N'Bantam Books', 1988, N'English', 3, 3, 'assets/images/books/brief_history_of_time.png',
 N'Khám phá vũ trụ và thuyết tương đối', 'AVAILABLE'),
(N'Đại Việt Sử Ký', 10, 5, N'NXB Khoa học Xã hội', 2012, N'Tiếng Việt', 4, 4, 'assets/images/books/dai_viet_su_ky.png',
 N'Bộ sử chính thống đầu tiên của Việt Nam', 'AVAILABLE');
