<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Danh mục"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title"><i class="bi bi-tags"></i>Quản lý danh mục</h1>
        <p class="admin-page-subtitle">Phân loại sách – không xóa được nếu còn sách dùng danh mục này.</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/categories/new" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>Thêm danh mục
    </a>
</div>

<c:if test="${param.success == 'saved'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Lưu thành công!
        <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.success == 'deleted'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Đã xóa.
        <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'category_in_use'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Không xóa được: còn sách đang dùng danh mục này. Hãy đổi danh mục của các sách trước.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'delete_failed'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Xóa thất bại. Thử lại sau.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0 table-responsive-stack">
                <thead>
                    <tr><th>#</th><th>Tên danh mục</th><th>Mô tả</th><th style="min-width:120px">Thao tác</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="cat" items="${categories}" varStatus="st">
                        <tr>
                            <td data-label="#">${st.index + 1}</td>
                            <td data-label="Tên">
                                <span class="fw-semibold"><c:out value="${cat.name}"/></span>
                            </td>
                            <td data-label="Mô tả">
                                <c:choose>
                                    <c:when test="${not empty cat.description}">
                                        <span class="text-muted"><c:out value="${cat.description}"/></span>
                                    </c:when>
                                    <c:otherwise><span class="text-muted fst-italic">Không có mô tả</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Thao tác">
                                <a href="${pageContext.request.contextPath}/admin/categories/edit?id=${cat.id}"
                                   class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/categories/delete?id=${cat.id}"
                                   class="btn btn-sm btn-outline-danger" title="Xóa"
                                   onclick="return confirm('Xóa danh mục &quot;<c:out value='${cat.name}'/>&quot;?')">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/views/common/adminFooter.jsp"/>
