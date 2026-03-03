package com.exercise.service;

import com.exercise.common.PageResult;
import com.exercise.entity.ExerciseBook;
import java.math.BigDecimal;
import java.util.List;

public interface ExerciseBookService {
    List<ExerciseBook> getList(String bookName);
    
    List<ExerciseBook> getListWithPurchase(String bookName, Long userId);
    
    ExerciseBook getDetailById(Long id, Long userId);
    
    ExerciseBook getById(Long id);
    
    ExerciseBook getByIdWithPurchase(Long id, Long userId);
    
    List<ExerciseBook> getMyBooks(Long userId);
    
    void createBook(ExerciseBook book);
    
    void updateBook(ExerciseBook book);
    
    void updateStatus(Long id, Integer status);
    
    void updatePrice(Long id, BigDecimal price);
    
    void deleteBook(Long id);
    
    List<ExerciseBook> getAllBooks();
}
