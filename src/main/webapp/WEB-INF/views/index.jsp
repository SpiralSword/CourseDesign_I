<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>ACSS 智学共享</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(180deg, #eef6ff 0%, #f8fafc 45%, #ffffff 100%); }
        .hero { background: linear-gradient(135deg, #0f4c81 0%, #1d7fbf 52%, #7fd6ff 100%); border-radius: 28px; color: #fff; padding: 56px; box-shadow: 0 24px 60px rgba(15, 76, 129, 0.18); }
        .card-soft { border: 0; border-radius: 24px; box-shadow: 0 16px 36px rgba(15, 23, 42, 0.08); }
        .section-title { font-weight: 700; letter-spacing: 0.03em; }
        .tag { background: #e0f2fe; color: #0369a1; border-radius: 999px; padding: 4px 10px; font-size: 12px; }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg bg-white border-bottom sticky-top">
    <div class="container py-2">
        <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/index">ACSS 智学共享</a>
        <div class="navbar-nav me-auto">
            <a class="nav-link" href="${pageContext.request.contextPath}/post/list">课程社区</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/resource/list">资源共享</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/ai/chatPage">AI 助教</a>
        </div>
        <c:choose>
            <c:when test="${not empty currUser}">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted small">欢迎，${currUser.nickname}</span>
                    <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/user/profile">个人中心</a>
                    <c:if test="${currUser.role == '1'}">
                        <a class="btn btn-outline-dark btn-sm" href="${pageContext.request.contextPath}/admin/users">后台</a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-flex gap-2">
                    <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/user/loginPage">登录</a>
                    <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/user/registerPage">注册</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="container py-4">
    <div class="hero mb-4">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <div class="small text-uppercase opacity-75 mb-3">Academic Course Sharing Space</div>
                <h1 class="display-5 fw-bold mb-3">课程社区、资料共享、AI 助教，整合在一个学习空间里。</h1>
                <p class="lead mb-4">围绕 Java / SSM / 数据库课程沉淀讨论帖、学习资料和 AI 咨询记录，用积分机制形成贡献闭环。</p>
                <div class="d-flex flex-wrap gap-2">
                    <a class="btn btn-light btn-lg text-primary" href="${pageContext.request.contextPath}/post/publish">发布课程帖</a>
                    <a class="btn btn-outline-light btn-lg" href="${pageContext.request.contextPath}/resource/upload">上传资料</a>
                    <a class="btn btn-outline-light btn-lg" href="${pageContext.request.contextPath}/ai/chatPage">进入 AI 助教</a>
                </div>
            </div>
            <div class="col-lg-4 mt-4 mt-lg-0">
                <div class="card card-soft border-0">
                    <div class="card-body p-4 text-dark">
                        <h5 class="fw-bold mb-3">学习入口</h5>
                        <form action="${pageContext.request.contextPath}/resource/list" method="get" class="mb-3">
                            <label class="form-label small text-muted">搜资料</label>
                            <div class="input-group">
                                <input class="form-control" type="search" name="keyword" placeholder="课程名 / 标题 / 关键字">
                                <button class="btn btn-primary" type="submit">查找</button>
                            </div>
                        </form>
                        <form action="${pageContext.request.contextPath}/post/list" method="get">
                            <label class="form-label small text-muted">搜讨论</label>
                            <div class="input-group">
                                <input class="form-control" type="search" name="keyword" placeholder="课程名 / 问题 / 主题">
                                <button class="btn btn-outline-primary" type="submit">进入社区</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card card-soft mb-4">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="section-title mb-0">最新课程讨论</h4>
                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/post/list">查看全部</a>
                    </div>
                    <c:forEach items="${posts}" var="post" begin="0" end="4">
                        <div class="border rounded-4 p-3 mb-3">
                            <div class="d-flex justify-content-between align-items-start gap-3">
                                <div>
                                    <div class="tag mb-2">${post.courseName}</div>
                                    <h5 class="mb-1">${post.title}</h5>
                                    <div class="text-muted small mb-2">${post.authorNickname} · 点赞 ${post.likeCount} · 回复 ${post.replyCount}</div>
                                    <p class="text-secondary mb-0">${fn:length(post.content) > 80 ? fn:substring(post.content, 0, 80) : post.content}</p>
                                </div>
                                <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/post/detail?id=${post.id}">查看</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty posts}">
                        <div class="text-muted">还没有课程讨论，先发一条帖子建立社区内容。</div>
                    </c:if>
                </div>
            </div>

            <div class="card card-soft">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="section-title mb-0">最新共享资料</h4>
                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/resource/list">资料库</a>
                    </div>
                    <div class="row g-3">
                        <c:forEach items="${resources}" var="r" begin="0" end="5">
                            <div class="col-md-6">
                                <div class="border rounded-4 p-3 h-100">
                                    <div class="tag mb-2">${r.courseName}</div>
                                    <h5 class="mb-1">${r.title}</h5>
                                    <div class="text-muted small mb-2">${r.category} · ${r.uploaderNickname}</div>
                                    <p class="text-secondary mb-3">${fn:length(r.description) > 70 ? fn:substring(r.description, 0, 70) : r.description}</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge text-bg-warning">积分 ${r.points}</span>
                                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/resource/detail?id=${r.id}">查看详情</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <c:choose>
                <c:when test="${not empty currUser}">
                    <div class="card card-soft mb-4">
                        <div class="card-body p-4 text-center">
                            <img src="${currUser.avatar}" class="rounded-circle border p-1 mb-3" style="width: 92px;height: 92px;object-fit: cover;">
                            <h5 class="fw-bold">${currUser.nickname}</h5>
                            <div class="text-muted mb-3">当前积分 <span class="fw-bold text-primary" id="pointSpan">${currUser.points}</span></div>
                            <div class="d-grid gap-2">
                                <button class="btn btn-warning" onclick="handleCheckIn()">每日签到</button>
                                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/user/profile">进入个人中心</a>
                                <a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/user/logout">退出登录</a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card card-soft mb-4">
                        <div class="card-body p-4">
                            <h5 class="fw-bold mb-3">未登录也可先浏览内容</h5>
                            <p class="text-muted">登录后可上传资料、发帖、签到、下载文件和查看 AI 历史记录。</p>
                            <div class="d-grid gap-2">
                                <a class="btn btn-primary" href="${pageContext.request.contextPath}/user/loginPage">登录系统</a>
                                <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/user/registerPage">创建账号</a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="card card-soft">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3">贡献榜</h5>
                    <c:forEach items="${topUsers}" var="u" varStatus="status">
                        <div class="d-flex justify-content-between align-items-center border rounded-4 p-3 mb-2">
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge text-bg-light">#${status.index + 1}</span>
                                <span>${u.nickname}</span>
                            </div>
                            <span class="text-primary fw-bold">${u.points}</span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function handleCheckIn() {
        fetch('${pageContext.request.contextPath}/user/checkin', { method: 'POST' })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.msg ? data.msg : ('签到成功，获得 ' + data.reward + ' 积分'));
                if (data.code === 200 && data.points !== undefined) {
                    document.getElementById('pointSpan').innerText = data.points;
                }
            });
    }
</script>
</body>
</html>
