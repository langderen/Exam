package com.exercise.service;

import com.exercise.dto.GenerateExamDTO;
import com.exercise.dto.SaveAnswerDTO;
import com.exercise.dto.SubmitExamDTO;
import com.exercise.entity.ExamQuestion;
import com.exercise.entity.ExamRecord;
import com.exercise.entity.Question;
import com.exercise.vo.ExamResultVO;
import java.util.List;
import java.util.Map;

public interface ExamService {
    Map<String, Object> generateExam(GenerateExamDTO dto);
    
    Question jumpToQuestion(Long examId, Integer seq);
    
    Map<String, Object> saveAnswer(SaveAnswerDTO dto);
    
    ExamResultVO submitExam(SubmitExamDTO dto);
    
    List<ExamQuestion> getExamQuestions(Long examId);
    
    List<ExamRecord> getUserExamRecords(Long userId);
}
