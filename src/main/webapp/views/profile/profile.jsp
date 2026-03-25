<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Hồ sơ"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<main class="container py-4">
    <h2 class="sl-section-title mb-4"><i class="bi bi-person-circle"></i> Hồ sơ cá nhân</h2>

    <c:if test="${param.success == 'updated'}">
        <div class="alert alert-success alert-dismissible fade show">
            <i class="bi bi-check-circle me-2"></i>Cập nhật hồ sơ thành công!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-circle me-2"></i><c:out value="${error}"/>
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <form method="post" action="${pageContext.request.contextPath}/profile">
                        <div class="mb-3">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" name="fullName"
                                   value="<c:out value="${sessionScope.loggedUser.fullName}"/>" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="text" class="form-control" value="<c:out value="${sessionScope.loggedUser.email}"/>"
                                   readonly disabled>
                            <small class="text-muted">Email không thể thay đổi</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Vai trò</label>
                            <input type="text" class="form-control" value="<c:out value="${sessionScope.loggedUser.role}"/>"
                                   readonly disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ngày tạo tài khoản</label>
                            <input type="text" class="form-control" value="${sessionScope.loggedUser.createdAt}"
                                   readonly disabled>
                        </div>
                        <hr class="my-4">
                        <h6 class="mb-3">Đổi mật khẩu</h6>
                        <p class="text-muted small">Để trống nếu không muốn thay đổi</p>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu hiện tại</label>
                            <input type="password" class="form-control" name="currentPassword"
                                   placeholder="••••••••">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu mới</label>
                            <input type="password" class="form-control" name="newPassword"
                                   placeholder="Tối thiểu 6 ký tự" minlength="6">
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Xác nhận mật khẩu mới</label>
                            <input type="password" class="form-control" name="confirmPassword"
                                   placeholder="Nhập lại mật khẩu mới">
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg me-2"></i>Lưu thay đổi
                        </button>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary ms-2">Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/views/common/footer.jsp"/>
