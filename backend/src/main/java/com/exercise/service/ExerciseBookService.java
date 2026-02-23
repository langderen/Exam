package com.exercise.service;

import com.exercise.common.PageResult;
import com.exercise.entity.ExerciseBook;
import java.util.List;

public interface ExerciseBookService {
    List<ExerciseBook> getList(String bookName);
    
    ExerciseBook getDetailById(Long id, Long userId);
    
    ExerciseBook getById(Long id);
    
    List<ExerciseBook> getMyBooks(Long userId);
    
    void createBook(ExerciseBook book);
    
    void updateBook(ExerciseBook book);
    
    void updateStatus(Long id, Integer status);
    
    void deleteBook(Long id);
    
    List<ExerciseBook> getAllBooks();
}
