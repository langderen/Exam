package com.exercise.controller;

import com.exercise.common.PageResult;
import com.exercise.common.Result;
import com.exercise.entity.QuestionRecord;
import com.exercise.service.QuestionRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/error")
public class ErrorController {
    
    @Autowired
    private QuestionRecordService questionRecordService;
    
    @GetMapping("/list")
    public Result<PageResult<QuestionRecord>> list(
            @RequestParam Long userId,
            @RequestParam(required = false) Long bookId,
            @RequestParam(required = false) Long typeId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        PageResult<QuestionRecord> result = questionRecordService.getErrorList(userId, bookId, typeId, pageNum, pageSize);
        return Result.success(result);
    }
    
    @DeleteMapping("/delete/{recordId}")
    public Result<Boolean> delete(@PathVariable Long recordId) {
        boolean success = questionRecordService.removeError(recordId);
        return success ? Result.success(true) : Result.error("删除失败");
    }
    
    @GetMapping("/high-error")
    public Result<List<QuestionRecord>> highError(
            @RequestParam Long userId,
            @RequestParam(defaultValue = "10") Integer limit) {
        List<QuestionRecord> list = questionRecordService.getHighErrorQuestions(userId, limit);
        return Result.success(list);
    }
    
    @GetMapping("/recent")
    public Result<List<QuestionRecord>> recent(
            @RequestParam Long userId,
            @RequestParam(defaultValue = "10") Integer limit) {
        List<QuestionRecord> list = questionRecordService.getRecentRecords(userId, limit);
        return Result.success(list);
    }
}
