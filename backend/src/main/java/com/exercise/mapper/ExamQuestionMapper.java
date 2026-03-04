package com.exercise.mapper;

import com.exercise.entity.ExamQuestion;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ExamQuestionMapper {
    int insert(ExamQuestion examQuestion);
    
    int insertBatch(List<ExamQuestion> examQuestions);
    
    int update(ExamQuestion examQuestion);
    
    ExamQuestion selectById(@Param("id") Long id);
    
    List<ExamQuestion> selectByExamId(@Param("examId") Long examId);
    
    int updateAnswer(@Param("examId") Long examId, @Param("questionId") Long questionId, @Param("userAnswer") String userAnswer, @Param("isAnswered") Integer isAnswered);
    
    int updateCorrect(@Param("examId") Long examId, @Param("questionId") Long questionId, @Param("isCorrect") Integer isCorrect);
    
    int updateAiScore(@Param("examId") Long examId, @Param("questionId") Long questionId, @Param("isCorrect") Integer isCorrect, @Param("aiScore") Integer aiScore, @Param("aiComment") String aiComment);
    
    int deleteByExamId(@Param("examId") Long examId);
}
