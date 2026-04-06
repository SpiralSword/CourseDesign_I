package com.study.ai.service;

import com.github.pagehelper.PageInfo;
import com.study.ai.pojo.entity.Post;
import com.study.ai.pojo.entity.PostReply;
import com.study.ai.pojo.entity.User;

import java.util.List;

public interface PostService {
    PageInfo<Post> listPosts(int page, String keyword);

    Post getDetail(Integer id, Integer currentUserId);

    List<PostReply> listReplies(Integer postId);

    void createPost(User user, String title, String courseName, String content);

    void addReply(User user, Integer postId, String content);

    boolean toggleLike(User user, Integer postId);

    List<Post> findByUserId(Integer userId);

    void deletePost(Integer id, User operator, boolean admin);
}
