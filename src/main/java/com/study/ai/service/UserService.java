package com.study.ai.service;

import com.study.ai.pojo.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User login(String username, String password);

    void register(User user);

    User refreshById(Integer userId);

    User updateAvatar(User currentUser, String avatarUrl);

    int checkIn(User currentUser);

    List<User> findTopUsers();

    List<User> findAllUsers();

    void updateStatus(Integer id, Integer status);

    Map<String, Object> buildProfileData(Integer userId);
}
