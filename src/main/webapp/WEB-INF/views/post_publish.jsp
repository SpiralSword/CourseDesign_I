<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>发布帖子 - ACSS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f5f7fb; }
        .publish-card { max-width: 820px; margin: 48px auto; border-radius: 24px; }
    </style>
</head>
<body>
<div class="container">
    <div class="card publish-card border-0 shadow-sm">
        <div class="card-body p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <div class="small text-uppercase text-primary fw-semibold">Publish Post</div>
                    <h2 class="fw-bold mb-0">发起课程讨论</h2>
                </div>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/post/list">返回社区</a>
            </div>

            <form id="postForm">
                <div class="row g-3">
                    <div class="col-md-7">
                        <label class="form-label">帖子标题</label>
                        <input type="text" name="title" class="form-control form-control-lg" placeholder="描述你的问题或经验主题">
                    </div>
                    <div class="col-md-5">
                        <label class="form-label">课程名</label>
                        <input type="text" name="courseName" class="form-control form-control-lg" placeholder="如 Java 基础 / SSM">
                    </div>
                    <div class="col-12">
                        <label class="form-label">帖子内容</label>
                        <textarea name="content" class="form-control" rows="12" placeholder="写清背景、问题、尝试过的方法或你的分享内容"></textarea>
                    </div>
                </div>
                <div class="d-flex gap-2 mt-4">
                    <button type="button" class="btn btn-primary btn-lg" onclick="submitPost()">发布帖子</button>
                    <a class="btn btn-outline-secondary btn-lg" href="${pageContext.request.contextPath}/index">回首页</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function submitPost() {
        const form = new FormData(document.getElementById('postForm'));
        const params = new URLSearchParams();
        form.forEach(function(value, key) { params.append(key, value); });
        fetch('${pageContext.request.contextPath}/post/save', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                alert(data.msg || '发布完成');
                if (data.code === 200) {
                    window.location.href = '${pageContext.request.contextPath}/post/list';
                }
            });
    }
</script>
</body>
</html>
