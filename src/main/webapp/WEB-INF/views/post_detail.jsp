<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>帖子详情 - ${post.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f7fb; }
        .wrapper { max-width: 980px; margin: 40px auto; background: #fff; padding: 40px; border-radius: 24px; box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08); }
        .content-box { border: 1px solid #e5edf5; background: #f8fbfd; border-radius: 18px; padding: 24px; white-space: pre-wrap; line-height: 1.9; }
    </style>
</head>
<body>
<div class="container">
    <div class="wrapper">
        <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
            <div>
                <div class="small text-primary fw-semibold">${post.courseName}</div>
                <h2 class="fw-bold mb-2">${post.title}</h2>
                <div class="text-muted">${post.authorNickname} · <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/> · 点赞 ${post.likeCount} · 回复 ${post.replyCount}</div>
            </div>
            <div class="d-flex flex-column gap-2">
                <button class="btn btn-primary" onclick="toggleLike()">${post.liked ? '取消点赞' : '点赞帖子'}</button>
                <c:if test="${not empty currUser && (currUser.role == '1' || currUser.id == post.userId)}">
                    <button class="btn btn-outline-danger" onclick="deletePost()">删除帖子</button>
                </c:if>
            </div>
        </div>

        <div class="content-box mb-4">${post.content}</div>

        <div class="mb-4">
            <h4 class="fw-bold mb-3">回复讨论</h4>
            <textarea id="replyInput" class="form-control mb-2" rows="4" placeholder="补充你的解法、经验或思路"></textarea>
            <div class="text-end">
                <button class="btn btn-dark" onclick="submitReply()">发送回复</button>
            </div>
        </div>

        <div>
            <h4 class="fw-bold mb-3">全部回复</h4>
            <c:forEach items="${replyList}" var="reply">
                <div class="border rounded-4 p-3 mb-2">
                    <div class="d-flex justify-content-between mb-1">
                        <span class="fw-semibold text-primary">${reply.nickname}</span>
                        <small class="text-muted"><fmt:formatDate value="${reply.createTime}" pattern="yy-MM-dd HH:mm"/></small>
                    </div>
                    <div class="text-secondary">${reply.content}</div>
                </div>
            </c:forEach>
            <c:if test="${empty replyList}">
                <div class="text-muted">还没有回复，欢迎开始讨论。</div>
            </c:if>
        </div>
    </div>
</div>

<script>
    function submitReply() {
        const content = document.getElementById('replyInput').value.trim();
        if (!content) {
            return;
        }
        const params = new URLSearchParams();
        params.append('postId', '${post.id}');
        params.append('content', content);
        fetch('${pageContext.request.contextPath}/post/reply', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.code === 200) {
                    location.reload();
                } else {
                    alert(data.msg || '回复失败');
                }
            });
    }

    function toggleLike() {
        const params = new URLSearchParams();
        params.append('postId', '${post.id}');
        fetch('${pageContext.request.contextPath}/post/like', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.code === 200) {
                    location.reload();
                } else {
                    alert(data.msg || '操作失败');
                }
            });
    }

    function deletePost() {
        if (!confirm('确定删除该帖子吗？')) {
            return;
        }
        const params = new URLSearchParams();
        params.append('id', '${post.id}');
        fetch('${pageContext.request.contextPath}/post/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.msg || '处理完成');
                if (data.code === 200) {
                    window.location.href = '${pageContext.request.contextPath}/post/list';
                }
            });
    }
</script>
</body>
</html>
