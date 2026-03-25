-- ============================================================
-- Migration: Thêm sách từ ảnh thực tế (23 cuốn)
-- Ngày tạo: 2026-03-25
-- Mô tả: Thêm tác giả, NXB, thể loại mới và 23 đầu sách
--        phân tích từ ảnh bìa thực tế
-- ============================================================

-- ------------------------------------------------------------
-- 1. Thêm thể loại mới (nếu chưa có)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM categories WHERE name = N'Trinh thám')
    INSERT INTO categories (name, description) VALUES (N'Trinh thám', N'Tiểu thuyết trinh thám, hình sự, bí ẩn');

IF NOT EXISTS (SELECT 1 FROM categories WHERE name = N'Kỹ năng sống')
    INSERT INTO categories (name, description) VALUES (N'Kỹ năng sống', N'Sách phát triển bản thân, kỹ năng sống');

-- ------------------------------------------------------------
-- 2. Thêm nhà xuất bản mới (nếu chưa có)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM publishers WHERE name = N'NXB Hội Nhà Văn')
    INSERT INTO publishers (name, note) VALUES (N'NXB Hội Nhà Văn', N'Nhà xuất bản Hội Nhà Văn Việt Nam');

IF NOT EXISTS (SELECT 1 FROM publishers WHERE name = N'NXB Phụ Nữ')
    INSERT INTO publishers (name, note) VALUES (N'NXB Phụ Nữ', N'Nhà xuất bản Phụ Nữ Việt Nam');

IF NOT EXISTS (SELECT 1 FROM publishers WHERE name = N'NXB Thanh Niên')
    INSERT INTO publishers (name, note) VALUES (N'NXB Thanh Niên', N'Nhà xuất bản Thanh Niên Việt Nam');

IF NOT EXISTS (SELECT 1 FROM publishers WHERE name = N'NXB Tổng Hợp TP.HCM')
    INSERT INTO publishers (name, note) VALUES (N'NXB Tổng Hợp TP.HCM', N'Nhà xuất bản Tổng hợp Thành phố Hồ Chí Minh');

-- NXB Văn học đã tồn tại trong DB (tên chính xác: 'NXB Văn học')
-- IF NOT EXISTS (SELECT 1 FROM publishers WHERE name = N'NXB Văn học')
--     INSERT INTO publishers (name, note) VALUES (N'NXB Văn học', N'Nhà xuất bản Văn Học Việt Nam');

-- ------------------------------------------------------------
-- 3. Thêm tác giả mới (nếu chưa có)
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Lưu Vũ Tinh')
    INSERT INTO authors (name, bio) VALUES (N'Lưu Vũ Tinh', N'Nhà văn Trung Quốc, tác giả nhiều tiểu thuyết lãng mạn nổi tiếng');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Chu Ngọc')
    INSERT INTO authors (name, bio) VALUES (N'Chu Ngọc', N'Tác giả tiểu thuyết ngôn tình Trung Quốc');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Cửu Bả Đao')
    INSERT INTO authors (name, bio) VALUES (N'Cửu Bả Đao', N'Nhà văn, đạo diễn Đài Loan – tác giả "You Are the Apple of My Eye"');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Agatha Christie')
    INSERT INTO authors (name, bio) VALUES (N'Agatha Christie', N'Nữ hoàng trinh thám người Anh, tác giả bộ truyện thám tử Hercule Poirot');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Cương Tuyết Âm')
    INSERT INTO authors (name, bio) VALUES (N'Cương Tuyết Âm', N'Tác giả tiểu thuyết trinh thám Trung Quốc');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Lưu Bát Bách')
    INSERT INTO authors (name, bio) VALUES (N'Lưu Bát Bách', N'Tác giả series Ghi Chép Pháp Y, nhà văn Trung Quốc');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Minato Kanae')
    INSERT INTO authors (name, bio) VALUES (N'Minato Kanae', N'Nhà văn Nhật Bản, tác giả tiểu thuyết Thú Tội (Confessions)');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Thomas Harris')
    INSERT INTO authors (name, bio) VALUES (N'Thomas Harris', N'Nhà văn Mỹ, tác giả series Hannibal Lecter – Sự Im Lặng Của Bầy Cừu');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Liêu Tiểu Đao')
    INSERT INTO authors (name, bio) VALUES (N'Liêu Tiểu Đao', N'Tác giả series Ghi Chép Pháp Y, nhà văn Trung Quốc');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Lưu Hiểu Huy')
    INSERT INTO authors (name, bio) VALUES (N'Lưu Hiểu Huy', N'Tác giả trinh thám Trung Quốc, series Ghi Chép Pháp Y');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Higashino Keigo')
    INSERT INTO authors (name, bio) VALUES (N'Higashino Keigo', N'Nhà văn trinh thám Nhật Bản nổi tiếng thế giới');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Rosie Nguyễn')
    INSERT INTO authors (name, bio) VALUES (N'Rosie Nguyễn', N'Tác giả người Việt, nổi tiếng với "Tuổi Trẻ Đáng Giá Bao Nhiêu?"');

IF NOT EXISTS (SELECT 1 FROM authors WHERE name = N'Nhiều tác giả')
    INSERT INTO authors (name, bio) VALUES (N'Nhiều tác giả', N'Tập hợp bài viết từ nhiều tác giả');

-- ------------------------------------------------------------
-- 4. Thêm 23 đầu sách
--    Lưu ý: Dùng SELECT để lấy id động, tránh hardcode
-- ------------------------------------------------------------
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
VALUES

-- 1. Thất Tịch Không Mưa
(
    N'Thất Tịch Không Mưa',
    (SELECT id FROM authors WHERE name = N'Lưu Vũ Tinh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Hội Nhà Văn'),
    2020, N'Tiếng Việt', 5, 5,
    'assets/images/uploads/that_tich_khong_mua.jpg',
    N'Tiểu thuyết lãng mạn của tác giả Lưu Vũ Tinh – Cẩm Ninh (Jini) dịch.',
    'AVAILABLE'
),

-- 2. Đạo Tình (tập 2)
(
    N'Đạo Tình (Tập 2)',
    (SELECT id FROM authors WHERE name = N'Chu Ngọc'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Văn học'),
    2019, N'Tiếng Việt', 4, 4,
    'assets/images/uploads/dao_tinh_2.jpg',
    N'Tiểu thuyết ngôn tình của Chu Ngọc – tập 2.',
    'AVAILABLE'
),

-- 3. Cô Gái Năm Ấy Chúng Ta Cùng Theo Đuổi
(
    N'Cô Gái Năm Ấy Chúng Ta Cùng Theo Đuổi',
    (SELECT id FROM authors WHERE name = N'Cửu Bả Đao'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Phụ Nữ'),
    2013, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/co_gai_nam_ay.jpg',
    N'Tiểu thuyết bán tự truyện của Cửu Bả Đao – chuyển thể thành phim "You Are the Apple of My Eye". Lục Hương dịch.',
    'AVAILABLE'
),

-- 4. Cho Tôi Xin Một Vé Đi Tuổi Thơ
(
    N'Cho Tôi Xin Một Vé Đi Tuổi Thơ',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    2008, N'Tiếng Việt', 10, 10,
    'assets/images/uploads/cho_toi_xin_mot_ve.jpg',
    N'Truyện về ký ức tuổi thơ trong sáng và hồn nhiên của Nguyễn Nhật Ánh. Bán hơn 400.000 bản.',
    'AVAILABLE'
),

-- 5. Tôi Là Bêtô
(
    N'Tôi Là Bêtô',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    2007, N'Tiếng Việt', 8, 8,
    'assets/images/uploads/toi_la_beto.jpg',
    N'Câu chuyện cảm động kể từ góc nhìn của chú chó Bêtô – phiên bản màu đặc biệt.',
    'AVAILABLE'
),

-- 6. Cô Gái Đến Từ Hôm Qua
(
    N'Cô Gái Đến Từ Hôm Qua',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    1989, N'Tiếng Việt', 12, 12,
    'assets/images/uploads/co_gai_den_tu_hom_qua.jpg',
    N'Truyện dài về tình yêu học trò trong sáng. In lần thứ 39. Tác giả sách bán chạy nhất.',
    'AVAILABLE'
),

-- 7. Tôi Thấy Hoa Vàng Trên Cỏ Xanh (bản mới)
(
    N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    2010, N'Tiếng Việt', 15, 15,
    'assets/images/uploads/toi_thay_hoa_vang.jpg',
    N'Truyện dài về tuổi thơ ở làng quê – đã chuyển thể thành phim. Bán hơn 270.000 bản, in lần thứ 38.',
    'AVAILABLE'
),

-- 8. Mắt Biếc (bản mới)
(
    N'Mắt Biếc',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    1990, N'Tiếng Việt', 15, 15,
    'assets/images/uploads/mat_biec.jpg',
    N'Chuyện tình buồn vượt thời gian – đã chuyển thể thành phim. Bán hơn 200.000 bản, in lần thứ 44.',
    'AVAILABLE'
),

-- 9. Chúc Một Ngày Tốt Lành
(
    N'Chúc Một Ngày Tốt Lành',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    2014, N'Tiếng Việt', 8, 8,
    'assets/images/uploads/chuc_mot_ngay_tot_lanh.jpg',
    N'Truyện về những điều bình dị và ấm áp trong cuộc sống. Bán hơn 100.000 bản, in lần thứ 15.',
    'AVAILABLE'
),

-- 10. Ngày Xưa Có Một Chuyện Tình (bìa cũ)
(
    N'Ngày Xưa Có Một Chuyện Tình',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    2004, N'Tiếng Việt', 10, 10,
    'assets/images/uploads/ngay_xua_co_mot_chuyen_tinh_cu.jpg',
    N'Truyện dài về mối tình đẹp buồn – in lần thứ 2. Bán hơn 100.000 bản.',
    'AVAILABLE'
),

-- 11. Có Hai Con Mèo Ngồi Bên Cửa Sổ
(
    N'Có Hai Con Mèo Ngồi Bên Cửa Sổ',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    2012, N'Tiếng Việt', 7, 7,
    'assets/images/uploads/co_hai_con_meo.jpg',
    N'Truyện ngắn dí dỏm kể từ góc nhìn của hai chú mèo.',
    'AVAILABLE'
),

-- 12. Ngày Xưa Có Một Chuyện Tình (bìa mới)
(
    N'Ngày Xưa Có Một Chuyện Tình (Tái bản)',
    (SELECT id FROM authors WHERE name = N'Nguyễn Nhật Ánh'),
    (SELECT id FROM categories WHERE name = N'Văn học'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    2020, N'Tiếng Việt', 10, 10,
    'assets/images/uploads/ngay_xua_co_mot_chuyen_tinh_moi.jpg',
    N'Truyện dài về mối tình đẹp buồn – bản tái bản bìa mới in lần thứ 8. Bán hơn 100.000 bản.',
    'AVAILABLE'
),

-- 13. Án Mạng Trên Sông Nile
(
    N'Án Mạng Trên Sông Nile',
    (SELECT id FROM authors WHERE name = N'Agatha Christie'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Hội Nhà Văn'),
    2018, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/an_mang_tren_song_nile.jpg',
    N'Vụ án trên sông Nile của thám tử Hercule Poirot – chuyển thể thành phim bởi hãng 20th Century Studios.',
    'AVAILABLE'
),

-- 14. Kế Hoạch "Chữa Lành" Của Kẻ Sát Nhân
(
    N'Kế Hoạch "Chữa Lành" Của Kẻ Sát Nhân',
    (SELECT id FROM authors WHERE name = N'Cương Tuyết Âm'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Thanh Niên'),
    2022, N'Tiếng Việt', 5, 5,
    'assets/images/uploads/ke_sat_nhan_chua_lanh.jpg',
    N'Tiểu thuyết trinh thám – thiên tài phá án, kẻ sát nhân với kế hoạch "chữa lành" bí ẩn. Vũ Phương dịch.',
    'AVAILABLE'
),

-- 15. Ghi Chép Pháp Y – Những Thi Thể Không Hoàn Chỉnh
(
    N'Ghi Chép Pháp Y: Những Thi Thể Không Hoàn Chỉnh',
    (SELECT id FROM authors WHERE name = N'Lưu Bát Bách'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Thanh Niên'),
    2021, N'Tiếng Việt', 5, 5,
    'assets/images/uploads/ghi_chep_phap_y_1.jpg',
    N'Series Ghi Chép Pháp Y – tập 1: những thi thể không hoàn chỉnh và những bí ẩn pháp y. Linh Tử dịch.',
    'AVAILABLE'
),

-- 16. Thú Tội
(
    N'Thú Tội',
    (SELECT id FROM authors WHERE name = N'Minato Kanae'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Hội Nhà Văn'),
    2015, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/thu_toi.jpg',
    N'Tiểu thuyết tâm lý tội phạm của Minato Kanae – đã được chuyển thể thành phim. Trần Quỳnh Anh dịch.',
    'AVAILABLE'
),

-- 17. Sự Im Lặng Của Bầy Cừu
(
    N'Sự Im Lặng Của Bầy Cừu',
    (SELECT id FROM authors WHERE name = N'Thomas Harris'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Hội Nhà Văn'),
    2016, N'Tiếng Việt', 5, 5,
    'assets/images/uploads/su_im_lang_cua_bay_cuu.jpg',
    N'Kiệt tác trinh thám tâm lý của Thomas Harris – cơ sở của bộ phim "The Silence of the Lambs" đoạt giải Oscar.',
    'AVAILABLE'
),

-- 18. Án Mạng Trên Chuyến Tàu Tốc Hành Phương Đông
(
    N'Án Mạng Trên Chuyến Tàu Tốc Hành Phương Đông',
    (SELECT id FROM authors WHERE name = N'Agatha Christie'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Trẻ'),
    2017, N'Tiếng Việt', 7, 7,
    'assets/images/uploads/an_mang_chuyen_tau_phuong_dong.jpg',
    N'Murder on the Orient Express – chuyển thể thành phim bởi hãng Twentieth Century Fox. Tuấn Việt dịch, in lần thứ 2.',
    'AVAILABLE'
),

-- 19. Ghi Chép Pháp Y – Khi Tử Thi Biết Nói (tập 2)
(
    N'Ghi Chép Pháp Y: Khi Tử Thi Biết Nói (Tập 2)',
    (SELECT id FROM authors WHERE name = N'Liêu Tiểu Đao'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Thanh Niên'),
    2022, N'Tiếng Việt', 5, 5,
    'assets/images/uploads/ghi_chep_phap_y_2.jpg',
    N'Series Ghi Chép Pháp Y – tập 2: khi tử thi biết nói. Linh Tú dịch.',
    'AVAILABLE'
),

-- 20. Ghi Chép Pháp Y – Những Cái Chết Bí Ẩn
(
    N'Ghi Chép Pháp Y: Những Cái Chết Bí Ẩn',
    (SELECT id FROM authors WHERE name = N'Lưu Hiểu Huy'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Thanh Niên'),
    2022, N'Tiếng Việt', 5, 5,
    'assets/images/uploads/ghi_chep_phap_y_3.jpg',
    N'Series Ghi Chép Pháp Y – những cái chết bí ẩn và hành trình điều tra. Bùi Thanh Thúy dịch.',
    'AVAILABLE'
),

-- 21. Phía Sau Nghi Can
(
    N'Phía Sau Nghi Can',
    (SELECT id FROM authors WHERE name = N'Higashino Keigo'),
    (SELECT id FROM categories WHERE name = N'Trinh thám'),
    (SELECT id FROM publishers WHERE name = N'NXB Hội Nhà Văn'),
    2014, N'Tiếng Việt', 6, 6,
    'assets/images/uploads/phia_sau_nghi_can.jpg',
    N'Tiểu thuyết trinh thám Nhật Bản của Higashino Keigo – The International Bestseller.',
    'AVAILABLE'
),

-- 22. Hạt Giống Tâm Hồn 3 – Từ Những Điều Bình Dị
(
    N'Hạt Giống Tâm Hồn 3: Từ Những Điều Bình Dị',
    (SELECT id FROM authors WHERE name = N'Nhiều tác giả'),
    (SELECT id FROM categories WHERE name = N'Kỹ năng sống'),
    (SELECT id FROM publishers WHERE name = N'NXB Tổng Hợp TP.HCM'),
    2010, N'Tiếng Việt', 8, 8,
    'assets/images/uploads/hat_giong_tam_hon_3.jpg',
    N'Tập 3 series Hạt Giống Tâm Hồn – những câu chuyện truyền cảm hứng từ những điều bình dị. First News tổng hợp.',
    'AVAILABLE'
),

-- 23. Tuổi Trẻ Đáng Giá Bao Nhiêu?
(
    N'Tuổi Trẻ Đáng Giá Bao Nhiêu?',
    (SELECT id FROM authors WHERE name = N'Rosie Nguyễn'),
    (SELECT id FROM categories WHERE name = N'Kỹ năng sống'),
    (SELECT id FROM publishers WHERE name = N'NXB Hội Nhà Văn'),
    2017, N'Tiếng Việt', 10, 10,
    'assets/images/uploads/tuoi_tre_dang_gia_bao_nhieu.jpg',
    N'Cuốn sách truyền động lực cho giới trẻ của tác giả Rosie Nguyễn.',
    'AVAILABLE'
);
