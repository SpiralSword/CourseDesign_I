<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>后台管理 - 用户列表</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<h4 class="mb-4">系统用户权限管理</h4>
<div class="card border-0 shadow-sm">
    <table class="table table-hover align-middle">
        <thead class="table-light">
        <tr>
            <th>UID</th>
            <th>头像</th>
            <th>账号</th>
            <th>昵称</th>
            <th>积分</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${users}" var="u">
            <tr>
                <td>${u.id}</td>
                <td><img src="${u.avatar}" class="rounded-circle" width="30"></td>
                <td>${u.username}</td>
                <td>${u.nickname}</td>
                <td class="fw-bold">${u.points}</td>
                <td>
                    <c:choose>
                        <c:when test="${u.status == 0}"><span class="badge bg-success">正常</span></c:when>
                        <c:otherwise><span class="badge bg-danger">已封禁</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:if test="${u.status == 0}">
                        <a href="updateStatus?id=${u.id}&status=1" class="btn btn-sm btn-danger">冻结</a>
                    </c:if>
                    <c:if test="${u.status == 1}">
                        <a href="updateStatus?id=${u.id}&status=0" class="btn btn-sm btn-success">启用</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>