<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${category != null ? 'Sửa danh mục' : 'Thêm danh mục'}"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">
            <i class="bi bi-arrow-left me-2" style="font-size:1rem;opacity:.6"></i>
            <c:choose>
                <c:when test="${category != null}">Sửa danh mục</c:when>
                <c:otherwise>Thêm danh mục</c:otherwise>
            </c:choose>
        </h1>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger"><i class="bi bi-x-circle me-2"></i><c:out value="${error}"/></div>
</c:if>

<div class="card" style="max-width:560px">
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/admin/categories/save">
            <c:if test="${category != null}">
                <input type="hidden" name="id" value="${category.id}">
            </c:if>
            <div class="mb-3">
                <label class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="name" required
                       value="<c:out value="${category != null ? category.name : ''}"/>">
            </div>
            <div class="mb-3">
                <label class="form-label">Mô tả</label>
                <textarea class="form-control" name="description" rows="3"><c:out value="${category != null ? category.description : ''}"/></textarea>
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-floppy me-2"></i>Lưu
                </button>
                <a href="${pageContext.request.contextPath}/admin/categories/list" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/views/common/adminFooter.jsp"/>
