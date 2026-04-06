package com.study.ai.controller;

import com.study.ai.pojo.entity.Post;
import com.study.ai.pojo.entity.Resource;
import com.study.ai.service.PostService;
import com.study.ai.service.ResourceService;
import com.study.ai.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class IndexController {

    @Autowired private ResourceService resourceService;
    @Autowired private PostService postService;
    @Autowired private UserService userService;

    @GetMapping({"/", "/index"})
    public String index(Model model, HttpSession session) {
        List<Resource> resources = resourceService.listResources(1, null).getList();
        List<Post> posts = postService.listPosts(1, null).getList();
        model.addAttribute("resources", resources);
        model.addAttribute("posts", posts);
        model.addAttribute("topUsers", userService.findTopUsers());
        model.addAttribute("currUser", session.getAttribute("currUser"));
        return "index";
    }
}
