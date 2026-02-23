package com.exercise.service;

import com.exercise.common.PageResult;
import com.exercise.entity.ExerciseBook;
import java.util.List;

public interface ExerciseBookService {
    List<ExerciseBook> getList(String bookName);
    
    ExerciseBook getDetailById(Long id, Long userId);
    
    ExerciseBook getById(Long id);
}
