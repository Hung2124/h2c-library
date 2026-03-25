<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đặt lại mật khẩu"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<div class="container py-5" style="max-width:480px">
    <h3 class="fw-bold mb-4">Đặt lại mật khẩu</h3>
    <c:if test="${not empty error}">
        <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${empty token and empty error}">
        <p class="text-muted">Không có liên kết hợp lệ.</p>
        <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a>
    </c:if>
    <c:if test="${not empty token}">
        <div class="card shadow-sm">
            <div class="card-body p-4">
                <form method="post" action="${pageContext.request.contextPath}/auth/reset-password">
                    <input type="hidden" name="token" value="<c:out value='${token}'/>">
                    <div class="mb-3">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" name="password" required minlength="6" autocomplete="new-password">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nhập lại mật khẩu</label>
                        <input type="password" class="form-control" name="password2" required minlength="6" autocomplete="new-password">
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Cập nhật</button>
                </form>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="/views/common/footer.jsp"/>
