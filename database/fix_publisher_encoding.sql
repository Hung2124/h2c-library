-- =============================================================
-- H2C LIBRARY – Fix publisher Vietnamese encoding
-- Chạy trong SQL Server Management Studio hoặc SQLCMD
-- =============================================================
USE SmartLibraryDB;
GO

-- Bước 1: Xóa tất cả publishers đang bị sai encoding (chứa ? hoặc corrupt)
DELETE FROM publishers;

-- Bước 2: Re-insert đúng giá trị với N'' prefix (UTF-16 / NVARCHAR)
INSERT INTO publishers (name, note) VALUES
(N'Addison-Wesley',    N'Nhà xuất bản sách CNTT uy tín'),
(N'Prentice Hall',     N'Sách giáo khoa và khoa học máy tính'),
(N'NXB Giáo Dục',     N'Nhà xuất bản truyền thống Việt Nam'),
(N'NXB Kim Đồng',     N'Chuyên sách truyện dành cho thiếu nhi'),
(N'McGraw-Hill',       N'Nhà xuất bản giáo dục toàn cầu'),
(N'NXB Trẻ',          N'Nhà xuất bản lớn tại Việt Nam cho thanh niên'),
(N'Bantam Books',      N'Sách khoa học viễn tưởng và đại chúng');

-- Bước 3: Cập nhật publisher_id trong books (dựa vào name matching)
;WITH PubMap AS (
    SELECT id, name FROM publishers
)
UPDATE b
SET b.publisher_id = p.id
FROM books b
INNER JOIN PubMap p ON b.publisher = p.name
WHERE b.publisher IS NOT NULL
  AND LTRIM(RTRIM(b.publisher)) <> ''
  AND b.publisher_id IS NULL;

PRINT N'DONE: publishers re-inserted and books.publisher_id updated.';
GO
