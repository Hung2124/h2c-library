<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Giỏ mượn sách"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<main class="container py-4">
    <h2 class="sl-section-title mb-4"><i class="bi bi-cart3"></i> Giỏ mượn sách</h2>

    <c:if test="${param.error == 'empty'}">
        <div class="alert alert-warning">Giỏ mượn trống. Vui lòng thêm sách trước.</div>
    </c:if>
    <c:if test="${param.error == 'unavailable'}">
        <div class="alert alert-warning">Tất cả sách trong giỏ đều không còn khả dụng.</div>
    </c:if>

    <c:choose>
        <c:when test="${empty cart or cart.itemCount == 0}">
            <div class="sl-empty-state">
                <i class="bi bi-cart-x sl-empty-icon d-block" aria-hidden="true"></i>
                <p class="sl-empty-title">Giỏ mượn đang trống</p>
                <p class="sl-empty-hint">Thêm sách từ trang tìm kiếm, rồi quay lại đây để gửi yêu cầu mượn.</p>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary mt-2">
                    <i class="bi bi-search me-2" aria-hidden="true"></i>Tìm sách để mượn
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-body p-0">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width:60px"></th>
                                        <th>Tên sách</th>
                                        <th style="width:140px">Số lượng</th>
                                        <th style="width:80px"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cart.items}">
                                        <tr>
                                            <td class="align-middle ps-3">
                                                <c:choose>
                                                    <c:when test="${not empty item.bookImage}">
                                                        <c:choose><c:when test="${fn:startsWith(item.bookImage, 'assets/')}"><c:set var="itemImgSrc" value="${pageContext.request.contextPath}/${item.bookImage}"/></c:when><c:otherwise><c:set var="itemImgSrc" value="${pageContext.request.contextPath}/assets/images/uploads/${item.bookImage}"/></c:otherwise></c:choose><img src="${itemImgSrc}"
                                                             width="50" height="65" class="object-fit-cover rounded"
                                                             alt="${item.bookTitle}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="bg-light d-flex align-items-center justify-content-center rounded" style="width:50px;height:65px">
                                                            <i class="bi bi-book text-muted"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="align-middle">
                                                <a href="${pageContext.request.contextPath}/books/detail?id=${item.bookId}"
                                                   class="text-decoration-none fw-semibold">
                                                    <c:out value="${item.bookTitle}"/>
                                                </a>
                                                <div class="small text-muted">Tối đa: ${item.maxQuantity} quyển</div>
                                            </td>
                                            <td class="align-middle">
                                                <form method="post" action="${pageContext.request.contextPath}/cart/update"
                                                      class="d-flex align-items-center gap-1">
                                                    <input type="hidden" name="bookId" value="${item.bookId}">
                                                    <input type="number" name="quantity" value="${item.quantity}"
                                                           min="1" max="${item.maxQuantity}"
                                                           class="form-control form-control-sm text-center" style="width:70px"
                                                           onchange="this.form.submit()">
                                                </form>
                                            </td>
                                            <td class="align-middle text-center">
                                                <form method="post" action="${pageContext.request.contextPath}/cart/remove">
                                                    <input type="hidden" name="bookId" value="${item.bookId}">
                                                    <button class="btn btn-sm btn-outline-danger" title="Xóa">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="mt-3 d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i>Tiếp tục tìm sách
                        </a>
                        <form method="post" action="${pageContext.request.contextPath}/cart/clear">
                            <button class="btn btn-outline-danger">
                                <i class="bi bi-cart-x me-1"></i>Xóa tất cả
                            </button>
                        </form>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title fw-bold">Tổng kết</h5>
                            <p class="mb-1">Số đầu sách: <strong>${cart.itemCount}</strong></p>
                            <p class="mb-3">Tổng số quyển: <strong>${cart.totalItems}</strong></p>
                            <hr>
                            <p class="text-muted small">Sau khi gửi yêu cầu, thủ thư sẽ xét duyệt trong vòng 1–2 ngày làm việc.</p>
                            <form method="post" action="${pageContext.request.contextPath}/borrow/submit">
                                <button class="btn btn-primary w-100">
                                    <i class="bi bi-send me-2"></i>Gửi yêu cầu mượn
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/views/common/footer.jsp"/>
