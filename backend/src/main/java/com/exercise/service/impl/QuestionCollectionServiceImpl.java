package com.exercise.service.impl;

import com.exercise.common.PageResult;
import com.exercise.dto.CollectionDTO;
import com.exercise.entity.QuestionCollection;
import com.exercise.mapper.QuestionCollectionMapper;
import com.exercise.service.QuestionCollectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class QuestionCollectionServiceImpl implements QuestionCollectionService {
    
    @Autowired
    private QuestionCollectionMapper questionCollectionMapper;
    
    @Override
    public boolean add(CollectionDTO dto) {
        QuestionCollection exist = questionCollectionMapper.selectByUserAndQuestion(dto.getUserId(), dto.getQuestionId());
        if (exist != null) {
            return true;
        }
        QuestionCollection collection = new QuestionCollection();
        collection.setUserId(dto.getUserId());
        collection.setQuestionId(dto.getQuestionId());
        return questionCollectionMapper.insert(collection) > 0;
    }
    
    @Override
    public boolean remove(Long userId, Long questionId) {
        return questionCollectionMapper.deleteByUserAndQuestion(userId, questionId) > 0;
    }
    
    @Override
    public PageResult<QuestionCollection> getList(Long userId, Long bookId, Long typeId, Integer pageNum, Integer pageSize) {
        int total = questionCollectionMapper.countByUserId(userId, bookId, typeId);
        List<QuestionCollection> list = questionCollectionMapper.selectByUserId(userId, bookId, typeId);
        int start = (pageNum - 1) * pageSize;
        int end = Math.min(start + pageSize, list.size());
        List<QuestionCollection> pageList = list.subList(start, end);
        return new PageResult<>((long) total, pageList);
    }
    
    @Override
    public boolean isCollected(Long userId, Long questionId) {
        return questionCollectionMapper.selectByUserAndQuestion(userId, questionId) != null;
    }
}
