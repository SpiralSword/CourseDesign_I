package com.study.ai.controller;

import com.study.ai.service.AIService;
import com.study.ai.pojo.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/ai")
public class AIController {

    @Autowired private AIService aiService;

    @GetMapping("/chatPage")
    public String chatPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currUser");
        if (user == null) return "redirect:/user/loginPage";
        model.addAttribute("history", aiService.listHistory(user.getId()));
        return "ai-chat";
    }

    @PostMapping("/ask")
    @ResponseBody
    public Map<String, Object> ask(String question, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        if (user == null) {
            result.put("code", 401);
            result.put("msg", "请先登录");
            return result;
        }
        try {
            String answer = aiService.ask(user, question);
            result.put("code", 200);
            result.put("answer", answer);
        } catch (IllegalArgumentException e) {
            result.put("code", 400);
            result.put("msg", e.getMessage());
        }
        return result;
    }
}
