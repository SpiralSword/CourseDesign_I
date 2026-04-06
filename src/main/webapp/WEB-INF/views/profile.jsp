<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>个人中心</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; }
        .profile-card, .list-card { border-radius: 24px; }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <div class="small text-uppercase text-primary fw-semibold">Profile Center</div>
            <h2 class="fw-bold mb-0">我的学习档案</h2>
        </div>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/index">返回首页</a>
    </div>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="card profile-card border-0 shadow-sm">
                <div class="card-body p-4 text-center">
                    <img id="avatarImg" src="${currUser.avatar}" class="rounded-circle border p-1 mb-3" style="width: 132px;height:132px;object-fit:cover;">
                    <h4 class="fw-bold mb-1">${currUser.nickname}</h4>
                    <div class="text-muted mb-3">${currUser.username}</div>
                    <div class="badge text-bg-warning fs-6 mb-3">积分 ${currUser.points}</div>
                    <div class="text-muted small mb-3">${currUser.email}</div>
                    <div class="d-grid gap-2">
                        <input type="file" id="fileInput" class="form-control">
                        <button type="button" onclick="uploadAvatar()" class="btn btn-primary">更新头像</button>
                        <a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/resource/upload">上传新资源</a>
                        <a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/post/publish">发布课程帖</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card list-card border-0 shadow-sm mb-4">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3">我的资源</h5>
                    <c:forEach items="${uploadedResources}" var="r">
                        <div class="d-flex justify-content-between align-items-center border rounded-4 p-3 mb-2">
                            <div>
                                <div class="fw-semibold">${r.title}</div>
                                <div class="small text-muted">${r.courseName} · ${r.category} · 下载 ${r.downloadCount}</div>
                            </div>
                            <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/resource/detail?id=${r.id}">查看</a>
                        </div>
                    </c:forEach>
                    <c:if test="${empty uploadedResources}">
                        <div class="text-muted">你还没有上传任何资源。</div>
                    </c:if>
                </div>
            </div>

            <div class="card list-card border-0 shadow-sm mb-4">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3">我的帖子</h5>
                    <c:forEach items="${myPosts}" var="post">
                        <div class="d-flex justify-content-between align-items-center border rounded-4 p-3 mb-2">
                            <div>
                                <div class="fw-semibold">${post.title}</div>
                                <div class="small text-muted">${post.courseName} · 点赞 ${post.likeCount} · 回复 ${post.replyCount}</div>
                            </div>
                            <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/post/detail?id=${post.id}">查看</a>
                        </div>
                    </c:forEach>
                    <c:if test="${empty myPosts}">
                        <div class="text-muted">你还没有发布课程帖子。</div>
                    </c:if>
                </div>
            </div>

            <div class="card list-card border-0 shadow-sm">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3">AI 提问历史</h5>
                    <c:forEach items="${aiHistory}" var="item">
                        <div class="border rounded-4 p-3 mb-2">
                            <div class="fw-semibold mb-1">${item.question}</div>
                            <div class="small text-muted mb-2"><fmt:formatDate value="${item.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                            <div class="text-secondary">${item.answer}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty aiHistory}">
                        <div class="text-muted">还没有 AI 记录。</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function uploadAvatar() {
        const fileInput = document.getElementById('fileInput');
        if (fileInput.files.length === 0) {
            alert('请先选择头像图片');
            return;
        }
        const formData = new FormData();
        formData.append('avatarFile', fileInput.files[0]);
        fetch('${pageContext.request.contextPath}/user/updateAvatar', {
            method: 'POST',
            body: formData
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.msg || '头像更新完成');
                if (data.code === 200) {
                    document.getElementById('avatarImg').src = data.avatar;
                }
            });
    }
</script>
</body>
</html>
