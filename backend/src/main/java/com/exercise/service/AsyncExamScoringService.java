package com.exercise.service;

import com.exercise.dto.SubmitExamDTO;
import com.exercise.vo.ExamResultVO;

public interface AsyncExamScoringService {
    void scoreExamAsync(Long examRecordId, SubmitExamDTO dto);
    
    ExamResultVO getExamResult(Long examRecordId);
}
