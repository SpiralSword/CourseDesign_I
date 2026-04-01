package com.study.ai.mapper;
import com.study.ai.pojo.entity.AIChatLog;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface AIChatLogMapper {
    void insertLog(AIChatLog log);
    List<AIChatLog> findByUserId(Integer userId);
}