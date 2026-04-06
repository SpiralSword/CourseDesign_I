package com.study.ai.service.impl;

import com.study.ai.mapper.AIChatLogMapper;
import com.study.ai.mapper.PostMapper;
import com.study.ai.mapper.ResourceMapper;
import com.study.ai.pojo.entity.User;
import com.study.ai.service.UserService;
import com.study.ai.mapper.UserMapper;
import com.study.ai.util.MD5Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

@Service
public class UserServiceImpl implements UserService {

    @Autowired private UserMapper userMapper;
    @Autowired private ResourceMapper resourceMapper;
    @Autowired private PostMapper postMapper;
    @Autowired private AIChatLogMapper aiChatLogMapper;

    @Override
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            return null;
        }
        User user = userMapper.findByUsername(username.trim());
        if (user == null || user.getStatus() != null && user.getStatus() == 1) {
            return null;
        }
        String md5Password = MD5Utils.encode(password.trim());
        return md5Password.equals(user.getPassword()) ? user : null;
    }

    @Override
    public void register(User user) {
        if (user == null) {
            throw new IllegalArgumentException("注册信息不能为空");
        }
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("用户名不能为空");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }
        if (userMapper.countByUsername(user.getUsername().trim()) > 0) {
            throw new IllegalArgumentException("用户名已存在");
        }
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty()
                && userMapper.countByEmail(user.getEmail().trim()) > 0) {
            throw new IllegalArgumentException("邮箱已存在");
        }
        user.setUsername(user.getUsername().trim());
        user.setNickname(user.getNickname() == null || user.getNickname().trim().isEmpty()
                ? user.getUsername()
                : user.getNickname().trim());
        user.setPassword(MD5Utils.encode(user.getPassword().trim()));
        user.setPoints(100);
        user.setAvatar("/static/images/default-avatar.svg");
        user.setRole("0");
        user.setStatus(0);
        userMapper.insert(user);
    }

    @Override
    public User refreshById(Integer userId) {
        return userId == null ? null : userMapper.findById(userId);
    }

    @Override
    public User updateAvatar(User currentUser, String avatarUrl) {
        if (currentUser == null || currentUser.getId() == null) {
            throw new IllegalArgumentException("用户未登录");
        }
        User updated = new User();
        updated.setId(currentUser.getId());
        updated.setAvatar(avatarUrl);
        userMapper.updateByPrimaryKeySelective(updated);
        currentUser.setAvatar(avatarUrl);
        return refreshById(currentUser.getId());
    }

    @Override
    public int checkIn(User currentUser) {
        if (currentUser == null || currentUser.getId() == null) {
            throw new IllegalArgumentException("用户未登录");
        }
        if (userMapper.countTodayCheckIn(currentUser.getId()) > 0) {
            throw new IllegalArgumentException("今日已签到");
        }
        int reward = new Random().nextInt(6) + 5;
        userMapper.insertCheckIn(currentUser.getId());
        userMapper.changePoints(currentUser.getId(), reward);
        return reward;
    }

    @Override
    public List<User> findTopUsers() {
        return userMapper.findTopPointsUsers();
    }

    @Override
    public List<User> findAllUsers() {
        return userMapper.findAll();
    }

    @Override
    public void updateStatus(Integer id, Integer status) {
        if (id == null || status == null) {
            throw new IllegalArgumentException("参数不完整");
        }
        userMapper.updateStatus(id, status);
    }

    @Override
    public Map<String, Object> buildProfileData(Integer userId) {
        Map<String, Object> data = new HashMap<>();
        data.put("user", refreshById(userId));
        data.put("uploadedResources", resourceMapper.findByUploaderId(userId));
        data.put("myPosts", postMapper.findByUserId(userId));
        data.put("aiHistory", aiChatLogMapper.findByUserId(userId));
        return data;
    }
}
