package com.study.ai.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.study.ai.mapper.CommentMapper;
import com.study.ai.mapper.ResourceMapper;
import com.study.ai.mapper.UserMapper;
import com.study.ai.pojo.entity.Comment;
import com.study.ai.pojo.entity.Resource;
import com.study.ai.pojo.entity.User;
import com.study.ai.service.FilterService;
import com.study.ai.service.ResourceService;
import com.study.ai.util.FileStorageUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
import java.util.List;

@Service
public class ResourceServiceImpl implements ResourceService {

    @Autowired private ResourceMapper resourceMapper;
    @Autowired private UserMapper userMapper;
    @Autowired private CommentMapper commentMapper;
    @Autowired private FilterService filterService;

    @Override
    public PageInfo<Resource> listResources(int page, String keyword) {
        PageHelper.startPage(page, 8);
        List<Resource> list = (keyword == null || keyword.trim().isEmpty())
                ? resourceMapper.findAll()
                : resourceMapper.searchByKeyword(keyword.trim());
        return new PageInfo<>(list);
    }

    @Override
    public Resource getDetail(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException("资源不存在");
        }
        Resource resource = resourceMapper.findById(id);
        if (resource == null) {
            throw new IllegalArgumentException("资源不存在");
        }
        return resource;
    }

    @Override
    public void uploadResource(User user, MultipartFile file, String title, String courseName, String category,
                               String description, Integer points, String uploadRoot) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("请上传资源文件");
        }
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("资源标题不能为空");
        }
        Resource resource = new Resource();
        resource.setTitle(title.trim());
        resource.setCourseName(defaultValue(courseName, "综合课程"));
        resource.setCategory(defaultValue(category, "学习资料"));
        resource.setDescription(filterService.sanitize(description));
        resource.setPoints(points == null || points < 0 ? 0 : points);
        resource.setUploaderId(user.getId());
        resource.setCreateTime(new Date());
        resource.setFilePath(FileStorageUtils.store(file, uploadRoot));
        resource.setFileSize(FileStorageUtils.humanReadableSize(file.getSize()));
        resourceMapper.insertResource(resource);
        userMapper.changePoints(user.getId(), 5);
    }

    @Override
    public void addComment(User user, Integer resourceId, String content) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        if (resourceMapper.findById(resourceId) == null) {
            throw new IllegalArgumentException("资源不存在");
        }
        String sanitized = filterService.sanitize(content);
        if (sanitized.length() < 2) {
            throw new IllegalArgumentException("评论内容太短");
        }
        Comment comment = new Comment();
        comment.setResourceId(resourceId);
        comment.setUserId(user.getId());
        comment.setContent(sanitized);
        commentMapper.insert(comment);
    }

    @Override
    public Resource assertDownloadable(User user, Integer resourceId) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        Resource resource = getDetail(resourceId);
        if (user.getPoints() < resource.getPoints()) {
            throw new IllegalArgumentException("积分不足");
        }
        return resource;
    }

    @Override
    public void consumeDownload(User user, Integer resourceId) {
        Resource resource = getDetail(resourceId);
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        if (user.getPoints() < resource.getPoints()) {
            throw new IllegalArgumentException("积分不足");
        }
        userMapper.changePoints(user.getId(), -resource.getPoints());
    }

    @Override
    public void markDownloaded(Integer resourceId) {
        resourceMapper.incrDownloadCount(resourceId);
    }

    @Override
    public void deleteResource(Integer id, User operator, String uploadRoot, boolean admin) {
        Resource resource = getDetail(id);
        if (operator == null || operator.getId() == null) {
            throw new IllegalArgumentException("请先登录");
        }
        if (!admin && !operator.getId().equals(resource.getUploaderId())) {
            throw new IllegalArgumentException("仅上传者或管理员可删除");
        }
        commentMapper.deleteByResourceId(id);
        resourceMapper.deleteById(id);
        FileStorageUtils.deleteQuietly(uploadRoot, resource.getFilePath());
    }

    @Override
    public List<Resource> findByUploader(Integer userId) {
        return resourceMapper.findByUploaderId(userId);
    }

    private String defaultValue(String value, String fallback) {
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}
