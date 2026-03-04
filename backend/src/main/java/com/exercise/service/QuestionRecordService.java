package com.exercise.service;

import com.exercise.common.PageResult;
import com.exercise.entity.QuestionRecord;
import java.util.List;

public interface QuestionRecordService {
    PageResult<QuestionRecord> getErrorList(Long userId, Long bookId, Long typeId, Integer pageNum, Integer pageSize);
    
    boolean removeError(Long recordId);
    
    int countErrors(Long userId, Long bookId, Long typeId);
    
    List<QuestionRecord> getHighErrorQuestions(Long userId, Integer limit);
    
    List<QuestionRecord> getRecentRecords(Long userId, Integer limit);
}
