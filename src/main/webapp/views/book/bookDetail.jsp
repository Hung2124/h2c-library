<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${book.title}"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

    <main class="container py-4">
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/books">Sách</a></li>
            <li class="breadcrumb-item active"><c:out value="${book.title}"/></li>
        </ol>
    </nav>

    <c:if test="${param.reviewSuccess == '1'}">
        <div class="alert alert-success alert-dismissible fade show">Đã lưu đánh giá của bạn.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>
    <c:if test="${param.reviewError == 'not_eligible'}">
        <div class="alert alert-warning alert-dismissible fade show">Chỉ thành viên đã hoặc đang mượn sách này mới được đánh giá.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>
    <c:if test="${param.reviewError == 'invalid'}">
        <div class="alert alert-danger alert-dismissible fade show">Đánh giá không hợp lệ.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>

    <div class="row g-4">
        <div class="col-md-3 text-center">
            <c:choose>
                <c:when test="${not empty book.image}">
                    <c:choose><c:when test="${fn:startsWith(book.image, 'assets/')}"><c:set var="imgSrc" value="${pageContext.request.contextPath}/${book.image}"/></c:when><c:otherwise><c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/images/uploads/${book.image}"/></c:otherwise></c:choose><img src="${imgSrc}"
                         class="img-fluid rounded shadow" alt="${book.title}" style="max-height:350px">
                </c:when>
                <c:otherwise>
                    <div class="book-img-placeholder" style="height:300px; border-radius: 12px; margin-bottom: 0.5rem;">
                        <i class="bi bi-book"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="col-md-6">
            <h2 class="fw-bold"><c:out value="${book.title}"/></h2>
            <p class="text-muted mb-2">
                <i class="bi bi-person me-1"></i>
                <c:out value="${book.author != null ? book.author.name : 'Chưa rõ'}"/>
            </p>
            <p class="mb-1">
                <span class="badge rounded-pill bg-primary text-white px-3 py-2 me-2">
                    <c:out value="${book.category != null ? book.category.name : 'Chưa phân loại'}"/>
                </span>
                <c:if test="${not empty book.language}">
                    <span class="badge rounded-pill bg-secondary text-white px-3 py-2">
                        <c:out value="${book.language}"/>
                    </span>
                </c:if>
            </p>

            <c:if test="${reviewCount > 0}">
                <p class="small text-warning mb-2">
                    <c:forEach begin="1" end="5" var="s">
                        <i class="bi ${reviewAvg >= s ? 'bi-star-fill' : 'bi-star'}"></i>
                    </c:forEach>
                    <span class="text-muted ms-1">(<c:out value="${reviewAvg}"/>/5 · ${reviewCount} đánh giá)</span>
                </p>
            </c:if>

            <table class="table table-sm mt-3" style="max-width:400px">
                <c:if test="${book.publisher != null}">
                    <tr><td class="text-muted">Nhà xuất bản</td><td><c:out value="${book.publisher.name}"/></td></tr>
                </c:if>
                <c:if test="${not empty book.publishYear}">
                    <tr><td class="text-muted">Năm xuất bản</td><td>${book.publishYear}</td></tr>
                </c:if>
                <tr><td class="text-muted">Tổng số</td><td>${book.quantity} quyển</td></tr>
                <tr>
                    <td class="text-muted">Hiện có</td>
                    <td>
                        <c:choose>
                            <c:when test="${book.available}">
                                <span class="badge badge-sl-available rounded-pill px-2 py-1"><i class="bi bi-check-circle me-1"></i>Còn ${book.availableQuantity} quyển</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge rounded-pill bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-2 py-1">Hết sách</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>

            <div class="d-flex flex-wrap sl-action-buttons sl-action-buttons--stack-sm mt-3">
                <c:if test="${sessionScope.loggedUser != null and not sessionScope.loggedUser.admin}">
                    <form method="post" action="${pageContext.request.contextPath}/favorites/toggle" class="d-inline">
                        <input type="hidden" name="bookId" value="${book.id}">
                        <input type="hidden" name="redirect" value="/books/detail?id=${book.id}">
                        <button type="submit" class="btn ${isFavorite ? 'btn-danger' : 'btn-outline-danger'}">
                            <i class="bi ${isFavorite ? 'bi-heart-fill' : 'bi-heart'} me-1"></i>
                            ${isFavorite ? 'Bỏ yêu thích' : 'Yêu thích'}
                        </button>
                    </form>
                </c:if>
                <c:choose>
                    <c:when test="${sessionScope.loggedUser == null}">
                        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập để mượn
                        </a>
                    </c:when>
                    <c:when test="${not sessionScope.loggedUser.admin and book.available}">
                        <form method="post" action="${pageContext.request.contextPath}/cart/add" class="d-inline">
                            <input type="hidden" name="bookId" value="${book.id}">
                            <button class="btn btn-primary px-4">
                                <i class="bi bi-cart-plus me-2"></i>Thêm vào giỏ
                            </button>
                        </form>
                    </c:when>
                    <c:when test="${not book.available}">
                        <button class="btn btn-secondary" disabled>Hết sách</button>
                    </c:when>
                </c:choose>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>Quay lại
                </a>
            </div>
        </div>
    </div>

    <c:if test="${sessionScope.loggedUser != null and canReview}">
        <div class="card mt-4 shadow-sm">
            <div class="card-header fw-semibold">
                ${myReview != null ? 'Sửa đánh giá của bạn' : 'Viết đánh giá'}
            </div>
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/books/review">
                    <input type="hidden" name="bookId" value="${book.id}">
                    <input type="hidden" name="redirect" value="/books/detail?id=${book.id}">
                    <div class="mb-2">
                        <label class="form-label small">Số sao (1–5)</label>
                        <div class="star-rating-input" id="starRatingInput">
                            <c:forEach begin="1" end="5" var="r">
                                <i class="bi bi-star fs-4 me-1 ${myReview != null && myReview.rating >= r ? 'filled' : ''}"
                                   data-value="${r}" role="button" aria-label="${r} sao"></i>
                            </c:forEach>
                            <input type="hidden" name="rating" id="ratingValue"
                                   value="${myReview != null ? myReview.rating : ''}" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small">Nhận xét</label>
                        <textarea name="comment" class="form-control" rows="3" maxlength="2000"
                                  placeholder="Chia sẻ cảm nhận (không bắt buộc)"><c:out value="${myReview != null ? myReview.comment : ''}"/></textarea>
                    </div>
                    <button type="submit" class="btn btn-sm btn-primary">Gửi đánh giá</button>
                </form>
            </div>
        </div>
    </c:if>
    <c:if test="${sessionScope.loggedUser != null and not canReview and not sessionScope.loggedUser.admin}">
        <p class="small text-muted mt-3"><i class="bi bi-info-circle me-1"></i>Chỉ người đã hoặc đang mượn sách này mới có thể đánh giá.</p>
    </c:if>

    <c:if test="${not empty reviews}">
        <div class="mt-4">
            <h5 class="fw-bold border-bottom pb-2">Đánh giá độc giả</h5>
            <c:forEach var="rv" items="${reviews}">
                <div class="border-bottom py-3">
                    <div class="d-flex justify-content-between">
                        <strong><c:out value="${rv.user.fullName}"/></strong>
                        <span class="text-warning small">
                            <c:forEach begin="1" end="5" var="s">
                                <i class="bi ${s <= rv.rating ? 'bi-star-fill' : 'bi-star'}"></i>
                            </c:forEach>
                        </span>
                    </div>
                    <div class="small text-muted">${rv.createdAt}</div>
                    <c:if test="${not empty rv.comment}">
                        <p class="mb-0 mt-2"><c:out value="${rv.comment}"/></p>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${not empty book.description}">
        <div class="mt-4">
            <h5 class="fw-bold border-bottom pb-2">Giới thiệu sách</h5>
            <div class="mt-3">${book.description}</div>
        </div>
    </c:if>

    <c:if test="${not empty similarBooks}">
        <section class="mt-5">
            <h5 class="fw-bold border-bottom pb-2 mb-3">Sách tương tự</h5>
            <div class="row g-3">
                <c:forEach var="sb" items="${similarBooks}">
                    <div class="col-6 col-md-3">
                        <div class="card book-card h-100">
                            <a href="${pageContext.request.contextPath}/books/detail?id=${sb.id}">
                                <c:choose>
                                    <c:when test="${not empty sb.image}">
                                        <c:choose><c:when test="${fn:startsWith(sb.image, 'assets/')}"><c:set var="imgSrc2" value="${pageContext.request.contextPath}/${sb.image}"/></c:when><c:otherwise><c:set var="imgSrc2" value="${pageContext.request.contextPath}/assets/images/uploads/${sb.image}"/></c:otherwise></c:choose><img src="${imgSrc2}"
                                             class="card-img-top book-img" alt="${sb.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="book-img-placeholder">
                                            <i class="bi bi-book"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <div class="card-body p-2">
                                <h6 class="card-title text-truncate small">
                                    <a href="${pageContext.request.contextPath}/books/detail?id=${sb.id}"
                                       class="text-decoration-none text-dark">
                                        <c:out value="${sb.title}"/>
                                    </a>
                                </h6>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>
</main>

<jsp:include page="/views/common/footer.jsp"/>
