package com.exercise.mapper;

import com.exercise.entity.ExamRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ExamRecordMapper {
    int insert(ExamRecord record);
    
    ExamRecord selectById(@Param("id") Long id);
    
    int update(ExamRecord record);
    
    List<ExamRecord> selectByUserId(@Param("userId") Long userId);
}
