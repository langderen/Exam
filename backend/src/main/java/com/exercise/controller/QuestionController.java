package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.dto.GenerateExamDTO;
import com.exercise.dto.SubmitAnswerDTO;
import com.exercise.dto.SubmitExamDTO;
import com.exercise.entity.Question;
import com.exercise.service.QuestionCollectionService;
import com.exercise.service.QuestionService;
import com.exercise.vo.ExamResultVO;
import com.exercise.vo.SubmitResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/question")
public class QuestionController {
    
    @Autowired
    private QuestionService questionService;
    
    @Autowired
    private QuestionCollectionService questionCollectionService;
    
    @GetMapping("/sequence/{bookId}")
    public Result<Question> sequence(@PathVariable Long bookId,
                                     @RequestParam(defaultValue = "1") Integer pageNum,
                                     @RequestParam(defaultValue = "1") Integer pageSize) {
        Question question = questionService.getSequence(bookId, pageNum, pageSize);
        return Result.success(question);
    }
    
    @GetMapping("/random/{bookId}")
    public Result<Question> random(@PathVariable Long bookId, @RequestParam Long userId) {
        Question question = questionService.getRandom(bookId, userId);
        return Result.success(question);
    }
    
    @GetMapping("/jump/{bookId}/{seq}")
    public Result<Question> jump(@PathVariable Long bookId, @PathVariable Integer seq) {
        Question question = questionService.jumpToQuestion(bookId, seq);
        return Result.success(question);
    }
    
    @GetMapping("/answerStatus/{userId}/{bookId}")
    public Result<Map<String, Object>> answerStatus(@PathVariable Long userId, @PathVariable Long bookId) {
        Map<String, Object> status = questionService.getAnswerStatus(userId, bookId);
        return Result.success(status);
    }
    
    @PostMapping("/submit")
    public Result<SubmitResultVO> submit(@RequestBody SubmitAnswerDTO dto) {
        try {
            SubmitResultVO vo = questionService.submitAnswer(dto);
            return Result.success(vo);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @GetMapping("/detail/{id}")
    public Result<Question> detail(@PathVariable Long id, @RequestParam(required = false) Long userId) {
        Question question = questionService.getById(id);
        if (question != null && userId != null) {
            question.setIsCollected(questionCollectionService.isCollected(userId, id) ? 1 : 0);
        }
        return Result.success(question);
    }
}
