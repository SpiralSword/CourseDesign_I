package com.study.ai.service.impl;

import com.study.ai.pojo.entity.User;
import com.study.ai.service.UserService;
import com.study.ai.mapper.UserMapper; // 确保路径正确
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils; // 用于MD5加密

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String username, String password) {
        // 如果数据库存的是加密后的密码，这行需要加密后再查
        // String md5Password = DigestUtils.md5DigestAsHex(password.getBytes());
        return userMapper.selectByUsernameAndPassword(username, password);
    }

    @Override
    public int register(User user) {
        // 初始积分设为100，初始头像设为默认
        user.setPoints(100);
        user.setAvatar("/static/images/default-avatar.png");
        return userMapper.insert(user);
    }

    @Override
    public int updateById(User user) {
        return userMapper.updateByPrimaryKeySelective(user);
    }
}