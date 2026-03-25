<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="st" value="${applicationScope.siteSettings}"/>
<c:set var="f1" value="${empty st['footer_line1'] ? 'H2C LIBRARY' : st['footer_line1']}"/>
<c:set var="f2" value="${empty st['footer_line2'] ? 'PRJ301 Project' : st['footer_line2']}"/>
<c:set var="showYear" value="${st['footer_show_year'] == 'true'}"/>
<footer class="site-footer py-4 mt-auto">
    <div class="container">
        <div class="row justify-content-center text-center">
            <div class="col-md-8">
                <p class="sl-footer-brand mb-2">
                    <i class="bi bi-book-half me-2"></i>H2C LIBRARY
                </p>
                <p class="sl-footer-sub mb-1">
                    Địa chỉ: Đại học FPT - khu công nghệ cao Thạch Hòa, Thạch Thất, Hòa Lạc, Hà Nội
                </p>
                <p class="sl-footer-sub mb-1">
                    SĐT: <a href="tel:+84-XXX-XXX-XXXX" class="sl-footer-link">XXX XXX XXXX</a>
                </p>
                <p class="sl-footer-sub mb-1">
                    Gmail: <a href="mailto:contact@h2clibrary.edu.vn" class="sl-footer-link">contact@h2clibrary.edu.vn</a>
                </p>
                <c:if test="${showYear}">
                    <p class="sl-footer-sub mb-0">&copy; <%= java.time.Year.now() %> H2C LIBRARY. PRJ301 Project.</p>
                </c:if>
            </div>
        </div>
    </div>
</footer>
<jsp:include page="/views/common/chatWidget.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
