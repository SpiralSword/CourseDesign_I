package com.study.ai.controller;

import com.study.ai.mapper.ResourceMapper;
import com.study.ai.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {

    @Autowired private ResourceMapper resourceMapper;
    @Autowired private UserMapper userMapper;

    @GetMapping({"/", "/index"})
    public String index(Model model) {
        // 首页展示最新的 6 条资源
        model.addAttribute("resources", resourceMapper.findAll().subList(0, Math.min(6, resourceMapper.findAll().size())));
        // 侧边栏：积分贡献榜 (假设 UserMapper 有此方法)
        model.addAttribute("topUsers", userMapper.findTopPointsUsers());
        return "index";
    }
}