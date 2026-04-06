package com.study.ai.mapper;

import com.study.ai.pojo.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserMapper {
    User findByUsername(@Param("username") String username);
    User findById(@Param("id") Integer id);
    List<User> findAll();
    List<User> findTopPointsUsers();

    int countByUsername(@Param("username") String username);
    int countByEmail(@Param("email") String email);

    int insert(User user);
    int updateByPrimaryKeySelective(User user);
    void updateStatus(@Param("id") Integer id, @Param("status") Integer status);
    void changePoints(@Param("userId") Integer userId, @Param("amount") Integer amount);

    int countTodayCheckIn(@Param("userId") Integer userId);
    void insertCheckIn(@Param("userId") Integer userId);
}
