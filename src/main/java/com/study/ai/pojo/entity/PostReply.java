package com.study.ai.pojo.entity;

import lombok.Data;

import java.util.Date;

@Data
public class PostReply {
    private Integer id;
    private Integer postId;
    private Integer userId;
    private String content;
    private Date createTime;
    private String nickname;
    private String avatar;
}
