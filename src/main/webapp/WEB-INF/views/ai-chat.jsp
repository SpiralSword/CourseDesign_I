<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>AI 导师 - ACSS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <style>
        .chat-window { height: 65vh; overflow-y: auto; background: #fff; border-radius: 10px; border: 1px solid #eee; padding: 20px; }
        .msg-bubble { margin-bottom: 20px; max-width: 85%; padding: 12px 18px; border-radius: 15px; line-height: 1.6; }
        .msg-user { background: #007bff; color: white; margin-left: auto; border-bottom-right-radius: 2px; }
        .msg-ai { background: #f0f2f5; border-bottom-left-radius: 2px; }
    </style>
</head>
<body class="bg-light">
<nav class="navbar navbar-dark bg-primary shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index">⬅ 智学 AI 导师</a>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="chat-window shadow-sm bg-white mb-3" id="chatBox">
                <!-- 初始提示 -->
                <div class="msg-bubble msg-ai shadow-sm">你好，${currUser.nickname}！我是你的 Java 学习伙伴。有什么我可以帮你的吗？</div>

                <!-- 渲染历史 -->
                <c:forEach items="${history}" var="h">
                    <div class="msg-bubble msg-user">${h.question}</div>
                    <div class="msg-bubble msg-ai ai-render">${h.answer}</div>
                </c:forEach>
            </div>

            <div class="input-group input-group-lg shadow-sm">
                <input type="text" id="qInput" class="form-control" placeholder="在此输入你的 Java 技术疑问...">
                <button class="btn btn-primary px-5" onclick="sendToAI()">发送</button>
            </div>
            <div id="status" class="text-muted mt-2 small ml-2" style="display: none;">🧠 AI 正在思考并编撰代码...</div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        $(".ai-render").each(function() { $(this).html(marked.parse($(this).text())); });
        scrollDown();
    });

    function sendToAI() {
        let q = $("#qInput").val();
        if(!q) return;

        $("#chatBox").append(`<div class="msg-bubble msg-user">${q}</div>`);
        $("#qInput").val("");
        $("#status").show();
        scrollDown();

        $.post("${pageContext.request.contextPath}/ai/ask", {question: q}, function(res) {
            $("#status").hide();
            if(res.code === 200) {
                let htmlAns = marked.parse(res.answer);
                $("#chatBox").append(`<div class="msg-bubble msg-ai">${htmlAns}</div>`);
                scrollDown();
            }
        });
    }

    function scrollDown() {
        let cb = document.getElementById("chatBox");
        cb.scrollTop = cb.scrollHeight;
    }
</script>
</body>
</html>