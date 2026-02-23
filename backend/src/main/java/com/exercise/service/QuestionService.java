package com.exercise.service;

import com.exercise.common.PageResult;
import com.exercise.dto.GenerateExamDTO;
import com.exercise.dto.SubmitAnswerDTO;
import com.exercise.dto.SubmitExamDTO;
import com.exercise.entity.Question;
import com.exercise.entity.QuestionRecord;
import com.exercise.vo.ExamResultVO;
import com.exercise.vo.SubmitResultVO;
import java.util.List;
import java.util.Map;

public interface QuestionService {
    Question getSequence(Long bookId, Integer pageNum, Integer pageSize);
    
    Question getRandom(Long bookId, Long userId);
    
    Question jumpToQuestion(Long bookId, Integer seq);
    
    SubmitResultVO submitAnswer(SubmitAnswerDTO dto);
    
    List<Question> generateExam(GenerateExamDTO dto);
    
    ExamResultVO submitExam(SubmitExamDTO dto);
    
    Question getById(Long id);
    
    int countByBookId(Long bookId);
    
    Map<String, Object> getAnswerStatus(Long userId, Long bookId);
}
