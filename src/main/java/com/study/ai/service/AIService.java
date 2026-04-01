package com.study.ai.service;

public interface AIService {
    /**
     * 发送问题给 AI 并获取回答
     * @param question 用户提问内容
     * @return AI 返回的文本
     */
    String getAIResponse(String question);
}