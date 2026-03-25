<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- fmt:formatDate không hỗ trợ java.time.LocalDateTime (requestDate) --%>
<c:set var="pageTitle" value="Yêu cầu mượn"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title"><i class="bi bi-clipboard-check"></i>Yêu cầu mượn sách</h1>
        <p class="admin-page-subtitle">Tổng: <strong>${totalItems}</strong> yêu cầu</p>
    </div>
</div>

<c:if test="${not empty param.success}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Thao tác thành công!
        <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Status Filter Pills -->
<div class="d-flex flex-wrap gap-2 mb-4">
    <a href="${pageContext.request.contextPath}/admin/borrows/list"
       class="btn btn-sm ${empty statusFilter ? 'btn-primary' : 'btn-outline-secondary'}">
        <i class="bi bi-list me-1"></i>Tất cả
    </a>
    <a href="?status=PENDING"
       class="btn btn-sm ${statusFilter == 'PENDING' ? 'btn-warning' : 'btn-outline-secondary'}">
        <i class="bi bi-hourglass-split me-1"></i>Chờ duyệt
    </a>
    <a href="?status=APPROVED"
       class="btn btn-sm ${statusFilter == 'APPROVED' ? 'btn-success' : 'btn-outline-secondary'}">
        <i class="bi bi-check-circle me-1"></i>Đã duyệt
    </a>
    <a href="?status=REJECTED"
       class="btn btn-sm ${statusFilter == 'REJECTED' ? 'btn-danger' : 'btn-outline-secondary'}">
        <i class="bi bi-x-circle me-1"></i>Từ chối
    </a>
    <a href="?status=RETURNED"
       class="btn btn-sm ${statusFilter == 'RETURNED' ? 'btn-secondary' : 'btn-outline-secondary'}">
        <i class="bi bi-arrow-return-left me-1"></i>Đã trả
    </a>
</div>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="text-center" style="width:60px">#ID</th>
                        <th>Người mượn</th>
                        <th style="min-width:160px">Ngày yêu cầu</th>
                        <th class="text-center" style="width:120px">Số sách</th>
                        <th style="min-width:130px">Trạng thái</th>
                        <th class="text-center" style="min-width:200px">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty requests}">
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <i class="bi bi-clipboard-x" style="font-size:2rem;opacity:.3;display:block;margin-bottom:.5rem"></i>
                                    <span class="text-muted">Không có yêu cầu nào.</span>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="borrowReq" items="${requests}">
                                <tr>
                                    <td class="text-center">
                                        <span class="fw-semibold text-muted">#${borrowReq.id}</span>
                                    </td>
                                    <td>
                                        <div class="fw-semibold"><c:out value="${borrowReq.user.fullName}"/></div>
                                        <div class="small text-muted"><c:out value="${borrowReq.user.email}"/></div>
                                    </td>
                                    <td>
                                        ${borrowReq.requestDate}
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-info text-dark">${fn:length(borrowReq.details)} cuốn</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${borrowReq.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark">
                                                    <i class="bi bi-hourglass-split me-1"></i>Chờ duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${borrowReq.status == 'APPROVED'}">
                                                <span class="badge bg-success">
                                                    <i class="bi bi-check-circle-fill me-1"></i>Đã duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${borrowReq.status == 'REJECTED'}">
                                                <span class="badge bg-danger">
                                                    <i class="bi bi-x-circle-fill me-1"></i>Từ chối
                                                </span>
                                            </c:when>
                                            <c:when test="${borrowReq.status == 'RETURNED'}">
                                                <span class="badge bg-secondary">
                                                    <i class="bi bi-arrow-return-left me-1"></i>Đã trả
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/admin/borrows/detail?id=${borrowReq.id}"
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-eye me-1"></i>Chi tiết
                                        </a>
                                        <c:if test="${borrowReq.status == 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/borrows/approve" class="d-inline">
                                                <input type="hidden" name="id" value="${borrowReq.id}">
                                                <input type="hidden" name="dueDays" value="14">
                                                <button class="btn btn-sm btn-success" title="Duyệt">
                                                    <i class="bi bi-check-lg"></i>
                                                </button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/borrows/reject" class="d-inline">
                                                <input type="hidden" name="id" value="${borrowReq.id}">
                                                <button class="btn btn-sm btn-outline-danger" title="Từ chối"
                                                        onclick="return confirm('Từ chối yêu cầu #${borrowReq.id}?')">
                                                    <i class="bi bi-x-lg"></i>
                                                </button>
                                            </form>
                                        </c:if>
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

<c:if test="${totalPages > 1}">
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${totalPages}" var="p">
                <li class="page-item ${p == currentPage ? 'active' : ''}">
                    <a class="page-link" href="?status=${statusFilter}&page=${p}">${p}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</c:if>

<jsp:include page="/views/common/adminFooter.jsp"/>
