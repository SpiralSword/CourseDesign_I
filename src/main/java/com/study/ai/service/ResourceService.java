package com.study.ai.service;

import com.github.pagehelper.PageInfo;
import com.study.ai.pojo.entity.Resource;
import com.study.ai.pojo.entity.User;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ResourceService {
    PageInfo<Resource> listResources(int page, String keyword);

    Resource getDetail(Integer id);

    void uploadResource(User user, MultipartFile file, String title, String courseName, String category,
                        String description, Integer points, String uploadRoot);

    void addComment(User user, Integer resourceId, String content);

    Resource assertDownloadable(User user, Integer resourceId);

    void consumeDownload(User user, Integer resourceId);

    void markDownloaded(Integer resourceId);

    void deleteResource(Integer id, User operator, String uploadRoot, boolean admin);

    List<Resource> findByUploader(Integer userId);
}
