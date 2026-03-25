<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="${publisher != null ? 'Sửa NXB' : 'Thêm NXB'}"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">
            <i class="bi bi-arrow-left me-2" style="font-size:1rem;opacity:.6"></i>
            <c:choose>
                <c:when test="${publisher != null}">Sửa nhà xuất bản</c:when>
                <c:otherwise>Thêm nhà xuất bản</c:otherwise>
            </c:choose>
        </h1>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger"><i class="bi bi-x-circle me-2"></i><c:out value="${error}"/></div>
</c:if>

<div class="card" style="max-width:560px">
    <div class="card-body">
        <form method="post" accept-charset="UTF-8"
              action="${pageContext.request.contextPath}/admin/publishers/save">
            <c:if test="${publisher != null}">
                <input type="hidden" name="id" value="${publisher.id}">
            </c:if>
            <div class="mb-3">
                <label class="form-label">Tên <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="name" required
                       value="<c:out value="${publisher != null ? publisher.name : ''}"/>">
            </div>
            <div class="mb-3">
                <label class="form-label">Ghi chú</label>
                <textarea class="form-control" name="note" rows="3"><c:out value="${publisher != null ? publisher.note : ''}"/></textarea>
            </div>
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-floppy me-2"></i>Lưu
            </button>
        </form>
    </div>
</div>

<jsp:include page="/views/common/adminFooter.jsp"/>
