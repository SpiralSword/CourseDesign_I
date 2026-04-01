package com.study.ai.mapper;
import com.study.ai.pojo.entity.Resource;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ResourceMapper {
    int insertResource(Resource resource);
    Resource findById(Integer id);
    List<Resource> findAll();
    List<Resource> searchByTitle(@Param("keyword") String keyword);
    List<Resource> findByUploaderId(Integer userId);

    void deleteById(Integer id);
    void incrDownloadCount(Integer id);
    void incrementLikes(Integer id);

    void insert(Resource res);
}