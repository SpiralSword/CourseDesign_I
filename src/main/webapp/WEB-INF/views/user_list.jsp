<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>后台管理 - 用户列表</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <div class="small text-uppercase text-primary fw-semibold">Admin</div>
            <h3 class="fw-bold mb-0">用户治理中心</h3>
        </div>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/index">返回首页</a>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th>UID</th>
                    <th>头像</th>
                    <th>账号</th>
                    <th>昵称</th>
                    <th>角色</th>
                    <th>积分</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${users}" var="u">
                    <tr>
                        <td>${u.id}</td>
                        <td><img src="${u.avatar}" class="rounded-circle" width="36" height="36" style="object-fit: cover;"></td>
                        <td>${u.username}</td>
                        <td>${u.nickname}</td>
                        <td>
                            <c:choose>
                                <c:when test="${u.role == '1'}"><span class="badge text-bg-dark">管理员</span></c:when>
                                <c:otherwise><span class="badge text-bg-secondary">普通用户</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="fw-bold text-primary">${u.points}</td>
                        <td>
                            <c:choose>
                                <c:when test="${u.status == 0}"><span class="badge text-bg-success">正常</span></c:when>
                                <c:otherwise><span class="badge text-bg-danger">冻结</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${u.status == 0}">
                                <a href="${pageContext.request.contextPath}/admin/updateStatus?id=${u.id}&status=1" class="btn btn-sm btn-outline-danger">冻结</a>
                            </c:if>
                            <c:if test="${u.status == 1}">
                                <a href="${pageContext.request.contextPath}/admin/updateStatus?id=${u.id}&status=0" class="btn btn-sm btn-outline-success">启用</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
