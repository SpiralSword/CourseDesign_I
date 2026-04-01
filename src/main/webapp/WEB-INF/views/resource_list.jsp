<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>资源中心 - 智学共享</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">全部共享资源</h3>
        <a href="${pageContext.request.contextPath}/index" class="btn btn-outline-primary">回首页</a>
    </div>

    <div class="card shadow-sm border-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th class="ps-4">资源标题</th>
                    <th>积分</th>
                    <th>上传者</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pageInfo.list}" var="r">
                    <tr>
                        <td class="ps-4">
                            <span class="fw-bold text-dark">${r.title}</span><br>
                            <small class="text-muted">${r.category}</small>
                        </td>
                        <td><span class="badge bg-warning text-dark">${r.points}</span></td>
                        <td>${r.uploaderNickname}</td>
                        <td class="text-center">
                            <a href="detail?id=${r.id}" class="btn btn-sm btn-primary">查看详情</a>
                            <!-- 仅管理员可删 -->
                            <c:if test="${currUser.role == 'ADMIN'}">
                                <button onclick="doDelete(${r.id})" class="btn btn-sm btn-outline-danger ms-2">删除</button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 分页组件 -->
    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <li class="page-item ${pageInfo.hasPreviousPage ? '' : 'disabled'}">
                <a class="page-link" href="?page=${pageInfo.prePage}&keyword=${keyword}">上一页</a>
            </li>
            <c:forEach items="${pageInfo.navigatepageNums}" var="n">
                <li class="page-item ${pageInfo.pageNum == n ? 'active' : ''}">
                    <a class="page-link" href="?page=${n}&keyword=${keyword}">${n}</a>
                </li>
            </c:forEach>
            <li class="page-item ${pageInfo.hasNextPage ? '' : 'disabled'}">
                <a class="page-link" href="?page=${pageInfo.nextPage}&keyword=${keyword}">下一页</a>
            </li>
        </ul>
    </nav>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/layerjs/dist/layer.js"></script>
<script>
    function doDelete(id) {
        layer.confirm('确定要移除此资源吗？', {icon: 3, title:'警告'}, function(index){
            $.post("delete", {id: id}, function(res){
                if(res.code === 200){ layer.msg("删除成功"); location.reload(); }
                else { layer.msg("权限不足"); }
            });
            layer.close(index);
        });
    }
</script>
</body>
</html>