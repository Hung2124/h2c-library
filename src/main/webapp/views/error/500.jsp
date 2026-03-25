<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Lỗi hệ thống"/>
<jsp:include page="/views/common/header.jsp"/>
<div class="container text-center py-5">
    <h1 class="display-1 text-danger">500</h1>
    <h3>Lỗi hệ thống</h3>
    <p class="text-muted">Đã xảy ra lỗi. Vui lòng thử lại sau.</p>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-3">Về trang chủ</a>
</div>
<jsp:include page="/views/common/footer.jsp"/>
