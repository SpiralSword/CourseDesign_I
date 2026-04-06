package com.study.ai.pojo.entity;
import lombok.Data;
import java.util.Date;

@Data
public class Resource {
    private Integer id;
    private String title;
    private String courseName;
    private String category;
    private String description;
    private String filePath;
    private String fileSize;
    private Integer points;
    private Integer uploaderId;
    private Integer downloadCount;
    private Integer likes;
    private Date createTime;
    private String uploaderNickname;
    private Integer userUploadCount;
}
