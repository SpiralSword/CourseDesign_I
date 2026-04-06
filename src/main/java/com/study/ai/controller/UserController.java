package com.study.ai.controller;

import com.study.ai.pojo.entity.User;
import com.study.ai.service.UserService;
import com.study.ai.util.FileStorageUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/loginPage")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/registerPage")
    public String registerPage() {
        return "register";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, org.springframework.ui.Model model) {
        User currUser = (User) session.getAttribute("currUser");
        if (currUser == null) {
            return "redirect:/user/loginPage";
        }
        Map<String, Object> profileData = userService.buildProfileData(currUser.getId());
        User refreshedUser = (User) profileData.get("user");
        session.setAttribute("currUser", refreshedUser);
        model.addAttribute("currUser", refreshedUser);
        model.addAttribute("uploadedResources", profileData.get("uploadedResources"));
        model.addAttribute("myPosts", profileData.get("myPosts"));
        model.addAttribute("aiHistory", profileData.get("aiHistory"));
        return "profile";
    }

    @PostMapping("/login")
    @ResponseBody
    public Map<String, Object> login(String username, String password, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("currUser", user);
            map.put("code", 200);
        } else {
            map.put("code", 500);
            map.put("msg", "用户名或密码错误");
        }
        return map;
    }

    @PostMapping("/register")
    @ResponseBody
    public Map<String, Object> register(User user) {
        Map<String, Object> map = new HashMap<>();
        try {
            userService.register(user);
            map.put("code", 200);
            map.put("msg", "注册成功");
        } catch (IllegalArgumentException e) {
            map.put("code", 500);
            map.put("msg", e.getMessage());
        }
        return map;
    }

    @PostMapping("/updateAvatar")
    @ResponseBody
    public Map<String, Object> updateAvatar(@RequestParam("avatarFile") MultipartFile file,
                                            HttpSession session, HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        User currUser = (User) session.getAttribute("currUser");
        if (currUser == null) {
            res.put("code", 401);
            return res;
        }
        try {
            String path = request.getServletContext().getRealPath("/uploads/avatar/");
            File dir = new File(path);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String fileName = FileStorageUtils.store(file, path);
            String url = request.getContextPath() + "/uploads/avatar/" + fileName;
            User refreshedUser = userService.updateAvatar(currUser, url);
            session.setAttribute("currUser", refreshedUser);
            res.put("code", 200);
            res.put("avatar", url);
        } catch (IllegalArgumentException | IllegalStateException e) {
            res.put("code", 500);
            res.put("msg", e.getMessage());
        }
        return res;
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/loginPage";
    }
}
