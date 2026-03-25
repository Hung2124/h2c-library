-- Script thêm 29 sách từ thư mục ảnh vào Database
USE SmartLibraryDB;
GO

-- 1. Thêm Category 'Thiếu nhi / Cổ tích' nếu chưa có
IF NOT EXISTS (SELECT 1 FROM categories WHERE name = N'Thiếu nhi')
BEGIN
    INSERT INTO categories (name, description) VALUES (N'Thiếu nhi', N'Truyện cổ tích, truyện tranh, sách thiếu nhi');
END
GO

-- 2. Đảm bảo tất cả tác giả tồn tại
DECLARE @authors TABLE (name NVARCHAR(200));
INSERT INTO @authors (name) VALUES 
(N'Dân Gian'), (N'Nguyễn Văn Bổng'), (N'Nguyễn Minh Châu'), (N'Nguyên Hồng'), (N'Bà Tùng Long'), 
(N'Vũ Trọng Phụng'), (N'Hồng Hà'), (N'Nguyễn Mạnh Thái'), (N'Linh Nhi'), (N'Hồng Hoa'), (N'Hiếu Minh');

INSERT INTO authors (name, bio)
SELECT DISTINCT name, N'Tác giả Việt Nam' FROM @authors a
WHERE NOT EXISTS (SELECT 1 FROM authors WHERE name = a.name);
GO

-- 3. Đảm bảo tất cả nhà xuất bản tồn tại
DECLARE @publishers TABLE (name NVARCHAR(200));
INSERT INTO @publishers (name) VALUES 
(N'NXB Văn Hóa Thông Tin'), (N'CTG'), (N'ISACH'), (N'NXB Văn Học'), (N'NXB Hà Nội'), 
(N'NXB Mỹ Thuật'), (N'NXB Đồng Nai');

INSERT INTO publishers (name, note)
SELECT DISTINCT name, N'Nhà xuất bản' FROM @publishers p
WHERE NOT EXISTS (SELECT 1 FROM publishers WHERE name = p.name);
GO

-- 4. Định nghĩa và thêm 29 sách
-- Note: Những sách văn học sử dụng N'Văn học', truyện cổ tích sử dụng N'Thiếu nhi'

-- Function: insertBook
CREATE PROCEDURE #InsertBook
    @Title NVARCHAR(300),
    @AuthorName NVARCHAR(200),
    @CatName NVARCHAR(150),
    @PubName NVARCHAR(200),
    @Image NVARCHAR(500)
AS
BEGIN
    DECLARE @A_ID BIGINT = (SELECT TOP 1 id FROM authors WHERE name = @AuthorName);
    DECLARE @C_ID BIGINT = (SELECT TOP 1 id FROM categories WHERE name = @CatName);
    DECLARE @P_ID BIGINT = (SELECT TOP 1 id FROM publishers WHERE name = @PubName);

    IF NOT EXISTS (SELECT 1 FROM books WHERE title = @Title)
    BEGIN
        INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status)
        VALUES (@Title, @A_ID, @C_ID, @P_ID, 2020, N'Tiếng Việt', 10, 10, @Image, N'Sách mới thêm', 'AVAILABLE');
    END
END
GO

-- Thực thi thêm sách
EXEC #InsertBook N'Cây Tre Trăm Đốt', N'Dân Gian', N'Thiếu nhi', N'NXB Văn Hóa Thông Tin', 'assets/images/books/cay_tre_tram_dot.jpg';
EXEC #InsertBook N'Áo Trắng', N'Nguyễn Văn Bổng', N'Văn học', N'NXB Trẻ', 'assets/images/books/ao_trang.jpg';
EXEC #InsertBook N'Vợ Chồng A Phủ', N'Tô Hoài', N'Văn học', N'CTG', 'assets/images/books/vo_chong_a_phu.jpg';
EXEC #InsertBook N'Sự Tích Con Dã Tràng', N'Dân Gian', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/su_tich_con_da_trang.jpg';
EXEC #InsertBook N'Sự Tích Tháp Báo Ân', N'Dân Gian', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/su_tich_thap_bao_an.jpg';
EXEC #InsertBook N'Chiếc Thuyền Ngoài Xa', N'Nguyễn Minh Châu', N'Văn học', N'ISACH', 'assets/images/books/chiec_thuyen_ngoai_xa.jpg';
EXEC #InsertBook N'Những Ngày Thơ Ấu', N'Nguyên Hồng', N'Văn học', N'NXB Văn Học', 'assets/images/books/nhung_ngay_tho_au.jpg';
EXEC #InsertBook N'Ngỗng Đẻ Trứng Vàng', N'Dân Gian', N'Thiếu nhi', N'NXB Hà Nội', 'assets/images/books/ngong_de_trung_vang.jpg';
EXEC #InsertBook N'Chử Đồng Tử Tiên Dung', N'Dân Gian', N'Thiếu nhi', N'NXB Mỹ Thuật', 'assets/images/books/chu_dong_tu_tien_dung.jpg';
EXEC #InsertBook N'Sự Tích Bánh Chưng Bánh Giầy', N'Dân Gian', N'Thiếu nhi', N'NXB Mỹ Thuật', 'assets/images/books/su_tich_banh_chung_banh_giay.jpg';
EXEC #InsertBook N'Dế Mèn Phiêu Lưu Ký (Bản Hình Mới)', N'Tô Hoài', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/de_men_phieu_luu_ky_2.jpg';
EXEC #InsertBook N'Tình Yêu Và Thù Hận', N'Bà Tùng Long', N'Văn học', N'NXB Trẻ', 'assets/images/books/tinh_yeu_va_thu_han.jpg';
EXEC #InsertBook N'Nàng Tiên Cua', N'Hồng Hà', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/nang_tien_cua.jpg';
EXEC #InsertBook N'Sự Tích Trầu Cau', N'Hồng Hà', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/su_tich_trau_cau.jpg';
EXEC #InsertBook N'Thạch Sanh', N'Dân Gian', N'Thiếu nhi', N'NXB Văn Học', 'assets/images/books/thach_sanh.jpg';
EXEC #InsertBook N'Sơn Tinh Thủy Tinh', N'Dân Gian', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/son_tinh_thuy_tinh.jpg';
EXEC #InsertBook N'Sọ Dừa', N'Dân Gian', N'Thiếu nhi', N'NXB Mỹ Thuật', 'assets/images/books/so_dua.jpg';
EXEC #InsertBook N'Sự Tích Hồ Gươm', N'Nguyễn Mạnh Thái', N'Thiếu nhi', N'NXB Mỹ Thuật', 'assets/images/books/su_tich_ho_guom.jpg';
EXEC #InsertBook N'Sự Tích Hoa Cúc Trắng', N'Linh Nhi', N'Thiếu nhi', N'NXB Mỹ Thuật', 'assets/images/books/su_tich_hoa_cuc_trang.jpg';
EXEC #InsertBook N'Sự Tích Quả Dưa Hấu', N'Hồng Hoa', N'Thiếu nhi', N'NXB Văn Học', 'assets/images/books/su_tich_qua_dua_hau.jpg';
EXEC #InsertBook N'Ăn Khế Trả Vàng', N'Dân Gian', N'Thiếu nhi', N'NXB Đồng Nai', 'assets/images/books/an_khe_tra_vang.jpg';
EXEC #InsertBook N'Cậu Bé Tích Chu', N'Linh Nhi', N'Thiếu nhi', N'NXB Mỹ Thuật', 'assets/images/books/cau_be_tich_chu.jpg';
EXEC #InsertBook N'Con Cóc Là Cậu Ông Giời', N'Hiếu Minh', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/con_coc_la_cau_ong_gioi.jpg';
EXEC #InsertBook N'Sự Tích Chú Cuội Cung Trăng', N'Hồng Hà', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/su_tich_chu_cuoi.jpg';
EXEC #InsertBook N'Lão Hạc', N'Nam Cao', N'Văn học', N'NXB Văn Học', 'assets/images/books/lao_hac.jpg';
EXEC #InsertBook N'Tấm Cám', N'Nguyễn Mạnh Thái', N'Thiếu nhi', N'NXB Mỹ Thuật', 'assets/images/books/tam_cam.jpg';
EXEC #InsertBook N'Đời Thừa', N'Nam Cao', N'Văn học', N'NXB Văn Học', 'assets/images/books/doi_thua.jpg';
EXEC #InsertBook N'Trí Khôn Của Ta Đây', N'Dân Gian', N'Thiếu nhi', N'NXB Kim Đồng', 'assets/images/books/tri_khon_cua_ta_day.jpg';
EXEC #InsertBook N'Giông Tố', N'Vũ Trọng Phụng', N'Văn học', N'NXB Văn Học', 'assets/images/books/giong_to.jpg';
GO

DROP PROCEDURE #InsertBook;
GO
