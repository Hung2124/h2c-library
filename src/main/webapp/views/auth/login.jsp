<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng nhập"/>
<jsp:include page="/views/common/header.jsp"/>

<div class="auth-page-wrapper">
<div class="container d-flex justify-content-center align-items-center py-5">
    <div class="card shadow-lg border-0" style="width:420px;border-radius:16px">
        <div class="card-body p-4">
            <div class="text-center mb-4">
                <i class="bi bi-book-half text-primary" style="font-size:2.75rem;"></i>
                <h4 class="mt-3 fw-bold">H2C LIBRARY</h4>
                <p class="text-muted small">Đăng nhập vào tài khoản của bạn</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2"><i class="bi bi-exclamation-circle me-2"></i><c:out value="${error}"/></div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success py-2"><i class="bi bi-check-circle me-2"></i><c:out value="${success}"/></div>
            </c:if>
            <c:if test="${param.logout == 'true'}">
                <div class="alert alert-info py-2">Bạn đã đăng xuất thành công.</div>
            </c:if>
            <c:if test="${param.reset == 'ok'}">
                <div class="alert alert-success py-2">Đặt lại mật khẩu thành công. Vui lòng đăng nhập.</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/auth/login">
                <c:if test="${not empty param.redirect}">
                    <input type="hidden" name="redirect" value="${param.redirect}">
                </c:if>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" class="form-control" name="email"
                               value="<c:out value="${email}"/>" required placeholder="email@example.com">
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input type="password" class="form-control" name="password" required placeholder="••••••">
                    </div>
                </div>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="bi bi-box-arrow-in-right me-2"></i>Đăng nhập
                </button>
            </form>
            <p class="text-center small mt-2 mb-0">
                <a href="${pageContext.request.contextPath}/auth/forgot-password">Quên mật khẩu?</a>
            </p>

            <hr>
            <p class="text-center mb-0 small">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/auth/register">Đăng ký ngay</a>
            </p>
            <p class="text-center mb-0 small text-muted mt-1">
                Demo: admin@library.com / Admin@123
            </p>
        </div>
    </div>
</div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
