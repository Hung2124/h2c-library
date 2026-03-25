<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Tác giả"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title"><i class="bi bi-person-lines-fill"></i>Quản lý tác giả</h1>
        <p class="admin-page-subtitle">Mỗi sách gắn một tác giả. Không xóa được nếu còn sách thuộc tác giả đó.</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/authors/new" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>Thêm tác giả
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
        <i class="bi bi-check-circle me-2"></i>Đã xóa tác giả.
        <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'author_in_use'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Không xóa được: còn sách gắn với tác giả này.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'delete_failed'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Xóa thất bại.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0 table-responsive-stack">
                <thead>
                    <tr><th>#</th><th>Tên tác giả</th><th>Tiểu sử</th><th style="min-width:120px">Thao tác</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="author" items="${authors}" varStatus="st">
                        <tr>
                            <td data-label="#">${st.index + 1}</td>
                            <td data-label="Tên">
                                <span class="fw-semibold"><c:out value="${author.name}"/></span>
                            </td>
                            <td data-label="Tiểu sử" class="text-muted" style="max-width:320px">
                                <c:choose>
                                    <c:when test="${not empty author.bio}">
                                        <c:out value="${author.bio}"/>
                                    </c:when>
                                    <c:otherwise><span class="fst-italic">Không có tiểu sử</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Thao tác">
                                <a href="${pageContext.request.contextPath}/admin/authors/edit?id=${author.id}"
                                   class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/authors/delete?id=${author.id}"
                                   class="btn btn-sm btn-outline-danger" title="Xóa"
                                   onclick="return confirm('Xóa tác giả &quot;<c:out value='${author.name}'/>&quot;?')">
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
