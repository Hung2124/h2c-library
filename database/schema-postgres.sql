-- =============================================================
-- Smart Library — PostgreSQL Schema
-- Dùng cho: Railway, Render, Docker, local PostgreSQL
-- =============================================================

-- Tạo database (chạy riêng nếu cần)
-- CREATE DATABASE smartlibrary;

-- =============================================================
-- Table: users
-- =============================================================
CREATE TABLE IF NOT EXISTS users (
    id                       BIGSERIAL PRIMARY KEY,
    full_name                VARCHAR(150) NOT NULL,
    email                    VARCHAR(200) NOT NULL UNIQUE,
    password                 VARCHAR(255) NOT NULL,
    role                     VARCHAR(20)  NOT NULL DEFAULT 'MEMBER'
                                 CHECK (role IN ('MEMBER', 'ADMIN', 'LIBRARIAN')),
    status                   VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
                                 CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at               TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    password_reset_token     VARCHAR(100),
    password_reset_expires   TIMESTAMP
);

-- =============================================================
-- Table: categories
-- =============================================================
CREATE TABLE IF NOT EXISTS categories (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    description TEXT
);

-- =============================================================
-- Table: authors
-- =============================================================
CREATE TABLE IF NOT EXISTS authors (
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    bio  TEXT
);

-- =============================================================
-- Table: publishers
-- =============================================================
CREATE TABLE IF NOT EXISTS publishers (
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    note TEXT
);

-- =============================================================
-- Table: books
-- =============================================================
CREATE TABLE IF NOT EXISTS books (
    id                 BIGSERIAL PRIMARY KEY,
    title              VARCHAR(300) NOT NULL,
    author_id          BIGINT REFERENCES authors(id),
    category_id        BIGINT REFERENCES categories(id),
    publisher_id       BIGINT REFERENCES publishers(id),
    publish_year       INT,
    language           VARCHAR(50),
    quantity           INT NOT NULL DEFAULT 0,
    available_quantity INT NOT NULL DEFAULT 0,
    image              VARCHAR(500),
    description        TEXT,
    status             VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
                            CHECK (status IN ('AVAILABLE', 'UNAVAILABLE')),
    created_at         TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- Table: borrow_requests
-- =============================================================
CREATE TABLE IF NOT EXISTS borrow_requests (
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT NOT NULL REFERENCES users(id),
    request_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status        VARCHAR(20) NOT NULL DEFAULT 'PENDING'
                      CHECK (status IN ('PENDING','APPROVED','REJECTED','RETURNED')),
    approved_by   BIGINT REFERENCES users(id),
    approved_date TIMESTAMP
);

-- =============================================================
-- Table: borrow_request_details
-- =============================================================
CREATE TABLE IF NOT EXISTS borrow_request_details (
    id                    BIGSERIAL PRIMARY KEY,
    request_id            BIGINT NOT NULL REFERENCES borrow_requests(id),
    book_id               BIGINT NOT NULL REFERENCES books(id),
    quantity              INT    NOT NULL DEFAULT 1,
    due_date              DATE,
    return_date           DATE,
    fine_amount           DECIMAL(10,2) DEFAULT 0.00,
    renewal_count         INT    NOT NULL DEFAULT 0,
    overdue_email_sent_at TIMESTAMP,
    status                VARCHAR(20) NOT NULL DEFAULT 'BORROWING'
                             CHECK (status IN ('BORROWING','RETURNED','OVERDUE'))
);

-- =============================================================
-- Table: book_reviews
-- =============================================================
CREATE TABLE IF NOT EXISTS book_reviews (
    id         BIGSERIAL PRIMARY KEY,
    book_id    BIGINT NOT NULL REFERENCES books(id),
    user_id    BIGINT NOT NULL REFERENCES users(id),
    rating     INT    NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment    TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_book_review UNIQUE (user_id, book_id)
);

-- =============================================================
-- Table: user_favorites
-- =============================================================
CREATE TABLE IF NOT EXISTS user_favorites (
    id         BIGSERIAL PRIMARY KEY,
    user_id    BIGINT NOT NULL REFERENCES users(id),
    book_id    BIGINT NOT NULL REFERENCES books(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_book_favorite UNIQUE (user_id, book_id)
);

-- =============================================================
-- Table: site_settings
-- =============================================================
CREATE TABLE IF NOT EXISTS site_settings (
    id    BIGSERIAL PRIMARY KEY,
    key   VARCHAR(100) NOT NULL UNIQUE,
    value TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================
-- Sample Data
-- =============================================================

-- Admin (password: 123456 — BCrypt hash)
INSERT INTO users (full_name, email, password, role, status)
VALUES ('Administrator', 'admin@library.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMye9TjBgKAHqPZv9xNLaS.ZH5qMFXHKK6y',
        'ADMIN', 'ACTIVE')
ON CONFLICT (email) DO NOTHING;

-- Sample member (password: 123456)
INSERT INTO users (full_name, email, password, role, status)
VALUES ('Nguyen Van A', 'member@library.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMye9TjBgKAHqPZv9xNLaS.ZH5qMFXHKK6y',
        'MEMBER', 'ACTIVE')
ON CONFLICT (email) DO NOTHING;

-- Categories
INSERT INTO categories (name, description) VALUES
    (N'Lập trình', N'Sách về lập trình và công nghệ'),
    (N'Văn học', N'Tiểu thuyết, truyện ngắn, thơ'),
    (N'Kinh tế', N'Quản trị, tài chính, marketing'),
    (N'Khoa học', N'Vật lý, hóa học, sinh học'),
    (N'Lịch sử', N'Lịch sử Việt Nam và thế giới')
ON CONFLICT DO NOTHING;

-- Authors
INSERT INTO authors (name, bio) VALUES
    (N'James Gosling', N'Cha đẻ của ngôn ngữ Java'),
    (N'Robert C. Martin', N'Tác giả Clean Code, chuyên gia phần mềm'),
    (N'Nam Cao', N'Nhà văn Việt Nam nổi tiếng'),
    (N'Tô Hoài', N'Nhà văn Việt Nam, tác giả Dế Mèn Phiêu Lưu Ký'),
    (N'Joshua Bloch', N'Kỹ sư Google, tác giả Effective Java'),
    (N'Ngô Tất Tố', N'Nhà văn nổi tiếng của Việt Nam thời kỳ trước 1945'),
    (N'Stephen Hawking', N'Nhà vật lý lý thuyết vĩ đại của thế kỷ 21'),
    (N'Philip Kotler', N'Cha đẻ của Marketing hiện đại'),
    (N'Nguyễn Nhật Ánh', N'Nhà văn chuyên viết truyện tuổi thơ đầy cảm xúc'),
    (N'Charles Darwin', N'Nhà sinh vật học với thuyết tiến hóa')
ON CONFLICT DO NOTHING;

-- Publishers
INSERT INTO publishers (name, note) VALUES
    (N'Addison-Wesley', N'Nhà xuất bản sách CNTT uy tín'),
    (N'Prentice Hall', N'Sách giáo khoa và khoa học máy tính'),
    (N'NXB Giáo Dục', N'Nhà xuất bản truyền thống Việt Nam'),
    (N'NXB Kim Đồng', N'Chuyên sách truyện dành cho thiếu nhi'),
    (N'McGraw-Hill', N'Nhà xuất bản giáo dục toàn cầu'),
    (N'NXB Trẻ', N'Nhà xuất bản lớn tại Việt Nam cho thanh niên'),
    (N'Bantam Books', N'Sách khoa học viễn tưởng và đại chúng')
ON CONFLICT (name) DO NOTHING;

-- Books
INSERT INTO books (title, author_id, category_id, publisher_id, publish_year, language, quantity, available_quantity, image, description, status) VALUES
    (N'Effective Java', 5, 1, 1, 2018, 'English', 5, 5, 'assets/images/books/effective_java.png', 'Best practices for Java programming language', 'AVAILABLE'),
    (N'Clean Code', 2, 1, 2, 2008, 'English', 3, 3, 'assets/images/books/clean_code.png', 'A Handbook of Agile Software Craftsmanship', 'AVAILABLE'),
    (N'Chí Phèo', 3, 2, 3, 2010, 'Tiếng Việt', 8, 8, 'assets/images/books/chi_pheo.png', 'Tác phẩm kinh điển của Nam Cao', 'AVAILABLE'),
    (N'Dế Mèn Phiêu Lưu Ký', 4, 2, 4, 2015, 'Tiếng Việt', 10, 10, 'assets/images/books/de_men_phieu_luu_ky.png', 'Câu chuyện phiêu lưu của chú dế mèn', 'AVAILABLE'),
    (N'Java: The Complete Reference', 1, 1, 5, 2021, 'English', 4, 4, 'assets/images/books/java_complete_reference.png', 'Comprehensive Java programming reference', 'AVAILABLE'),
    (N'Tắt Đèn', 6, 2, 3, 2009, 'Tiếng Việt', 7, 7, 'assets/images/books/literature_cover.png', 'Tác phẩm hiện thực phê phán', 'AVAILABLE'),
    (N'Lược Sử Thời Gian', 7, 4, 7, 2017, 'Tiếng Việt', 5, 5, 'assets/images/books/science_cover.png', 'Cuốn sách vật lý đại chúng vĩ đại', 'AVAILABLE'),
    (N'Marketing Management', 8, 3, 2, 2015, 'English', 6, 6, 'assets/images/books/economics_cover.png', 'Sách gối đầu giường của dân marketing', 'AVAILABLE'),
    (N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh', 9, 2, 6, 2010, 'Tiếng Việt', 12, 12, 'assets/images/books/literature_cover.png', 'Truyện về tình cảm hồn nhiên', 'AVAILABLE'),
    (N'Nguồn Gốc Các Loài', 10, 4, 7, 2012, 'Tiếng Việt', 4, 4, 'assets/images/books/science_cover.png', 'Thuyết tiến hóa làm thay đổi văn minh nhân loại', 'AVAILABLE'),
    (N'Head First Java', 1, 1, 6, 2005, 'English', 10, 10, 'assets/images/books/programming_cover.png', 'Học Java qua sơ đồ tư duy', 'AVAILABLE'),
    (N'Mắt Biếc', 9, 2, 6, 1990, 'Tiếng Việt', 15, 15, 'assets/images/books/literature_cover.png', 'Chuyện tình buồn vượt thời gian', 'AVAILABLE'),
    (N'Clean Architecture', 2, 1, 2, 2017, 'English', 8, 8, 'assets/images/books/programming_cover.png', 'Kiến trúc phần mềm sạch', 'AVAILABLE'),
    (N'Nguyên Lý Khởi Nghiệp Đoạn Trường', 8, 3, 5, 2020, 'Tiếng Việt', 6, 6, 'assets/images/books/economics_cover.png', 'Sách hay về khởi nghiệp', 'AVAILABLE'),
    (N'Lịch Sử Việt Nam - Cổ Đại', 6, 5, 3, 2005, 'Tiếng Việt', 5, 5, 'assets/images/books/history_cover.png', 'Tìm hiểu lịch sử nước nhà', 'AVAILABLE'),
    (N'Đại Số Tuyến Tính', 7, 4, 3, 2010, 'Tiếng Việt', 10, 10, 'assets/images/books/science_cover.png', 'Giáo trình đại học Đại số', 'AVAILABLE'),
    (N'Tài Chính Doanh Nghiệp', 8, 3, 2, 2018, 'English', 4, 4, 'assets/images/books/economics_cover.png', 'Corporate finance in details', 'AVAILABLE'),
    (N'Lập trình Web với Java', 5, 1, 1, 2023, 'Tiếng Việt', 9, 9, 'assets/images/books/programming_cover.png', 'Cẩm nang trở thành Java Web Developer', 'AVAILABLE'),
    (N'Kính Vạn Hoa', 9, 2, 4, 1995, 'Tiếng Việt', 20, 20, 'assets/images/books/literature_cover.png', 'Bộ truyện teen huyền thoại', 'AVAILABLE'),
    (N'Thế Giới Lượng Tử', 7, 4, 7, 2021, 'Tiếng Việt', 7, 7, 'assets/images/books/science_cover.png', 'Cái nhìn sâu hơn về vật lý lượng tử', 'AVAILABLE'),
    (N'Kinh Tế Vĩ Mô', 8, 3, 5, 2013, 'English', 3, 3, 'assets/images/books/economics_cover.png', 'Sách giáo khoa kinh tế vĩ mô', 'AVAILABLE'),
    (N'Sapiens Lược Sử Loài Người', 10, 5, 6, 2014, 'Tiếng Việt', 11, 11, 'assets/images/books/history_cover.png', 'Tóm lược lịch sử phát triển loài người', 'AVAILABLE'),
    (N'Đất Rừng Phương Nam', 4, 2, 4, 2002, 'Tiếng Việt', 5, 5, 'assets/images/books/literature_cover.png', 'Văn học vùng tự nhiên hoang sơ', 'AVAILABLE'),
    (N'Cơ Sở Dữ Liệu SQL Server', 1, 1, 3, 2019, 'Tiếng Việt', 6, 6, 'assets/images/books/programming_cover.png', 'Thực hành SQL Server 2019', 'AVAILABLE'),
    (N'Chiến Tranh Và Hòa Bình', 3, 5, 7, 2005, 'Tiếng Việt', 2, 2, 'assets/images/books/history_cover.png', 'Bản dịch tiếng việt tác phẩm kinh điển', 'AVAILABLE')
ON CONFLICT DO NOTHING;
