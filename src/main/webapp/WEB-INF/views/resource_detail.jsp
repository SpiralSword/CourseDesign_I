<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>资源详情 - ${res.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f6f8fb; }
        .detail-wrapper { max-width: 980px; margin: 40px auto; background: #fff; padding: 40px; border-radius: 24px; box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08); }
        .main-content { min-height: 220px; border: 1px solid #eef2f7; background: #f8fafc; padding: 24px; border-radius: 16px; line-height: 1.9; white-space: pre-wrap; }
        .comment-item { border-bottom: 1px solid #eef2f7; padding: 16px 0; }
    </style>
</head>
<body>
<div class="container">
    <div class="detail-wrapper">
        <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
            <div>
                <div class="small text-primary fw-semibold">${res.courseName} · ${res.category}</div>
                <h2 class="fw-bold mb-2">${res.title}</h2>
                <div class="text-muted">
                    上传者 ${res.uploaderNickname} ·
                    发布时间 <fmt:formatDate value="${res.createTime}" pattern="yyyy-MM-dd HH:mm"/> ·
                    下载 ${res.downloadCount}
                </div>
            </div>
            <div class="text-end">
                <div class="badge text-bg-warning fs-6 mb-2">积分 ${res.points}</div>
                <div class="d-flex flex-column gap-2">
                    <button onclick="doDownload()" class="btn btn-primary">下载文件</button>
                    <c:if test="${not empty currUser && (currUser.role == '1' || currUser.id == res.uploaderId)}">
                        <button onclick="deleteResource()" class="btn btn-outline-danger">删除资源</button>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="main-content mb-4">${res.description}</div>

        <c:if test="${not empty res.filePath}">
            <c:set var="fname" value="${fn:toLowerCase(res.filePath)}"/>
            <c:if test="${fn:endsWith(fname,'.jpg') || fn:endsWith(fname,'.png') || fn:endsWith(fname,'.jpeg') || fn:endsWith(fname,'.gif')}">
                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/uploads/${res.filePath}" class="img-fluid rounded-4 border">
                </div>
            </c:if>
        </c:if>

        <div class="mt-5">
            <h4 class="fw-bold mb-3">资源评论</h4>
            <div class="mb-4">
                <textarea id="commInput" class="form-control mb-2" rows="4" placeholder="说说这份资料是否有帮助"></textarea>
                <div class="text-end">
                    <button onclick="postComm()" class="btn btn-dark">发表评论</button>
                </div>
            </div>

            <div id="commentList">
                <c:forEach items="${commentList}" var="c">
                    <div class="comment-item">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="fw-bold text-primary">${c.nickname}</span>
                            <small class="text-muted"><fmt:formatDate value="${c.createTime}" pattern="yy-MM-dd HH:mm"/></small>
                        </div>
                        <div class="text-secondary">${c.content}</div>
                    </div>
                </c:forEach>
                <c:if test="${empty commentList}">
                    <div class="text-muted">还没有评论，欢迎补充使用体验。</div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    function doDownload() {
        fetch('${pageContext.request.contextPath}/resource/downloadCheck?id=${res.id}')
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.code === 200) {
                    window.location.href = '${pageContext.request.contextPath}/resource/getFile?id=${res.id}';
                } else {
                    alert(data.msg || '下载失败');
                }
            });
    }

    function postComm() {
        const txt = document.getElementById('commInput').value.trim();
        if (!txt) {
            return;
        }
        const params = new URLSearchParams();
        params.append('resourceId', '${res.id}');
        params.append('content', txt);
        fetch('${pageContext.request.contextPath}/resource/addComment', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.code === 200) {
                    location.reload();
                } else {
                    alert(data.msg || '评论失败');
                }
            });
    }

    function deleteResource() {
        if (!confirm('确定删除该资源吗？')) {
            return;
        }
        const params = new URLSearchParams();
        params.append('id', '${res.id}');
        fetch('${pageContext.request.contextPath}/resource/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.msg || '处理完成');
                if (data.code === 200) {
                    window.location.href = '${pageContext.request.contextPath}/resource/list';
                }
            });
    }
</script>
</body>
</html>
