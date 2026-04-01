<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>创建账号 - 智学 AI</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/4.6.1/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #e0f2f1; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .reg-box {
            background: white; padding: 40px; border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05); width: 420px;
        }
        .form-control { border-radius: 8px; background: #f9f9f9; }
        .btn-reg { background: #00bfa5; color: white; border: none; padding: 12px; border-radius: 8px; width: 100%; font-weight: bold; }
        .btn-reg:hover { background: #00897b; }
    </style>
</head>
<body>

<div class="reg-box">
    <h3 class="text-center mb-4" style="color: #00796b;">创建新账号</h3>
    <div class="form-group">
        <label>登录用户名</label>
        <input type="text" id="username" class="form-control">
    </div>
    <div class="form-group">
        <label>邮箱地址</label>
        <input type="email" id="email" class="form-control" placeholder="example@mail.com">
    </div>
    <div class="form-group">
        <label>显示昵称</label>
        <input type="text" id="nickname" class="form-control">
    </div>
    <div class="form-group">
        <label>设置密码</label>
        <input type="password" id="password" class="form-control">
    </div>
    <button type="button" id="regBtn" class="btn-reg mt-2">立即注册并签到</button>
    <div class="text-center mt-3">
        <a href="${pageContext.request.contextPath}/user/loginPage" class="text-muted small">已有账号？返回登录</a>
    </div>
</div>

<script>
    document.getElementById('regBtn').onclick = function() {
        const u = document.getElementById('username').value;
        const e = document.getElementById('email').value; // 获取邮箱
        const n = document.getElementById('nickname').value;
        const p = document.getElementById('password').value;
        if(!u || !e || !p) { alert("用户名、邮箱、密码必填！"); return; }
        const params = new URLSearchParams();
        params.append('username', u);
        params.append('email', e);
        params.append('nickname', n);
        params.append('password', p);
        fetch('${pageContext.request.contextPath}/user/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(res => res.json()).then(data => {
            if(data.code === 200) { alert("注册成功！"); window.location.href = "..."; }
        });
    };
</script>
</body>
</html>