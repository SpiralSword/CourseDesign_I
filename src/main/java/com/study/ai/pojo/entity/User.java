package com.study.ai.pojo.entity;
import lombok.Data;
import java.util.Date;

@Data
public class User {
    private Integer id;
    private String username;
    private String password;
    private String nickname;
    private String avatar;
    private String role;     // "1": 管理员, "0": 普通用户
    private Integer points;
    private Integer status;  // 0: 正常, 1: 冻结
    private Date createTime;
    private String email;
}