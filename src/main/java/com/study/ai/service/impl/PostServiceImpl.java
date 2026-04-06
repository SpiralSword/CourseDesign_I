package com.study.ai.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.study.ai.mapper.PostMapper;
import com.study.ai.mapper.PostReplyMapper;
import com.study.ai.mapper.UserMapper;
import com.study.ai.pojo.entity.Post;
import com.study.ai.pojo.entity.PostReply;
import com.study.ai.pojo.entity.User;
import com.study.ai.service.FilterService;
import com.study.ai.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class PostServiceImpl implements PostService {

    @Autowired private PostMapper postMapper;
    @Autowired private PostReplyMapper postReplyMapper;
    @Autowired private UserMapper userMapper;
    @Autowired private FilterService filterService;

    @Override
    public PageInfo<Post> listPosts(int page, String keyword) {
        PageHelper.startPage(page, 10);
        List<Post> list = (keyword == null || keyword.trim().isEmpty())
                ? postMapper.findAll()
                : postMapper.searchByKeyword(keyword.trim());
        return new PageInfo<>(list);
    }

    @Override
    public Post getDetail(Integer id, Integer currentUserId) {
        if (id == null) {
            throw new IllegalArgumentException("帖子不存在");
        }
        Post post = postMapper.findById(id);
        if (post == null) {
            throw new IllegalArgumentException("帖子不存在");
        }
        post.setLiked(currentUserId != null && postMapper.countLikeRecord(id, currentUserId) > 0);
        return post;
    }

    @Override
    public List<PostReply> listReplies(Integer postId) {
        return postReplyMapper.findByPostId(postId);
    }

    @Override
    public void createPost(User user, String title, String courseName, String content) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("帖子标题不能为空");
        }
        String sanitized = filterService.sanitize(content);
        if (sanitized.length() < 5) {
            throw new IllegalArgumentException("帖子内容至少 5 个字");
        }
        Post post = new Post();
        post.setTitle(title.trim());
        post.setCourseName(courseName == null || courseName.trim().isEmpty() ? "综合课程" : courseName.trim());
        post.setContent(sanitized);
        post.setUserId(user.getId());
        post.setCreateTime(new Date());
        postMapper.insertPost(post);
        userMapper.changePoints(user.getId(), 2);
    }

    @Override
    public void addReply(User user, Integer postId, String content) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        if (postMapper.findById(postId) == null) {
            throw new IllegalArgumentException("帖子不存在");
        }
        String sanitized = filterService.sanitize(content);
        if (sanitized.length() < 2) {
            throw new IllegalArgumentException("回复内容太短");
        }
        PostReply reply = new PostReply();
        reply.setPostId(postId);
        reply.setUserId(user.getId());
        reply.setContent(sanitized);
        postReplyMapper.insert(reply);
        postMapper.incrementReplyCount(postId);
        userMapper.changePoints(user.getId(), 1);
    }

    @Override
    public boolean toggleLike(User user, Integer postId) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        if (postMapper.findById(postId) == null) {
            throw new IllegalArgumentException("帖子不存在");
        }
        if (postMapper.countLikeRecord(postId, user.getId()) > 0) {
            postMapper.deleteLikeRecord(postId, user.getId());
            postMapper.decrementLikeCount(postId);
            return false;
        }
        postMapper.insertLikeRecord(postId, user.getId());
        postMapper.incrementLikeCount(postId);
        return true;
    }

    @Override
    public List<Post> findByUserId(Integer userId) {
        return postMapper.findByUserId(userId);
    }

    @Override
    public void deletePost(Integer id, User operator, boolean admin) {
        Post post = getDetail(id, operator == null ? null : operator.getId());
        if (operator == null || operator.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        if (!admin && !operator.getId().equals(post.getUserId())) {
            throw new IllegalArgumentException("仅发帖人或管理员可删除");
        }
        postReplyMapper.deleteByPostId(id);
        postMapper.deleteLikeRecordsByPostId(id);
        postMapper.deleteById(id);
    }
}
