<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- fmt taglib not used for LocalDateTime --%>
<c:set var="pageTitle" value="Lịch sử mượn sách"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<main class="container py-4">
    <h2 class="sl-section-title mb-4"><i class="bi bi-clock-history"></i> Lịch sử mượn sách</h2>

    <c:if test="${param.success == 'submitted'}">
        <div class="alert alert-success">
            <i class="bi bi-check-circle me-2"></i>Yêu cầu mượn đã được gửi thành công! Vui lòng chờ thủ thư xét duyệt.
        </div>
    </c:if>
    <c:if test="${param.renewSuccess == '1'}">
        <div class="alert alert-success alert-dismissible fade show">Gia hạn mượn thành công.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>
    <c:if test="${param.renewError == 'overdue'}">
        <div class="alert alert-warning alert-dismissible fade show">Không gia hạn khi đã quá hạn. Vui lòng liên hệ thư viện.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>
    <c:if test="${param.renewError == 'max'}">
        <div class="alert alert-warning alert-dismissible fade show">Bạn đã dùng hết số lần gia hạn cho cuốn này.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>
    <c:if test="${not empty param.renewError and param.renewError != 'overdue' and param.renewError != 'max'}">
        <div class="alert alert-danger alert-dismissible fade show">Không thể gia hạn (yêu cầu không hợp lệ hoặc không thuộc về bạn).
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>

    <c:choose>
        <c:when test="${empty history}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox" style="font-size:4rem"></i>
                <p class="mt-3">Bạn chưa có yêu cầu mượn nào.</p>
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary mt-2">
                    Tìm sách để mượn
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="borrowReq" items="${history}">
                <div class="card shadow-sm mb-3">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>
                            <i class="bi bi-receipt me-2"></i>
                            Yêu cầu #<strong>${borrowReq.id}</strong>
                            &nbsp;–&nbsp;
                            ${borrowReq.requestDate}
                        </span>
                        <c:choose>
                            <c:when test="${borrowReq.status == 'PENDING'}">
                                <span class="badge bg-warning text-dark">Đang chờ duyệt</span>
                            </c:when>
                            <c:when test="${borrowReq.status == 'APPROVED'}">
                                <span class="badge bg-success">Đã duyệt</span>
                            </c:when>
                            <c:when test="${borrowReq.status == 'REJECTED'}">
                                <span class="badge bg-danger">Từ chối</span>
                            </c:when>
                            <c:when test="${borrowReq.status == 'RETURNED'}">
                                <span class="badge bg-secondary">Đã trả</span>
                            </c:when>
                        </c:choose>
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-sm mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Tên sách</th>
                                    <th>Số lượng</th>
                                    <th>Hạn trả</th>
                                    <th>Ngày trả</th>
                                    <th>Phạt</th>
                                    <th>Trạng thái</th>
                                    <th>Gia hạn</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="detail" items="${borrowReq.details}">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/books/detail?id=${detail.book.id}"
                                               class="text-decoration-none">
                                                <c:out value="${detail.book.title}"/>
                                            </a>
                                        </td>
                                        <td>${detail.quantity}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty detail.dueDate}">
                                                    ${detail.dueDate}
                                                </c:when>
                                                <c:otherwise>–</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty detail.returnDate}">
                                                    ${detail.returnDate}
                                                </c:when>
                                                <c:otherwise>–</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${detail.fineAmount != null and detail.fineAmount.signum() gt 0}">
                                                    <span class="text-danger fw-bold">
                                                        ${detail.fineAmount} đ
                                                    </span>
                                                </c:when>
                                                <c:otherwise>0 đ</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${detail.status == 'BORROWING'}">
                                                    <span class="badge bg-primary">Đang mượn</span>
                                                </c:when>
                                                <c:when test="${detail.status == 'RETURNED'}">
                                                    <span class="badge bg-secondary">Đã trả</span>
                                                </c:when>
                                                <c:when test="${detail.status == 'OVERDUE'}">
                                                    <span class="badge bg-danger">Quá hạn</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${borrowReq.status == 'APPROVED' and detail.status == 'BORROWING'}">
                                                <form method="post" action="${pageContext.request.contextPath}/borrow/renew" class="d-inline">
                                                    <input type="hidden" name="detailId" value="${detail.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-primary">Gia hạn</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${detail.renewalCount > 0}">
                                                <div class="small text-muted mt-1">Đã gia hạn ${detail.renewalCount} lần</div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/views/common/footer.jsp"/>
