-- ============================================================
-- Migration: Thêm sách từ ảnh thực tế (22 cuốn) - Lần 2
-- Ngày tạo: 2026-03-25
-- Mô tả: Thêm tác giả, NXB, thể loại mới và 22 đầu sách
--        phân tích từ ảnh bìa thực tế (bộ ảnh thứ hai)
-- ============================================================

-- ------------------------------------------------------------
-- 1. Thêm thể loại mới (nếu chưa có)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Tâm lý - Khoa học')
    INSERT INTO categories (name, description) VALUES (N'Tâm lý - Khoa học', N'Sách khoa học tâm lý, nhận thức, hành vi con người');

IF NOT EXISTS (SELECT 1 FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Lịch sử')
    INSERT INTO categories (name, description) VALUES (N'Lịch sử', N'Sách lịch sử, khoa học lịch sử nhân loại');

IF NOT EXISTS (SELECT 1 FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Thiếu nhi')
    INSERT INTO categories (name, description) VALUES (N'Thiếu nhi', N'Sách dành cho thiếu nhi và tuổi học trò');

-- ------------------------------------------------------------
-- 2. Thêm nhà xuất bản mới (nếu chưa có)
-- ------------------------------------------------------------
-- NXB Kim Đồng đã có sẵn trong DB (từ fix_publisher_encoding.sql)
-- IF NOT EXISTS (SELECT 1 FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Kim Đồng')
--     INSERT INTO publishers (name, note) VALUES (N'NXB Kim Đồng', N'Nhà xuất bản Kim Đồng Việt Nam');

IF NOT EXISTS (SELECT 1 FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Đông A')
    INSERT INTO publishers (name, note) VALUES (N'NXB Đông A', N'Công ty sách Đông A');

IF NOT EXISTS (SELECT 1 FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Thế Giới')
    INSERT INTO publishers (name, note) VALUES (N'NXB Thế Giới', N'Nhà xuất bản Thế Giới Việt Nam');

-- NXB Văn học, NXB Trẻ, NXB Kim Đồng đã tồn tại trong DB

-- ------------------------------------------------------------
-- 3. Thêm tác giả mới (nếu chưa có)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Yuval Noah Harari')
    INSERT INTO authors (name, bio) VALUES (N'Yuval Noah Harari', N'Sử gia, triết gia người Israel, tác giả bộ ba Sapiens – Homo Deus – 21 Lessons for the 21st Century');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Sơn Tùng')
    INSERT INTO authors (name, bio) VALUES (N'Sơn Tùng', N'Nhà văn Việt Nam, tác giả Búp Sen Xanh – tiểu thuyết về thời niên thiếu của Chủ tịch Hồ Chí Minh');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Victor Hugo')
    INSERT INTO authors (name, bio) VALUES (N'Victor Hugo', N'Nhà văn Pháp vĩ đại, tác giả Những Người Khốn Khổ và Nhà Thờ Đức Bà Paris');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Tetsuko Kuroyanagi')
    INSERT INTO authors (name, bio) VALUES (N'Tetsuko Kuroyanagi', N'Diễn viên, nhà văn Nhật Bản, tác giả hồi ký Totto-chan: Cô Bé Bên Cửa Sổ');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Daniel Kahneman')
    INSERT INTO authors (name, bio) VALUES (N'Daniel Kahneman', N'Nhà tâm lý học người Israel, đoạt giải Nobel Kinh tế 2002, tác giả Thinking, Fast and Slow');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Antoine de Saint-Exupéry')
    INSERT INTO authors (name, bio) VALUES (N'Antoine de Saint-Exupéry', N'Nhà văn, phi công người Pháp, tác giả Hoàng Tử Bé – một trong những cuốn sách bán chạy nhất mọi thời đại');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Emily Brontë')
    INSERT INTO authors (name, bio) VALUES (N'Emily Brontë', N'Nữ nhà văn người Anh thế kỷ 19, tác giả kiệt tác Đồi Gió Hú (Wuthering Heights)');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Ernest Hemingway')
    INSERT INTO authors (name, bio) VALUES (N'Ernest Hemingway', N'Nhà văn Mỹ đoạt giải Nobel Văn học 1954, tác giả Ông Già và Biển Cả');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Lev Tolstoy')
    INSERT INTO authors (name, bio) VALUES (N'Lev Tolstoy', N'Nhà văn Nga vĩ đại, tác giả Chiến Tranh và Hòa Bình, Anna Karenina');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Hector Malot')
    INSERT INTO authors (name, bio) VALUES (N'Hector Malot', N'Nhà văn Pháp thế kỷ 19, tác giả Không Gia Đình (Sans Famille)');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Dale Carnegie')
    INSERT INTO authors (name, bio) VALUES (N'Dale Carnegie', N'Nhà văn, diễn giả người Mỹ, tác giả Đắc Nhân Tâm – một trong những cuốn sách bán chạy nhất mọi thời đại');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Cao Minh')
    INSERT INTO authors (name, bio) VALUES (N'Cao Minh', N'Tác giả người Trung Quốc, viết cuốn Thiên Tài Bên Trái, Kẻ Điên Bên Phải');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Paulo Coelho')
    INSERT INTO authors (name, bio) VALUES (N'Paulo Coelho', N'Nhà văn Brazil nổi tiếng thế giới, tác giả Nhà Giả Kim – cuốn sách bán chạy thứ hai sau Kinh Thánh');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Jeffrey Archer')
    INSERT INTO authors (name, bio) VALUES (N'Jeffrey Archer', N'Nhà văn, chính khách người Anh, tác giả Hai Số Phận (Kane & Abel)');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'La Quán Trung')
    INSERT INTO authors (name, bio) VALUES (N'La Quán Trung', N'Nhà văn Trung Quốc thế kỷ 14, tác giả Tam Quốc Chí Diễn Nghĩa');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Vũ Trọng Phụng')
    INSERT INTO authors (name, bio) VALUES (N'Vũ Trọng Phụng', N'Nhà văn Việt Nam (1912–1939), tác giả tiểu thuyết trào phúng Số Đỏ');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Nguyễn Du')
    INSERT INTO authors (name, bio) VALUES (N'Nguyễn Du', N'Đại thi hào Việt Nam (1765–1820), tác giả Truyện Kiều – kiệt tác văn học chữ Nôm');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Kim Lân')
    INSERT INTO authors (name, bio) VALUES (N'Kim Lân', N'Nhà văn Việt Nam (1920–2007), tác giả truyện ngắn nổi tiếng Vợ Nhặt và Làng');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Nguyễn Dữ')
    INSERT INTO authors (name, bio) VALUES (N'Nguyễn Dữ', N'Nhà văn Việt Nam thế kỷ 16, tác giả Truyền Kỳ Mạn Lục – tập truyện truyền kỳ bằng chữ Hán');

-- ------------------------------------------------------------
-- 4. Thêm 22 đầu sách (bộ ảnh thứ hai)
-- ------------------------------------------------------------

-- 1. Sapiens: Lược Sử Loài Người
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Sapiens: Lược Sử Loài Người')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Sapiens: Lược Sử Loài Người',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Yuval Noah Harari'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Lịch sử'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Thế Giới'),
    2017, N'Tiếng Việt', 8, 8,
    'assets/images/uploads/sapiens.jpg',
    N'Lược sử về loài người từ thời tiền sử đến hiện đại – cuốn sách best-seller toàn cầu của Yuval Noah Harari.',
    'AVAILABLE'
);

-- 2. Búp Sen Xanh
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Búp Sen Xanh')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Búp Sen Xanh',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Sơn Tùng'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Kim Đồng'),
    1982, N'Tiếng Việt', 10, 10,
    'assets/images/uploads/bup_sen_xanh.jpg',
    N'Tiểu thuyết về thời niên thiếu của Chủ tịch Hồ Chí Minh – tác phẩm chọn lọc dành cho thiếu nhi của NXB Kim Đồng.',
    'AVAILABLE'
);

-- 3. Những Người Khốn Khổ (Tập 2)
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Những Người Khốn Khổ (Tập 2)')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Những Người Khốn Khổ (Tập 2)',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Victor Hugo'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2020, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/nhung_nguoi_khon_kho_2.jpg',
    N'Tập 2 tiểu thuyết kinh điển Les Misérables của Victor Hugo – nhiều người dịch.',
    'AVAILABLE'
);

-- 4. Totto-chan: Cô Bé Bên Cửa Sổ
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Totto-chan: Cô Bé Bên Cửa Sổ')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Totto-chan: Cô Bé Bên Cửa Sổ',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Tetsuko Kuroyanagi'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Thiếu nhi'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Trẻ'),
    1981, N'Tiếng Việt', 8, 8,
    'assets/images/uploads/totto_chan.jpg',
    N'Hồi ký về tuổi thơ tại trường học độc đáo Tomoe Gakuen – một trong những cuốn sách bán chạy nhất Nhật Bản.',
    'AVAILABLE'
);

-- 5. Tư Duy Nhanh và Chậm
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Tư Duy Nhanh và Chậm')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Tư Duy Nhanh và Chậm',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Daniel Kahneman'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Tâm lý - Khoa học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Thế Giới'),
    2011, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/thinking_fast_and_slow.jpg',
    N'Thinking, Fast and Slow – bestseller New York Times, khám phá hai hệ thống tư duy của Daniel Kahneman, đoạt giải Nobel Kinh tế.',
    'AVAILABLE'
);

-- 6. Hoàng Tử Bé
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Hoàng Tử Bé')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Hoàng Tử Bé',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Antoine de Saint-Exupéry'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Đông A'),
    1943, N'Tiếng Việt', 12, 12,
    'assets/images/uploads/hoang_tu_be.jpg',
    N'Le Petit Prince – kiệt tác văn học Pháp dành cho mọi lứa tuổi. Vĩnh Lạc dịch, với minh họa của chính tác giả.',
    'AVAILABLE'
);

-- 7. Đồi Gió Hú
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Đồi Gió Hú')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Đồi Gió Hú',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Emily Brontë'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2019, N'Tiếng Việt', 7, 7,
    'assets/images/uploads/doi_gio_hu.jpg',
    N'Wuthering Heights – tiểu thuyết lãng mạn kinh điển của Emily Brontë. Mạnh Chương dịch.',
    'AVAILABLE'
);

-- 8. Ông Già và Biển Cả
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Ông Già và Biển Cả')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Ông Già và Biển Cả',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Ernest Hemingway'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    1952, N'Tiếng Việt', 8, 8,
    'assets/images/uploads/ong_gia_va_bien_ca.jpg',
    N'The Old Man and the Sea – tiểu thuyết ngắn đoạt giải Pulitzer 1953 của Ernest Hemingway.',
    'AVAILABLE'
);

-- 9. Chiến Tranh và Hòa Bình (Tập 1)
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Chiến Tranh và Hòa Bình (Tập 1)')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Chiến Tranh và Hòa Bình (Tập 1)',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Lev Tolstoy'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2018, N'Tiếng Việt', 5, 5,
    'assets/images/uploads/chien_tranh_va_hoa_binh_1.jpg',
    N'Tập 1 tiểu thuyết sử thi vĩ đại của Lev Tolstoy. Dịch: Cao Xuân Hạo, Nhữ Thành, Hoàng Thiếu Sơn, Trường Xuyên.',
    'AVAILABLE'
);

-- 10. Không Gia Đình (bìa cổ điển)
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Không Gia Đình')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Không Gia Đình',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Hector Malot'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2015, N'Tiếng Việt', 8, 8,
    'assets/images/uploads/khong_gia_dinh.jpg',
    N'Sans Famille – tiểu thuyết kinh điển Pháp về cậu bé Rémi lưu lạc của Hector Malot.',
    'AVAILABLE'
);

-- 11. Đắc Nhân Tâm
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Đắc Nhân Tâm')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Đắc Nhân Tâm',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Dale Carnegie'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Kỹ năng sống'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Thế Giới'),
    1936, N'Tiếng Việt', 15, 15,
    'assets/images/uploads/dac_nhan_tam.jpg',
    N'How to Win Friends and Influence People – phiên bản hoàn thiện, cuốn sách kỹ năng sống hay nhất mọi thời đại. Tín Nghĩa dịch.',
    'AVAILABLE'
);

-- 12. Thiên Tài Bên Trái, Kẻ Điên Bên Phải
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Thiên Tài Bên Trái, Kẻ Điên Bên Phải')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Thiên Tài Bên Trái, Kẻ Điên Bên Phải',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Cao Minh'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Tâm lý - Khoa học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Thế Giới'),
    2016, N'Tiếng Việt', 7, 7,
    'assets/images/uploads/thien_tai_ben_trai.jpg',
    N'Những cuộc trò chuyện với thiên tài và người điên – khám phá ranh giới mong manh của tâm trí. Thu Hương dịch.',
    'AVAILABLE'
);

-- 13. Không Gia Đình (bìa mới - NXB Văn Học / Huy Hoàng)
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Không Gia Đình (Tái bản bìa mới)')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Không Gia Đình (Tái bản bìa mới)',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Hector Malot'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2022, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/khong_gia_dinh_2.jpg',
    N'Sans Famille – tái bản bìa mới minh họa đẹp. Như Phong dịch.',
    'AVAILABLE'
);

-- 14. Nhà Giả Kim
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Nhà Giả Kim')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Nhà Giả Kim',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Paulo Coelho'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Trẻ'),
    1988, N'Tiếng Việt', 12, 12,
    'assets/images/uploads/nha_gia_kim.jpg',
    N'The Alchemist – cuốn sách bán chạy thứ hai chỉ sau Kinh Thánh, hành trình theo đuổi vận mệnh. Lê Chu Cầu dịch.',
    'AVAILABLE'
);

-- 15. Hai Số Phận (bìa cổ điển)
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Hai Số Phận')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Hai Số Phận',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Jeffrey Archer'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2019, N'Tiếng Việt', 7, 7,
    'assets/images/uploads/hai_so_phan.jpg',
    N'Kane & Abel – The Global No.1 Bestseller, câu chuyện về hai người đàn ông sinh cùng ngày, kẻ thù suốt đời. Nguyễn Việt Hải dịch.',
    'AVAILABLE'
);

-- 16. Hai Số Phận (bìa mới)
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Hai Số Phận (Tái bản bìa mới)')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Hai Số Phận (Tái bản bìa mới)',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Jeffrey Archer'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2023, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/hai_so_phan_2.jpg',
    N'Kane & Abel – tái bản bìa mới. The Global No.1 Bestseller. Nguyễn Việt Hải dịch.',
    'AVAILABLE'
);

-- 17. Tam Quốc Chí (Tập 3)
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Tam Quốc Chí (Tập 3)')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Tam Quốc Chí (Tập 3)',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'La Quán Trung'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2010, N'Tiếng Việt', 5, 5,
    'assets/images/uploads/tam_quoc_chi_3.jpg',
    N'Tam Quốc Chí Diễn Nghĩa – tập 3, tiểu thuyết lịch sử Trung Hoa kinh điển của La Quán Trung.',
    'AVAILABLE'
);

-- 18. Số Đỏ
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Số Đỏ')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Số Đỏ',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Vũ Trọng Phụng'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    1936, N'Tiếng Việt', 10, 10,
    'assets/images/uploads/so_do.jpg',
    N'Tiểu thuyết trào phúng kinh điển của văn học Việt Nam hiện đại, phê phán xã hội thực dân nửa phong kiến.',
    'AVAILABLE'
);

-- 19. Truyện Kiều
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Truyện Kiều')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Truyện Kiều',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Nguyễn Du'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Trẻ'),
    2015, N'Tiếng Việt', 12, 12,
    'assets/images/uploads/truyen_kieu.jpg',
    N'Kiệt tác văn học chữ Nôm của đại thi hào Nguyễn Du – ấn bản kỷ niệm 250 năm ngày sinh. Bản văn do Hội Kiều học Việt Nam hiệu khảo.',
    'AVAILABLE'
);

-- 20. Vợ Nhặt
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Vợ Nhặt')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Vợ Nhặt',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Kim Lân'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    2010, N'Tiếng Việt', 10, 10,
    'assets/images/uploads/vo_nhat.jpg',
    N'Tập truyện ngắn của Kim Lân – danh tác văn học Việt Nam, gồm truyện nổi tiếng Vợ Nhặt về nạn đói 1945.',
    'AVAILABLE'
);

-- 21. Làng
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Làng')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Làng',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Kim Lân'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Văn học'),
    1948, N'Tiếng Việt', 8, 8,
    'assets/images/uploads/lang.jpg',
    N'Truyện ngắn nổi tiếng của Kim Lân về người nông dân yêu làng, yêu nước trong kháng chiến chống Pháp.',
    'AVAILABLE'
);

-- 22. Truyền Kỳ Mạn Lục
IF NOT EXISTS (SELECT 1 FROM books WHERE title = N'Truyền Kỳ Mạn Lục')
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES (
    N'Truyền Kỳ Mạn Lục',
    (SELECT id FROM authors WHERE name COLLATE Vietnamese_CI_AS = N'Nguyễn Dữ'),
    (SELECT id FROM categories WHERE name COLLATE Vietnamese_CI_AS = N'Văn học'),
    (SELECT id FROM publishers WHERE name COLLATE Vietnamese_CI_AS = N'NXB Kim Đồng'),
    2020, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/truyen_ky_man_luc.jpg',
    N'Tập truyện truyền kỳ chữ Hán của Nguyễn Dữ – 20 câu chuyện kỳ bí thế kỷ 16. Trúc Khê – Ngô Văn Thiện dịch. Minh họa: Đặng Khánh Ly.',
    'AVAILABLE'
);
