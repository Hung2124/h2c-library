<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${book != null ? 'Sửa sách' : 'Thêm sách'}"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">
            <i class="bi bi-arrow-left me-2" style="font-size:1rem;opacity:.6"></i>
            <c:choose>
                <c:when test="${book != null}">Sửa sách</c:when>
                <c:otherwise>Thêm sách mới</c:otherwise>
            </c:choose>
        </h1>
        <p class="admin-page-subtitle">
            <c:if test="${book != null}"><c:out value="${book.title}"/></c:if>
        </p>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger"><i class="bi bi-x-circle me-2"></i><c:out value="${error}"/></div>
</c:if>

<div class="card">
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/admin/books/save"
              enctype="multipart/form-data">
            <c:if test="${book != null}">
                <input type="hidden" name="id" value="${book.id}">
            </c:if>

            <div class="row g-4">
                <div class="col-md-8">
                    <label class="form-label">Tên sách <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="title" required
                           value="<c:out value="${book != null ? book.title : ''}"/>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="AVAILABLE" ${book == null || book.status == 'AVAILABLE' ? 'selected' : ''}>Khả dụng</option>
                        <option value="UNAVAILABLE" ${book != null && book.status == 'UNAVAILABLE' ? 'selected' : ''}>Ẩn</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Tác giả</label>
                    <select class="form-select" name="authorId">
                        <option value="">— Chọn tác giả —</option>
                        <c:forEach var="author" items="${authors}">
                            <option value="${author.id}"
                                ${book != null && book.author != null && book.author.id == author.id ? 'selected' : ''}>
                                <c:out value="${author.name}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Danh mục</label>
                    <select class="form-select" name="categoryId">
                        <option value="">— Chọn danh mục —</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}"
                                ${book != null && book.category != null && book.category.id == cat.id ? 'selected' : ''}>
                                <c:out value="${cat.name}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Nhà xuất bản</label>
                    <select class="form-select" name="publisherId">
                        <option value="">— Chọn NXB —</option>
                        <c:forEach var="pub" items="${publishers}">
                            <option value="${pub.id}"
                                ${book != null && book.publisher != null && book.publisher.id == pub.id ? 'selected' : ''}>
                                <c:out value="${pub.name}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Năm xuất bản</label>
                    <input type="number" class="form-control" name="publishYear" min="1900" max="2099"
                           value="${book != null ? book.publishYear : ''}">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Ngôn ngữ</label>
                    <input type="text" class="form-control" name="language"
                           value="<c:out value="${book != null ? book.language : ''}"/>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Tổng số quyển</label>
                    <input type="number" class="form-control" name="quantity" min="0"
                           value="${book != null ? book.quantity : 0}">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Quyển khả dụng</label>
                    <input type="number" class="form-control" name="availableQuantity" min="0"
                           value="${book != null ? book.availableQuantity : 0}">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Ảnh bìa</label>
                    <input type="file" class="form-control" name="image" accept="image/*">
                    <c:if test="${book != null and not empty book.image}">
                        <div class="mt-2">
                            <c:choose>
                                <c:when test="${fn:startsWith(book.image, 'assets/')}"><c:set var="bookImgSrc" value="${pageContext.request.contextPath}/${book.image}"/></c:when>
                                <c:otherwise><c:set var="bookImgSrc" value="${pageContext.request.contextPath}/assets/images/uploads/${book.image}"/></c:otherwise>
                            </c:choose>
                            <img src="${bookImgSrc}" class="sl-img-preview" alt="current">
                            <span class="form-text d-block">Upload ảnh mới để thay thế.</span>
                        </div>
                    </c:if>
                </div>
                <div class="col-12">
                    <label class="form-label">Mô tả / Giới thiệu</label>
                    <textarea class="form-control" name="description" id="description" rows="8"><c:out value="${book != null ? book.description : ''}"/></textarea>
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-floppy me-2"></i>Lưu
                </button>
                <a href="${pageContext.request.contextPath}/admin/books/list" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>

<!-- CKEditor 5 -->
<script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<script>
ClassicEditor.create(document.querySelector('#description')).catch(err => console.error(err));
</script>

<jsp:include page="/views/common/adminFooter.jsp"/>
