package com.study.ai.mapper;

import com.study.ai.pojo.entity.Post;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PostMapper {
    List<Post> findAll();

    List<Post> searchByKeyword(@Param("keyword") String keyword);

    Post findById(@Param("id") Integer id);

    List<Post> findByUserId(@Param("userId") Integer userId);

    int insertPost(Post post);

    void incrementReplyCount(@Param("id") Integer id);

    void incrementLikeCount(@Param("id") Integer id);

    void decrementLikeCount(@Param("id") Integer id);

    int countLikeRecord(@Param("postId") Integer postId, @Param("userId") Integer userId);

    void insertLikeRecord(@Param("postId") Integer postId, @Param("userId") Integer userId);

    void deleteLikeRecord(@Param("postId") Integer postId, @Param("userId") Integer userId);

    void deleteLikeRecordsByPostId(@Param("postId") Integer postId);

    void deleteById(@Param("id") Integer id);
}
