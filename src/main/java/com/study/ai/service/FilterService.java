package com.study.ai.service;

import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

@Service
public class FilterService {
    private static final List<String> BLACK_WORDS = Arrays.asList("暴力", "违法", "垃圾", "广告");

    public boolean isContentSafe(String content) {
        return sanitize(content).equals(content == null ? "" : content);
    }

    public String sanitize(String content) {
        if (content == null) {
            return "";
        }
        String result = content;
        for (String word : BLACK_WORDS) {
            result = result.replaceAll(Pattern.quote(word), mask(word.length()));
        }
        return result.trim();
    }

    private String mask(int len) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < len; i++) {
            builder.append('*');
        }
        return builder.toString();
    }
}
