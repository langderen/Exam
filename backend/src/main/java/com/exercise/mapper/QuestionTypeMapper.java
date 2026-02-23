package com.exercise.mapper;

import com.exercise.entity.QuestionType;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface QuestionTypeMapper {
    List<QuestionType> selectAll();
    
    QuestionType selectById(Long id);
}
