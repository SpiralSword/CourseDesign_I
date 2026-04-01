package com.study.ai.pojo.entity;
import lombok.Data;
import java.util.Date;

@Data
public class Resource {
    private Integer id;
    private String title;
    private String category;
    private String description;
    private String filePath;    // 存储上传后的文件名 (如 xxx.jpg)
    private String fileSize;
    private Integer points;
    private Integer uploaderId;
    private Integer downloadCount;
    private Integer likes;
    private Date createTime;

    // 冗余字段
    private String uploaderNickname;
    private Integer userUploadCount;
}