<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<a class="skip-link" href="#main-content">Bỏ qua đến nội dung chính</a>
<nav class="navbar navbar-expand-lg navbar-light fixed-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-book-half me-2"></i>H2C LIBRARY
        </a>
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse"
                data-bs-target="#navMenu" aria-controls="navMenu" aria-expanded="false"
                aria-label="Mở menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/books">
                        <i class="bi bi-search me-1"></i>Tìm sách
                    </a>
                </li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${sessionScope.loggedUser != null}">
                        <c:if test="${not sessionScope.loggedUser.admin}">
                            <li class="nav-item me-2">
                                <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                                    <i class="bi bi-cart3 fs-5"></i>
                                    <c:if test="${not empty sessionScope.cart and sessionScope.cart.itemCount gt 0}">
                                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                            ${sessionScope.cart.itemCount}
                                        </span>
                                    </c:if>
                                </a>
                            </li>
                            <li class="nav-item me-2">
                                <a class="nav-link" href="${pageContext.request.contextPath}/borrow/history">
                                    <i class="bi bi-clock-history me-1"></i>Lịch sử
                                </a>
                            </li>
                            <li class="nav-item me-2">
                                <a class="nav-link" href="${pageContext.request.contextPath}/favorites/list">
                                    <i class="bi bi-heart me-1"></i>Yêu thích
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${sessionScope.loggedUser.admin}">
                            <li class="nav-item me-2">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-speedometer2 me-1"></i>Admin
                                </a>
                            </li>
                        </c:if>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#"
                               id="userMenu" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle fs-5 me-1"></i>
                                <c:out value="${sessionScope.loggedUser.fullName}"/>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="bi bi-person me-2"></i>Hồ sơ</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout">
                                    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-outline-primary btn-sm ms-2" href="${pageContext.request.contextPath}/auth/register">
                                Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
<div id="main-content" tabindex="-1"></div>
