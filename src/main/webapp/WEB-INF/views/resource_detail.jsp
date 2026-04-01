<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>资源详情 - ${res.title}</title>
    <!-- 1. 先引入 jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 2. 再引入 Bootstrap -->
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.2.3/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f7f9fc; }
        .detail-wrapper {
            max-width: 960px;
            margin: 40px auto;
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }
        .main-content {
            min-height: 450px; /* 超大正文框 */
            border: 1px solid #eee;
            background: #fafafa;
            padding: 25px;
            border-radius: 8px;
            font-size: 16px;
            line-height: 2;
            white-space: pre-wrap;
            margin-bottom: 30px;
        }
        .comment-item { border-bottom: 1px solid #f0f0f0; padding: 15px 0; }
    </style>
</head>
<body>

<div class="container">
    <div class="detail-wrapper">
        <h2 class="text-center fw-bold mb-4">${res.title}</h2>

        <div class="text-muted text-center mb-4">
            <span class="me-3">上传者：${res.uploaderNickname}</span>
            <span class="me-3">日期：<fmt:formatDate value="${res.createTime}" pattern="yyyy-MM-dd"/></span>
            <span>下载次数：${res.downloadCount}</span>
        </div>

        <!-- 正文内容 -->
        <div class="main-content">
            ${res.description}
        </div>

        <!-- 预览图：注意路径是 uploads -->
        <c:if test="${not empty res.filePath}">
            <c:set var="fname" value="${fn:toLowerCase(res.filePath)}" />
            <c:if test="${fn:endsWith(fname,'.jpg') || fn:endsWith(fname,'.png') || fn:endsWith(fname,'.jpeg')}">
                <div class="text-center my-4">
                    <p class="text-secondary small">--- 图片预览 ---</p>
                    <img src="${pageContext.request.contextPath}/uploads/${res.filePath}" class="img-fluid border rounded">
                </div>
            </c:if>
        </c:if>

        <!-- 下载控制区 -->
        <div class="card bg-light border-0 mb-5">
            <div class="card-body d-flex justify-content-between align-items-center">
                <span class="fs-5">下载所需积分：<strong class="text-danger">${res.points}</strong></span>
                <button onclick="doDownload()" class="btn btn-primary btn-lg px-5">🚀 立即下载</button>
            </div>
        </div>

        <!-- 评论区 -->
        <div class="mt-5">
            <h4 class="mb-4">交流评论</h4>
            <div class="mb-4">
                <textarea id="commInput" class="form-control mb-2" rows="4" placeholder="说点什么吧..."></textarea>
                <div class="text-end">
                    <button onclick="postComm()" class="btn btn-dark btn-lg">发表评论</button>
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
            </div>
        </div>
    </div>
</div>

<script>
    // 强制检查 jQuery 是否加载
    if (typeof jQuery == 'undefined') {
        alert("jQuery 加载失败，请检查网络或路径！");
    }

    function doDownload() {
        $.get("${pageContext.request.contextPath}/resource/downloadCheck", {id: "${res.id}"}, function(res) {
            if(res.code == 200) {
                window.location.href = "${pageContext.request.contextPath}/resource/getFile?id=${res.id}";
            } else {
                alert(res.msg || "请先登录");
            }
        });
    }

    function postComm() {
        var txt = $("#commInput").val();
        if(!txt) return;

        // 关键：提交后立即禁用按钮防止连击
        $(this).attr("disabled", true);

        $.post("${pageContext.request.contextPath}/resource/addComment", {
            resourceId: "${res.id}",
            content: txt
        }, function(res) {
            if(res.code == 200) {
                // 成功后重载当前页面，防止 POST 刷新导致的重复提交
                window.location.reload();
            } else {
                alert("发送失败，请尝试登录");
            }
        });
    }
</script>
</body>
</html>