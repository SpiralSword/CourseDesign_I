package com.study.ai.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.study.ai.service.AIService;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Service;

@Service
public class AIServiceImpl implements AIService {
    // 建议：此处可以通过 @Value("${ai.api.key}") 从配置文件读取
    private static final String API_KEY = "你的_API_KEY";
    private static final String API_URL = "https://api.deepseek.com/chat/completions";

    @Override
    public String getAIResponse(String question) {
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost post = new HttpPost(API_URL);
            post.addHeader("Content-Type", "application/json");
            post.addHeader("Authorization", "Bearer " + API_KEY);

            JSONObject payload = new JSONObject();
            payload.put("model", "deepseek-chat");
            JSONArray messages = new JSONArray();

            messages.add(new JSONObject().fluentPut("role", "system").fluentPut("content", "你是一个Java学习助教。"));
            messages.add(new JSONObject().fluentPut("role", "user").fluentPut("content", question));

            payload.put("messages", messages);
            post.setEntity(new StringEntity(payload.toString(), "UTF-8"));

            try (CloseableHttpResponse response = httpClient.execute(post)) {
                String fullJson = EntityUtils.toString(response.getEntity());
                JSONObject resObj = JSON.parseObject(fullJson);
                // 关键点：路径提取
                return resObj.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content");
            }
        } catch (Exception e) {
            return "AI 助手目前正忙，请稍后再试。错误信息：" + e.getMessage();
        }
    }
}