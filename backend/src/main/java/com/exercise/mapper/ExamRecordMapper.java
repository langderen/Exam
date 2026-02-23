package com.exercise.mapper;

import com.exercise.entity.ExamRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ExamRecordMapper {
    int insert(ExamRecord record);
    
    ExamRecord selectById(@Param("id") Long id);
    
    int update(ExamRecord record);
}
