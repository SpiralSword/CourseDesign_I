<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 - 智学 AI 系统</title>
    <!-- 使用更稳定的 CDN 获取 Bootstrap -->
    <link href="https://cdn.staticfile.org/twitter-bootstrap/4.6.1/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);
            height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px; border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            width: 400px; transition: transform 0.3s;
        }
        .login-container:hover { transform: translateY(-5px); }
        .btn-custom {
            background: #4facfe; border: none; color: white; padding: 12px;
            font-weight: bold; border-radius: 10px; width: 100%; transition: 0.3s;
        }
        .btn-custom:hover { background: #00f2fe; box-shadow: 0 5px 15px rgba(79,172,254,0.4); }
        .form-control { border-radius: 10px; padding: 25px 15px; border: 1px solid #ddd; }
    </style>
</head>
<body>

<div class="login-container">
    <h3 class="text-center mb-4" style="color: #333; font-weight: 700;">智学 AI 系统</h3>
    <div class="form-group">
        <label>用户名</label>
        <input type="text" id="username" class="form-control" placeholder="请输入您的账号">
    </div>
    <div class="form-group">
        <label>密码</label>
        <input type="password" id="password" class="form-control" placeholder="请输入您的密码">
    </div>
    <button type="button" id="loginBtn" class="btn-custom mt-3">进入系统</button>
    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/user/registerPage" style="color: #666; text-decoration: none; font-size: 14px;">没有账号？<span style="color: #4facfe;">立即注册</span></a>
    </div>
</div>

<script>
    // 使用原生 JavaScript (不需要 jQuery)，确保 100% 响应点击
    document.getElementById('loginBtn').onclick = function() {
        const user = document.getElementById('username').value;
        const pass = document.getElementById('password').value;

        if (!user || !pass) {
            alert("请输入完整的账号和密码");
            return;
        }

        // 使用原生 Fetch API 代替 Ajax
        const params = new URLSearchParams();
        params.append('username', user);
        params.append('password', pass);

        fetch('${pageContext.request.contextPath}/user/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    window.location.href = "${pageContext.request.contextPath}/index";
                } else {
                    alert(data.msg);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("登录请求失败，请检查后端服务是否启动");
            });
    };
</script>
</body>
</html>