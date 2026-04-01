<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>404 - 页面去火星了</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { height: 100vh; display: flex; align-items: center; justify-content: center; background: #f8f9fa; }
        .error-code { font-size: 150px; font-weight: bold; color: #dee2e6; }
    </style>
</head>
<body class="text-center">
<div>
    <div class="error-code">404</div>
    <h2 class="mb-4">找不到该页面</h2>
    <p class="text-muted mb-5">抱歉，您访问的内容不存在或已被移除。</p>
    <a href="${pageContext.request.contextPath}/index" class="btn btn-primary px-5">返回社区首页</a>
</div>
</body>
</html>