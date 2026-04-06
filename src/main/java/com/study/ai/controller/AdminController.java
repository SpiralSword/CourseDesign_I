package com.study.ai.controller;

import com.study.ai.pojo.entity.User;
import com.study.ai.service.PostService;
import com.study.ai.service.ResourceService;
import com.study.ai.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private UserService userService;
    @Autowired private ResourceService resourceService;
    @Autowired private PostService postService;

    @GetMapping("/users")
    public String userList(Model model) {
        model.addAttribute("users", userService.findAllUsers());
        return "user_list";
    }

    @GetMapping("/updateStatus")
    public String updateStatus(Integer id, Integer status) {
        userService.updateStatus(id, status);
        return "redirect:/admin/users";
    }

    @PostMapping("/resource/delete")
    @ResponseBody
    public Map<String, Object> deleteResource(Integer id, HttpSession session, HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        resourceService.deleteResource(id, user, request.getServletContext().getRealPath("/uploads/"), true);
        res.put("code", 200);
        return res;
    }

    @PostMapping("/post/delete")
    @ResponseBody
    public Map<String, Object> deletePost(Integer id, HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        postService.deletePost(id, user, true);
        res.put("code", 200);
        return res;
    }
}
