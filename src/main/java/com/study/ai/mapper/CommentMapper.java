package com.study.ai.mapper;

import com.study.ai.pojo.entity.Comment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommentMapper {
    List<Comment> findByResourceId(@Param("resourceId") Integer resourceId);
    int insert(Comment comment);
    void deleteByResourceId(@Param("resourceId") Integer resourceId);
}
