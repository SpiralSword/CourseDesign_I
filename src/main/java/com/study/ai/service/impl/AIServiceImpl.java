package com.study.ai.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.study.ai.mapper.AIChatLogMapper;
import com.study.ai.pojo.entity.AIChatLog;
import com.study.ai.pojo.entity.User;
import com.study.ai.service.AIService;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class AIServiceImpl implements AIService {
    private static final MediaType JSON_TYPE = MediaType.get("application/json; charset=utf-8");

    @Autowired
    private AIChatLogMapper aiChatLogMapper;

    @Value("${ai.api.key:}")
    private String apiKey;

    @Value("${ai.api.url:https://api.deepseek.com/chat/completions}")
    private String apiUrl;

    @Value("${ai.api.model:deepseek-chat}")
    private String model;

    private final OkHttpClient client = new OkHttpClient.Builder()
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .build();

    @Override
    public List<AIChatLog> listHistory(Integer userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        return aiChatLogMapper.findByUserId(userId);
    }

    @Override
    public String ask(User user, String question) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("用户未登录");
        }
        if (question == null || question.trim().isEmpty()) {
            throw new IllegalArgumentException("问题不能为空");
        }
        String answer = callModel(question.trim());
        AIChatLog log = new AIChatLog();
        log.setUserId(user.getId());
        log.setQuestion(question.trim());
        log.setAnswer(answer);
        aiChatLogMapper.insertLog(log);
        return answer;
    }

    private String callModel(String question) {
        if (apiKey == null || apiKey.trim().isEmpty()) {
            return "AI 服务尚未配置密钥，请在 ai-config.properties 中填写后重试。";
        }
        try {
            JSONObject payload = new JSONObject();
            payload.put("model", model);

            JSONArray messages = new JSONArray();
            messages.add(new JSONObject()
                    .fluentPut("role", "system")
                    .fluentPut("content", "你是智学共享平台的课程助教，只回答 Java、SSM、数据库与课程学习相关问题。"));
            messages.add(new JSONObject()
                    .fluentPut("role", "user")
                    .fluentPut("content", question));
            payload.put("messages", messages);

            Request request = new Request.Builder()
                    .url(apiUrl)
                    .addHeader("Authorization", "Bearer " + apiKey.trim())
                    .post(RequestBody.create(payload.toJSONString(), JSON_TYPE))
                    .build();

            try (Response response = client.newCall(request).execute()) {
                if (!response.isSuccessful() || response.body() == null) {
                    return "AI 助手目前不可用，请稍后再试。";
                }
                String json = response.body().string();
                JSONObject body = JSON.parseObject(json);
                JSONArray choices = body.getJSONArray("choices");
                if (choices == null || choices.isEmpty()) {
                    return "AI 助手暂时没有返回有效结果。";
                }
                return choices.getJSONObject(0).getJSONObject("message").getString("content");
            }
        } catch (Exception e) {
            return "AI 助手目前正忙，请稍后再试。错误信息：" + e.getMessage();
        }
    }
}
