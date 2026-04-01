package com.study.ai.controller;

import com.study.ai.pojo.entity.*;
import com.study.ai.service.AIService;
import com.study.ai.mapper.AIChatLogMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/ai")
public class AIController {

    @Autowired private AIService aiService;
    @Autowired private AIChatLogMapper aiChatLogMapper;

    @GetMapping("/chatPage")
    public String chatPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currUser");
        if(user == null) return "redirect:/user/loginPage";
        model.addAttribute("history", aiChatLogMapper.findByUserId(user.getId()));
        return "ai-chat";
    }

    @PostMapping("/ask")
    @ResponseBody
    public Map<String, Object> ask(String question, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");

        String answer = aiService.getAIResponse(question);

        AIChatLog log = new AIChatLog();
        log.setUserId(user.getId());
        log.setQuestion(question);
        log.setContent(answer); // 对应数据库 content 字段
        aiChatLogMapper.insertLog(log);

        result.put("code", 200);
        result.put("answer", answer);
        return result;
    }
}