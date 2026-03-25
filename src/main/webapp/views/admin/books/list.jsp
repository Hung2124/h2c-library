<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý sách"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title"><i class="bi bi-book"></i>Quản lý sách</h1>
        <p class="admin-page-subtitle">Tìm thấy <strong>${totalItems}</strong> sách</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/books/new" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>Thêm sách
    </a>
</div>

<c:if test="${param.success == 'saved'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Lưu thành công!
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.success == 'deleted'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Đã xóa sách.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'book_borrowed'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Không thể xóa sách này vì đã có trong lịch sử mượn. Hãy ẩn sách (trạng thái &quot;Ẩn&quot;) thay vì xóa.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'delete_failed'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Không xóa được. Có thể sách vẫn đang được tham chiếu.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Filter Card -->
<div class="sl-filter-card">
    <form method="get" action="${pageContext.request.contextPath}/admin/books/list" class="row g-2 align-items-end">
        <div class="col-md-3">
            <label class="form-label small text-muted mb-1">Từ khóa</label>
            <input type="text" class="form-control form-control-sm" name="keyword"
                   placeholder="Tên sách…" value="<c:out value="${keyword}"/>">
        </div>
        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Danh mục</label>
            <select class="form-select form-select-sm" name="categoryId">
                <option value="">Tất cả</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.id}" ${selectedCategoryId == cat.id ? 'selected' : ''}>
                        <c:out value="${cat.name}"/>
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">Tác giả</label>
            <select class="form-select form-select-sm" name="authorId">
                <option value="">Tất cả</option>
                <c:forEach var="author" items="${authors}">
                    <option value="${author.id}" ${selectedAuthorId == author.id ? 'selected' : ''}>
                        <c:out value="${author.name}"/>
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-2">
            <label class="form-label small text-muted mb-1">NXB</label>
            <select class="form-select form-select-sm" name="publisherId">
                <option value="">Tất cả</option>
                <c:forEach var="pub" items="${publishers}">
                    <option value="${pub.id}" ${selectedPublisherId == pub.id ? 'selected' : ''}>
                        <c:out value="${pub.name}"/>
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-1">
            <label class="form-label small text-muted mb-1">Trạng thái</label>
            <select class="form-select form-select-sm" name="status">
                <option value="" ${empty statusFilter ? 'selected' : ''}>Tất cả</option>
                <option value="AVAILABLE" ${statusFilter == 'AVAILABLE' ? 'selected' : ''}>Khả dụng</option>
                <option value="UNAVAILABLE" ${statusFilter == 'UNAVAILABLE' ? 'selected' : ''}>Ẩn</option>
            </select>
        </div>
        <div class="col-md-1">
            <div class="form-check mt-3">
                <input class="form-check-input" type="checkbox" name="available" value="1" id="admAvail"
                       ${available == '1' ? 'checked' : ''}>
                <label class="form-check-label small" for="admAvail">Còn sách</label>
            </div>
        </div>
        <div class="col-md-1">
            <button type="submit" class="btn btn-primary btn-sm w-100">
                <i class="bi bi-search"></i>
            </button>
        </div>
    </form>
    <c:if test="${not empty keyword || not empty selectedCategoryId || not empty selectedAuthorId || not empty selectedPublisherId || not empty statusFilter || available == '1'}">
        <div class="mt-2">
            <a href="${pageContext.request.contextPath}/admin/books/list" class="btn btn-ghost btn-sm">
                <i class="bi bi-x-circle me-1"></i>Xóa bộ lọc
            </a>
        </div>
    </c:if>
</div>

<!-- Books Table -->
<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0 table-responsive-stack">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Tên sách</th>
                        <th>Tác giả</th>
                        <th>Danh mục</th>
                        <th>NXB</th>
                        <th>Tổng</th>
                        <th>Còn</th>
                        <th>Trạng thái</th>
                        <th style="min-width:110px">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty books}">
                            <tr>
                                <td colspan="9" class="text-center py-5">
                                    <i class="bi bi-search" style="font-size:2rem;opacity:.3;display:block;margin-bottom:.5rem"></i>
                                    <span class="text-muted">Không có sách nào khớp bộ lọc.</span>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="book" items="${books}" varStatus="st">
                                <tr>
                                    <td data-label="#">${(currentPage - 1) * 10 + st.index + 1}</td>
                                    <td data-label="Tên sách">
                                        <span class="fw-semibold"><c:out value="${book.title}"/></span>
                                    </td>
                                    <td data-label="Tác giả">
                                        <span class="text-muted"><c:out value="${book.author != null ? book.author.name : '—'}"/></span>
                                    </td>
                                    <td data-label="Danh mục">
                                        <span class="text-muted"><c:out value="${book.category != null ? book.category.name : '—'}"/></span>
                                    </td>
                                    <td data-label="NXB">
                                        <span class="text-muted"><c:out value="${book.publisher != null ? book.publisher.name : '—'}"/></span>
                                    </td>
                                    <td data-label="Tổng">${book.quantity}</td>
                                    <td data-label="Còn">${book.availableQuantity}</td>
                                    <td data-label="Trạng thái">
                                        <c:choose>
                                            <c:when test="${book.status == 'AVAILABLE'}">
                                                <span class="sl-badge sl-badge-success">
                                                    <i class="bi bi-check-circle-fill"></i>Khả dụng
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="sl-badge sl-badge-neutral">
                                                    <i class="bi bi-eye-slash-fill"></i>Ẩn
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td data-label="Thao tác">
                                        <a href="${pageContext.request.contextPath}/admin/books/edit?id=${book.id}"
                                           class="btn btn-sm btn-outline-primary me-1 btn-icon" title="Sửa">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button" class="btn btn-sm btn-outline-danger btn-icon"
                                                title="Xóa"
                                                data-book-title="<c:out value="${book.title}"/>"
                                                onclick="confirmDelete(${book.id}, this.getAttribute('data-book-title'))">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Pagination -->
<c:if test="${totalPages > 1}">
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${totalPages}" var="p">
                <li class="page-item ${p == currentPage ? 'active' : ''}">
                    <a class="page-link" href="?page=${p}<c:if test='${not empty keyword}'>&amp;keyword=<c:out value='${keyword}'/></c:if><c:if test='${not empty selectedCategoryId}'>&amp;categoryId=<c:out value='${selectedCategoryId}'/></c:if><c:if test='${not empty selectedAuthorId}'>&amp;authorId=<c:out value='${selectedAuthorId}'/></c:if><c:if test='${not empty selectedPublisherId}'>&amp;publisherId=<c:out value='${selectedPublisherId}'/></c:if><c:if test='${not empty statusFilter}'>&amp;status=<c:out value='${statusFilter}'/></c:if><c:if test="${available eq '1'}">&amp;available=1</c:if>">${p}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</c:if>

<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalTitle">
    <div class="modal-dialog modal-sm modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h6 class="modal-title" id="deleteModalTitle">Xác nhận xóa</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Xóa sách <strong id="deleteBookName"></strong>?</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                <a id="deleteConfirmBtn" class="btn btn-sm btn-danger">
                    <i class="bi bi-trash me-1"></i>Xóa
                </a>
            </div>
        </div>
    </div>
</div>
<script>
function confirmDelete(id, name) {
    document.getElementById('deleteBookName').textContent = name || '';
    document.getElementById('deleteConfirmBtn').href =
        '${pageContext.request.contextPath}/admin/books/delete?id=' + id;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>

<jsp:include page="/views/common/adminFooter.jsp"/>
