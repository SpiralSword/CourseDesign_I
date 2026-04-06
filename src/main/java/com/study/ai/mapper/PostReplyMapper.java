package com.study.ai.mapper;

import com.study.ai.pojo.entity.PostReply;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PostReplyMapper {
    List<PostReply> findByPostId(@Param("postId") Integer postId);

    int insert(PostReply reply);

    void deleteByPostId(@Param("postId") Integer postId);
}
