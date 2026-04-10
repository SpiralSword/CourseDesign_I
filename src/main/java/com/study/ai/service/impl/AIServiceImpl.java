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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
public class AIServiceImpl implements AIService {
    private static final MediaType JSON_TYPE = MediaType.get("application/json; charset=utf-8");
    private static final Logger logger = LoggerFactory.getLogger(AIServiceImpl.class);
    private static final String DEFAULT_API_URL = "https://api.deepseek.com/chat/completions";

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
            String resolvedApiUrl = resolveApiUrl();
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
                    .url(resolvedApiUrl)
                    .addHeader("Authorization", "Bearer " + apiKey.trim())
                    .post(RequestBody.create(payload.toJSONString(), JSON_TYPE))
                    .build();

            try (Response response = client.newCall(request).execute()) {
                String responseText = response.body() == null ? "" : response.body().string();
                if (!response.isSuccessful()) {
                    logger.warn("AI API request failed. status={}, url={}, body={}",
                            response.code(), resolvedApiUrl, abbreviate(responseText));
                    return buildFailureMessage(response.code());
                }
                if (responseText.trim().isEmpty()) {
                    logger.warn("AI API returned empty body. url={}", resolvedApiUrl);
                    return "AI 助手目前不可用，请稍后再试。";
                }
                JSONObject body = JSON.parseObject(responseText);
                JSONArray choices = body.getJSONArray("choices");
                if (choices == null || choices.isEmpty()) {
                    logger.warn("AI API returned no choices. url={}, body={}", resolvedApiUrl, abbreviate(responseText));
                    return "AI 助手暂时没有返回有效结果。";
                }
                JSONObject firstChoice = choices.getJSONObject(0);
                JSONObject message = firstChoice == null ? null : firstChoice.getJSONObject("message");
                String content = message == null ? null : message.getString("content");
                if (content == null || content.trim().isEmpty()) {
                    logger.warn("AI API returned empty content. url={}, body={}", resolvedApiUrl, abbreviate(responseText));
                    return "AI 助手暂时没有返回有效结果。";
                }
                return content.trim();
            }
        } catch (Exception e) {
            logger.error("Call AI model failed. url={}, model={}", resolveApiUrl(), model, e);
            return "AI 助手目前正忙，请检查网络或接口配置。错误信息：" + e.getMessage();
        }
    }

    private String resolveApiUrl() {
        if (apiUrl == null || apiUrl.trim().isEmpty()) {
            return DEFAULT_API_URL;
        }
        String trimmed = apiUrl.trim();
        if ("https://api.deepseek.com".equals(trimmed) || "https://api.deepseek.com/".equals(trimmed)) {
            return DEFAULT_API_URL;
        }
        return trimmed;
    }

    private String buildFailureMessage(int statusCode) {
        if (statusCode == 401 || statusCode == 403) {
            return "AI 服务鉴权失败，请检查 ai.api.key 是否正确且仍可用。";
        }
        if (statusCode == 404) {
            return "AI 接口地址不可用，请检查 ai.api.url 是否为完整的 /chat/completions 地址。";
        }
        if (statusCode == 429) {
            return "AI 服务请求过于频繁，或当前账户额度不足，请稍后重试。";
        }
        if (statusCode >= 500) {
            return "AI 服务提供商暂时不可用，请稍后再试。";
        }
        return "AI 助手目前不可用，请检查 AI 接口配置后重试。";
    }

    private String abbreviate(String text) {
        if (text == null) {
            return "";
        }
        String normalized = text.replaceAll("\\s+", " ").trim();
        if (normalized.length() <= 300) {
            return normalized;
        }
        return normalized.substring(0, 300) + "...";
    }
}
