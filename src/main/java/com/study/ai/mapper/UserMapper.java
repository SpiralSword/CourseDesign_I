package com.study.ai.mapper;
import com.study.ai.pojo.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface UserMapper {
    User findByUsername(@Param("username") String username);
    List<User> findAll();
    List<User> findTopPointsUsers(); // 获取排行

    int insertUser(User user);
    void updateUser(User user);
    void updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    // 扣费与充值的核心原子操作
    void changePoints(@Param("userId") Integer userId, @Param("amount") Integer amount);

    // 签到相关
    int countTodayCheckIn(@Param("userId") Integer userId);
    void insertCheckIn(@Param("userId") Integer userId);

    int insert(User user);

    User selectByUsernameAndPassword(@Param("username") String username, @Param("password") String password);

    int updateByPrimaryKeySelective(User user);
}