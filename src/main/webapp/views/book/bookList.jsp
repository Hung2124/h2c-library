<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Danh sách sách"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<main class="container py-4">
    <h2 class="sl-section-title mb-2"><i class="bi bi-search"></i> Tìm kiếm sách</h2>
    <p class="text-muted small mb-4">Gõ tên sách hoặc chọn danh mục / tác giả, rồi bấm nút <strong class="text-body">tìm</strong> (ô vuông có kính lúp). Có thể lọc thêm “Còn sách” nếu chỉ muốn sách đang mượn được.</p>

    <!-- Filter Form -->
    <div class="card search-filter-card mb-4">
        <div class="card-body p-4">
            <form method="get" action="${pageContext.request.contextPath}/books" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label small text-muted mb-1">Từ khóa</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" class="form-control" name="keyword" placeholder="Tìm theo tên sách..."
                               value="<c:out value="${keyword}"/>">
                    </div>
                </div>
                <div class="col-md-2">
                    <label class="form-label small text-muted mb-1">Danh mục</label>
                    <select class="form-select" name="categoryId">
                        <option value="">-- Danh mục --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>
                                <c:out value="${cat.name}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label small text-muted mb-1">Tác giả</label>
                    <select class="form-select" name="authorId">
                        <option value="">-- Tác giả --</option>
                        <c:forEach var="author" items="${authors}">
                            <option value="${author.id}" ${selectedAuthorId == author.id ? 'selected' : ''}>
                                <c:out value="${author.name}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label small text-muted mb-1">Sắp xếp</label>
                    <select class="form-select" name="sort">
                        <option value="newest" ${sort == 'newest' || empty sort ? 'selected' : ''}>Mới nhất</option>
                        <option value="title_asc" ${sort == 'title_asc' ? 'selected' : ''}>Tên A–Z</option>
                        <option value="most_borrowed" ${sort == 'most_borrowed' ? 'selected' : ''}>Mượn nhiều nhất</option>
                    </select>
                </div>
                <div class="col-md-1">
                    <div class="form-check mt-2">
                        <input class="form-check-input" type="checkbox" name="available" value="1" id="cbAvail"
                            ${available == '1' ? 'checked' : ''}>
                        <label class="form-check-label small" for="cbAvail">Còn sách</label>
                    </div>
                </div>
                <div class="col-md-1">
                    <button type="submit" class="btn btn-primary w-100 shadow-sm" style="height: 42px;">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Result info -->
    <p class="text-muted mb-3">
        Tìm thấy <strong>${totalItems}</strong> sách
        <c:if test="${not empty keyword}"> – từ khóa: "<strong><c:out value="${keyword}"/></strong>"</c:if>
    </p>

    <!-- Books Grid -->
    <div class="row g-3">
        <c:choose>
            <c:when test="${empty books}">
                <div class="col-12">
                    <div class="sl-empty-state">
                        <i class="bi bi-search sl-empty-icon d-block" aria-hidden="true"></i>
                        <p class="sl-empty-title">Không tìm thấy sách nào</p>
                        <p class="sl-empty-hint">Thử bỏ bớt bộ lọc hoặc dùng từ khóa ngắn hơn.</p>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-primary btn-sm mt-2">Xóa bộ lọc</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="book" items="${books}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card book-card h-100">
                            <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}">
                                <c:choose>
                                    <c:when test="${not empty book.image}">
                                        <c:choose><c:when test="${fn:startsWith(book.image, 'assets/')}"><c:set var="imgSrc" value="${pageContext.request.contextPath}/${book.image}"/></c:when><c:otherwise><c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/images/uploads/${book.image}"/></c:otherwise></c:choose><img src="${imgSrc}"
                                             class="card-img-top book-img" alt="${book.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="book-img-placeholder">
                                            <i class="bi bi-book"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <div class="card-body d-flex flex-column p-3">
                                <h6 class="card-title text-truncate">
                                    <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}"
                                       class="text-decoration-none text-dark">
                                        <c:out value="${book.title}"/>
                                    </a>
                                </h6>
                                <small class="text-muted">
                                    <c:out value="${book.author != null ? book.author.name : 'Chưa rõ'}"/>
                                </small>
                                <small class="text-muted">
                                    <c:out value="${book.category != null ? book.category.name : ''}"/>
                                </small>
                                <div class="mt-auto pt-3 d-flex justify-content-between align-items-center">
                                    <div>
                                        <c:choose>
                                            <c:when test="${book.available}">
                                                <span class="badge badge-sl-available rounded-pill px-2 py-1"><i class="bi bi-check-circle me-1"></i>Còn ${book.availableQuantity}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge rounded-pill bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">Hết sách</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:if test="${sessionScope.loggedUser != null and not sessionScope.loggedUser.admin and book.available}">
                                        <form method="post" action="${pageContext.request.contextPath}/cart/add" class="d-inline m-0">
                                            <input type="hidden" name="bookId" value="${book.id}">
                                            <button class="btn btn-sm btn-outline-primary rounded-circle" style="width: 32px; height: 32px; padding: 0; display: inline-flex; align-items: center; justify-content: center;" title="Thêm vào giỏ">
                                                <i class="bi bi-cart-plus"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <c:if test="${currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/books?keyword=${keyword}&categoryId=${selectedCategoryId}&authorId=${selectedAuthorId}&sort=${sort}&available=${available}&page=${currentPage - 1}">
                            &laquo;
                        </a>
                    </li>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="p">
                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/books?keyword=${keyword}&categoryId=${selectedCategoryId}&authorId=${selectedAuthorId}&sort=${sort}&available=${available}&page=${p}">
                            ${p}
                        </a>
                    </li>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="${pageContext.request.contextPath}/books?keyword=${keyword}&categoryId=${selectedCategoryId}&authorId=${selectedAuthorId}&sort=${sort}&available=${available}&page=${currentPage + 1}">
                            &raquo;
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </c:if>

</main>

<jsp:include page="/views/common/footer.jsp"/>
