package com.exercise.service;

import com.exercise.entity.QuestionType;
import java.util.List;

public interface QuestionTypeService {
    List<QuestionType> getAll();
    
    QuestionType getById(Long id);
}
