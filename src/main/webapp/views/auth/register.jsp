<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng ký"/>
<jsp:include page="/views/common/header.jsp"/>

<div class="auth-page-wrapper">
<div class="container d-flex justify-content-center align-items-center py-5">
    <div class="card shadow-lg border-0" style="width:460px;border-radius:16px">
        <div class="card-body p-4">
            <div class="text-center mb-4">
                <i class="bi bi-person-plus text-primary" style="font-size:2.75rem;"></i>
                <h4 class="mt-3 fw-bold">Tạo tài khoản</h4>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2"><i class="bi bi-exclamation-circle me-2"></i><c:out value="${error}"/></div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/auth/register">
                <div class="mb-3">
                    <label class="form-label">Họ và tên</label>
                    <input type="text" class="form-control" name="fullName"
                           value="<c:out value="${fullName}"/>" required placeholder="Nguyễn Văn A">
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" name="email"
                           value="<c:out value="${email}"/>" required placeholder="email@example.com">
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" class="form-control" name="password" required
                           placeholder="Tối thiểu 6 ký tự" minlength="6">
                </div>
                <div class="mb-4">
                    <label class="form-label">Xác nhận mật khẩu</label>
                    <input type="password" class="form-control" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
                </div>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="bi bi-person-check me-2"></i>Đăng ký
                </button>
            </form>

            <hr>
            <p class="text-center mb-0 small">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a>
            </p>
        </div>
    </div>
</div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
