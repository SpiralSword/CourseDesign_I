package com.study.ai.controller;

import com.study.ai.pojo.entity.User;
import com.study.ai.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.*;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    // --- 页面跳转方法 (解决 404 和 GET Not Supported 的关键) ---

    @GetMapping("/loginPage")
    public String loginPage() {
        return "login"; // 确保 WEB-INF/views/ 目录下有 login.jsp
    }

    @GetMapping("/registerPage")
    public String registerPage() {
        return "register"; // 确保 WEB-INF/views/ 目录下有 register.jsp
    }

    @GetMapping("/profile")
    public String profile(HttpSession session) {
        if (session.getAttribute("currUser") == null) {
            return "redirect:/user/loginPage";
        }
        return "profile"; // 确保有 profile.jsp
    }

    // --- 业务逻辑方法 ---

    // 登录逻辑
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

    // 注册逻辑 (支持邮箱)
    @PostMapping("/register")
    @ResponseBody
    public Map<String, Object> register(User user) {
        Map<String, Object> map = new HashMap<>();
        try {
            // 补全默认信息
            user.setPoints(100);
            if(user.getAvatar() == null) user.setAvatar("/static/images/default.jpg");

            userService.register(user);
            map.put("code", 200);
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code", 500);
            map.put("msg", "注册失败，请检查用户名或邮箱是否重复");
        }
        return map;
    }

    // 更换头像
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
            String path = request.getServletContext().getRealPath("/uploads/");
            File dir = new File(path);
            if (!dir.exists()) dir.mkdirs();

            String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
            file.transferTo(new File(path + fileName));

            String url = request.getContextPath() + "/uploads/" + fileName;
            currUser.setAvatar(url);

            userService.updateById(currUser);
            session.setAttribute("currUser", currUser); // 更新Session

            res.put("code", 200);
            res.put("avatar", url);
        } catch (Exception e) {
            res.put("code", 500);
        }
        return res;
    }

    // 退出登录
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/loginPage";
    }
}