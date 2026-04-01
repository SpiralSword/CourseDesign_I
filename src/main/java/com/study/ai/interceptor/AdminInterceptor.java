package com.study.ai.interceptor;

import com.study.ai.pojo.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AdminInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        User user = (User) request.getSession().getAttribute("currUser");
        // 判断 role 是否为 "1" 或 "ADMIN"（根据数据库设定，此处采用字符串比较）
        if (user != null && "1".equals(user.getRole())) {
            return true;
        }
        // 非管理员尝试进入后台，拦截并跳转
        response.sendRedirect(request.getContextPath() + "/index");
        return false;
    }
}