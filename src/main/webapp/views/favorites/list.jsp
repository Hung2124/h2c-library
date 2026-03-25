<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Sách yêu thích"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<main class="container py-4">
    <h2 class="sl-section-title mb-4"><i class="bi bi-heart-fill"></i> Sách yêu thích</h2>

    <c:choose>
        <c:when test="${empty books}">
            <div class="sl-empty-state">
                <i class="bi bi-heart sl-empty-icon d-block" aria-hidden="true"></i>
                <p class="sl-empty-title">Chưa có sách yêu thích</p>
                <p class="sl-empty-hint">Mở trang chi tiết sách và bấm nút trái tim để lưu vào danh sách này.</p>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary btn-sm mt-2">Tìm sách</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-3">
                <c:forEach var="book" items="${books}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card book-card h-100">
                            <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}">
                                <c:choose>
                                    <c:when test="${not empty book.image}">
                                        <c:choose><c:when test="${fn:startsWith(book.image, 'assets/')}"><c:set var="imgSrc" value="${pageContext.request.contextPath}/${book.image}"/></c:when><c:otherwise><c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/images/uploads/${book.image}"/></c:otherwise></c:choose><img src="${imgSrc}" class="book-img" alt="">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="book-img-placeholder">
                                            <i class="bi bi-book"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <div class="card-body">
                                <h3 class="card-title text-truncate">
                                    <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}" class="text-decoration-none">
                                        <c:out value="${book.title}"/>
                                    </a>
                                </h3>
                                <form method="post" action="${pageContext.request.contextPath}/favorites/toggle">
                                    <input type="hidden" name="bookId" value="${book.id}">
                                    <input type="hidden" name="redirect" value="/favorites/list">
                                    <button type="submit" class="btn btn-sm btn-outline-danger mt-2">
                                        <i class="bi bi-heartbreak me-1"></i>Bỏ yêu thích
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/views/common/footer.jsp"/>
