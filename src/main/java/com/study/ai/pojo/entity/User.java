package com.study.ai.pojo.entity;
import lombok.Data;
import java.util.Date;

@Data
public class User {
    private Integer id;
    private String username;
    private String password;
    private String nickname;
    private String email;
    private String avatar;
    private String role;
    private Integer points;
    private Integer status;
    private Date createTime;
}
