package com.study.ai.service;

import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class FilterService {
    // 简单示例敏感词库，实际项目建议存入数据库或文件
    private static final List<String> BLACK_WORDS = Arrays.asList("暴力", "违法", "垃圾", "广告");

    public boolean isContentSafe(String content) {
        if (content == null || content.trim().isEmpty()) return true;
        for (String word : BLACK_WORDS) {
            if (content.contains(word)) return false;
        }
        return true;
    }
}