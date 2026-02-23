package com.exercise.controller;

import com.exercise.common.PageResult;
import com.exercise.common.Result;
import com.exercise.dto.CollectionDTO;
import com.exercise.entity.QuestionCollection;
import com.exercise.service.QuestionCollectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/collection")
public class CollectionController {
    
    @Autowired
    private QuestionCollectionService questionCollectionService;
    
    @PostMapping("/add")
    public Result<Boolean> add(@RequestBody CollectionDTO dto) {
        boolean success = questionCollectionService.add(dto);
        return success ? Result.success(true) : Result.error("收藏失败");
    }
    
    @DeleteMapping("/remove/{questionId}")
    public Result<Boolean> remove(@PathVariable Long questionId, @RequestParam Long userId) {
        boolean success = questionCollectionService.remove(userId, questionId);
        return success ? Result.success(true) : Result.error("取消收藏失败");
    }
    
    @GetMapping("/list")
    public Result<PageResult<QuestionCollection>> list(
            @RequestParam Long userId,
            @RequestParam(required = false) Long bookId,
            @RequestParam(required = false) Long typeId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        PageResult<QuestionCollection> result = questionCollectionService.getList(userId, bookId, typeId, pageNum, pageSize);
        return Result.success(result);
    }
}
