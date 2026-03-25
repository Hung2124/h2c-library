<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : 'Admin'}"/> – H2C LIBRARY</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=8">
</head>
<body>

<a class="skip-link" href="#admin-main">Bỏ qua đến nội dung chính</a>

<!-- Mobile top bar -->
<nav class="admin-topbar navbar navbar-dark d-md-none px-3 py-2">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="bi bi-book-half me-2"></i>H2C LIBRARY
    </a>
    <button class="btn btn-sm btn-outline-light border-0" type="button"
            data-bs-toggle="offcanvas" data-bs-target="#adminSidebar" aria-label="Mở menu quản trị">
        <i class="bi bi-list fs-5"></i>
    </button>
</nav>

<div class="admin-wrapper">

    <!-- Desktop sidebar -->
    <nav class="sidebar d-none d-md-flex flex-column" aria-label="Menu quản trị">

        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-brand">
            <i class="bi bi-book-half"></i>
            <span>H2C LIBRARY</span>
        </a>

        <div class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="nav-link ${param.page == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i>Dashboard
            </a>

            <p class="sidebar-section-label">Dữ liệu sách</p>
            <a href="${pageContext.request.contextPath}/admin/books/list"
               class="nav-link ${param.page == 'books' ? 'active' : ''}">
                <i class="bi bi-book"></i>Quản lý sách
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories/list"
               class="nav-link ${param.page == 'categories' ? 'active' : ''}">
                <i class="bi bi-tags"></i>Danh mục
            </a>
            <a href="${pageContext.request.contextPath}/admin/authors/list"
               class="nav-link ${param.page == 'authors' ? 'active' : ''}">
                <i class="bi bi-person-lines-fill"></i>Tác giả
            </a>
            <a href="${pageContext.request.contextPath}/admin/publishers/list"
               class="nav-link ${param.page == 'publishers' ? 'active' : ''}">
                <i class="bi bi-building"></i>Nhà xuất bản
            </a>

            <p class="sidebar-section-label">Người dùng &amp; mượn</p>
            <a href="${pageContext.request.contextPath}/admin/users/list"
               class="nav-link ${param.page == 'users' ? 'active' : ''}">
                <i class="bi bi-people"></i>Người dùng
            </a>
            <a href="${pageContext.request.contextPath}/admin/borrows/list"
               class="nav-link ${param.page == 'borrows' ? 'active' : ''}">
                <i class="bi bi-clipboard-check"></i>Yêu cầu mượn
            </a>

            <p class="sidebar-section-label">Hệ thống</p>
            <a href="${pageContext.request.contextPath}/admin/settings"
               class="nav-link ${param.page == 'settings' ? 'active' : ''}">
                <i class="bi bi-sliders"></i>Cài đặt &amp; chân trang
            </a>
        </div>

        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/home" class="nav-link">
                <i class="bi bi-arrow-left-circle"></i>Về trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="nav-link text-danger">
                <i class="bi bi-box-arrow-right"></i>Đăng xuất
            </a>
        </div>
    </nav>

    <!-- Offcanvas sidebar for mobile -->
    <div class="offcanvas offcanvas-start admin-offcanvas d-md-none" id="adminSidebar" tabindex="-1">
        <div class="offcanvas-header border-bottom">
            <span class="fw-bold text-white fs-6">
                <i class="bi bi-book-half me-2" style="color:var(--sl-primary-light)"></i>H2C LIBRARY
            </span>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Đóng"></button>
        </div>
        <div class="offcanvas-body p-3 d-flex flex-column">
            <div class="sidebar-nav" style="flex:1">
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                   class="nav-link ${param.page == 'dashboard' ? 'active' : ''}">
                    <i class="bi bi-speedometer2"></i>Dashboard
                </a>
                <p class="sidebar-section-label">Dữ liệu sách</p>
                <a href="${pageContext.request.contextPath}/admin/books/list"
                   class="nav-link ${param.page == 'books' ? 'active' : ''}">
                    <i class="bi bi-book"></i>Quản lý sách
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories/list"
                   class="nav-link ${param.page == 'categories' ? 'active' : ''}">
                    <i class="bi bi-tags"></i>Danh mục
                </a>
                <a href="${pageContext.request.contextPath}/admin/authors/list"
                   class="nav-link ${param.page == 'authors' ? 'active' : ''}">
                    <i class="bi bi-person-lines-fill"></i>Tác giả
                </a>
                <a href="${pageContext.request.contextPath}/admin/publishers/list"
                   class="nav-link ${param.page == 'publishers' ? 'active' : ''}">
                    <i class="bi bi-building"></i>Nhà xuất bản
                </a>
                <p class="sidebar-section-label">Người dùng &amp; mượn</p>
                <a href="${pageContext.request.contextPath}/admin/users/list"
                   class="nav-link ${param.page == 'users' ? 'active' : ''}">
                    <i class="bi bi-people"></i>Người dùng
                </a>
                <a href="${pageContext.request.contextPath}/admin/borrows/list"
                   class="nav-link ${param.page == 'borrows' ? 'active' : ''}">
                    <i class="bi bi-clipboard-check"></i>Yêu cầu mượn
                </a>
                <p class="sidebar-section-label">Hệ thống</p>
                <a href="${pageContext.request.contextPath}/admin/settings"
                   class="nav-link ${param.page == 'settings' ? 'active' : ''}">
                    <i class="bi bi-sliders"></i>Cài đặt &amp; chân trang
                </a>
            </div>
            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/home" class="nav-link">
                    <i class="bi bi-arrow-left-circle"></i>Về trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/auth/logout" class="nav-link text-danger">
                    <i class="bi bi-box-arrow-right"></i>Đăng xuất
                </a>
            </div>
        </div>
    </div>

    <!-- Main content — page content gets inserted here -->
    <main id="admin-main" tabindex="-1" class="admin-main flex-grow-1">
