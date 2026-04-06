<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>上传资源</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f4f8fb; }
        .upload-card { max-width: 760px; margin: 48px auto; border-radius: 24px; }
    </style>
</head>
<body>
<div class="container">
    <div class="card upload-card border-0 shadow-sm">
        <div class="card-body p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <div class="small text-uppercase text-primary fw-semibold">Resource Library</div>
                    <h2 class="fw-bold mb-0">分享新的课程资料</h2>
                </div>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/resource/list">返回列表</a>
            </div>

            <form id="uploadForm">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">资源标题</label>
                        <input type="text" name="title" class="form-control form-control-lg" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">课程名</label>
                        <input type="text" name="courseName" class="form-control form-control-lg" placeholder="如 Java Web / SSM">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">分类</label>
                        <select name="category" class="form-select form-select-lg">
                            <option value="学习资料">学习资料</option>
                            <option value="PPT课件">PPT课件</option>
                            <option value="历年试卷">历年试卷</option>
                            <option value="笔记总结">笔记总结</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">下载所需积分</label>
                        <input type="number" name="points" class="form-control form-control-lg" min="0" value="0">
                    </div>
                    <div class="col-12">
                        <label class="form-label">上传文件</label>
                        <input type="file" name="file" class="form-control form-control-lg" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label">资源说明</label>
                        <textarea name="description" class="form-control" rows="7" placeholder="建议写清适用课程、资料内容、使用方式"></textarea>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <button type="button" class="btn btn-primary btn-lg" onclick="submitUpload()">确认上传</button>
                    <a class="btn btn-outline-secondary btn-lg" href="${pageContext.request.contextPath}/index">回首页</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function submitUpload() {
        const form = document.getElementById('uploadForm');
        const formData = new FormData(form);
        fetch('${pageContext.request.contextPath}/resource/doUpload', {
            method: 'POST',
            body: formData
        }).then(function(res) {
            return res.json();
        }).then(function(data) {
            alert(data.msg || '上传完成');
            if (data.code === 200) {
                window.location.href = '${pageContext.request.contextPath}/resource/list';
            }
        });
    }
</script>
</body>
</html>
