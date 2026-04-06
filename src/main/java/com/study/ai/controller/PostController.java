package com.study.ai.controller;

import com.study.ai.pojo.entity.User;
import com.study.ai.service.PostService;
import com.study.ai.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/post")
public class PostController {

    @Autowired private PostService postService;
    @Autowired private UserService userService;

    @GetMapping("/list")
    public String list(Integer page, String keyword, Model model, HttpSession session) {
        int pageNum = page == null || page < 1 ? 1 : page;
        model.addAttribute("pageInfo", postService.listPosts(pageNum, keyword));
        model.addAttribute("keyword", keyword);
        model.addAttribute("currUser", session.getAttribute("currUser"));
        return "post_list";
    }

    @GetMapping("/detail")
    public String detail(Integer id, Model model, HttpSession session) {
        User currUser = (User) session.getAttribute("currUser");
        model.addAttribute("post", postService.getDetail(id, currUser == null ? null : currUser.getId()));
        model.addAttribute("replyList", postService.listReplies(id));
        model.addAttribute("currUser", currUser);
        return "post_detail";
    }

    @GetMapping("/publish")
    public String publishPage() {
        return "post_publish";
    }

    @PostMapping("/save")
    @ResponseBody
    public Map<String, Object> save(String title, String courseName, String content, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        try {
            postService.createPost(user, title, courseName, content);
            if (user != null) {
                session.setAttribute("currUser", userService.refreshById(user.getId()));
            }
            result.put("code", 200);
            result.put("msg", "发布成功");
        } catch (IllegalArgumentException e) {
            result.put("code", 400);
            result.put("msg", e.getMessage());
        }
        return result;
    }

    @PostMapping("/reply")
    @ResponseBody
    public Map<String, Object> reply(Integer postId, String content, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        try {
            postService.addReply(user, postId, content);
            if (user != null) {
                session.setAttribute("currUser", userService.refreshById(user.getId()));
            }
            result.put("code", 200);
        } catch (IllegalArgumentException e) {
            result.put("code", 400);
            result.put("msg", e.getMessage());
        }
        return result;
    }

    @PostMapping("/like")
    @ResponseBody
    public Map<String, Object> like(Integer postId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        try {
            boolean liked = postService.toggleLike(user, postId);
            result.put("code", 200);
            result.put("liked", liked);
        } catch (IllegalArgumentException e) {
            result.put("code", 400);
            result.put("msg", e.getMessage());
        }
        return result;
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        try {
            postService.deletePost(id, user, user != null && "1".equals(user.getRole()));
            result.put("code", 200);
            result.put("msg", "删除成功");
        } catch (IllegalArgumentException e) {
            result.put("code", 403);
            result.put("msg", e.getMessage());
        }
        return result;
    }
}
