-- =============================================================
-- Gộp bản ghi NXB trùng (tên lỗi ? + tên đúng) — chạy một lần
-- SmartLibraryDB / SQL Server
-- =============================================================
USE SmartLibraryDB;
GO

-- NXB H?i Nhà Van  ->  NXB Hội Nhà Văn
DECLARE @bad_hoi BIGINT = (SELECT TOP 1 id FROM dbo.publishers WHERE name = N'NXB H?i Nhà Van');
DECLARE @ok_hoi  BIGINT = (SELECT TOP 1 id FROM dbo.publishers WHERE name = N'NXB Hội Nhà Văn');
IF @bad_hoi IS NOT NULL AND @ok_hoi IS NOT NULL AND @bad_hoi <> @ok_hoi
BEGIN
    UPDATE dbo.books SET publisher_id = @ok_hoi WHERE publisher_id = @bad_hoi;
    DELETE FROM dbo.publishers WHERE id = @bad_hoi;
    PRINT N'Merged: NXB H?i Nhà Van -> NXB Hội Nhà Văn';
END

-- NXB Ph? N?  ->  NXB Phụ Nữ (nếu có bản đúng)
DECLARE @bad_pn BIGINT = (SELECT TOP 1 id FROM dbo.publishers WHERE name = N'NXB Ph? N?');
DECLARE @ok_pn  BIGINT = (SELECT TOP 1 id FROM dbo.publishers WHERE name = N'NXB Phụ Nữ');
IF @bad_pn IS NOT NULL AND @ok_pn IS NOT NULL AND @bad_pn <> @ok_pn
BEGIN
    UPDATE dbo.books SET publisher_id = @ok_pn WHERE publisher_id = @bad_pn;
    DELETE FROM dbo.publishers WHERE id = @bad_pn;
    PRINT N'Merged: NXB Ph? N? -> NXB Phụ Nữ';
END
ELSE IF @bad_pn IS NOT NULL AND @ok_pn IS NULL
BEGIN
    UPDATE dbo.publishers SET name = N'NXB Phụ Nữ' WHERE id = @bad_pn;
    PRINT N'Renamed: NXB Ph? N? -> NXB Phụ Nữ (no duplicate row)';
END
GO

PRINT N'Done publishers_merge_duplicates.';
GO
