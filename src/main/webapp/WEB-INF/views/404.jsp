<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>页面异常</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { min-height: 100vh; display: flex; align-items: center; justify-content: center; background: #f8fafc; }
        .error-code { font-size: 120px; font-weight: 800; color: #dbe4ee; }
    </style>
</head>
<body class="text-center">
<div class="card border-0 shadow-sm p-5">
    <div class="error-code">404</div>
    <h2 class="mb-3">页面暂时不可用</h2>
    <p class="text-muted mb-4">${empty msg ? '抱歉，您访问的内容不存在或已被移除。' : msg}</p>
    <a href="${pageContext.request.contextPath}/index" class="btn btn-primary px-4">返回首页</a>
</div>
</body>
</html>
