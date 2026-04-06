package com.study.ai.pojo.entity;

import lombok.Data;

import java.util.Date;

@Data
public class Post {
    private Integer id;
    private String title;
    private String courseName;
    private String content;
    private Integer userId;
    private Integer likeCount;
    private Integer replyCount;
    private Date createTime;
    private String authorNickname;
    private String authorAvatar;
    private boolean liked;
}
