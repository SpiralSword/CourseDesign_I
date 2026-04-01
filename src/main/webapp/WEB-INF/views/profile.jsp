<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>个人中心</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/4.6.1/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card mx-auto" style="width: 500px;">
        <div class="card-header bg-primary text-white">个人中心</div>
        <div class="card-body text-center">
            <!-- 头像显示 -->
            <img id="avatarImg" src="${currUser.avatar != null ? currUser.avatar : 'https://via.placeholder.com/150'}"
                 class="rounded-circle mb-3" style="width: 150px; height: 150px; object-fit: cover; border: 3px solid #eee;">

            <form id="avatarForm">
                <div class="custom-file mb-3">
                    <input type="file" name="avatarFile" class="custom-file-input" id="fileInput">
                    <label class="custom-file-label">选择图片</label>
                </div>
                <button type="button" onclick="uploadAvatar()" class="btn btn-info btn-sm">更换头像</button>
            </form>

            <hr>
            <p>用户名: <strong>${currUser.username}</strong></p>
            <p>昵称: <strong>${currUser.nickname}</strong></p>
            <a href="${pageContext.request.contextPath}/index" class="btn btn-secondary">返回首页</a>
        </div>
    </div>
</div>

<script>
    function uploadAvatar() {
        const fileInput = document.getElementById('fileInput');
        if (fileInput.files.length === 0) {
            alert("请先选择一张图片");
            return;
        }

        const formData = new FormData();
        formData.append('avatarFile', fileInput.files[0]);

        fetch('${pageContext.request.contextPath}/user/updateAvatar', {
            method: 'POST',
            body: formData
        })
            .then(res => res.json())
            .then(data => {
                if (data.code === 200) {
                    alert("头像更新成功！");
                    document.getElementById('avatarImg').src = data.avatar;
                } else {
                    alert("上传失败");
                }
            });
    }
</script>
</body>
</html>