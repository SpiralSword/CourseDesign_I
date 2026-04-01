package com.study.ai.controller;

import com.study.ai.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private UserMapper userMapper;
    @Autowired private ResourceMapper resourceMapper;

    @GetMapping("/users")
    public String userList(Model model) {
        model.addAttribute("users", userMapper.findAll());
        return "user_list"; // 路径根据 prefix 自动拼接
    }

    @GetMapping("/updateStatus")
    public String updateStatus(Integer id, Integer status) {
        userMapper.updateStatus(id, status);
        return "redirect:/admin/users";
    }

    @PostMapping("/resource/delete")
    @ResponseBody
    public Map<String, Object> deleteResource(Integer id) {
        resourceMapper.deleteById(id);
        Map<String, Object> res = new java.util.HashMap<>();
        res.put("code", 200);
        return res;
    }
}