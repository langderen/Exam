package com.exercise.service;

import com.exercise.common.PageResult;
import com.exercise.dto.CollectionDTO;
import com.exercise.entity.QuestionCollection;

public interface QuestionCollectionService {
    boolean add(CollectionDTO dto);
    
    boolean remove(Long userId, Long questionId);
    
    PageResult<QuestionCollection> getList(Long userId, Long bookId, Long typeId, Integer pageNum, Integer pageSize);
    
    boolean isCollected(Long userId, Long questionId);
}
