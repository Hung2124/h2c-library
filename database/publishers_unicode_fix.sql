-- =============================================================
-- Sửa tên nhà xuất bản tiếng Việt (SQL Server)
-- Chạy khi tên hiển thị ký tự "?" thay cho dấu.
-- =============================================================
USE SmartLibraryDB;
GO

PRINT N'SmartLibraryDB: Bắt đầu sửa publishers...';
GO

-- ==============================================================
-- BƯỚC 1: Tìm và xóa unique constraint trên cột name
-- ==============================================================
DECLARE @uk_name NVARCHAR(128);
SELECT @uk_name = kc.name
FROM sys.key_constraints kc
INNER JOIN sys.tables t ON kc.parent_object_id = t.object_id
INNER JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id
INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
WHERE t.name = N'publishers' AND kc.type = N'UQ' AND c.name = N'name';

IF @uk_name IS NOT NULL
BEGIN
    DECLARE @sql0 NVARCHAR(200) = N'ALTER TABLE dbo.publishers DROP CONSTRAINT [' + @uk_name + '];';
    EXEC sp_executesql @sql0;
    PRINT N'Dropped constraint: ' + @uk_name;
END
ELSE
    PRINT N'Khong co unique constraint tren name.';
GO

-- ==============================================================
-- BƯỚC 2: Đổi cột name sang NVARCHAR
-- ==============================================================
IF EXISTS (
    SELECT 1 FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID(N'dbo.publishers') AND c.name = N'name'
      AND t.name IN (N'varchar', N'char')
)
BEGIN
    ALTER TABLE dbo.publishers ALTER COLUMN name NVARCHAR(200) NOT NULL;
    PRINT N'Altered publishers.name -> NVARCHAR(200)';
END
GO

-- ==============================================================
-- BƯỚC 3: Đổi cột note sang NVARCHAR
-- ==============================================================
IF EXISTS (
    SELECT 1 FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID(N'dbo.publishers') AND c.name = N'note'
      AND t.name IN (N'varchar', N'char', N'text')
)
BEGIN
    ALTER TABLE dbo.publishers ALTER COLUMN note NVARCHAR(MAX) NULL;
    PRINT N'Altered publishers.note -> NVARCHAR(MAX)';
END
GO

-- ==============================================================
-- BƯỚC 4: Tạo lại unique constraint
-- ==============================================================
IF NOT EXISTS (
    SELECT 1 FROM sys.key_constraints kc
    INNER JOIN sys.tables t ON kc.parent_object_id = t.object_id
    INNER JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id
    INNER JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
    WHERE t.name = N'publishers' AND kc.type = N'UQ' AND c.name = N'name'
)
BEGIN
    ALTER TABLE dbo.publishers ADD CONSTRAINT UK_publishers_name UNIQUE (name);
    PRINT N'Created UNIQUE constraint on publishers.name';
END
GO

-- ==============================================================
-- BƯỚC 5: Chuẩn hóa tên NXB bị sai mã hóa
-- ==============================================================
DECLARE @r NCHAR(1) = NCHAR(0xFFFD);

-- NXB Giáo Dục
UPDATE dbo.publishers SET name = N'NXB Giáo Dục'
WHERE CHARINDEX(N'Giáo', name) > 0 AND CHARINDEX(N'Dục', name) = 0 AND LEN(name) < 20;

-- NXB Kim Đồng
UPDATE dbo.publishers SET name = N'NXB Kim Đồng'
WHERE CHARINDEX(N'Kim', name) > 0 AND CHARINDEX(N'Đồng', name) = 0 AND LEN(name) < 20;

-- NXB Hội Nhà Văn
UPDATE dbo.publishers SET name = N'NXB Hội Nhà Văn'
WHERE CHARINDEX(N'Hội', name) > 0 AND CHARINDEX(N'Văn', name) > 0 AND LEN(name) < 25;

-- NXB Khoa học Xã hội
UPDATE dbo.publishers SET name = N'NXB Khoa học Xã hội'
WHERE CHARINDEX(N'Khoa', name) > 0 AND CHARINDEX(N'Xã', name) > 0 AND LEN(name) < 30;

-- NXB Phụ Nữ
UPDATE dbo.publishers SET name = N'NXB Phụ Nữ'
WHERE CHARINDEX(N'Phụ', name) > 0 AND CHARINDEX(N'Nữ', name) > 0 AND LEN(name) < 20;

-- NXB Tổng Hợp TP.HCM
UPDATE dbo.publishers SET name = N'NXB Tổng Hợp TP.HCM'
WHERE CHARINDEX(N'Tổng', name) > 0 AND CHARINDEX(N'Hợp', name) > 0 AND LEN(name) < 30;

-- NXB Thế Giới
UPDATE dbo.publishers SET name = N'NXB Thế Giới'
WHERE CHARINDEX(N'Thế', name) > 0 AND CHARINDEX(N'Giới', name) > 0 AND LEN(name) < 20;

-- NXB Trẻ
UPDATE dbo.publishers SET name = N'NXB Trẻ'
WHERE CHARINDEX(N'Trẻ', name) > 0 AND LEN(name) < 20;

-- NXB Văn học
UPDATE dbo.publishers SET name = N'NXB Văn học'
WHERE CHARINDEX(N'Văn', name) > 0 AND CHARINDEX(N'học', name) = 0 AND LEN(name) < 20;

-- Các dòng chứa ? (char 63) – thay bằng tên gần đúng
UPDATE dbo.publishers SET name = N'NXB Giáo Dục'
WHERE name LIKE N'%?%' AND CHARINDEX(N'Giáo', name) > 0;

UPDATE dbo.publishers SET name = N'NXB Kim Đồng'
WHERE name LIKE N'%?%' AND CHARINDEX(N'Kim', name) > 0;

UPDATE dbo.publishers SET name = N'NXB Thế Giới'
WHERE name LIKE N'%' + @r + N'%' AND CHARINDEX(N'Thế', name) > 0;

UPDATE dbo.publishers SET name = N'NXB Văn học'
WHERE (name LIKE N'%' + @r + N'%' OR name LIKE N'%?%')
  AND CHARINDEX(N'Văn', name) > 0;

-- Xóa những dòng còn ? hoặc U+FFFD mà không match được
DELETE FROM dbo.publishers
WHERE name LIKE N'%?%' OR name LIKE N'%' + @r + N'%';

-- Xóa trùng lặp (giữ dòng có id nhỏ nhất)
DELETE p FROM dbo.publishers p
WHERE EXISTS (
    SELECT 1 FROM dbo.publishers p2
    WHERE p2.name = p.name AND p2.id < p.id
);

-- BƯỚC 6: Thêm các NXB chuẩn nếu chưa có
IF NOT EXISTS (SELECT 1 FROM dbo.publishers WHERE name = N'NXB Giáo Dục')
    INSERT INTO dbo.publishers (name, note) VALUES (N'NXB Giáo Dục', N'Nhà xuất bản truyền thống Việt Nam');

IF NOT EXISTS (SELECT 1 FROM dbo.publishers WHERE name = N'NXB Kim Đồng')
    INSERT INTO dbo.publishers (name, note) VALUES (N'NXB Kim Đồng', N'Chuyên sách truyện dành cho thiếu nhi');

IF NOT EXISTS (SELECT 1 FROM dbo.publishers WHERE name = N'NXB Thế Giới')
    INSERT INTO dbo.publishers (name, note) VALUES (N'NXB Thế Giới', N'Nhà xuất bản Thế Giới Việt Nam');

IF NOT EXISTS (SELECT 1 FROM dbo.publishers WHERE name = N'NXB Văn học')
    INSERT INTO dbo.publishers (name, note) VALUES (N'NXB Văn học', N'Nhà xuất bản Văn học Việt Nam');

IF NOT EXISTS (SELECT 1 FROM dbo.publishers WHERE name = N'NXB Trẻ')
    INSERT INTO dbo.publishers (name, note) VALUES (N'NXB Trẻ', N'Nhà xuất bản lớn tại Việt Nam cho thanh niên');

IF NOT EXISTS (SELECT 1 FROM dbo.publishers WHERE name = N'NXB Hội Nhà Văn')
    INSERT INTO dbo.publishers (name, note) VALUES (N'NXB Hội Nhà Văn', N'Hội Nhà Văn Việt Nam');

PRINT N'DONE: publishers_unicode_fix xong.';
GO

-- Kiểm tra kết quả
SELECT id, name, note FROM dbo.publishers ORDER BY id;
GO
