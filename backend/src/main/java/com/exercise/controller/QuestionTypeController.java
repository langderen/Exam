package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.entity.QuestionType;
import com.exercise.service.QuestionTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/type")
public class QuestionTypeController {
    
    @Autowired
    private QuestionTypeService questionTypeService;
    
    @GetMapping("/list")
    public Result<List<QuestionType>> list() {
        List<QuestionType> list = questionTypeService.getAll();
        return Result.success(list);
    }
}
