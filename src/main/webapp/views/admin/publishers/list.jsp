<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Nhà xuất bản"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title"><i class="bi bi-building"></i>Nhà xuất bản</h1>
        <p class="admin-page-subtitle">Thêm NXB trước khi tạo/sửa sách. Không xóa được nếu còn sách gắn NXB này.</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/publishers/new" class="btn btn-primary">
        <i class="bi bi-plus-lg me-1"></i>Thêm NXB
    </a>
</div>

<c:if test="${param.success == 'saved'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Đã lưu.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.success == 'deleted'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Đã xóa.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'publisher_in_use'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Không xóa được: còn sách đang gắn NXB này.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'delete_failed'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Xóa thất bại.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.success == 'merged'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Đã gộp NXB trùng: sách đã chuyển sang bản ghi đúng tên.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'duplicate_name'}">
    <div class="alert alert-warning alert-dismissible fade show">
        <i class="bi bi-exclamation-triangle me-2"></i>Tên nhà xuất bản đã tồn tại. Chọn bản ghi đó hoặc đổi tên khác.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'merge_failed' || param.error == 'save_failed'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Lưu thất bại. Thử lại hoặc kiểm tra trùng tên trong CSDL.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
<c:if test="${param.error == 'not_found'}">
    <div class="alert alert-danger alert-dismissible fade show">
        <i class="bi bi-x-circle me-2"></i>Không tìm thấy bản ghi cần sửa.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0 table-responsive-stack">
                <thead>
                    <tr><th>#</th><th>Tên</th><th>Ghi chú</th><th style="min-width:120px">Thao tác</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${publishers}" varStatus="st">
                        <tr>
                            <td data-label="#">${st.index + 1}</td>
                            <td data-label="Tên"><span class="fw-semibold"><c:out value="${p.name}"/></span></td>
                            <td data-label="Ghi chú" class="text-muted" style="max-width:280px">
                                <c:choose>
                                    <c:when test="${not empty p.note}"><c:out value="${p.note}"/></c:when>
                                    <c:otherwise><span class="fst-italic">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Thao tác">
                                <a href="${pageContext.request.contextPath}/admin/publishers/edit?id=${p.id}"
                                   class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/publishers/delete?id=${p.id}"
                                   class="btn btn-sm btn-outline-danger" title="Xóa"
                                   onclick="return confirm('Xóa NXB &quot;<c:out value='${p.name}'/>&quot;?')">
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
