package com.study.ai.controller;

import com.study.ai.pojo.entity.User;
import com.study.ai.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class CheckInController {

    @Autowired private UserService userService;

    @PostMapping("/checkin")
    @ResponseBody
    public Map<String, Object> checkIn(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        if (user == null) {
            result.put("code", 401);
            result.put("msg", "请先登录");
            return result;
        }
        try {
            int reward = userService.checkIn(user);
            User refreshedUser = userService.refreshById(user.getId());
            session.setAttribute("currUser", refreshedUser);
            result.put("code", 200);
            result.put("reward", reward);
            result.put("points", refreshedUser.getPoints());
        } catch (IllegalArgumentException e) {
            result.put("code", 400);
            result.put("msg", e.getMessage());
        }
        return result;
    }
}
