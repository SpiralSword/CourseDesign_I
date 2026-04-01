package com.study.ai.service;

import com.study.ai.pojo.entity.User;

public interface UserService {
    // 登录业务
    User login(String username, String password);

    // 注册业务 (包含邮箱)
    int register(User user);

    // 更新用户信息 (用于修改头像等)
    int updateById(User user);
}