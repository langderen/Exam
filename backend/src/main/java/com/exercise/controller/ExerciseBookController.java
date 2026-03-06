package com.exercise.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import com.exercise.common.PageResult;
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
    
    @GetMapping("/listWithPurchase")
    public Result<List<ExerciseBook>> listWithPurchase(@RequestParam(required = false) String bookName, @RequestParam Long userId) {
        List<ExerciseBook> list = exerciseBookService.getListWithPurchase(bookName, userId);
        return Result.success(list);
    }
    
    @GetMapping("/listWithPurchasePaged")
    public Result<PageResult<ExerciseBook>> listWithPurchasePaged(
            @RequestParam(required = false) String bookName,
            @RequestParam Long userId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize) {
        PageResult<ExerciseBook> result = exerciseBookService.getListWithPurchasePaged(bookName, userId, page, pageSize);
        return Result.success(result);
    }
    
    @GetMapping("/detail/{bookId}")
    public Result<ExerciseBook> detail(@PathVariable Long bookId, @RequestParam Long userId) {
        ExerciseBook book = exerciseBookService.getDetailById(bookId, userId);
        return Result.success(book);
    }
    
    @GetMapping("/my")
    @SaCheckLogin
    public Result<List<ExerciseBook>> myBooks(@RequestParam Long userId) {
        List<ExerciseBook> list = exerciseBookService.getMyBooks(userId);
        return Result.success(list);
    }
    
    @PostMapping("/create")
    @SaCheckLogin
    public Result<Void> create(@RequestBody ExerciseBook book) {
        try {
            exerciseBookService.createBook(book);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PutMapping("/update")
    @SaCheckLogin
    public Result<Void> update(@RequestBody ExerciseBook book) {
        try {
            exerciseBookService.updateBook(book);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PutMapping("/status/{id}")
    @SaCheckLogin
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        try {
            exerciseBookService.updateStatus(id, status);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @DeleteMapping("/{id}")
    @SaCheckLogin
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
    
    @PutMapping("/price/{id}")
    @SaCheckLogin
    public Result<Void> updatePrice(@PathVariable Long id, @RequestParam java.math.BigDecimal price) {
        try {
            exerciseBookService.updatePrice(id, price);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
}
