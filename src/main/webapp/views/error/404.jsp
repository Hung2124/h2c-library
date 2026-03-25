<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Không tìm thấy trang"/>
<jsp:include page="/views/common/header.jsp"/>
<div class="container text-center py-5">
    <h1 class="display-1 text-muted">404</h1>
    <h3>Trang không tìm thấy</h3>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-3">Về trang chủ</a>
</div>
<jsp:include page="/views/common/footer.jsp"/>
