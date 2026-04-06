<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>注册 - ACSS 智学共享</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { min-height: 100vh; background: linear-gradient(145deg, #eefbf3 0%, #edf8ff 50%, #ffffff 100%); }
        .reg-panel { max-width: 520px; margin: 5vh auto; border-radius: 28px; box-shadow: 0 24px 50px rgba(15, 23, 42, 0.1); }
    </style>
</head>
<body>
<div class="container">
    <div class="card reg-panel border-0">
        <div class="card-body p-5">
            <div class="small text-uppercase text-success fw-semibold mb-2">Create Account</div>
            <h2 class="fw-bold mb-2">创建你的学习账号</h2>
            <p class="text-muted mb-4">注册后即可发帖、上传资料、使用 AI 助教并参与积分体系。</p>
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label">用户名</label>
                    <input type="text" id="username" class="form-control form-control-lg">
                </div>
                <div class="col-12">
                    <label class="form-label">邮箱</label>
                    <input type="email" id="email" class="form-control form-control-lg" placeholder="example@mail.com">
                </div>
                <div class="col-12">
                    <label class="form-label">昵称</label>
                    <input type="text" id="nickname" class="form-control form-control-lg" placeholder="默认使用用户名">
                </div>
                <div class="col-12">
                    <label class="form-label">密码</label>
                    <input type="password" id="password" class="form-control form-control-lg">
                </div>
            </div>
            <div class="d-grid gap-2 mt-4">
                <button type="button" id="regBtn" class="btn btn-success btn-lg">注册账号</button>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/user/loginPage">返回登录</a>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('regBtn').onclick = function() {
        const u = document.getElementById('username').value.trim();
        const e = document.getElementById('email').value.trim();
        const n = document.getElementById('nickname').value.trim();
        const p = document.getElementById('password').value.trim();
        if (!u || !e || !p) {
            alert('用户名、邮箱、密码必填');
            return;
        }
        const params = new URLSearchParams();
        params.append('username', u);
        params.append('email', e);
        params.append('nickname', n);
        params.append('password', p);
        fetch('${pageContext.request.contextPath}/user/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) {
            return res.json();
        }).then(function(data) {
            alert(data.msg || '注册完成');
            if (data.code === 200) {
                window.location.href = '${pageContext.request.contextPath}/user/loginPage';
            }
        });
    };
</script>
</body>
</html>
