package com.exercise.service.impl;

import com.exercise.common.PageResult;
import com.exercise.entity.QuestionRecord;
import com.exercise.mapper.QuestionRecordMapper;
import com.exercise.service.QuestionRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class QuestionRecordServiceImpl implements QuestionRecordService {
    
    @Autowired
    private QuestionRecordMapper questionRecordMapper;
    
    @Override
    public PageResult<QuestionRecord> getErrorList(Long userId, Long bookId, Long typeId, Integer pageNum, Integer pageSize) {
        int total = questionRecordMapper.countErrors(userId, bookId, typeId);
        List<QuestionRecord> list = questionRecordMapper.selectErrorList(userId, bookId, typeId);
        int start = (pageNum - 1) * pageSize;
        if (start >= list.size()) {
            return new PageResult<>((long) total, new ArrayList<>());
        }
        int end = Math.min(start + pageSize, list.size());
        List<QuestionRecord> pageList = list.subList(start, end);
        return new PageResult<>((long) total, pageList);
    }
    
    @Override
    public boolean removeError(Long recordId) {
        return questionRecordMapper.deleteById(recordId) > 0;
    }
    
    @Override
    public int countErrors(Long userId, Long bookId, Long typeId) {
        return questionRecordMapper.countErrors(userId, bookId, typeId);
    }
}
