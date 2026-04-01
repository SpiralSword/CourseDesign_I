package com.study.ai.pojo.entity;
import lombok.Data;
import java.util.Date;

@Data
public class Comment {
    private Integer id;
    private Integer resourceId;
    private Integer userId;
    private String content;
    private Date createTime;
    private String nickname; // 用户昵称显示
}