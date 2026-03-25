-- H2C LIBRARY – migration for plan v2 (run against SmartLibraryDB)
USE SmartLibraryDB;
GO

-- Site settings (footer, renew max, mail flags)
IF OBJECT_ID('site_settings', 'U') IS NULL
BEGIN
    CREATE TABLE site_settings (
        setting_key   NVARCHAR(100) NOT NULL PRIMARY KEY,
        setting_value NVARCHAR(MAX) NULL
    );
    INSERT INTO site_settings (setting_key, setting_value) VALUES
    (N'footer_line1', N'H2C LIBRARY'),
    (N'footer_line2', N'PRJ301 Project'),
    (N'footer_show_year', N'true'),
    (N'max_borrow_renewals', N'2'),
    (N'renew_extend_days', N'14'),
    (N'mail_enabled', N'false');
END
GO

-- Password reset
IF COL_LENGTH('users', 'password_reset_token') IS NULL
    ALTER TABLE users ADD password_reset_token NVARCHAR(100) NULL;
IF COL_LENGTH('users', 'password_reset_expires') IS NULL
    ALTER TABLE users ADD password_reset_expires DATETIME2 NULL;
GO

-- Borrow detail: renew + overdue email
IF COL_LENGTH('borrow_request_details', 'renewal_count') IS NULL
    ALTER TABLE borrow_request_details ADD renewal_count INT NOT NULL DEFAULT 0;
IF COL_LENGTH('borrow_request_details', 'overdue_email_sent_at') IS NULL
    ALTER TABLE borrow_request_details ADD overdue_email_sent_at DATETIME2 NULL;
GO

-- Publishers
IF OBJECT_ID('publishers', 'U') IS NULL
BEGIN
    CREATE TABLE publishers (
        id   BIGINT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(200) NOT NULL UNIQUE,
        note NVARCHAR(MAX) NULL
    );
END
GO

-- Link books to publishers
IF COL_LENGTH('books', 'publisher_id') IS NULL
BEGIN
    ALTER TABLE books ADD publisher_id BIGINT NULL;
    ALTER TABLE books ADD CONSTRAINT FK_books_publishers
        FOREIGN KEY (publisher_id) REFERENCES publishers(id);
END
GO

-- Migrate distinct publisher names into publishers + publisher_id
INSERT INTO publishers (name)
SELECT DISTINCT LTRIM(RTRIM(publisher))
FROM books
WHERE publisher IS NOT NULL AND LTRIM(RTRIM(publisher)) <> ''
  AND NOT EXISTS (SELECT 1 FROM publishers pub WHERE pub.name = LTRIM(RTRIM(books.publisher)));

UPDATE b
SET b.publisher_id = p.id
FROM books b
INNER JOIN publishers p ON LTRIM(RTRIM(b.publisher)) = p.name
WHERE b.publisher IS NOT NULL AND b.publisher_id IS NULL;
GO

-- Book reviews
IF OBJECT_ID('book_reviews', 'U') IS NULL
BEGIN
    CREATE TABLE book_reviews (
        id         BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id    BIGINT NOT NULL REFERENCES users(id),
        book_id    BIGINT NOT NULL REFERENCES books(id),
        rating     INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
        comment    NVARCHAR(MAX) NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT UQ_book_reviews_user_book UNIQUE (user_id, book_id)
    );
END
GO

-- User favorites
IF OBJECT_ID('user_favorites', 'U') IS NULL
BEGIN
    CREATE TABLE user_favorites (
        id         BIGINT IDENTITY(1,1) PRIMARY KEY,
        user_id    BIGINT NOT NULL REFERENCES users(id),
        book_id    BIGINT NOT NULL REFERENCES books(id),
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT UQ_user_favorites_user_book UNIQUE (user_id, book_id)
    );
END
GO
