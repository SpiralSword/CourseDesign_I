<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 - ACSS 智学共享</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { min-height: 100vh; background: radial-gradient(circle at top, #d8f3ff 0, #edf7ff 35%, #f8fbff 100%); }
        .login-panel { max-width: 420px; margin: 7vh auto; border-radius: 28px; box-shadow: 0 24px 50px rgba(15, 23, 42, 0.12); }
    </style>
</head>
<body class="d-flex align-items-center">
<div class="container">
    <div class="card login-panel border-0">
        <div class="card-body p-5">
            <div class="small text-uppercase text-primary fw-semibold mb-2">ACSS</div>
            <h2 class="fw-bold mb-2">登录学习空间</h2>
            <p class="text-muted mb-4">进入课程社区、资料共享和 AI 助教。</p>
            <div class="mb-3">
                <label class="form-label">用户名</label>
                <input type="text" id="username" class="form-control form-control-lg" placeholder="请输入用户名">
            </div>
            <div class="mb-4">
                <label class="form-label">密码</label>
                <input type="password" id="password" class="form-control form-control-lg" placeholder="请输入密码">
            </div>
            <div class="d-grid gap-2">
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg">登录</button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/index">先浏览首页</a>
            </div>
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/user/registerPage" class="text-decoration-none">没有账号？立即注册</a>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('loginBtn').onclick = function() {
        const user = document.getElementById('username').value.trim();
        const pass = document.getElementById('password').value.trim();
        if (!user || !pass) {
            alert('请输入完整的账号和密码');
            return;
        }
        const params = new URLSearchParams();
        params.append('username', user);
        params.append('password', pass);
        fetch('${pageContext.request.contextPath}/user/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) {
            return res.json();
        }).then(function(data) {
            if (data.code === 200) {
                window.location.href = '${pageContext.request.contextPath}/index';
            } else {
                alert(data.msg || '登录失败');
            }
        });
    };
</script>
</body>
</html>
