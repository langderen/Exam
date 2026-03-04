package com.exercise.service.impl;

import com.exercise.common.PageResult;
import com.exercise.entity.ExerciseBook;
import com.exercise.mapper.ExerciseBookMapper;
import com.exercise.service.ExerciseBookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDateTime;
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
    public List<ExerciseBook> getListWithPurchase(String bookName, Long userId) {
        return exerciseBookMapper.selectListWithPurchase(bookName, userId);
    }
    
    @Override
    public PageResult<ExerciseBook> getListWithPurchasePaged(String bookName, Long userId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        List<ExerciseBook> list = exerciseBookMapper.selectListWithPurchasePaged(bookName, userId, offset, pageSize);
        int total = exerciseBookMapper.countListWithPurchase(bookName, userId);
        return new PageResult<>((long) total, list);
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
    
    @Override
    public ExerciseBook getByIdWithPurchase(Long id, Long userId) {
        return exerciseBookMapper.selectByIdWithPurchase(id, userId);
    }
    
    @Override
    public List<ExerciseBook> getMyBooks(Long userId) {
        return exerciseBookMapper.selectByCreatorId(userId);
    }
    
    @Override
    public void createBook(ExerciseBook book) {
        book.setCreateTime(LocalDateTime.now());
        book.setStatus(1);
        book.setIsPublic(1);
        if (book.getPrice() == null) {
            book.setPrice(java.math.BigDecimal.ZERO);
        }
        exerciseBookMapper.insert(book);
    }
    
    @Override
    public void updateBook(ExerciseBook book) {
        exerciseBookMapper.update(book);
    }
    
    @Override
    public void updateStatus(Long id, Integer status) {
        exerciseBookMapper.updateStatus(id, status);
    }
    
    @Override
    public void updatePrice(Long id, BigDecimal price) {
        exerciseBookMapper.updatePrice(id, price);
    }
    
    @Override
    public void deleteBook(Long id) {
        exerciseBookMapper.deleteById(id);
    }
    
    @Override
    public List<ExerciseBook> getAllBooks() {
        return exerciseBookMapper.selectAll();
    }
}
