<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Chi tiết yêu cầu #${request.id}"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">
            <i class="bi bi-arrow-left me-2" style="font-size:1rem;opacity:.6"></i>
            Yêu cầu mượn #${request.id}
        </h1>
    </div>
</div>

<div class="row g-3 mb-4">
    <div class="col-md-6">
        <div class="card">
            <div class="card-body">
                <h6 class="fw-bold mb-3">Thông tin người mượn</h6>
                <p class="mb-1"><strong>Họ tên:</strong> <c:out value="${request.user.fullName}"/></p>
                <p class="mb-1"><strong>Email:</strong> <c:out value="${request.user.email}"/></p>
                <p class="mb-1"><strong>Ngày yêu cầu:</strong> ${request.requestDate}</p>
                <p class="mb-0"><strong>Trạng thái:</strong>
                    <c:choose>
                        <c:when test="${request.status == 'PENDING'}"><span class="sl-badge sl-borrow-pending"><i class="bi bi-hourglass-split"></i>Chờ duyệt</span></c:when>
                        <c:when test="${request.status == 'APPROVED'}"><span class="sl-badge sl-borrow-borrowing"><i class="bi bi-check-circle-fill"></i>Đã duyệt</span></c:when>
                        <c:when test="${request.status == 'REJECTED'}"><span class="sl-badge sl-borrow-overdue"><i class="bi bi-x-circle-fill"></i>Từ chối</span></c:when>
                        <c:when test="${request.status == 'RETURNED'}"><span class="sl-badge sl-borrow-returned"><i class="bi bi-arrow-return-left"></i>Đã trả</span></c:when>
                    </c:choose>
                </p>
                <c:if test="${request.approvedBy != null}">
                    <p class="mb-0 mt-2 small text-muted">Duyệt bởi: <c:out value="${request.approvedBy.fullName}"/> (${request.approvedDate})</p>
                </c:if>
            </div>
        </div>
    </div>
    <c:if test="${request.status == 'PENDING'}">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h6 class="fw-bold mb-3">Thao tác</h6>
                    <form method="post" action="${pageContext.request.contextPath}/admin/borrows/approve"
                          class="d-flex align-items-end gap-2 mb-3">
                        <input type="hidden" name="id" value="${request.id}">
                        <div>
                            <label class="form-label small mb-1">Số ngày mượn</label>
                            <input type="number" name="dueDays" value="14" min="1" max="60"
                                   class="form-control form-control-sm" style="width:80px">
                        </div>
                        <button class="btn btn-success">
                            <i class="bi bi-check-lg me-1"></i>Duyệt
                        </button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/admin/borrows/reject">
                        <input type="hidden" name="id" value="${request.id}">
                        <button class="btn btn-outline-danger" onclick="return confirm('Từ chối yêu cầu này?')">
                            <i class="bi bi-x-lg me-1"></i>Từ chối
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </c:if>
</div>

<div class="card">
    <div class="card-header">
        <i class="bi bi-list-ul"></i>Chi tiết sách mượn
    </div>
    <div class="card-body p-0">
        <table class="table table-hover mb-0 table-responsive-stack">
            <thead>
                <tr>
                    <th>Tên sách</th>
                    <th>Số lượng</th>
                    <th>Hạn trả</th>
                    <th>Ngày trả</th>
                    <th>Phạt</th>
                    <th>Trạng thái</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="d" items="${request.details}">
                    <tr>
                        <td data-label="Tên sách">
                            <span class="fw-semibold"><c:out value="${d.book.title}"/></span>
                        </td>
                        <td data-label="Số lượng">${d.quantity}</td>
                        <td data-label="Hạn trả">
                            <c:choose>
                                <c:when test="${not empty d.dueDate}">${d.dueDate}</c:when>
                                <c:otherwise><span class="text-muted">–</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td data-label="Ngày trả">
                            <c:choose>
                                <c:when test="${not empty d.returnDate}">${d.returnDate}</c:when>
                                <c:otherwise><span class="text-muted">–</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td data-label="Phạt">
                            <c:choose>
                                <c:when test="${d.fineAmount != null and d.fineAmount.signum() gt 0}">
                                    <span class="sl-badge sl-badge-danger">${d.fineAmount} đ</span>
                                </c:when>
                                <c:otherwise><span class="text-muted">–</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td data-label="Trạng thái">
                            <c:choose>
                                <c:when test="${d.status == 'BORROWING'}"><span class="sl-badge sl-badge-info"><i class="bi bi-journal"></i>Đang mượn</span></c:when>
                                <c:when test="${d.status == 'RETURNED'}"><span class="sl-badge sl-badge-success"><i class="bi bi-check-circle-fill"></i>Đã trả</span></c:when>
                                <c:when test="${d.status == 'OVERDUE'}"><span class="sl-badge sl-badge-danger"><i class="bi bi-exclamation-triangle-fill"></i>Quá hạn</span></c:when>
                            </c:choose>
                        </td>
                        <td data-label="Thao tác">
                            <c:if test="${d.status == 'BORROWING' and request.status == 'APPROVED'}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/borrows/return">
                                    <input type="hidden" name="detailId" value="${d.id}">
                                    <button class="btn btn-sm btn-outline-success"
                                            onclick="return confirm('Xác nhận đã nhận lại sách &quot;<c:out value='${d.book.title}'/>&quot;?')">
                                        <i class="bi bi-box-arrow-in-down me-1"></i>Xác nhận trả
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/views/common/adminFooter.jsp"/>
