package com.study.ai.pojo.entity;
import lombok.Data;
import java.util.Date;

@Data
public class AIChatLog {
    private Integer id;
    private Integer userId;
    private String question;
    private String answer;
    private Date createTime;
}
