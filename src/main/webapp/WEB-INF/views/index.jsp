<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>智学 AI 社区</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .banner { background: #007bff; color: white; padding: 60px 0; border-radius: 15px; margin-bottom: 30px; }
        .sidebar-card { border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .nav-link { color: rgba(255,255,255,0.8); }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index">ACSS 智学</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/index">首页</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/resource/list">资料库</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/ai/chatPage">AI 助手</a></li>
            </ul>
            <form action="${pageContext.request.contextPath}/resource/list" method="get" class="d-flex">
                <input class="form-control me-2 text-white bg-secondary border-0" type="search" name="keyword" placeholder="搜资源...">
                <button class="btn btn-outline-light" type="submit">搜索</button>
            </form>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-9">
            <div class="banner text-center shadow">
                <h1 class="display-4 fw-bold">探索 Java 的无限可能</h1>
                <p class="lead">AI 驱动的学习资源共享社区</p>
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/ai/chatPage" class="btn btn-light btn-lg text-primary me-3 fw-bold">💬 向 AI 提问</a>
                    <a href="${pageContext.request.contextPath}/resource/list" class="btn btn-outline-light btn-lg">📂 浏览资源</a>
                </div>
            </div>

            <div class="row">
                <h4 class="mb-3 fw-bold">🔥 最新分享</h4>
                <c:forEach items="${resources}" var="r">
                    <div class="col-md-6 mb-4">
                        <div class="card h-100 sidebar-card">
                            <div class="card-body">
                                <h5 class="card-title text-primary">${r.title}</h5>
                                <p class="card-text text-muted small">${r.description}</p>
                            </div>
                            <div class="card-footer bg-white border-0 d-flex justify-content-between align-items-center">
                                <span class="badge bg-info text-dark">积分: ${r.points}</span>
                                <a href="${pageContext.request.contextPath}/resource/detail?id=${r.id}" class="btn btn-sm btn-outline-primary">查看详情</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card sidebar-card mb-4 text-center p-4">
                <img src="${currUser.avatar}" class="rounded-circle mx-auto mb-3 border p-1" style="width: 80px; height: 80px; object-fit: cover">
                <h5 class="fw-bold">${currUser.nickname}</h5>
                <p class="text-muted">我的积分: <span class="text-primary fw-bold" id="pointSpan">${currUser.points}</span></p>
                <button class="btn btn-warning w-100 fw-bold" onclick="handleCheckIn()">📅 每日签到</button>
                <hr>
                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-link text-decoration-none">进入个人中心</a>
                <a href="${pageContext.request.contextPath}/resource/upload" class="btn btn-success">发布新资源</a>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layerjs/dist/layer.js"></script>
<script>
    function handleCheckIn() {
        $.post("${pageContext.request.contextPath}/user/checkin", function(res) {
            if(res.code === 200) {
                layer.alert("签到成功！奖励 " + res.reward + " 积分", {icon: 6});
                $("#pointSpan").text(parseInt($("#pointSpan").text()) + res.reward);
            } else {
                layer.msg(res.msg, {icon: 5});
            }
        });
    }
</script>
</body>
</html>