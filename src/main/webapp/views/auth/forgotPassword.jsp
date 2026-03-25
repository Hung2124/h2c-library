<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quên mật khẩu"/>
<jsp:include page="/views/common/header.jsp"/>
<jsp:include page="/views/common/navbar.jsp"/>

<div class="container py-5" style="max-width:480px">
    <h3 class="fw-bold mb-4">Quên mật khẩu</h3>
    <c:if test="${not empty error}">
        <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${not empty info}">
        <div class="alert alert-info"><c:out value="${info}"/></div>
    </c:if>
    <div class="card shadow-sm">
        <div class="card-body p-4">
            <form method="post" action="${pageContext.request.contextPath}/auth/forgot-password">
                <div class="mb-3">
                    <label class="form-label">Email đã đăng ký</label>
                    <input type="email" class="form-control" name="email" required autocomplete="email">
                </div>
                <button type="submit" class="btn btn-primary w-100">Gửi liên kết đặt lại</button>
            </form>
            <p class="small text-muted mt-3 mb-0">
                <a href="${pageContext.request.contextPath}/auth/login">Quay lại đăng nhập</a>
            </p>
        </div>
    </div>
</div>

<jsp:include page="/views/common/footer.jsp"/>
