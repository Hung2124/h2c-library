<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Dashboard"/>
<jsp:include page="/views/common/adminLayout.jsp"/>

<!-- Page Header -->
<div class="admin-page-header">
    <div>
        <h1 class="admin-page-title">
            <i class="bi bi-speedometer2"></i>Dashboard
        </h1>
        <p class="admin-page-subtitle">Năm ${currentYear}</p>
    </div>
</div>

<!-- Stat Cards -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
        <div class="sl-stat-card sl-stat-books">
            <div class="card-body">
                <div class="sl-stat-icon" style="background:rgba(255,255,255,0.15)">
                    <i class="bi bi-book-fill"></i>
                </div>
                <div>
                    <div class="sl-stat-value">${totalBooks}</div>
                    <div class="sl-stat-label">Tổng số sách</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="sl-stat-card sl-stat-users">
            <div class="card-body">
                <div class="sl-stat-icon" style="background:rgba(255,255,255,0.15)">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div>
                    <div class="sl-stat-value">${totalUsers}</div>
                    <div class="sl-stat-label">Thành viên</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="sl-stat-card sl-stat-borrow">
            <div class="card-body">
                <div class="sl-stat-icon" style="background:rgba(255,255,255,0.15)">
                    <i class="bi bi-journal-arrow-up"></i>
                </div>
                <div>
                    <div class="sl-stat-value">${borrowedBooks}</div>
                    <div class="sl-stat-label">Đang mượn</div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="sl-stat-card sl-stat-overdue">
            <div class="card-body">
                <div class="sl-stat-icon" style="background:rgba(255,255,255,0.15)">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                </div>
                <div>
                    <div class="sl-stat-value">${overdueBooks}</div>
                    <div class="sl-stat-label">Quá hạn</div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Metric Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="sl-metric-card">
            <div class="sl-metric-value text-primary">${maxQty}</div>
            <div class="sl-metric-label">Mượn nhiều nhất (1 lần)</div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="sl-metric-card">
            <div class="sl-metric-value text-success">${avgQty}</div>
            <div class="sl-metric-label">Trung bình mỗi lần</div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="sl-metric-card">
            <div class="sl-metric-value" style="color:var(--sl-text-muted)">${minQty}</div>
            <div class="sl-metric-label">Mượn ít nhất (1 lần)</div>
        </div>
    </div>
</div>

<!-- Charts Row -->
<div class="row g-3">
    <div class="col-lg-7">
        <div class="sl-chart-card">
            <div class="card-header">
                <i class="bi bi-bar-chart"></i>Yêu cầu mượn theo tháng – ${currentYear}
            </div>
            <div class="sl-chart-body"><canvas id="monthChart"></canvas></div>
        </div>
    </div>
    <div class="col-lg-5">
        <div class="sl-chart-card">
            <div class="card-header">
                <i class="bi bi-book"></i>Top sách được mượn nhiều
            </div>
            <div class="sl-chart-body"><canvas id="bookChart"></canvas></div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
<script>
(function () {
    const monthData = [0,0,0,0,0,0,0,0,0,0,0,0];
    <c:forEach var="row" items="${borrowByMonth}">
    monthData[${row[0]} - 1] = ${row[1]};
    </c:forEach>

    new Chart(document.getElementById('monthChart'), {
        type: 'bar',
        data: {
            labels: ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'],
            datasets: [{
                label: 'Số yêu cầu',
                data: monthData,
                backgroundColor: 'rgba(79,70,229,0.75)',
                borderRadius: 6,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { stepSize: 1 }, grid: { color: 'rgba(0,0,0,0.04)' } },
                x: { grid: { display: false } }
            }
        }
    });

    const bookLabels = [];
    const bookValues = [];
    <c:forEach var="row" items="${mostBorrowed}">
    bookLabels.push('<c:out value="${fn:replace(row[0], \"'\", \"\\'\")}" escapeXml="false"/>');
    bookValues.push(${row[1]});
    </c:forEach>

    new Chart(document.getElementById('bookChart'), {
        type: 'bar',
        data: {
            labels: bookLabels,
            datasets: [{
                label: 'Lượt mượn',
                data: bookValues,
                backgroundColor: 'rgba(22,163,74,0.75)',
                borderRadius: 6,
                borderSkipped: false
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: 'rgba(0,0,0,0.04)' } },
                y: { grid: { display: false } }
            }
        }
    });
})();
</script>

<jsp:include page="/views/common/adminFooter.jsp"/>
