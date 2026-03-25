<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Cài đặt chân trang &amp; email"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title"><i class="bi bi-sliders"></i>Cài đặt website</h1>
        <p class="admin-page-subtitle">Chỉnh nội dung chân trang trang chủ và bật/tắt gửi email.</p>
    </div>
</div>

<c:if test="${param.success == 'saved'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Đã lưu cài đặt.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Footer Settings -->
<div class="card mb-4">
    <div class="card-header">
        <i class="bi bi-layout-text-sidebar"></i>Chân trang (trang chủ)
    </div>
    <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/admin/settings">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Dòng tiêu đề</label>
                    <input type="text" class="form-control" name="footer_line1"
                           value="<c:out value="${settings['footer_line1']}"/>"
                           placeholder="Ví dụ: H2C LIBRARY">
                </div>
                <div class="col-md-6">
                    <label class="form-label">Dòng phụ / mô tả</label>
                    <input type="text" class="form-control" name="footer_line2"
                           value="<c:out value="${settings['footer_line2']}"/>"
                           placeholder="Ví dụ: Thư viện trường…">
                </div>
            </div>
            <div class="form-check mt-3">
                <input class="form-check-input" type="checkbox" name="footer_show_year" id="fy"
                    ${settings['footer_show_year'] == 'true' ? 'checked' : ''}>
                <label class="form-check-label" for="fy">Hiển thị năm hiện tại bên cạnh bản quyền</label>
            </div>

            <hr class="sl-divider">

            <!-- Email Settings -->
            <h6 class="fw-bold mb-3">
                <i class="bi bi-envelope me-2 text-primary"></i>Email &amp; gia hạn mượn
            </h6>
            <div class="form-check mb-3">
                <input class="form-check-input" type="checkbox" name="mail_enabled" id="me"
                    ${settings['mail_enabled'] == 'true' ? 'checked' : ''}>
                <label class="form-check-label" for="me">Bật gửi email (quá hạn, quên mật khẩu)</label>
            </div>
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Số lần gia hạn tối đa / cuốn</label>
                    <input type="number" min="0" max="10" class="form-control" name="max_borrow_renewals"
                           value="<c:out value="${empty settings['max_borrow_renewals'] ? '2' : settings['max_borrow_renewals']}"/>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Mỗi lần gia hạn thêm (ngày)</label>
                    <input type="number" min="1" max="90" class="form-control" name="renew_extend_days"
                           value="<c:out value="${empty settings['renew_extend_days'] ? '14' : settings['renew_extend_days']}"/>">
                </div>
            </div>

            <button type="submit" class="btn btn-primary mt-4">
                <i class="bi bi-floppy me-2"></i>Lưu cài đặt
            </button>
        </form>
    </div>
</div>

<jsp:include page="/views/common/adminFooter.jsp"/>
