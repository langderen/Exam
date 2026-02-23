package com.exercise.service.impl;

import com.exercise.entity.ExerciseBook;
import com.exercise.mapper.ExerciseBookMapper;
import com.exercise.service.ExerciseBookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ExerciseBookServiceImpl implements ExerciseBookService {
    
    @Autowired
    private ExerciseBookMapper exerciseBookMapper;
    
    @Override
    public List<ExerciseBook> getList(String bookName) {
        return exerciseBookMapper.selectList(bookName);
    }
    
    @Override
    public ExerciseBook getDetailById(Long id, Long userId) {
        ExerciseBook book = exerciseBookMapper.selectDetailById(id, userId);
        if (book != null) {
            if (book.getDoneCount() != null && book.getDoneCount() > 0) {
                double rate = (double) book.getCorrectCount() / book.getDoneCount() * 100;
                book.setCorrectRate(Math.round(rate * 100.0) / 100.0);
            } else {
                book.setCorrectRate(0.0);
            }
        }
        return book;
    }
    
    @Override
    public ExerciseBook getById(Long id) {
        return exerciseBookMapper.selectById(id);
    }
}
