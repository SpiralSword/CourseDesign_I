package com.study.ai.service;

import com.study.ai.pojo.entity.AIChatLog;
import com.study.ai.pojo.entity.User;

import java.util.List;

public interface AIService {
    List<AIChatLog> listHistory(Integer userId);

    String ask(User user, String question);
}
