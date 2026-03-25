-- Lỗi log: Hibernate chạy "ADD renewal_count int not null" (không DEFAULT) → SQL Server từ chối khi bảng đã có dòng.
-- Chạy một lần trong SSMS (đổi USE nếu tên DB khác).

USE SmartLibraryDB;
GO

IF COL_LENGTH('borrow_request_details', 'renewal_count') IS NULL
    ALTER TABLE dbo.borrow_request_details ADD renewal_count INT NOT NULL DEFAULT 0;
GO

IF COL_LENGTH('borrow_request_details', 'overdue_email_sent_at') IS NULL
    ALTER TABLE dbo.borrow_request_details ADD overdue_email_sent_at DATETIME2 NULL;
GO
