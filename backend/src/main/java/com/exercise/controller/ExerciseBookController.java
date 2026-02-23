package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.entity.ExerciseBook;
import com.exercise.service.ExerciseBookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

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
}
