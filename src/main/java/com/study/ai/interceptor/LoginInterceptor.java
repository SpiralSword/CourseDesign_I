package com.study.ai.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (request.getSession().getAttribute("currUser") != null) {
            return true;
        }
        // 未登录跳转登录页
        response.sendRedirect(request.getContextPath() + "/user/loginPage");
        return false;
    }
}