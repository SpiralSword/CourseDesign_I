<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>上传资源</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/5.2.3/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .upload-card { max-width: 600px; margin: 50px auto; }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="card upload-card shadow border-0">
        <div class="card-header bg-primary text-white text-center py-3">
            <h4 class="mb-0">分享新资源</h4>
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/resource/upload" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">资源标题</label>
                    <input type="text" name="title" class="form-control" placeholder="请输入资源名称" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">资源文件 (最大50MB)</label>
                    <input type="file" name="file" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">所需积分</label>
                    <input type="number" name="points" class="form-control" value="0" min="0">
                </div>

                <div class="mb-3">
                    <label class="form-label">资源详细介绍</label>
                    <textarea name="description" class="form-control" rows="6" placeholder="请详细描述资源功能、使用方法等..." required></textarea>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary btn-lg">确认上传</button>
                    <a href="index" class="btn btn-link text-muted">返回首页</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>