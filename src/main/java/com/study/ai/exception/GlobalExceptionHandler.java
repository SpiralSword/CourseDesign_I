package com.study.ai.exception;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(Exception e, HttpServletRequest request) {
        // 打印错误堆栈
        e.printStackTrace();
        ModelAndView mav = new ModelAndView();
        mav.addObject("msg", "系统开小差了：" + e.getMessage());
        // 统一指向 404 页面展示错误信息
        mav.setViewName("404");
        return mav;
    }
}