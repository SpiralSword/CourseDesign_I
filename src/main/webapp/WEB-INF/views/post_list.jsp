<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>课程社区 - ACSS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f7fb; }
        .post-card { border-radius: 22px; }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <div class="small text-uppercase text-primary fw-semibold">Course Community</div>
            <h2 class="fw-bold mb-0">课程讨论区</h2>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/post/publish">发布帖子</a>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/index">回首页</a>
        </div>
    </div>

    <form class="card border-0 shadow-sm p-3 mb-4" method="get" action="${pageContext.request.contextPath}/post/list">
        <div class="row g-2">
            <div class="col-md-10">
                <input class="form-control form-control-lg" type="search" name="keyword" value="${keyword}" placeholder="按课程名、标题、内容搜索讨论">
            </div>
            <div class="col-md-2 d-grid">
                <button class="btn btn-dark btn-lg" type="submit">搜索</button>
            </div>
        </div>
    </form>

    <div class="row g-3">
        <c:forEach items="${pageInfo.list}" var="post">
            <div class="col-lg-6">
                <div class="card post-card border-0 shadow-sm h-100">
                    <div class="card-body p-4">
                        <div class="small text-primary fw-semibold mb-2">${post.courseName}</div>
                        <h4 class="fw-bold">${post.title}</h4>
                        <div class="text-muted small mb-2">${post.authorNickname} · 点赞 ${post.likeCount} · 回复 ${post.replyCount}</div>
                        <p class="text-secondary">${fn:length(post.content) > 120 ? fn:substring(post.content, 0, 120) : post.content}</p>
                        <div class="d-flex gap-2">
                            <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/post/detail?id=${post.id}">查看讨论</a>
                            <c:if test="${not empty currUser && (currUser.role == '1' || currUser.id == post.userId)}">
                                <button class="btn btn-outline-danger btn-sm" onclick="deletePost(${post.id})">删除</button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty pageInfo.list}">
            <div class="col-12">
                <div class="card border-0 shadow-sm">
                    <div class="card-body text-center text-muted p-5">还没有相关帖子，发起第一条讨论吧。</div>
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
    function deletePost(id) {
        if (!confirm('确定删除该帖子吗？')) {
            return;
        }
        const params = new URLSearchParams();
        params.append('id', id);
        fetch('${pageContext.request.contextPath}/post/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.msg || '处理完成');
                if (data.code === 200) {
                    location.reload();
                }
            });
    }
</script>
</body>
</html>
