<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Người dùng"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title"><i class="bi bi-people"></i>Quản lý người dùng</h1>
        <p class="admin-page-subtitle">Tổng: <strong>${totalItems}</strong> người dùng</p>
    </div>
</div>

<c:if test="${param.success == 'updated'}">
    <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle me-2"></i>Cập nhật thành công!
        <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<div class="card">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0 table-responsive-stack">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th style="min-width:200px">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}" varStatus="st">
                        <tr>
                            <td data-label="#">${st.index + 1}</td>
                            <td data-label="Họ tên">
                                <div class="sl-avatar me-2" style="display:inline-flex;vertical-align:middle">
                                    ${fn:toUpperCase(fn:substring(user.fullName,0,1))}
                                </div>
                                <c:out value="${user.fullName}"/>
                            </td>
                            <td data-label="Email"><c:out value="${user.email}"/></td>
                            <td data-label="Vai trò">
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}">
                                        <span class="sl-badge sl-role-admin">
                                            <i class="bi bi-shield-check"></i>Admin
                                        </span>
                                    </c:when>
                                    <c:when test="${user.role == 'LIBRARIAN'}">
                                        <span class="sl-badge sl-role-librarian">
                                            <i class="bi bi-person-badge"></i>Librarian
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="sl-badge sl-role-member">
                                            <i class="bi bi-person"></i>Member
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Trạng thái">
                                <c:choose>
                                    <c:when test="${user.status == 'ACTIVE'}">
                                        <span class="sl-badge sl-badge-success">
                                            <i class="bi bi-check-circle-fill"></i>Active
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="sl-badge sl-badge-neutral">
                                            <i class="bi bi-dash-circle-fill"></i>Inactive
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td data-label="Ngày tạo">${user.createdAt}</td>
                            <td data-label="Thao tác">
                                <form method="post" action="${pageContext.request.contextPath}/admin/users/update" class="d-inline">
                                    <input type="hidden" name="id" value="${user.id}">
                                    <select name="status" class="form-select form-select-sm d-inline-block w-auto me-1"
                                            onchange="this.form.submit()">
                                        <option value="ACTIVE"   ${user.status == 'ACTIVE'   ? 'selected' : ''}>Active</option>
                                        <option value="INACTIVE"${user.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<c:if test="${totalPages > 1}">
    <nav class="mt-3">
        <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${totalPages}" var="p">
                <li class="page-item ${p == currentPage ? 'active' : ''}">
                    <a class="page-link" href="?page=${p}">${p}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</c:if>

<jsp:include page="/views/common/adminFooter.jsp"/>
