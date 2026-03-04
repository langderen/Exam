package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.service.AIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/ai")
public class AIController {
    
    @Autowired
    private AIService aiService;
    
    @PostMapping("/chat")
    public Result<String> chat(@RequestBody Map<String, String> params) {
        String prompt = params.get("prompt");
        if (prompt == null || prompt.isEmpty()) {
            return Result.error("提示词不能为空");
        }
        String response = aiService.chat(prompt);
        return Result.success(response);
    }
    
    @PostMapping("/analysis")
    public Result<String> generateAnalysis(@RequestBody Map<String, Object> question) {
        String analysis = aiService.generateAnalysis(question);
        return Result.success(analysis);
    }
    
    @PostMapping("/generate")
    public Result<String> generateQuestions(@RequestBody Map<String, Object> params) {
        String questions = aiService.generateQuestions(params);
        return Result.success(questions);
    }
    
    @PostMapping("/judge")
    public Result<String> judgeAnswer(@RequestBody Map<String, Object> params) {
        String result = aiService.judgeAnswer(params);
        return Result.success(result);
    }
}
