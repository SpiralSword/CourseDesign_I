package com.study.ai.controller;

import com.study.ai.mapper.UserMapper;
import com.study.ai.pojo.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/user")
public class CheckInController {

    @Autowired private UserMapper userMapper;

    @PostMapping("/checkin")
    @ResponseBody
    public Map<String, Object> checkIn(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");

        if (userMapper.countTodayCheckIn(user.getId()) > 0) {
            result.put("code", 400);
            result.put("msg", "今日已签到");
            return result;
        }

        int reward = new Random().nextInt(10) + 5;
        userMapper.insertCheckIn(user.getId());
        userMapper.changePoints(user.getId(), reward);

        user.setPoints(user.getPoints() + reward);
        session.setAttribute("currUser", user);

        result.put("code", 200);
        result.put("reward", reward);
        return result;
    }
}