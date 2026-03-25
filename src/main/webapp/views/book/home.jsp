<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Trang chủ – H2C LIBRARY"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<!-- Hero Banner -->
<section class="sl-hero">
    <div class="container">
        <h1 class="sl-hero-title">
            <span class="sl-icon"><i class="bi bi-book-half"></i></span>
            H2C LIBRARY
        </h1>
        <p class="sl-hero-sub">Learn today, lead tomorrow</p>

        <form action="${pageContext.request.contextPath}/books" method="get"
              class="sl-search-form position-relative">
            <input type="text" name="query" class="sl-search-input w-100 pe-5"
                   placeholder="Nhập tên sách, tác giả, danh mục…">
            <button class="sl-search-btn" type="submit">
                <i class="bi bi-search"></i> Tìm
            </button>
        </form>

        <div class="sl-features">
            <span class="sl-feature-pill">
                <i class="bi bi-check-circle-fill"></i> Miễn phí mượn
            </span>
            <span class="sl-feature-pill">
                <i class="bi bi-lightning-charge-fill"></i> Xử lý nhanh
            </span>
            <span class="sl-feature-pill">
                <i class="bi bi-phone-fill"></i> Tương thích mọi thiết bị
            </span>
        </div>
    </div>
</section>

<main class="container py-5">

    <!-- New Books -->
    <section class="mb-5">
        <div class="d-flex justify-content-between align-items-center">
            <h2 class="sl-section-title mb-0">
                <i class="bi bi-stars"></i> Sách mới nhất
            </h2>
            <a href="${pageContext.request.contextPath}/books?sort=newest" class="btn btn-sm btn-outline-primary">Xem tất cả</a>
        </div>
        <div class="row g-3 mt-1">
            <c:forEach var="book" items="${newBooks}">
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="card book-card h-100">
                        <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}">
                            <c:choose>
                                <c:when test="${not empty book.image}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(book.image, 'assets/')}"><c:set var="imgSrc" value="${pageContext.request.contextPath}/${book.image}"/></c:when>
                                        <c:otherwise><c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/images/uploads/${book.image}"/></c:otherwise>
                                    </c:choose>
                                    <img src="${imgSrc}" class="book-img" alt="${book.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="book-img-placeholder">
                                        <i class="bi bi-book"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <div class="card-body">
                            <h3 class="card-title mb-1">
                                <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}"
                                   class="text-decoration-none"><c:out value="${book.title}"/></a>
                            </h3>
                            <p class="small text-muted mb-2">
                                <c:out value="${book.author != null ? book.author.name : 'Chưa rõ'}"/>
                            </p>
                            <c:choose>
                                <c:when test="${book.available}">
                                    <span class="badge badge-sl-available rounded-pill px-2 py-1"><i class="bi bi-check-circle me-1"></i>Còn ${book.availableQuantity} quyển</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Hết sách</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Most Borrowed -->
    <section class="mb-5">
        <div class="d-flex justify-content-between align-items-center">
            <h2 class="sl-section-title mb-0">
                <i class="bi bi-fire"></i> Sách được mượn nhiều nhất
            </h2>
            <a href="${pageContext.request.contextPath}/books?sort=most_borrowed" class="btn btn-sm btn-outline-primary">Xem tất cả</a>
        </div>
        <div class="row g-3 mt-1">
            <c:forEach var="book" items="${mostBorrowed}">
                <div class="col-4 col-md-3 col-lg-2">
                    <div class="card book-card h-100">
                        <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}">
                            <c:choose>
                                <c:when test="${not empty book.image}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(book.image, 'assets/')}"><c:set var="imgSrc" value="${pageContext.request.contextPath}/${book.image}"/></c:when>
                                        <c:otherwise><c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/images/uploads/${book.image}"/></c:otherwise>
                                    </c:choose>
                                    <img src="${imgSrc}" class="book-img" alt="${book.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="book-img-placeholder">
                                        <i class="bi bi-book"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <div class="card-body py-2">
                            <p class="card-title mb-0 small text-truncate">
                                <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}"
                                   class="text-decoration-none"><c:out value="${book.title}"/></a>
                            </p>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Books by Category -->
    <c:forEach var="entry" items="${booksByCategory}">
        <c:if test="${not empty entry.value}">
            <section class="mb-5">
                <div class="d-flex justify-content-between align-items-center">
                    <h2 class="sl-section-title mb-0">
                        <i class="bi bi-bookmark-fill"></i>
                        <c:out value="${entry.key.name}"/>
                    </h2>
                    <a href="${pageContext.request.contextPath}/books?categoryId=${entry.key.id}"
                       class="btn btn-sm btn-outline-primary">Xem thêm</a>
                </div>
                <div class="row g-3 mt-1">
                    <c:forEach var="book" items="${entry.value}">
                        <div class="col-6 col-md-3">
                            <div class="card book-card h-100">
                                <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}">
                                    <c:choose>
                                        <c:when test="${not empty book.image}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(book.image, 'assets/')}"><c:set var="imgSrc" value="${pageContext.request.contextPath}/${book.image}"/></c:when>
                                                <c:otherwise><c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/images/uploads/${book.image}"/></c:otherwise>
                                            </c:choose>
                                            <img src="${imgSrc}" class="book-img" alt="${book.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="book-img-placeholder">
                                                <i class="bi bi-book"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="card-body py-2">
                                    <p class="card-title mb-0 small text-truncate">
                                        <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}"
                                           class="text-decoration-none"><c:out value="${book.title}"/></a>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>
    </c:forEach>

</main>

<jsp:include page="/views/common/footer.jsp"/>
