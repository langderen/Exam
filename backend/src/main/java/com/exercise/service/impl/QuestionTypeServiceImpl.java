package com.exercise.service.impl;

import com.exercise.entity.QuestionType;
import com.exercise.mapper.QuestionTypeMapper;
import com.exercise.service.QuestionTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class QuestionTypeServiceImpl implements QuestionTypeService {
    
    @Autowired
    private QuestionTypeMapper questionTypeMapper;
    
    @Override
    public List<QuestionType> getAll() {
        return questionTypeMapper.selectAll();
    }
    
    @Override
    public QuestionType getById(Long id) {
        return questionTypeMapper.selectById(id);
    }
}
