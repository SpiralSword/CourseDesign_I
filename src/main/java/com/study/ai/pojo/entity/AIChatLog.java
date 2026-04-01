package com.study.ai.pojo.entity;
import lombok.Data;
import java.util.Date;

@Data
public class AIChatLog {
    private Integer id;
    private Integer userId;
    private String question;
    private String content; // 对应数据库答复内容
    private Date createTime;
}