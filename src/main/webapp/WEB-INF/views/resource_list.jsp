<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>资源中心 - ACSS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f6f8fb; }
        .resource-card { border-radius: 22px; }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <div class="small text-uppercase text-primary fw-semibold">Resource Library</div>
            <h2 class="fw-bold mb-0">共享资料库</h2>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/resource/upload" class="btn btn-primary">上传资源</a>
            <a href="${pageContext.request.contextPath}/index" class="btn btn-outline-secondary">回首页</a>
        </div>
    </div>

    <form class="card border-0 shadow-sm p-3 mb-4" method="get" action="${pageContext.request.contextPath}/resource/list">
        <div class="row g-2 align-items-center">
            <div class="col-md-10">
                <input class="form-control form-control-lg" type="search" name="keyword" value="${keyword}" placeholder="按课程名、标题、说明搜索资源">
            </div>
            <div class="col-md-2 d-grid">
                <button class="btn btn-dark btn-lg" type="submit">搜索</button>
            </div>
        </div>
    </form>

    <div class="row g-3">
        <c:forEach items="${pageInfo.list}" var="r">
            <div class="col-lg-6">
                <div class="card resource-card border-0 shadow-sm h-100">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                            <div>
                                <div class="small text-primary fw-semibold">${r.courseName} · ${r.category}</div>
                                <h4 class="fw-bold mb-1">${r.title}</h4>
                                <div class="text-muted small">${r.uploaderNickname} · 下载 ${r.downloadCount}</div>
                            </div>
                            <span class="badge text-bg-warning">积分 ${r.points}</span>
                        </div>
                        <p class="text-secondary">${fn:length(r.description) > 110 ? fn:substring(r.description, 0, 110) : r.description}</p>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/resource/detail?id=${r.id}" class="btn btn-primary btn-sm">查看详情</a>
                            <c:if test="${not empty currUser && (currUser.role == '1' || currUser.id == r.uploaderId)}">
                                <button class="btn btn-outline-danger btn-sm" onclick="doDelete(${r.id})">删除</button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty pageInfo.list}">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-5 text-center text-muted">没有找到匹配资源。</div>
                </div>
            </div>
        </c:if>
    </div>

    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item ${pageInfo.hasPreviousPage ? '' : 'disabled'}">
                <a class="page-link" href="?page=${pageInfo.prePage}&keyword=${keyword}">上一页</a>
            </li>
            <c:forEach items="${pageInfo.navigatepageNums}" var="n">
                <li class="page-item ${pageInfo.pageNum == n ? 'active' : ''}">
                    <a class="page-link" href="?page=${n}&keyword=${keyword}">${n}</a>
                </li>
            </c:forEach>
            <li class="page-item ${pageInfo.hasNextPage ? '' : 'disabled'}">
                <a class="page-link" href="?page=${pageInfo.nextPage}&keyword=${keyword}">下一页</a>
            </li>
        </ul>
    </nav>
</div>

<script>
    function doDelete(id) {
        if (!confirm('确定删除该资源吗？')) {
            return;
        }
        const params = new URLSearchParams();
        params.append('id', id);
        fetch('${pageContext.request.contextPath}/resource/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) {
            return res.json();
        }).then(function(data) {
            alert(data.msg || '处理完成');
            if (data.code === 200) {
                location.reload();
            }
        });
    }
</script>
</body>
</html>
