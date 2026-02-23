package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.entity.ExerciseBook;
import com.exercise.service.ExerciseBookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/book")
public class ExerciseBookController {
    
    @Autowired
    private ExerciseBookService exerciseBookService;
    
    @GetMapping("/list")
    public Result<List<ExerciseBook>> list(@RequestParam(required = false) String bookName) {
        List<ExerciseBook> list = exerciseBookService.getList(bookName);
        return Result.success(list);
    }
    
    @GetMapping("/detail/{bookId}")
    public Result<ExerciseBook> detail(@PathVariable Long bookId, @RequestParam Long userId) {
        ExerciseBook book = exerciseBookService.getDetailById(bookId, userId);
        return Result.success(book);
    }
    
    @GetMapping("/my")
    public Result<List<ExerciseBook>> myBooks(@RequestParam Long userId) {
        List<ExerciseBook> list = exerciseBookService.getMyBooks(userId);
        return Result.success(list);
    }
    
    @PostMapping("/create")
    public Result<Void> create(@RequestBody ExerciseBook book) {
        try {
            exerciseBookService.createBook(book);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PutMapping("/update")
    public Result<Void> update(@RequestBody ExerciseBook book) {
        try {
            exerciseBookService.updateBook(book);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PutMapping("/status/{id}")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        try {
            exerciseBookService.updateStatus(id, status);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        try {
            exerciseBookService.deleteBook(id);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @GetMapping("/all")
    public Result<List<ExerciseBook>> allBooks() {
        List<ExerciseBook> list = exerciseBookService.getAllBooks();
        return Result.success(list);
    }
}
