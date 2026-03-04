package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.dto.GenerateExamDTO;
import com.exercise.dto.SaveAnswerDTO;
import com.exercise.dto.SubmitExamDTO;
import com.exercise.entity.ExamQuestion;
import com.exercise.entity.ExamRecord;
import com.exercise.entity.Question;
import com.exercise.service.ExamService;
import com.exercise.vo.ExamResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/exam")
public class ExamController {
    
    @Autowired
    private ExamService examService;
    
    @PostMapping("/generate")
    public Result<Map<String, Object>> generate(@RequestBody GenerateExamDTO dto) {
        Map<String, Object> result = examService.generateExam(dto);
        return Result.success(result);
    }
    
    @GetMapping("/question/jump/{examId}/{seq}")
    public Result<Question> jumpQuestion(@PathVariable Long examId, @PathVariable Integer seq) {
        Question question = examService.jumpToQuestion(examId, seq);
        return Result.success(question);
    }
    
    @PostMapping("/saveAnswer")
    public Result<Map<String, Object>> saveAnswer(@RequestBody SaveAnswerDTO dto) {
        Map<String, Object> result = examService.saveAnswer(dto);
        return Result.success(result);
    }
    
    @PostMapping("/submit")
    public Result<ExamResultVO> submit(@RequestBody SubmitExamDTO dto) {
        ExamResultVO result = examService.submitExam(dto);
        return Result.success(result);
    }
    
    @GetMapping("/result/{examId}")
    public Result<ExamResultVO> getResult(@PathVariable Long examId) {
        ExamResultVO result = examService.getExamResult(examId);
        return Result.success(result);
    }
    
    @GetMapping("/questions/{examId}")
    public Result<List<ExamQuestion>> getQuestions(@PathVariable Long examId) {
        List<ExamQuestion> questions = examService.getExamQuestions(examId);
        return Result.success(questions);
    }
    
    @GetMapping("/records/{userId}")
    public Result<List<ExamRecord>> getUserRecords(@PathVariable Long userId) {
        List<ExamRecord> records = examService.getUserExamRecords(userId);
        return Result.success(records);
    }
}
