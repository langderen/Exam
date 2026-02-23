package com.exercise.mapper;

import com.exercise.entity.ExamDetail;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface ExamDetailMapper {
    int insertBatch(List<ExamDetail> details);
    
    List<ExamDetail> selectByExamId(Long examId);
}
