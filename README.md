# Smart Library Management and Online Borrowing System

## 1. Project Overview

This project is a **Java Web application** built for **PRJ301**.

The system allows users to:
- Browse books
- Search and filter books
- View book details
- Add books to a borrow cart
- Submit borrowing requests
- Track borrowing history

Admins/Librarians can:
- Manage books, categories, authors, users
- Manage borrowing requests
- View system statistics

Although the project is in the library domain, it is designed with a structure similar to an **e-commerce website** so it can satisfy course requirements such as:

- Login / Register / Logout
- Home page loading data from database
- Search / Filter / Sort / Pagination
- Book detail and similar books
- CRUD management
- Statistics
- Borrow cart
- Advanced features: CKEditor, image upload, charts

---

## 2. Objectives

- Apply **PRJ301 technologies**: Servlet, JSP, JSTL, EL, MVC, Session, Filter, Listener, JDBC/JPA
- Build a full web application with both **user side** and **admin side**
- Keep the project realistic, easy to demo, and aligned with course requirements

---

## 3. Roles

### 3.1 Guest

- View home page
- Search books
- View book details
- View similar books

### 3.2 Member

- Register / Login / Logout
- Search, filter, sort books
- Add books to borrow cart
- Submit borrowing request
- View borrowing history
- View overdue books / fines

### 3.3 Admin / Librarian

- Manage books
- Manage categories
- Manage authors
- Manage users
- Approve or reject borrowing requests
- Confirm returned books
- View dashboard statistics

---

## 4. Main Features

### 4.1 Authentication

- Register
- Login
- Logout
- Session-based authentication

### 4.2 Home Page

Load data from database and display:

- New books
- Most borrowed books
- Featured books
- Books by category

### 4.3 Book Listing

- Search by title
- Filter by category, author, publish year, language, availability
- Sort by newest, title A–Z, most borrowed
- Pagination

### 4.4 Book Detail

- Display full book information
- Book image
- Description
- Available quantity
- Similar books

### 4.5 Borrow Cart

- Add book to borrow cart
- Remove book from borrow cart
- Update quantity
- Submit borrow request

### 4.6 Borrow Request Management

- User submits request
- Admin/Librarian approves or rejects
- Track due date, return date, fine amount

### 4.7 CRUD Management

- Book CRUD
- Category CRUD
- Author CRUD
- User CRUD

### 4.8 Statistics

- Total books
- Total users
- Borrowed books count
- Overdue books count
- Most borrowed books
- Borrow requests by month
- Max / Min / Avg borrowed quantity

### 4.9 Advanced Features

- CKEditor for book description
- Book image upload
- Chart dashboard (Chart.js)
- Similar books recommendation
- Optional AI feature: generate book summary / FAQ chatbot

---

## 5. Technologies

| Layer        | Technology              |
|-------------|-------------------------|
| Backend     | Java Servlet            |
| View        | JSP, JSTL, EL           |
| Architecture| MVC                     |
| Data        | JPA or JDBC             |
| Database    | SQL Server / MySQL      |
| Web         | Filter, Listener        |
| State       | Session / Cookie        |
| Frontend    | HTML / CSS / Bootstrap  |
| Script      | JavaScript, Chart.js    |
| Optional    | CKEditor / CKFinder     |

**Not used:** Spring Boot, React, Angular, Vue, or any frontend framework.

---

## 6. Suggested Project Structure

```
src/main/java/
├── controller/
│   ├── auth/
│   ├── book/
│   ├── cart/
│   ├── borrow/
│   └── admin/
├── model/
├── repository/   (or dao/)
├── service/
├── filter/
├── listener/
├── utils/
└── config/

src/main/webapp/
├── views/
│   ├── common/
│   ├── auth/
│   ├── book/
│   ├── cart/
│   ├── borrow/
│   └── admin/
├── assets/
│   ├── css/
│   ├── js/
│   └── images/
└── WEB-INF/
```

---

## 7. Database Design

### users

| Column      | Type         | Description     |
|------------|--------------|-----------------|
| id         | PK           |                 |
| full_name  | VARCHAR      |                 |
| email      | VARCHAR      |                 |
| password   | VARCHAR      |                 |
| role       | VARCHAR      | member / admin  |
| status     | VARCHAR      | active / inactive|
| created_at | DATETIME     |                 |

### categories

| Column     | Type    |
|-----------|--------|
| id        | PK     |
| name      | VARCHAR|
| description | TEXT  |

### authors

| Column | Type    |
|--------|--------|
| id     | PK     |
| name   | VARCHAR|
| bio    | TEXT   |

### books

| Column            | Type    |
|-------------------|--------|
| id                | PK     |
| title             | VARCHAR|
| author_id         | FK → authors |
| category_id       | FK → categories |
| publisher         | VARCHAR|
| publish_year      | INT    |
| language          | VARCHAR|
| quantity          | INT    |
| available_quantity| INT   |
| image             | VARCHAR|
| description       | TEXT   |
| status            | VARCHAR|
| created_at        | DATETIME |

### borrow_requests

| Column        | Type    |
|---------------|--------|
| id            | PK     |
| user_id       | FK → users |
| request_date  | DATETIME |
| status        | VARCHAR  |
| approved_by   | FK → users |
| approved_date | DATETIME |

### borrow_request_details

| Column      | Type    |
|-------------|--------|
| id          | PK     |
| request_id  | FK → borrow_requests |
| book_id     | FK → books |
| quantity    | INT    |
| due_date    | DATE   |
| return_date | DATE   |
| fine_amount | DECIMAL|
| status      | VARCHAR|

---

## 8. Mapping to PRJ301 Topics

| Topic    | Usage in project                                      |
|----------|--------------------------------------------------------|
| Servlet  | Controllers to handle requests and responses           |
| JSP      | Build UI pages                                        |
| JSTL/EL  | Display dynamic data, loops, conditions, messages    |
| MVC      | Separate Model, View, Controller                       |
| Session  | Logged-in user, borrow cart                            |
| Filter   | Authentication, authorization, encoding                |
| Listener | Active sessions, log events, init counters            |
| JPA/JDBC | Database interaction layer                             |

---

## 9. Suggested Development Phases

| Phase | Content |
|-------|---------|
| **Phase 1** | Project structure, database, authentication |
| **Phase 2** | Home page, book listing, search/filter/sort/pagination, book detail |
| **Phase 3** | Borrow cart, borrow request flow |
| **Phase 4** | Admin CRUD, request approval, return confirmation |
| **Phase 5** | Statistics dashboard, advanced features (CKEditor, charts, image upload) |

---

## 10. Optional AI Features

Choose **only one** small feature so the system still focuses on PRJ301:

- Generate short book description
- FAQ chatbot for library rules
- Recommend similar books

---

## 11. Expected Outcome

The final project should be a working Java Web application that demonstrates:

- Complete authentication flow
- Dynamic data loading from database
- Search, filter, sort, pagination
- Borrow cart and borrowing workflow
- CRUD management
- Statistics dashboard
- Clear application of PRJ301 technologies

---

## 12. Cursor Prompts

### 12.1 Initial prompt (project setup)

Use this **once** to get structure and plan:

```
I want to build a PRJ301 final project using Java Web technologies only.

Project title: Smart Library Management and Online Borrowing System

Important requirements:
- Use Java Servlet, JSP, JSTL, EL
- Use MVC architecture
- Use Session for authentication and borrow cart
- Use Filter for authentication/authorization
- Use Listener for session or application events
- Use JPA or JDBC for database access
- Do NOT use Spring Boot
- Do NOT use React, Angular, Vue, or any frontend framework
- Keep the code structure simple, clean, and suitable for a university PRJ301 project

Project idea:
This is a library management system designed like a mini e-commerce website.
Users can browse books, search/filter/sort/paginate books, view book details, add books to a borrow cart, and submit borrowing requests.
Admins/librarians can manage books, categories, authors, users, borrowing requests, and statistics.

Roles:
1. Guest – View home, search books, view book details, view similar books
2. Member – Register/Login/Logout, search/filter/sort/paginate, borrow cart, submit request, borrowing history
3. Admin/Librarian – Manage books/categories/authors/users, approve/reject requests, confirm returns, dashboard statistics

Main features: Authentication, Home page, Book listing, Book detail, Borrow cart, Admin CRUD, Borrow request management, Statistics.

Advanced: CKEditor, Chart.js, image upload, optional small AI feature later.

Please help me step by step. First generate:
1. Full recommended project structure (folders and packages)
2. Database schema design
3. Entity/model list
4. MVC flow explanation
5. Suggested servlet list
6. Suggested JSP page list
7. Filter and Listener design
8. Development roadmap by modules

Do not generate the entire project at once. I want to build it module by module in a clean and maintainable way.
```

### 12.2 Module-by-module prompts

**1. Database**

```
Based on the Smart Library Management and Online Borrowing System project, generate SQL schema for:
- users, categories, authors, books, borrow_requests, borrow_request_details, reviews (optional)

Requirements:
- Primary keys, foreign keys, suitable data types
- Simple schema suitable for PRJ301
- Sample constraints for status and role if appropriate
- Compatible with SQL Server
- After generating schema, explain table relationships clearly
```

**2. Authentication**

```
Create the authentication module for a Java Web MVC project using Servlet, JSP, JSTL, EL, and Session.

Requirements: Register, Login, Logout, store logged-in user in session, DAO/repository layer, JSP views, PRJ301 structure, no Spring Security. Include servlets, model/dao methods, JSP pages, form validation. Explain servlet mapping and navigation flow.
```

**3. Book list + search + filter + pagination**

```
Create the book listing module for my PRJ301 Java Web project.

Requirements: Display list of books from database, search by title, filter by category and author, sort by newest and title A–Z, pagination. JSP must use JSTL/EL, MVC pattern. Include servlet, DAO/repository methods, and JSP page. Explain request parameters and pagination logic clearly.
```

**4. Book detail + similar books**

```
Create the book detail module for my PRJ301 Java Web project.

Requirements: Show book detail by id; display title, image, description, author, category, quantity, available quantity; show similar books (same category or author). Use Servlet + JSP + JSTL/EL, MVC. Include DAO/repository methods and JSP page.
```

**5. Borrow cart**

```
Create the borrow cart module for my PRJ301 Java Web project.

Requirements: Session to store cart; add/remove books, update quantity; display cart in JSP with JSTL/EL; MVC; Cart model if needed; servlets and clear explanation of session flow.
```

**6. Borrow request**

```
Create the borrow request checkout module for my PRJ301 Java Web project.

Requirements: Convert cart to borrow request and borrow_request_details; save to database; clear session cart after success; require logged-in member; Servlet + JSP + DAO/repository; explain transaction flow clearly.
```

**7. Admin CRUD**

```
Create admin CRUD modules for books, categories, and authors in my PRJ301 Java Web project.

Requirements: Admin-only access; Filter for authorization; Servlet + JSP + JSTL/EL; create, read, update, delete; simple and maintainable; explain servlet mappings and page flow.
```

**8. Statistics dashboard**

```
Create a statistics dashboard module for my PRJ301 library management project.

Requirements: Total books, total users, borrowed count, overdue count, most borrowed books, borrow requests by month; Servlet + JSP; Chart.js on JSP; DAO/repository for aggregated data; explain how chart data is passed from servlet to JSP.
```

**9. Filter + Listener**

```
Create Filter and Listener components for my PRJ301 Java Web project.

Requirements: Authentication filter for protected pages; authorization filter for admin pages; optional encoding filter; session listener for active users; application listener if needed; explain web.xml or annotation configuration clearly.
```

### 12.3 Helpful prompts

**Before coding (explain first):**

```
Before coding, explain:
1. Which files will be created
2. Which files will be modified
3. Request flow
4. Session flow if any
5. Database tables involved

Then generate the code.
```

**Constraint (keep PRJ301 scope):**

```
Do not generate unnecessary frameworks or overly complex architecture.
Keep it suitable for a university PRJ301 Java Web project using Servlet, JSP, JSTL, EL, MVC, Session, Filter, Listener, and JPA/JDBC only.
```

---

## 13. How to Use This README with Cursor

1. **Paste README/spec first** – Use this README as the main reference.
2. **Ask Cursor for structure + schema** – Use the initial prompt in §12.1.
3. **Build one module at a time** – Use prompts in §12.2 (e.g. 1 → test → 2 → test …).
4. **For each module** ask Cursor to:
   - Explain the flow
   - List new files
   - Avoid changing unrelated existing files
5. **Use §12.3** when you want “explain then code” or to enforce PRJ301-only scope.

---

## 14. Nâng cấp (footer, email, AI, đánh giá, yêu thích, NXB)

### Cơ sở dữ liệu

Chạy script [`database/migration_v2.sql`](database/migration_v2.sql) trên **SmartLibraryDB** (bảng `site_settings`, `book_reviews`, `user_favorites`, `publishers`, cột reset mật khẩu, gia hạn, email quá hạn, `books.publisher_id`).  
Ứng dụng dùng `hibernate.hbm2ddl.auto=update` sẽ bổ sung entity mới; script migration vẫn cần cho dữ liệu mặc định và chuyển cột NXB cũ.

### Chân trang (admin)

Vào **Admin → Cài đặt & chân trang** (`/admin/settings`) để sửa dòng tiêu đề / phụ và bật hiển thị năm.

### Email (quên mật khẩu, nhắc quá hạn)

1. Trong **Admin → Cài đặt**, bật **Bật gửi email** (`mail_enabled=true`).
2. Cấu hình SMTP trong [`src/main/webapp/WEB-INF/web.xml`](src/main/webapp/WEB-INF/web.xml) (`mail.smtp.host`, `mail.smtp.port`, `mail.smtp.user`, `mail.smtp.password`, `mail.from`) **hoặc** biến môi trường: `MAIL_SMTP_HOST`, `MAIL_SMTP_PORT`, `MAIL_SMTP_USER`, `MAIL_SMTP_PASSWORD`, `MAIL_FROM`.
3. Job nhắc quá hạn chạy định kỳ (khoảng 6 giờ) qua [`AppStartupListener`](src/main/java/com/library/listener/AppStartupListener.java).

### Gemini (chat)

- Đặt biến môi trường **`GEMINI_API_KEY`** (Google AI Studio), hoặc thêm `context-param` `gemini.api.key` trong `web.xml`.
- Tùy chọn: `gemini.model` (mặc định `gemini-1.5-flash`).
- Widget chat nằm ở góc phải trên các trang dùng [`footer.jsp`](src/main/webapp/views/common/footer.jsp).

---

*PRJ301 – Smart Library Management and Online Borrowing System*
