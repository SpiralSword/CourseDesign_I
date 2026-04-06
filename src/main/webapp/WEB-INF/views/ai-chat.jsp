<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>AI 助教 - ACSS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <style>
        body { background: #eef4f8; }
        .chat-window { height: 66vh; overflow-y: auto; background: #fff; border-radius: 22px; border: 1px solid #e2e8f0; padding: 24px; }
        .msg-bubble { margin-bottom: 18px; max-width: 85%; padding: 14px 18px; border-radius: 18px; line-height: 1.7; }
        .msg-user { background: #0f4c81; color: white; margin-left: auto; }
        .msg-ai { background: #f3f6f9; color: #0f172a; }
    </style>
</head>
<body>
<nav class="navbar bg-white border-bottom mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/index">ACSS AI 助教</a>
        <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/index">回首页</a>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="chat-window shadow-sm mb-3" id="chatBox">
                <div class="msg-bubble msg-ai">你好，${currUser.nickname}。我会围绕 Java、SSM、数据库和课程资料内容提供答疑。</div>
                <c:forEach items="${history}" var="h">
                    <div class="msg-bubble msg-user">${h.question}</div>
                    <div class="msg-bubble msg-ai ai-render">${h.answer}</div>
                </c:forEach>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="input-group input-group-lg">
                        <input type="text" id="qInput" class="form-control" placeholder="输入课程问题、代码疑问或知识点">
                        <button class="btn btn-primary px-4" onclick="sendToAI()">发送</button>
                    </div>
                    <div id="status" class="text-muted small mt-2" style="display:none;">AI 正在整理回答...</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function renderHistory() {
        document.querySelectorAll('.ai-render').forEach(function(item) {
            item.innerHTML = marked.parse(item.textContent);
        });
        scrollDown();
    }

    function sendToAI() {
        const input = document.getElementById('qInput');
        const question = input.value.trim();
        if (!question) {
            return;
        }
        const box = document.getElementById('chatBox');
        box.insertAdjacentHTML('beforeend', '<div class="msg-bubble msg-user"></div>');
        box.lastElementChild.innerText = question;
        input.value = '';
        document.getElementById('status').style.display = 'block';
        scrollDown();

        const params = new URLSearchParams();
        params.append('question', question);
        fetch('${pageContext.request.contextPath}/ai/ask', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        }).then(function(res) { return res.json(); })
            .then(function(data) {
                document.getElementById('status').style.display = 'none';
                if (data.code === 200) {
                    const html = marked.parse(data.answer);
                    box.insertAdjacentHTML('beforeend', '<div class="msg-bubble msg-ai">' + html + '</div>');
                    scrollDown();
                } else {
                    alert(data.msg || '请求失败');
                }
            });
    }

    function scrollDown() {
        const box = document.getElementById('chatBox');
        box.scrollTop = box.scrollHeight;
    }

    renderHistory();
</script>
</body>
</html>
